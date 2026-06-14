import 'package:hive/hive.dart';
import '../../../../core/constants/app_box_names.dart';
import '../models/transaction_model.dart';
import 'package:helm/features/audit_log/data/datasources/audit_local_data_source.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';

abstract class TransactionLocalDataSource {
  Future<void> addTransaction(TransactionModel transaction);
  Future<void> updateTransaction(TransactionModel transaction);
  Future<List<TransactionModel>> getTransactions();
  Future<void> deleteTransaction(String id);
  Future<void> clearTransactions();
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  Box<TransactionModel> get _box => Hive.box<TransactionModel>(AppBoxNames.transactions);

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    await _box.put(transaction.id, transaction);
    try {
      final auditDs = AuditLocalDataSourceImpl();
      await auditDs.addEvent(AuditEvent(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp: DateTime.now(),
        eventType: AuditEventType.created,
        entityType: AuditEntityType.transaction,
        entityId: transaction.id,
        previousValue: null,
        newValue: transaction.toString(),
        description: 'Transaction created: ${transaction.id}',
      ));
    } catch (_) {
      // Audit failure is non-fatal — do not propagate
    }
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    await _box.put(transaction.id, transaction);
    try {
      final auditDs = AuditLocalDataSourceImpl();
      await auditDs.addEvent(AuditEvent(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp: DateTime.now(),
        eventType: AuditEventType.updated,
        entityType: AuditEntityType.transaction,
        entityId: transaction.id,
        previousValue: null,
        newValue: transaction.toString(),
        description: 'Transaction updated: ${transaction.id}',
      ));
    } catch (_) {
      // Audit failure is non-fatal — do not propagate
    }
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    return _box.values.toList();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await _box.delete(id);
    try {
      final auditDs = AuditLocalDataSourceImpl();
      await auditDs.addEvent(AuditEvent(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp: DateTime.now(),
        eventType: AuditEventType.deleted,
        entityType: AuditEntityType.transaction,
        entityId: id,
        previousValue: null,
        newValue: null,
        description: 'Transaction deleted: $id',
      ));
    } catch (_) {
      // Audit failure is non-fatal — do not propagate
    }
  }

  @override
  Future<void> clearTransactions() async {
    await _box.clear();
  }
}
