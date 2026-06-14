// lib/features/safe_to_spend/domain/repositories/fixed_cost_repository.dart

import 'package:helm/features/safe_to_spend/domain/entities/fixed_cost_entry.dart';

/// Abstract repository for managing [FixedCostEntry] records.
abstract class FixedCostRepository {
  /// Fetch all fixed cost entries.
  Future<List<FixedCostEntry>> getFixedCosts();

  /// Add a new fixed cost entry.
  Future<void> addFixedCost(FixedCostEntry entry);

  /// Update an existing fixed cost entry.
  Future<void> updateFixedCost(FixedCostEntry entry);

  /// Delete a fixed cost entry by ID.
  Future<void> deleteFixedCost(String id);
}
