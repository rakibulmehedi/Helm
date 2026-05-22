// lib/features/safe_to_spend/data/datasources/fixed_cost_local_data_source.dart

import 'package:hive/hive.dart';
import 'package:pocketa_v2/core/constants/app_box_names.dart';
import 'package:pocketa_v2/features/safe_to_spend/data/models/fixed_cost_model.dart';

abstract class FixedCostLocalDataSource {
  Future<List<FixedCostModel>> getFixedCosts();
  Future<void> addFixedCost(FixedCostModel model);
  Future<void> updateFixedCost(FixedCostModel model);
  Future<void> deleteFixedCost(String id);
}

class FixedCostLocalDataSourceImpl implements FixedCostLocalDataSource {
  final Box<FixedCostModel> _box;

  FixedCostLocalDataSourceImpl({Box<FixedCostModel>? box})
      : _box = box ?? Hive.box<FixedCostModel>(AppBoxNames.fixedCostsBox);

  @override
  Future<List<FixedCostModel>> getFixedCosts() async {
    return _box.values.toList();
  }

  @override
  Future<void> addFixedCost(FixedCostModel model) async {
    await _box.put(model.id, model);
  }

  @override
  Future<void> updateFixedCost(FixedCostModel model) async {
    if (_box.containsKey(model.id)) {
      await _box.put(model.id, model);
    } else {
      throw Exception('Fixed cost entry not found');
    }
  }

  @override
  Future<void> deleteFixedCost(String id) async {
    await _box.delete(id);
  }
}
