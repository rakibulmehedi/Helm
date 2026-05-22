// lib/features/transactions/data/repositories/transaction_repository_impl.dart
//
// Concrete implementation of [TransactionRepository].
//
// Phase 7f — Maps TransactionEntity ↔ TransactionModel internally.
// The repository interface (domain) now accepts/returns entities only.
// All TransactionModel usage is hidden behind this class.

import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_local_data_source.dart';
import '../models/transaction_model.dart';

/// Bridges the domain [TransactionRepository] interface and the Hive data source.
///
/// All entity-to-model and model-to-entity conversions happen here.
/// The domain and presentation layers never interact with [TransactionModel].
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl(this.localDataSource);

  @override
  Future<void> addTransaction(TransactionEntity transaction) {
    return localDataSource.addTransaction(
      TransactionModel.fromEntity(transaction),
    );
  }

  @override
  Future<void> updateTransaction(TransactionEntity transaction) {
    return localDataSource.updateTransaction(
      TransactionModel.fromEntity(transaction),
    );
  }

  @override
  Future<List<TransactionEntity>> getTransactions() async {
    final models = await localDataSource.getTransactions();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> deleteTransaction(String id) {
    return localDataSource.deleteTransaction(id);
  }

  @override
  Future<void> clearTransactions() {
    return localDataSource.clearTransactions();
  }
}
