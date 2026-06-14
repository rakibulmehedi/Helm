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

import 'package:hive/hive.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';

part 'audit_event_model.g.dart';

/// Hive-persisted representation of an [AuditEvent].
///
/// Stores [eventType] and [entityType] as their integer indices so that
/// enum additions in future phases do not break existing stored data.
@HiveType(typeId: 5)
class AuditEventModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late DateTime timestamp;

  /// Persisted as [AuditEventType.index].
  @HiveField(2)
  late int eventTypeIndex;

  /// Persisted as [AuditEntityType.index].
  @HiveField(3)
  late int entityTypeIndex;

  @HiveField(4)
  late String entityId;

  @HiveField(5)
  String? previousValue;

  @HiveField(6)
  String? newValue;

  @HiveField(7)
  late String description;

  AuditEvent toEntity() => AuditEvent(
        id: id,
        timestamp: timestamp,
        eventType: AuditEventType.values[eventTypeIndex],
        entityType: AuditEntityType.values[entityTypeIndex],
        entityId: entityId,
        previousValue: previousValue,
        newValue: newValue,
        description: description,
      );

  static AuditEventModel fromEntity(AuditEvent event) => AuditEventModel()
    ..id = event.id
    ..timestamp = event.timestamp
    ..eventTypeIndex = event.eventType.index
    ..entityTypeIndex = event.entityType.index
    ..entityId = event.entityId
    ..previousValue = event.previousValue
    ..newValue = event.newValue
    ..description = event.description;
}
