// test/features/audit_log/data/models/audit_event_model_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:helm/features/audit_log/data/models/audit_event_model.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';

void main() {
  group('AuditEventModel', () {
    test('round-trips valid entity', () {
      final event = AuditEvent(
        id: 'id-1',
        timestamp: DateTime(2025, 1, 2, 3, 4, 5),
        eventType: AuditEventType.created,
        entityType: AuditEntityType.transaction,
        entityId: 'tx-1',
        previousValue: null,
        newValue: '100',
        description: 'Created transaction',
      );

      final model = AuditEventModel.fromEntity(event);
      final result = model.toEntity();

      expect(result.id, event.id);
      expect(result.eventType, event.eventType);
      expect(result.entityType, event.entityType);
      expect(result.description, event.description);
    });

    test('toEntity falls back to unknown for out-of-range eventTypeIndex', () {
      final model = AuditEventModel(
        id: 'id-1',
        timestamp: DateTime.now(),
        eventTypeIndex: 999,
        entityTypeIndex: 0,
        entityId: 'tx-1',
        description: 'Corrupted',
      );

      expect(model.toEntity().eventType, AuditEventType.unknown);
    });

    test('toEntity falls back to unknown for negative eventTypeIndex', () {
      final model = AuditEventModel(
        id: 'id-1',
        timestamp: DateTime.now(),
        eventTypeIndex: -1,
        entityTypeIndex: 1,
        entityId: 'tx-1',
        description: 'Corrupted',
      );

      expect(model.toEntity().eventType, AuditEventType.unknown);
      expect(model.toEntity().entityType, AuditEntityType.income);
    });

    test('toEntity falls back to unknown for out-of-range entityTypeIndex', () {
      final model = AuditEventModel(
        id: 'id-1',
        timestamp: DateTime.now(),
        eventTypeIndex: 1,
        entityTypeIndex: 999,
        entityId: 'tx-1',
        description: 'Corrupted',
      );

      expect(model.toEntity().entityType, AuditEntityType.unknown);
    });
  });
}
