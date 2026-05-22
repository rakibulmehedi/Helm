// lib/features/safe_to_spend/data/repositories/fixed_cost_repository_impl.dart

import 'package:pocketa_v2/features/safe_to_spend/data/datasources/fixed_cost_local_data_source.dart';
import 'package:pocketa_v2/features/safe_to_spend/data/models/fixed_cost_model.dart';
import 'package:pocketa_v2/features/safe_to_spend/domain/entities/fixed_cost_entry.dart';
import 'package:pocketa_v2/features/safe_to_spend/domain/repositories/fixed_cost_repository.dart';

class FixedCostRepositoryImpl implements FixedCostRepository {
  final FixedCostLocalDataSource _dataSource;

  FixedCostRepositoryImpl({required FixedCostLocalDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<List<FixedCostEntry>> getFixedCosts() async {
    final models = await _dataSource.getFixedCosts();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> addFixedCost(FixedCostEntry entry) async {
    final model = FixedCostModel.fromEntity(entry);
    await _dataSource.addFixedCost(model);
  }

  @override
  Future<void> updateFixedCost(FixedCostEntry entry) async {
    final model = FixedCostModel.fromEntity(entry);
    await _dataSource.updateFixedCost(model);
  }

  @override
  Future<void> deleteFixedCost(String id) async {
    await _dataSource.deleteFixedCost(id);
  }
}
