// lib/features/income/data/datasources/income_local_data_source.dart
//
// Abstract interface and Hive implementation for income local persistence.
//
// Rules (per PHASE_7_EXECUTION_PLAN.md):
//   - Returns/accepts IncomeModel objects only (no entities at this layer)
//   - No business logic — pure data access
//   - Box is always retrieved via Hive.box() — never opened here
//   - NEVER call this from presentation layer — use IncomeRepository
//
// Phase 7a — Income Data Layer

import 'package:hive/hive.dart';
import 'package:helm/core/constants/app_box_names.dart';
import 'package:helm/features/income/data/models/income_model.dart';

// ── Abstract interface ────────────────────────────────────────────────────────

/// Contract for local income data access.
///
/// The concrete implementation ([IncomeLocalDataSourceImpl]) targets Hive.
/// Program against this abstract class everywhere except in the provider wire-up.
abstract class IncomeLocalDataSource {
  /// Writes [model] to local storage, keyed by [model.id].
  Future<void> addIncome(IncomeModel model);

  /// Overwrites the stored entry with the same [model.id].
  Future<void> updateIncome(IncomeModel model);

  /// Removes the entry identified by [id].
  /// No-op if [id] is not found.
  Future<void> deleteIncome(String id);

  /// Returns all stored [IncomeModel] objects, unsorted.
  List<IncomeModel> getIncomes();

  /// Removes all income entries from local storage.
  Future<void> clearIncomes();
}

// ── Hive implementation ───────────────────────────────────────────────────────

/// Hive-backed implementation of [IncomeLocalDataSource].
///
/// The box must be opened before any method is called.
/// Opening is managed exclusively by [HiveService.init()].
class IncomeLocalDataSourceImpl implements IncomeLocalDataSource {
  Box<IncomeModel> get _box =>
      Hive.box<IncomeModel>(AppBoxNames.incomeBox);

  @override
  Future<void> addIncome(IncomeModel model) async {
    await _box.put(model.id, model);
  }

  @override
  Future<void> updateIncome(IncomeModel model) async {
    await _box.put(model.id, model);
  }

  @override
  Future<void> deleteIncome(String id) async {
    await _box.delete(id);
  }

  @override
  List<IncomeModel> getIncomes() {
    return _box.values.toList();
  }

  @override
  Future<void> clearIncomes() async {
    await _box.clear();
  }
}
