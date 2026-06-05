// lib/features/income/data/repositories/income_repository_impl.dart
//
// Concrete implementation of the IncomeRepository domain contract.
//
// Responsibility:
//   - Wraps IncomeLocalDataSource (data layer)
//   - Maps IncomeModel ↔ IncomeEntryEntity (domain ↔ data translation)
//   - Surfaces domain-safe exceptions to callers
//   - No UI logic, no Riverpod, no Flutter imports
//
// Phase 7a — Income Data Layer

import 'package:pocketa_v2/features/audit_log/data/datasources/audit_local_data_source.dart';
import 'package:pocketa_v2/features/audit_log/domain/entities/audit_event.dart';
import 'package:pocketa_v2/features/income/data/datasources/income_local_data_source.dart';
import 'package:pocketa_v2/features/income/data/models/income_model.dart';
import 'package:pocketa_v2/features/income/domain/entities/income_entry_entity.dart';
import 'package:pocketa_v2/features/income/domain/repositories/income_repository.dart';

/// Concrete repository bridging the income domain and Hive data layer.
///
/// All public methods accept/return [IncomeEntryEntity] objects.
/// Internally converts to/from [IncomeModel] before delegating to the
/// [IncomeLocalDataSource].
class IncomeRepositoryImpl implements IncomeRepository {
  final IncomeLocalDataSource _dataSource;

  IncomeRepositoryImpl(this._dataSource);

  @override
  Future<void> addIncome(IncomeEntryEntity entity) async {
    final model = IncomeModel.fromEntity(entity);
    await _dataSource.addIncome(model);
    try {
      final auditDs = AuditLocalDataSourceImpl();
      await auditDs.addEvent(AuditEvent(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp: DateTime.now(),
        eventType: AuditEventType.created,
        entityType: AuditEntityType.income,
        entityId: entity.id,
        previousValue: null,
        newValue: entity.toString(),
        description: 'Income entry created: ${entity.id}',
      ));
    } catch (_) {
      // Audit failure is non-fatal — do not propagate
    }
  }

  @override
  Future<void> updateIncome(IncomeEntryEntity entity) async {
    final model = IncomeModel.fromEntity(entity);
    await _dataSource.updateIncome(model);
    try {
      final auditDs = AuditLocalDataSourceImpl();
      // Emit 'confirmed' when status transitions to received, 'updated' otherwise.
      final eventType = entity.status == IncomeStatus.received
          ? AuditEventType.confirmed
          : AuditEventType.updated;
      final description = entity.status == IncomeStatus.received
          ? 'Income confirmed received: ${entity.id}'
          : 'Income entry updated: ${entity.id}';
      await auditDs.addEvent(AuditEvent(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp: DateTime.now(),
        eventType: eventType,
        entityType: AuditEntityType.income,
        entityId: entity.id,
        previousValue: null,
        newValue: entity.toString(),
        description: description,
      ));
    } catch (_) {
      // Audit failure is non-fatal — do not propagate
    }
  }

  @override
  Future<void> deleteIncome(String id) async {
    await _dataSource.deleteIncome(id);
    try {
      final auditDs = AuditLocalDataSourceImpl();
      await auditDs.addEvent(AuditEvent(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp: DateTime.now(),
        eventType: AuditEventType.deleted,
        entityType: AuditEntityType.income,
        entityId: id,
        previousValue: null,
        newValue: null,
        description: 'Income entry deleted: $id',
      ));
    } catch (_) {
      // Audit failure is non-fatal — do not propagate
    }
  }

  @override
  List<IncomeEntryEntity> getIncomes() {
    return _dataSource.getIncomes().map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> clearIncomes() async {
    await _dataSource.clearIncomes();
  }
}
