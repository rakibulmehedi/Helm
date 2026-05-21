import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_local_data_source.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl(this.localDataSource);

  @override
  Future<void> addTransaction(TransactionModel transaction) {
    return localDataSource.addTransaction(transaction);
  }

  @override
  Future<void> clearTransactions() {
    return localDataSource.clearTransactions();
  }

  @override
  Future<void> deleteTransaction(String id) {
    return localDataSource.deleteTransaction(id);
  }

  @override
  Future<List<TransactionModel>> getTransactions() {
    return localDataSource.getTransactions();
  }
}
