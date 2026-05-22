// lib/features/income/data/repositories/income_repository_impl.dart
//
// Concrete implementation of the IncomeRepository domain contract.
//
// Responsibility:
//   - Wraps IncomeLocalDataSource (data layer)
//   - Maps IncomeModel ↔ IncomeEntryEntity (domain ↔ data translation)
//   - Surfaces domain-safe exceptions to callers
//   - No UI logic, no Riverpod, no Flutter imports
//
// Phase 7a — Income Data Layer

import 'package:pocketa_v2/features/income/data/datasources/income_local_data_source.dart';
import 'package:pocketa_v2/features/income/data/models/income_model.dart';
import 'package:pocketa_v2/features/income/domain/entities/income_entry_entity.dart';
import 'package:pocketa_v2/features/income/domain/repositories/income_repository.dart';

/// Concrete repository bridging the income domain and Hive data layer.
///
/// All public methods accept/return [IncomeEntryEntity] objects.
/// Internally converts to/from [IncomeModel] before delegating to the
/// [IncomeLocalDataSource].
class IncomeRepositoryImpl implements IncomeRepository {
  final IncomeLocalDataSource _dataSource;

  IncomeRepositoryImpl(this._dataSource);

  @override
  Future<void> addIncome(IncomeEntryEntity entity) async {
    final model = IncomeModel.fromEntity(entity);
    await _dataSource.addIncome(model);
  }

  @override
  Future<void> updateIncome(IncomeEntryEntity entity) async {
    final model = IncomeModel.fromEntity(entity);
    await _dataSource.updateIncome(model);
  }

  @override
  Future<void> deleteIncome(String id) async {
    await _dataSource.deleteIncome(id);
  }

  @override
  List<IncomeEntryEntity> getIncomes() {
    return _dataSource.getIncomes().map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> clearIncomes() async {
    await _dataSource.clearIncomes();
  }
}
