// lib/features/audit_log/data/models/audit_event_model.dart
//
// Hive-serializable representation of an audit event.
//
// IMPORTANT: typeId is 5 — FIXED. Do not change.
//   typeId 0 → TransactionModel      (FROZEN)
//   typeId 1 → Reserved
//   typeId 2 → IncomeModel           (Phase 7)
//   typeId 3 → FixedCostModel        (Phase 8b)
//   typeId 4 → TransactionTypeAdapter (Phase 1)
//   typeId 5 → AuditEventModel       (D1.05)
//
// HiveField index assignments are PERMANENT after first write.
// Never renumber, remove, or repurpose an existing field index.
//
// Enum values stored as int index — safe for future enum additions.
// D1.05 — Trust Layer: Audit Log

import 'package:hive_ce/hive_ce.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';

part 'audit_event_model.g.dart';

/// Hive-persisted representation of an [AuditEvent].
///
/// Stores [eventType] and [entityType] as their integer indices so that
/// enum additions in future phases do not break existing stored data.
@HiveType(typeId: 5)
class AuditEventModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime timestamp;

  /// Persisted as [AuditEventType.index].
  @HiveField(2)
  final int eventTypeIndex;

  /// Persisted as [AuditEntityType.index].
  @HiveField(3)
  final int entityTypeIndex;

  @HiveField(4)
  final String entityId;

  @HiveField(5)
  final String? previousValue;

  @HiveField(6)
  final String? newValue;

  @HiveField(7)
  final String description;

  AuditEventModel({
    required this.id,
    required this.timestamp,
    required this.eventTypeIndex,
    required this.entityTypeIndex,
    required this.entityId,
    this.previousValue,
    this.newValue,
    required this.description,
  });

  AuditEvent toEntity() => AuditEvent(
        id: id,
        timestamp: timestamp,
        eventType: _eventTypeOrDefault(eventTypeIndex),
        entityType: _entityTypeOrDefault(entityTypeIndex),
        entityId: entityId,
        previousValue: previousValue,
        newValue: newValue,
        description: description,
      );

  static AuditEventType _eventTypeOrDefault(int index) {
    final values = AuditEventType.values;
    if (index < 0 || index >= values.length) return AuditEventType.unknown;
    return values[index];
  }

  static AuditEntityType _entityTypeOrDefault(int index) {
    final values = AuditEntityType.values;
    if (index < 0 || index >= values.length) return AuditEntityType.unknown;
    return values[index];
  }

  static AuditEventModel fromEntity(AuditEvent event) => AuditEventModel(
        id: event.id,
        timestamp: event.timestamp,
        eventTypeIndex: event.eventType.index,
        entityTypeIndex: event.entityType.index,
        entityId: event.entityId,
        previousValue: event.previousValue,
        newValue: event.newValue,
        description: event.description,
      );
}
