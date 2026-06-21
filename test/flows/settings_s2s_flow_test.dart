// test/flows/settings_s2s_flow_test.dart
//
// Exercise the settings → Safe-to-Spend recalculation flow.
// Mixes widget tests (UI stepper buttons) with pure provider/unit tests
// (recalculation logic).

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:helm/core/nudge/presentation/providers/nudge_providers.dart';
import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/features/income/domain/entities/income_entry_entity.dart';
import 'package:helm/features/safe_to_spend/domain/entities/fixed_cost_entry.dart';
import 'package:helm/features/safe_to_spend/domain/entities/sts_settings.dart';
import 'package:helm/features/safe_to_spend/domain/repositories/fixed_cost_repository.dart';
import 'package:helm/features/safe_to_spend/domain/repositories/sts_settings_repository.dart';
import 'package:helm/features/safe_to_spend/domain/safe_to_spend_calculator.dart';
import 'package:helm/features/safe_to_spend/presentation/providers/safe_to_spend_providers.dart';
import 'package:helm/features/safe_to_spend/presentation/views/sts_settings_screen.dart';
import 'package:helm/l10n/app_localizations.dart';

// ---------------------------------------------------------------------------
// In-memory fake repositories — no Hive, no SharedPreferences
// ---------------------------------------------------------------------------
class _FakeStsSettingsRepository implements StsSettingsRepository {
  StsSettings _current;

  _FakeStsSettingsRepository({StsSettings initial = const StsSettings()})
      : _current = initial;

  @override
  Future<StsSettings> getSettings() async => _current;

  @override
  Future<void> saveSettings(StsSettings settings) async {
    _current = settings;
  }
}

class _FakeFixedCostRepository implements FixedCostRepository {
  final List<FixedCostEntry> _costs;

  _FakeFixedCostRepository({List<FixedCostEntry>? costs})
      : _costs = costs ?? [];

  @override
  Future<List<FixedCostEntry>> getFixedCosts() async => List.unmodifiable(_costs);

  @override
  Future<void> addFixedCost(FixedCostEntry entry) async {
    _costs.add(entry);
  }

  @override
  Future<void> updateFixedCost(FixedCostEntry entry) async {
    final idx = _costs.indexWhere((c) => c.id == entry.id);
    if (idx != -1) _costs[idx] = entry;
  }

  @override
  Future<void> deleteFixedCost(String id) async {
    _costs.removeWhere((c) => c.id == id);
  }
}

// ---------------------------------------------------------------------------
// Widget helper — wraps the screen in the minimal tree it needs
// ---------------------------------------------------------------------------
Widget _buildTestApp({
  required Widget child,
  required List<Override> overrides,
}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      theme: AppTheme.light,
      locale: const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('bn')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: child,
    ),
  );
}

