// lib/features/audit_log/presentation/utils/audit_event_presentation.dart
//
// Shared event-presentation mapping: icon, color, title, entity label.
// Extracted from audit_log_screen.dart so that both the detail sheet (Task 5)
// and the event card (Task 7) can reuse it without duplication.
//
// D1.07 — Trust Layer: Audit Log Display

import 'package:flutter/material.dart';
import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';
import 'package:helm/l10n/app_localizations.dart';

IconData auditIconFor(AuditEventType type) {
  switch (type) {
    case AuditEventType.created:
      return Icons.add_circle_outline;
    case AuditEventType.updated:
      return Icons.edit_outlined;
    case AuditEventType.deleted:
      return Icons.delete_outline;
    case AuditEventType.confirmed:
      return Icons.check_circle_outline;
    case AuditEventType.exported:
      return Icons.upload_outlined;
    case AuditEventType.unknown:
      return Icons.help_outline;
  }
}

Color auditColorFor(HelmColors colors, AuditEventType type) {
  switch (type) {
    case AuditEventType.created:
      return colors.stateSafe;
    case AuditEventType.updated:
      return colors.interactive;
    case AuditEventType.deleted:
      return colors.stateAtRisk;
    case AuditEventType.confirmed:
      return colors.stateSafe;
    case AuditEventType.exported:
      return colors.stateTight;
    case AuditEventType.unknown:
      return colors.inkTertiary;
  }
}

String auditEntityLabel(AuditEntityType type, AppLocalizations l10n) {
  switch (type) {
    case AuditEntityType.income:
      return l10n.auditEntityIncome;
    case AuditEntityType.transaction:
      return l10n.auditEntityTransaction;
    case AuditEntityType.stsSettings:
      return l10n.auditEntitySettings;
    case AuditEntityType.fixedCost:
      return l10n.auditEntityFixedCost;
    case AuditEntityType.unknown:
      return l10n.auditEntityRecord;
  }
}

String auditTitleFor(AuditEvent event, AppLocalizations l10n) {
  final entityLabel = auditEntityLabel(event.entityType, l10n);
  switch (event.eventType) {
    case AuditEventType.created:
      return l10n.auditEventAdded(entityLabel);
    case AuditEventType.updated:
      return l10n.auditEventUpdated(entityLabel);
    case AuditEventType.deleted:
      return l10n.auditEventDeleted(entityLabel);
    case AuditEventType.confirmed:
      return l10n.auditEventConfirmed(entityLabel);
    case AuditEventType.exported:
      return l10n.auditEventExported(entityLabel);
    case AuditEventType.unknown:
      return l10n.auditEventChanged(entityLabel);
  }
}
