// lib/features/transactions/domain/repositories/transaction_repository.dart
//
// Domain repository interface for transactions.
//
// Phase 7f — Updated to use TransactionEntity instead of TransactionModel.
// The domain layer no longer imports from the data layer.

import '../entities/transaction_entity.dart';

/// Contract for transaction persistence operations.
///
/// Accepts and returns [TransactionEntity] — the pure domain type.
/// Implementations map to/from storage models internally.
abstract class TransactionRepository {
  Future<void> addTransaction(TransactionEntity transaction);
  Future<void> updateTransaction(TransactionEntity transaction);
  Future<List<TransactionEntity>> getTransactions();
  Future<void> deleteTransaction(String id);
  Future<void> clearTransactions();
}
