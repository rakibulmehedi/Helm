import 'package:hive/hive.dart';
import '../../../../core/constants/app_box_names.dart';
import '../models/transaction_model.dart';

abstract class TransactionLocalDataSource {
  Future<void> addTransaction(TransactionModel transaction);
  Future<List<TransactionModel>> getTransactions();
  Future<void> deleteTransaction(String id);
  Future<void> clearTransactions();
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  Box<TransactionModel> get _box => Hive.box<TransactionModel>(AppBoxNames.transactions);

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    await _box.put(transaction.id, transaction);
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    return _box.values.toList();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> clearTransactions() async {
    await _box.clear();
  }
}