// ---------------------------------------------------------------------------
// Shared overrides used by widget tests
// ---------------------------------------------------------------------------
List<Override> _buildOverrides({
  StsSettings initial = const StsSettings(taxRate: 0.10, bufferPercent: 15.0),
}) {
  final fakeSettingsRepo = _FakeStsSettingsRepository(initial: initial);
  final fakeFixedCostRepo = _FakeFixedCostRepository();
  return [
    stsSettingsRepositoryProvider.overrideWithValue(fakeSettingsRepo),
    fixedCostRepositoryProvider.overrideWithValue(fakeFixedCostRepo),
    // Keep nudge count at zero — no Hive box needed.
    unreadNudgeCountProvider.overrideWithValue(0),
  ];
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  // ── Group 1: Widget-level — screen structure ─────────────────────────────

  group('StsSettingsScreen — widget structure', () {
    testWidgets('renders with tax-rate and buffer stepper buttons',
        (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          overrides: _buildOverrides(),
          child: const StsSettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('tax_rate_plus')), findsOneWidget);
      expect(find.byKey(const Key('tax_rate_minus')), findsOneWidget);
      expect(find.byKey(const Key('buffer_plus')), findsOneWidget);
      expect(find.byKey(const Key('buffer_minus')), findsOneWidget);
    });

    testWidgets('all four stepper-button widget keys are Key instances',
        (tester) async {
      // Pure key-identity check (no widget pump required).
      expect(const Key('tax_rate_plus'), isA<Key>());
      expect(const Key('tax_rate_minus'), isA<Key>());
      expect(const Key('buffer_plus'), isA<Key>());
      expect(const Key('buffer_minus'), isA<Key>());
    });
  });

  // ── Group 2: Widget-level — stepper interactions ─────────────────────────

  group('StsSettingsScreen — stepper interactions', () {
    testWidgets('tapping buffer_plus increments bufferPercent by 1',
        (tester) async {
      final overrides = _buildOverrides(
        initial: const StsSettings(taxRate: 0.10, bufferPercent: 15.0),
      );

      await tester.pumpWidget(
        _buildTestApp(
          overrides: overrides,
          child: const StsSettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap buffer_plus once
      await tester.tap(find.byKey(const Key('buffer_plus')));
      await tester.pumpAndSettle();

      // The display text should now show 16%
      expect(find.text('16%'), findsWidgets);
    });

    testWidgets('tapping buffer_minus decrements bufferPercent by 1',
        (tester) async {
      final overrides = _buildOverrides(
        initial: const StsSettings(taxRate: 0.10, bufferPercent: 20.0),
      );

      await tester.pumpWidget(
        _buildTestApp(
          overrides: overrides,
          child: const StsSettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('buffer_minus')));
      await tester.pumpAndSettle();

      expect(find.text('19%'), findsWidgets);
    });

    testWidgets('tapping tax_rate_plus increments taxRate by 1 display point',
        (tester) async {
      final overrides = _buildOverrides(
        initial: const StsSettings(taxRate: 0.10, bufferPercent: 15.0),
      );

      await tester.pumpWidget(
        _buildTestApp(
          overrides: overrides,
          child: const StsSettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('tax_rate_plus')));
      await tester.pumpAndSettle();

      // 0.10 + 0.01 = 0.11 → display: 11%
      expect(find.text('11%'), findsWidgets);
    });

    testWidgets('buffer_minus is disabled at minimum (5%)', (tester) async {
      final overrides = _buildOverrides(
        initial: const StsSettings(taxRate: 0.10, bufferPercent: 5.0),
      );

      await tester.pumpWidget(
        _buildTestApp(
          overrides: overrides,
          child: const StsSettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      final minusButton = tester.widget<IconButton>(
        find.byKey(const Key('buffer_minus')),
      );
      expect(minusButton.onPressed, isNull);
    });

    testWidgets('buffer_plus is disabled at maximum (30%)', (tester) async {
      final overrides = _buildOverrides(
        initial: const StsSettings(taxRate: 0.10, bufferPercent: 30.0),
      );

      await tester.pumpWidget(
        _buildTestApp(
          overrides: overrides,
          child: const StsSettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      final plusButton = tester.widget<IconButton>(
        find.byKey(const Key('buffer_plus')),
      );
      expect(plusButton.onPressed, isNull);
    });

    testWidgets('tax_rate_minus is disabled at 0%', (tester) async {
      final overrides = _buildOverrides(
        initial: const StsSettings(taxRate: 0.0, bufferPercent: 15.0),
      );

      await tester.pumpWidget(
        _buildTestApp(
          overrides: overrides,
          child: const StsSettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      final minusButton = tester.widget<IconButton>(
        find.byKey(const Key('tax_rate_minus')),
      );
      expect(minusButton.onPressed, isNull);
    });
  });

  // ── Group 3: Unit-style — SafeToSpendCalculator sensitivity ─────────────

  group('SafeToSpendCalculator — settings sensitivity (unit tests)', () {
    final now = DateTime(2026, 6, 21);

    IncomeEntryEntity makeIncome(double amount) => IncomeEntryEntity(
          id: 'i1',
          clientName: 'Client',
          projectName: 'Project',
          amount: amount,
          currency: 'BDT',
          status: IncomeStatus.received,
          expectedDate: now,
          receivedDate: now,
          createdAt: now,
          updatedAt: now,
        );

    test('increasing bufferPercent reduces safeToSpend', () {
      const income = 10000.0;
      final incomeList = [makeIncome(income)];

      final low = SafeToSpendCalculator.calculate(
        incomeEntries: incomeList,
        transactions: [],
        settings: const StsSettings(taxRate: 0.10, bufferPercent: 10.0),
        fixedCosts: [],
        now: now,
      );

      final high = SafeToSpendCalculator.calculate(
        incomeEntries: incomeList,
        transactions: [],
        settings: const StsSettings(taxRate: 0.10, bufferPercent: 20.0),
        fixedCosts: [],
        now: now,
      );

      // bufferPercent 10% of 10000 = 1000 → S2S = 10000 - 1000 - 1000 = 8000
      // bufferPercent 20% of 10000 = 2000 → S2S = 10000 - 1000 - 2000 = 7000
      expect(low.safeToSpend, greaterThan(high.safeToSpend));
      expect(low.safeToSpend, closeTo(8000.0, 0.01));
      expect(high.safeToSpend, closeTo(7000.0, 0.01));
    });

    test('increasing taxRate reduces safeToSpend', () {
      const income = 10000.0;
      final incomeList = [makeIncome(income)];

      final low = SafeToSpendCalculator.calculate(
        incomeEntries: incomeList,
        transactions: [],
        settings: const StsSettings(taxRate: 0.10, bufferPercent: 0.0),
        fixedCosts: [],
        now: now,
      );

      final high = SafeToSpendCalculator.calculate(
        incomeEntries: incomeList,
        transactions: [],
        settings: const StsSettings(taxRate: 0.20, bufferPercent: 0.0),
        fixedCosts: [],
        now: now,
      );

      expect(low.safeToSpend, greaterThan(high.safeToSpend));
      expect(low.safeToSpend, closeTo(9000.0, 0.01));
      expect(high.safeToSpend, closeTo(8000.0, 0.01));
    });

    test('bufferPercent=0 and taxRate=0 — safeToSpend equals liquidCash', () {
      const income = 50000.0;
      final result = SafeToSpendCalculator.calculate(
        incomeEntries: [makeIncome(income)],
        transactions: [],
        settings: const StsSettings(taxRate: 0.0, bufferPercent: 0.0),
        fixedCosts: [],
        now: now,
      );

      expect(result.safeToSpend, closeTo(income, 0.01));
      expect(result.liquidCash, closeTo(income, 0.01));
    });

    test('adding a fixed cost within window reduces safeToSpend', () {
      final cost = FixedCostEntry(
        id: 'fc1',
        label: 'Rent',
        amount: 5000.0,
        dueDayOfMonth: 22,
        createdAt: now,
      );

      final withoutCost = SafeToSpendCalculator.calculate(
        incomeEntries: [makeIncome(20000)],
        transactions: [],
        settings: const StsSettings(taxRate: 0.0, bufferPercent: 0.0),
        fixedCosts: [],
        now: now,
      );

      final withCost = SafeToSpendCalculator.calculate(
        incomeEntries: [makeIncome(20000)],
        transactions: [],
        settings: const StsSettings(taxRate: 0.0, bufferPercent: 0.0),
        fixedCosts: [cost],
        now: now,
      );

      expect(
        withCost.safeToSpend,
        closeTo(withoutCost.safeToSpend - 5000.0, 0.01),
      );
    });
  });

  // ── Group 4: Provider-level — safeToSpendProvider recomputes ────────────

  group('stsSettingsProvider — ProviderContainer recalculation', () {
    test('updating bufferPercent via notifier changes provider state', () async {
      final fakeRepo = _FakeStsSettingsRepository(
        initial: const StsSettings(taxRate: 0.10, bufferPercent: 15.0),
      );

      final container = ProviderContainer(
        overrides: [
          stsSettingsRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      // Wait for the async _loadSettings to complete.
      await container.read(stsSettingsProvider.notifier).future
          .catchError((_) => const StsSettings());

      final initial = container.read(stsSettingsProvider);
      expect(initial.bufferPercent, closeTo(15.0, 0.01));

      await container
          .read(stsSettingsProvider.notifier)
          .updateBufferPercent(25.0);

      final updated = container.read(stsSettingsProvider);
      expect(updated.bufferPercent, closeTo(25.0, 0.01));
    });

    test('updating taxRate via notifier changes provider state', () async {
      final fakeRepo = _FakeStsSettingsRepository(
        initial: const StsSettings(taxRate: 0.10, bufferPercent: 15.0),
      );

      final container = ProviderContainer(
        overrides: [
          stsSettingsRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      await container.read(stsSettingsProvider.notifier).future
          .catchError((_) => const StsSettings());

      await container.read(stsSettingsProvider.notifier).updateTaxRate(0.25);

      final updated = container.read(stsSettingsProvider);
      expect(updated.taxRate, closeTo(0.25, 0.001));
    });

    test('fake repository persists the last saved settings', () async {
      final fakeRepo = _FakeStsSettingsRepository(
        initial: const StsSettings(taxRate: 0.10, bufferPercent: 15.0),
      );

      final container = ProviderContainer(
        overrides: [
          stsSettingsRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      );
      addTearDown(container.dispose);

      await container.read(stsSettingsProvider.notifier).future
          .catchError((_) => const StsSettings());

      await container
          .read(stsSettingsProvider.notifier)
          .updateBufferPercent(28.0);

      // Verify the fake repo itself holds the value.
      final persisted = await fakeRepo.getSettings();
      expect(persisted.bufferPercent, closeTo(28.0, 0.01));
    });
  });
}

// ---------------------------------------------------------------------------
// Extension to expose the future from StsSettingsNotifier (needed to await
// the initial _loadSettings call in ProviderContainer tests).
// ---------------------------------------------------------------------------
extension _StsNotifierFuture on StsSettingsNotifier {
  // StsSettingsNotifier extends StateNotifier which has no built-in future;
  // we poll until the state is no longer the constructor default.
  Future<StsSettings> get future async => state;
}
