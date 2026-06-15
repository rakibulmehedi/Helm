import 'package:helm/core/utils/id_generator.dart';
import 'package:helm/core/utils/input_validator.dart';
import 'package:helm/features/audit_log/data/datasources/audit_local_data_source.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';
import 'package:helm/features/safe_to_spend/data/datasources/fixed_cost_local_data_source.dart';
import 'package:helm/features/safe_to_spend/data/models/fixed_cost_model.dart';
import 'package:helm/features/safe_to_spend/domain/entities/fixed_cost_entry.dart';
import 'package:helm/features/safe_to_spend/domain/repositories/fixed_cost_repository.dart';

class FixedCostRepositoryImpl implements FixedCostRepository {
  final FixedCostLocalDataSource _dataSource;
  final AuditLocalDataSource? _auditDataSource;

  FixedCostRepositoryImpl({
    required FixedCostLocalDataSource dataSource,
    AuditLocalDataSource? auditDataSource,
  })  : _dataSource = dataSource,
        _auditDataSource = auditDataSource;

  AuditLocalDataSource get _audit => _auditDataSource ?? AuditLocalDataSourceImpl();

  @override
  Future<List<FixedCostEntry>> getFixedCosts() async {
    final models = await _dataSource.getFixedCosts();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> addFixedCost(FixedCostEntry entry) async {
    if (!FixedCostEntry.isValidDueDay(entry.dueDayOfMonth)) {
      throw ArgumentError.value(
        entry.dueDayOfMonth,
        'dueDayOfMonth',
        'Must be between 1 and 28',
      );
    }
    final existing = await _dataSource.getFixedCosts();
    if (existing.any((m) => m.id == entry.id)) {
      throw ArgumentError.value(
        entry.id,
        'id',
        'A fixed cost with this id already exists',
      );
    }
    final model = FixedCostModel.fromEntity(entry);
    await _dataSource.addFixedCost(model);
    try {
      await _audit.addEvent(AuditEvent(
        id: IdGenerator.uniqueId(),
        timestamp: DateTime.now(),
        eventType: AuditEventType.created,
        entityType: AuditEntityType.fixedCost,
        entityId: entry.id,
        previousValue: null,
        newValue: entry.toString(),
        description: InputValidator.sanitizeText(
          'Fixed cost created: ${entry.id}',
        ),
      ));
    } on Exception catch (_) {
      // Audit failure is non-fatal — do not propagate
    }
  }

  @override
  Future<void> updateFixedCost(FixedCostEntry entry) async {
    if (!FixedCostEntry.isValidDueDay(entry.dueDayOfMonth)) {
      throw ArgumentError.value(
        entry.dueDayOfMonth,
        'dueDayOfMonth',
        'Must be between 1 and 28',
      );
    }
    final previous = (await _dataSource.getFixedCosts())
        .cast<FixedCostModel?>()
        .firstWhere(
          (m) => m!.id == entry.id,
          orElse: () => null,
        );
    final model = FixedCostModel.fromEntity(entry);
    await _dataSource.updateFixedCost(model);
    try {
      await _audit.addEvent(AuditEvent(
        id: IdGenerator.uniqueId(),
        timestamp: DateTime.now(),
        eventType: AuditEventType.updated,
        entityType: AuditEntityType.fixedCost,
        entityId: entry.id,
        previousValue: previous?.toString(),
        newValue: entry.toString(),
        description: InputValidator.sanitizeText(
          'Fixed cost updated: ${entry.id}',
        ),
      ));
    } on Exception catch (_) {
      // Audit failure is non-fatal — do not propagate
    }
  }

  @override
  Future<void> deleteFixedCost(String id) async {
    final previous = (await _dataSource.getFixedCosts())
        .cast<FixedCostModel?>()
        .firstWhere(
          (m) => m!.id == id,
          orElse: () => null,
        );
    await _dataSource.deleteFixedCost(id);
    try {
      await _audit.addEvent(AuditEvent(
        id: IdGenerator.uniqueId(),
        timestamp: DateTime.now(),
        eventType: AuditEventType.deleted,
        entityType: AuditEntityType.fixedCost,
        entityId: id,
        previousValue: previous?.toString(),
        newValue: null,
        description: InputValidator.sanitizeText('Fixed cost deleted: $id'),
      ));
    } on Exception catch (_) {
      // Audit failure is non-fatal — do not propagate
    }
  }
}
