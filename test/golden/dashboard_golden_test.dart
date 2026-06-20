// test/golden/dashboard_golden_test.dart
//
// Golden tests for Helm dashboard UI widgets.
// Run with: fvm flutter test test/golden/dashboard_golden_test.dart --update-goldens
// Verify with: fvm flutter test test/golden/dashboard_golden_test.dart
//
// Tagged 'golden' so CI can exclude them (macOS baselines differ from Linux rendering):
//   flutter test --exclude-tags golden

@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/core/widgets/next_best_action_card.dart';
import 'package:helm/features/dashboard/presentation/widgets/committed_section.dart';
import 'package:helm/features/dashboard/presentation/widgets/not_counted_section.dart';
import 'package:helm/features/dashboard/presentation/widgets/reserve_section.dart';
import 'package:helm/features/dashboard/presentation/widgets/s2s_hero_block.dart';
import 'package:helm/features/safe_to_spend/domain/entities/safe_to_spend_result.dart';
import 'package:helm/l10n/app_localizations.dart';

// ---------------------------------------------------------------------------
// Shared fixtures
// ---------------------------------------------------------------------------

/// Healthy cashflow state.
const _safeResult = SafeToSpendResult(
  liquidCash: 100000,
  safeToSpend: 45000,
  rawSafeToSpend: 45000,
  fixedCostsDue: 15000,
  anxietyBuffer: 5000,
  taxReserve: 10000,
  totalReceivedIncomeBdt: 100000,
  totalExpenses: 25000,
  pendingIncome: 20000,
  expectedIncome: 30000,
  horizonNumber: 75000,
  excludedUsdIncome: 500,
  excludedUsdEntryCount: 1,
);

/// Negative safe-to-spend (at-risk) state.
const _atRiskResult = SafeToSpendResult(
  liquidCash: 20000,
  safeToSpend: 0,
  rawSafeToSpend: -8000,
  fixedCostsDue: 15000,
  anxietyBuffer: 5000,
  taxReserve: 8000,
  totalReceivedIncomeBdt: 50000,
  totalExpenses: 30000,
  pendingIncome: 5000,
  expectedIncome: 10000,
  horizonNumber: 7000,
  excludedUsdIncome: 0,
  excludedUsdEntryCount: 0,
);

/// No data — all zeros.
const _zeroResult = SafeToSpendResult.zero();

/// Tight but not fully at-risk state.
const _tightResult = SafeToSpendResult(
  liquidCash: 30000,
  safeToSpend: 0,
  rawSafeToSpend: -2000,
  fixedCostsDue: 12000,
  anxietyBuffer: 5000,
  taxReserve: 6000,
  totalReceivedIncomeBdt: 80000,
  totalExpenses: 50000,
  pendingIncome: 10000,
  expectedIncome: 15000,
  horizonNumber: 15500,
  excludedUsdIncome: 200,
  excludedUsdEntryCount: 1,
);

/// A fixed reference time for deterministic golden renders.
final _referenceTime = DateTime(2026, 6, 16, 10, 30);

// ---------------------------------------------------------------------------
// Test widget helper
// ---------------------------------------------------------------------------

