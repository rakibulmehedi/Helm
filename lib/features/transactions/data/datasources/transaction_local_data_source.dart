import 'package:hive_ce/hive_ce.dart';
import '../../../../core/constants/app_box_names.dart';
import '../models/transaction_model.dart';
import 'package:helm/core/utils/id_generator.dart';
import 'package:helm/core/utils/input_validator.dart';
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
        id: IdGenerator.uniqueId(),
        timestamp: DateTime.now(),
        eventType: AuditEventType.created,
        entityType: AuditEntityType.transaction,
        entityId: transaction.id,
        previousValue: null,
        newValue: transaction.toString(),
        description: InputValidator.sanitizeText(
          'Transaction created: ${transaction.id}',
        ),
      ));
    } on Exception catch (_) {
      // Audit failure is non-fatal — do not propagate
    }
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    final previous = _box.get(transaction.id)?.toString();
    await _box.put(transaction.id, transaction);
    try {
      final auditDs = AuditLocalDataSourceImpl();
      await auditDs.addEvent(AuditEvent(
        id: IdGenerator.uniqueId(),
        timestamp: DateTime.now(),
        eventType: AuditEventType.updated,
        entityType: AuditEntityType.transaction,
        entityId: transaction.id,
        previousValue: previous,
        newValue: transaction.toString(),
        description: InputValidator.sanitizeText(
          'Transaction updated: ${transaction.id}',
        ),
      ));
    } on Exception catch (_) {
      // Audit failure is non-fatal — do not propagate
    }
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    return _box.values.toList();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final previous = _box.get(id)?.toString();
    await _box.delete(id);
    try {
      final auditDs = AuditLocalDataSourceImpl();
      await auditDs.addEvent(AuditEvent(
        id: IdGenerator.uniqueId(),
        timestamp: DateTime.now(),
        eventType: AuditEventType.deleted,
        entityType: AuditEntityType.transaction,
        entityId: id,
        previousValue: previous,
        newValue: null,
        description: InputValidator.sanitizeText('Transaction deleted: $id'),
      ));
    } on Exception catch (_) {
      // Audit failure is non-fatal — do not propagate
    }
  }

  @override
  Future<void> clearTransactions() async {
    await _box.clear();
  }
}
