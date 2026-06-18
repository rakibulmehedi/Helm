// lib/features/audit_log/presentation/views/audit_log_screen.dart
//
// Displays the append-only audit trail for all financial changes.
//
// D1.07 — Trust Layer: Audit Log Display

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_typography.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';
import 'package:helm/features/audit_log/presentation/providers/audit_providers.dart';
import 'package:helm/l10n/app_localization.dart';

class AuditLogScreen extends ConsumerWidget {
  const AuditLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(auditEventsProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.changeHistory),
        elevation: 0,
      ),
      body: eventsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Text(
            l10n.auditLogLoadError,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
        data: (events) {
          if (events.isEmpty) {
            return Center(
              child: Text(l10n.auditLogEmpty),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: events.length,
            separatorBuilder: (_, _) => const Divider(height: 1, indent: 72),
            itemBuilder: (context, index) {
              final event = events[index];
              return _AuditEventTile(event: event);
            },
          );
        },
      ),
    );
  }
}

// ── Tile ─────────────────────────────────────────────────────────────────────

class _AuditEventTile extends StatelessWidget {
  const _AuditEventTile({required this.event});

  final AuditEvent event;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListTile(
      leading: Icon(
        _iconFor(event.eventType),
        color: _colorFor(context, event.eventType),
      ),
      title: Text(
        _titleFor(event, l10n),
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        _formatTimestamp(event.timestamp),
        style: context.textStyles.labelSm.copyWith(
          color: context.colors.inkTertiary,
        ),
      ),
    );
  }

  IconData _iconFor(AuditEventType type) {
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

  Color _colorFor(BuildContext context, AuditEventType type) {
    final colors = context.colors;
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

  String _titleFor(AuditEvent event, AppLocalizations l10n) {
    final entityLabel = _entityLabel(event.entityType, l10n);
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

  String _entityLabel(AuditEntityType type, AppLocalizations l10n) {
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

  String _formatTimestamp(DateTime dt) {
    return DateFormat('MMM d, yyyy · h:mm a').format(dt);
  }
}
