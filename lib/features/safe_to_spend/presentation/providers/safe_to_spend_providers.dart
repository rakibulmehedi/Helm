// lib/features/safe_to_spend/presentation/providers/safe_to_spend_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helm/core/analytics/analytics_service.dart';
import 'package:helm/core/analytics/event_registry.dart';
import 'package:helm/features/income/presentation/providers/income_providers.dart';
import 'package:helm/features/safe_to_spend/data/datasources/fixed_cost_local_data_source.dart';
import 'package:helm/features/safe_to_spend/data/datasources/sts_settings_data_source.dart';
import 'package:helm/features/safe_to_spend/data/repositories/fixed_cost_repository_impl.dart';
import 'package:helm/features/safe_to_spend/data/repositories/sts_settings_repository_impl.dart';
import 'package:helm/features/safe_to_spend/domain/entities/fixed_cost_entry.dart';
import 'package:helm/features/safe_to_spend/domain/entities/safe_to_spend_result.dart';
import 'package:helm/features/safe_to_spend/domain/entities/sts_settings.dart';
import 'package:helm/features/safe_to_spend/domain/repositories/fixed_cost_repository.dart';
import 'package:helm/features/safe_to_spend/domain/repositories/sts_settings_repository.dart';
import 'package:helm/features/safe_to_spend/domain/safe_to_spend_calculator.dart';
import 'package:helm/features/transactions/presentation/providers/transaction_provider.dart';

// --- Data Sources ---
final fixedCostDataSourceProvider = Provider<FixedCostLocalDataSource>((ref) {
  return FixedCostLocalDataSourceImpl();
});

final stsSettingsDataSourceProvider = Provider<StsSettingsDataSource>((ref) {
  return StsSettingsDataSourceImpl();
});

// --- Repositories ---
final fixedCostRepositoryProvider = Provider<FixedCostRepository>((ref) {
  final dataSource = ref.watch(fixedCostDataSourceProvider);
  return FixedCostRepositoryImpl(dataSource: dataSource);
});

final stsSettingsRepositoryProvider = Provider<StsSettingsRepository>((ref) {
  final dataSource = ref.watch(stsSettingsDataSourceProvider);
  return StsSettingsRepositoryImpl(dataSource: dataSource);
});

// --- State Notifiers ---

final fixedCostNotifierProvider =
    StateNotifierProvider<FixedCostNotifier, List<FixedCostEntry>>((ref) {
  final repository = ref.watch(fixedCostRepositoryProvider);
  return FixedCostNotifier(repository);
});

class FixedCostNotifier extends StateNotifier<List<FixedCostEntry>> {
  final FixedCostRepository _repository;

  FixedCostNotifier(this._repository) : super([]) {
    _loadFixedCosts();
  }

  Future<void> _loadFixedCosts() async {
    final costs = await _repository.getFixedCosts();
    if (!mounted) return;
    state = costs;
  }

  Future<void> addFixedCost(FixedCostEntry entry) async {
    await _repository.addFixedCost(entry);
    if (!mounted) return;
    state = [...state, entry];
  }

  Future<void> updateFixedCost(FixedCostEntry entry) async {
    await _repository.updateFixedCost(entry);
    if (!mounted) return;
    state = [
      for (final cost in state)
        if (cost.id == entry.id) entry else cost,
    ];
  }

  Future<void> deleteFixedCost(String id) async {
    await _repository.deleteFixedCost(id);
    if (!mounted) return;
    state = state.where((cost) => cost.id != id).toList();
  }
}

final stsSettingsProvider =
    StateNotifierProvider<StsSettingsNotifier, StsSettings>((ref) {
  final repository = ref.watch(stsSettingsRepositoryProvider);
  return StsSettingsNotifier(repository);
});

class StsSettingsNotifier extends StateNotifier<StsSettings> {
  final StsSettingsRepository _repository;

  StsSettingsNotifier(this._repository) : super(const StsSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _repository.getSettings();
    if (!mounted) return;
    state = settings;
  }

  Future<void> updateTaxRate(double rate) async {
    final clamped = rate.clamp(0.0, 0.40);
    final newSettings = state.copyWith(taxRate: clamped);
    await _repository.saveSettings(newSettings);
    if (!mounted) return;
    state = newSettings;
  }

  Future<void> updateBufferPercent(double percent) async {
    final clamped = percent.clamp(0.0, 100.0);
    final newSettings = state.copyWith(bufferPercent: clamped);
    await _repository.saveSettings(newSettings);
    if (!mounted) return;
    state = newSettings;
  }

  /// Migration compatibility. Use [updateBufferPercent] instead.
  @Deprecated('Use updateBufferPercent instead')
  Future<void> updateAnxietyBuffer(double buffer) =>
      updateBufferPercent(buffer);
}

// --- Safe-to-Spend Computed Provider ---

final safeToSpendProvider = Provider<SafeToSpendResult>((ref) {
  final incomeEntries = ref.watch(incomeNotifierProvider);
  final transactionsAsync = ref.watch(transactionsProvider);
  final settings = ref.watch(stsSettingsProvider);
  final fixedCosts = ref.watch(fixedCostNotifierProvider);

  final transactions = transactionsAsync.valueOrNull ?? [];

  try {
    return SafeToSpendCalculator.calculate(
      incomeEntries: incomeEntries,
      transactions: transactions,
      settings: settings,
      fixedCosts: fixedCosts,
      now: DateTime.now(),
    );
  } on Exception catch (e) {
    try {
      ref.read(analyticsProvider).trackEvent(
        BoundaryEvents.s2sCalcFailure,
        properties: {'error_type': e.runtimeType.toString()},
      );
    } on Exception catch (_) {
      // analytics provider may not be available during tests
    }
    return SafeToSpendResult.failure(e.runtimeType.toString());
  }
});
