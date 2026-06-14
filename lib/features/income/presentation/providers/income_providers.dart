// lib/features/income/presentation/providers/income_providers.dart
//
// All Riverpod providers for the Freelancer Income feature.
//
// Provider hierarchy:
//   incomeDataSourceProvider
//       └── incomeRepositoryProvider
//               └── incomeNotifierProvider
//
// Rules (per PHASE_7_STATE_FLOW.md §4):
//   - These providers must NOT watch any transaction provider.
//   - No transaction provider watches these providers.
//   - Filter/sort logic lives in the widget layer, NOT here.
//   - Derived totals (expectedTotal, etc.) are computed in widgets, NOT here.
//   - No income provider goes outside this file.
//
// Phase 7a — Income Data Layer

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helm/features/income/data/datasources/income_local_data_source.dart';
import 'package:helm/features/income/data/repositories/income_repository_impl.dart';
import 'package:helm/features/income/domain/entities/income_entry_entity.dart';
import 'package:helm/features/income/domain/repositories/income_repository.dart';

// ── Infrastructure providers ──────────────────────────────────────────────────

/// Provides the singleton [IncomeLocalDataSource] (Hive-backed).
///
/// The incomeBox must be open before this provider is first read.
/// Opening is guaranteed by [HiveService.init()] in main().
final incomeDataSourceProvider = Provider<IncomeLocalDataSource>((ref) {
  return IncomeLocalDataSourceImpl();
});

/// Provides the singleton [IncomeRepository] wired to [incomeDataSourceProvider].
final incomeRepositoryProvider = Provider<IncomeRepository>((ref) {
  final dataSource = ref.watch(incomeDataSourceProvider);
  return IncomeRepositoryImpl(dataSource);
});

// ── State notifier provider ───────────────────────────────────────────────────

/// Provides the [IncomeNotifier] and its state: the full list of income entries.
///
/// Widgets that need the income list, filtered lists, or pipeline totals
/// should watch this provider and compute derived values in their build method.
///
/// DO NOT create separate providers for expectedTotal, pendingTotal, etc.
/// (per PHASE_7_STATE_FLOW.md §4 — Single Calculation Point Rule)
final incomeNotifierProvider =
    StateNotifierProvider<IncomeNotifier, List<IncomeEntryEntity>>((ref) {
  final repository = ref.watch(incomeRepositoryProvider);
  return IncomeNotifier(repository);
});

// ── State notifier ────────────────────────────────────────────────────────────

/// Manages the live list of [IncomeEntryEntity] objects.
///
/// State is the authoritative in-memory mirror of [AppBoxNames.incomeBox].
/// Any Hive write must be immediately reflected in state.
///
/// Sorting, filtering, and total computation are NOT done here —
/// they are the responsibility of the widget layer.
class IncomeNotifier extends StateNotifier<List<IncomeEntryEntity>> {
  final IncomeRepository _repository;

  /// Initialises with all persisted income entries loaded from Hive.
  IncomeNotifier(this._repository) : super([]) {
    _loadAll();
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  /// Reads all entries from the repository and updates state.
  void _loadAll() {
    state = _repository.getIncomes();
  }

  // ── Public CRUD methods ───────────────────────────────────────────────────

  /// Persists [entity] and appends it to state.
  ///
  /// If an entry with the same ID already exists, it is silently ignored
  /// to prevent duplicate state entries from double-taps.
  /// Throws on Hive write failure (caller handles error display).
  Future<void> addIncome(IncomeEntryEntity entity) async {
    if (state.any((e) => e.id == entity.id)) return;
    await _repository.addIncome(entity);
    if (!mounted) return;
    state = [...state, entity];
  }

  /// Persists [entity] (overwrite) and replaces the matching entry in state.
  ///
  /// If [entity.id] is not found in state, the entry is appended defensively
  /// to keep Hive and in-memory state consistent.
  Future<void> updateIncome(IncomeEntryEntity entity) async {
    await _repository.updateIncome(entity);
    if (!mounted) return;
    final found = state.any((e) => e.id == entity.id);
    if (found) {
      state = [
        for (final e in state)
          if (e.id == entity.id) entity else e,
      ];
    } else {
      state = [...state, entity];
    }
  }

  /// Removes the entry with [id] from Hive and from state.
  Future<void> deleteIncome(String id) async {
    await _repository.deleteIncome(id);
    if (!mounted) return;
    state = state.where((e) => e.id != id).toList();
  }

  /// Removes all entries from Hive and clears state.
  ///
  /// Use only for testing or explicit data-reset scenarios.
  Future<void> clearIncomes() async {
    await _repository.clearIncomes();
    if (!mounted) return;
    state = [];
  }
}
