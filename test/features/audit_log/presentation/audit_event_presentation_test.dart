// test/features/audit_log/presentation/audit_event_presentation_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';
import 'package:helm/features/audit_log/presentation/utils/audit_event_presentation.dart';

void main() {
  test('icon mapping covers created', () {
    expect(auditIconFor(AuditEventType.created), Icons.add_circle_outline);
  });
}
