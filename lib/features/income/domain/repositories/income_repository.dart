// lib/features/income/domain/repositories/income_repository.dart
//
// Abstract contract for the income data access layer.
// Presentation and domain layers program against this interface.
// The concrete implementation lives in data/repositories/income_repository_impl.dart.
//
// Phase 7a — Income Data Layer

import 'package:pocketa_v2/features/income/domain/entities/income_entry_entity.dart';

/// Abstract repository contract for the Freelancer Income domain.
///
/// All methods accept and return [IncomeEntryEntity] objects.
/// The data layer is responsible for mapping to/from [IncomeModel].
///
/// IMPORTANT: This repository is domain-only. It must not import any
/// Hive, Flutter, or data-layer symbols. Presentation layer depends
/// only on this interface — never on [IncomeRepositoryImpl].
abstract class IncomeRepository {
  /// Persists a new [entity] to local storage.
  ///
  /// Throws if the write fails (caller is responsible for error handling).
  Future<void> addIncome(IncomeEntryEntity entity);

  /// Overwrites the existing entry with the same [entity.id].
  ///
  /// Throws if the entry does not exist or the write fails.
  Future<void> updateIncome(IncomeEntryEntity entity);

  /// Removes the income entry identified by [id].
  ///
  /// No-op if [id] is not found. Throws on write failure.
  Future<void> deleteIncome(String id);

  /// Returns all stored income entries, unsorted.
  ///
  /// Sorting and filtering are the responsibility of the widget layer
  /// per PHASE_7_STATE_FLOW.md §4 (Ownership Rules).
  List<IncomeEntryEntity> getIncomes();

  /// Removes all income entries from local storage.
  ///
  /// Intended for testing and data-reset scenarios only.
  Future<void> clearIncomes();
}