Widget buildTestWidget({required Widget child}) {
  return MediaQuery(
    data: const MediaQueryData(disableAnimations: true),
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
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('S2sHeroBlock golden tests', () {
    testWidgets('s2s_hero_block - safe state', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        buildTestWidget(
          child: S2sHeroBlock(
            result: _safeResult,
            updatedAt: _referenceTime,
            onTapTrace: null,
            affirmation: null,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(S2sHeroBlock),
        matchesGoldenFile('goldens/s2s_hero_block_safe.png'),
      );
    });

    testWidgets('s2s_hero_block - atRisk state', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        buildTestWidget(
          child: S2sHeroBlock(
            result: _atRiskResult,
            updatedAt: _referenceTime,
            onTapTrace: null,
            affirmation: null,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(S2sHeroBlock),
        matchesGoldenFile('goldens/s2s_hero_block_at_risk.png'),
      );
    });

    testWidgets('s2s_hero_block - noData state', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        buildTestWidget(
          child: S2sHeroBlock(
            result: _zeroResult,
            updatedAt: _referenceTime,
            onTapTrace: null,
            affirmation: null,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(S2sHeroBlock),
        matchesGoldenFile('goldens/s2s_hero_block_no_data.png'),
      );
    });

    testWidgets('s2s_hero_block - tight state', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        buildTestWidget(
          child: S2sHeroBlock(
            result: _tightResult,
            updatedAt: _referenceTime,
            onTapTrace: null,
            affirmation: null,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(S2sHeroBlock),
        matchesGoldenFile('goldens/s2s_hero_block_tight.png'),
      );
    });

    testWidgets('s2s_hero_block - safe with affirmation', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        buildTestWidget(
          child: S2sHeroBlock(
            result: _safeResult,
            updatedAt: _referenceTime,
            onTapTrace: null,
            affirmation: 'Buffer holding steady.',
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(S2sHeroBlock),
        matchesGoldenFile('goldens/s2s_hero_block_safe_affirmation.png'),
      );
    });
  });

  // -------------------------------------------------------------------------

  group('CommittedSection golden tests', () {
    testWidgets('committed_section - with fixed costs', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        buildTestWidget(
          child: CommittedSection(
            result: _safeResult,
            onSetupFixedCosts: null,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(CommittedSection),
        matchesGoldenFile('goldens/committed_section_with_costs.png'),
      );
    });

    testWidgets('committed_section - empty state with CTA', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        buildTestWidget(
          child: CommittedSection(
            result: _zeroResult,
            onSetupFixedCosts: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(CommittedSection),
        matchesGoldenFile('goldens/committed_section_empty_cta.png'),
      );
    });

    testWidgets('committed_section - empty state no CTA', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        buildTestWidget(
          child: const CommittedSection(
            result: _zeroResult,
            onSetupFixedCosts: null,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(CommittedSection),
        matchesGoldenFile('goldens/committed_section_empty_no_cta.png'),
      );
    });

    testWidgets('committed_section - atRisk result', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        buildTestWidget(
          child: CommittedSection(
            result: _atRiskResult,
            onSetupFixedCosts: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(CommittedSection),
        matchesGoldenFile('goldens/committed_section_at_risk.png'),
      );
    });
  });

  // -------------------------------------------------------------------------

  group('ReserveSection golden tests', () {
    testWidgets('reserve_section - with buffer', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        buildTestWidget(
          child: const ReserveSection(result: _safeResult),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(ReserveSection),
        matchesGoldenFile('goldens/reserve_section_with_buffer.png'),
      );
    });

    testWidgets('reserve_section - no buffer (zero)', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        buildTestWidget(
          child: const ReserveSection(result: _zeroResult),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(ReserveSection),
        matchesGoldenFile('goldens/reserve_section_no_buffer.png'),
      );
    });

    testWidgets('reserve_section - atRisk result', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        buildTestWidget(
          child: const ReserveSection(result: _atRiskResult),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(ReserveSection),
        matchesGoldenFile('goldens/reserve_section_at_risk.png'),
      );
    });
  });

  // -------------------------------------------------------------------------

  group('NotCountedSection golden tests', () {
    testWidgets('not_counted_section - with pending and expected', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        buildTestWidget(
          child: NotCountedSection(
            result: _safeResult,
            onAddPipelineEntry: null,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(NotCountedSection),
        matchesGoldenFile('goldens/not_counted_section_with_data.png'),
      );
    });

    testWidgets('not_counted_section - empty state with CTA', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        buildTestWidget(
          child: NotCountedSection(
            result: _zeroResult,
            onAddPipelineEntry: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(NotCountedSection),
        matchesGoldenFile('goldens/not_counted_section_empty_cta.png'),
      );
    });

    testWidgets('not_counted_section - empty state no CTA', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        buildTestWidget(
          child: const NotCountedSection(
            result: _zeroResult,
            onAddPipelineEntry: null,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(NotCountedSection),
        matchesGoldenFile('goldens/not_counted_section_empty_no_cta.png'),
      );
    });

    testWidgets('not_counted_section - atRisk result', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        buildTestWidget(
          child: NotCountedSection(
            result: _atRiskResult,
            onAddPipelineEntry: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(NotCountedSection),
        matchesGoldenFile('goldens/not_counted_section_at_risk.png'),
      );
    });

    testWidgets('not_counted_section - tight result', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        buildTestWidget(
          child: NotCountedSection(
            result: _tightResult,
            onAddPipelineEntry: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(NotCountedSection),
        matchesGoldenFile('goldens/not_counted_section_tight.png'),
      );
    });
  });

  // -------------------------------------------------------------------------

  group('NextBestActionCard golden tests', () {
    testWidgets('next_best_action_card - setup variant', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        buildTestWidget(
          child: const NextBestActionCard(
            variant: ActionVariant.setup,
            count: 0,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(NextBestActionCard),
        matchesGoldenFile('goldens/next_best_action_card_setup.png'),
      );
    });

    testWidgets('next_best_action_card - overdue variant count 3', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        buildTestWidget(
          child: const NextBestActionCard(
            variant: ActionVariant.overdue,
            count: 3,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(NextBestActionCard),
        matchesGoldenFile('goldens/next_best_action_card_overdue.png'),
      );
    });

    testWidgets('next_best_action_card - atRisk variant', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        buildTestWidget(
          child: const NextBestActionCard(
            variant: ActionVariant.atRisk,
            count: 0,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(NextBestActionCard),
        matchesGoldenFile('goldens/next_best_action_card_at_risk.png'),
      );
    });

    testWidgets('next_best_action_card - relief variant', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        buildTestWidget(
          child: const NextBestActionCard(
            variant: ActionVariant.relief,
            count: 0,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(NextBestActionCard),
        matchesGoldenFile('goldens/next_best_action_card_relief.png'),
      );
    });
  });
}
