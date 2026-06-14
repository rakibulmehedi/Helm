// lib/features/audit_log/domain/entities/audit_event.dart
//
// Pure Dart domain entities for the audit log.
// Zero Flutter or Hive imports — clean domain layer.
//
// APPEND-ONLY: Audit records must never be deleted or modified.
// D1.05 — Trust Layer: Audit Log

/// Types of financial events that trigger audit records.
enum AuditEventType {
  unknown,
  created,
  updated,
  deleted,
  confirmed,
  exported,
}

/// Types of entities that can be audited.
enum AuditEntityType {
  unknown,
  income,
  transaction,
  stsSettings,
  fixedCost,
}

/// Immutable audit event — append-only record of financial changes.
///
/// Domain rules:
/// - Records are NEVER deleted or mutated after creation.
/// - [previousValue] is null for [AuditEventType.created] events.
/// - [newValue] is null for [AuditEventType.deleted] events.
class AuditEvent {
  final String id;
  final DateTime timestamp;
  final AuditEventType eventType;
  final AuditEntityType entityType;
  final String entityId;
  final String? previousValue;
  final String? newValue;
  final String description;

  const AuditEvent({
    required this.id,
    required this.timestamp,
    required this.eventType,
    required this.entityType,
    required this.entityId,
    this.previousValue,
    this.newValue,
    required this.description,
  });

  AuditEvent copyWith({
    String? id,
    DateTime? timestamp,
    AuditEventType? eventType,
    AuditEntityType? entityType,
    String? entityId,
    String? previousValue,
    String? newValue,
    String? description,
  }) {
    return AuditEvent(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      eventType: eventType ?? this.eventType,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      previousValue: previousValue ?? this.previousValue,
      newValue: newValue ?? this.newValue,
      description: description ?? this.description,
    );
  }
}
