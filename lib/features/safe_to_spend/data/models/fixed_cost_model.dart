// lib/features/safe_to_spend/data/models/fixed_cost_model.dart

import 'package:hive_ce/hive_ce.dart';
import 'package:helm/features/safe_to_spend/domain/entities/fixed_cost_entry.dart';

part 'fixed_cost_model.g.dart';

/// Hive model for [FixedCostEntry].
/// TypeId 3 is reserved in HIVE_TYPEID_REGISTRY.md.
@HiveType(typeId: 3)
class FixedCostModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String label;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final int dueDayOfMonth;

  @HiveField(4)
  final DateTime createdAt;

  FixedCostModel({
    required this.id,
    required this.label,
    required this.amount,
    required this.dueDayOfMonth,
    required this.createdAt,
  });

  /// Convert from Domain Entity to Hive Model
  factory FixedCostModel.fromEntity(FixedCostEntry entity) {
    return FixedCostModel(
      id: entity.id,
      label: entity.label,
      amount: entity.amount,
      dueDayOfMonth: entity.dueDayOfMonth,
      createdAt: entity.createdAt,
    );
  }

  /// Convert from Hive Model to Domain Entity
  FixedCostEntry toEntity() {
    return FixedCostEntry(
      id: id,
      label: label,
      amount: amount,
      dueDayOfMonth: dueDayOfMonth,
      createdAt: createdAt,
    );
  }
}
