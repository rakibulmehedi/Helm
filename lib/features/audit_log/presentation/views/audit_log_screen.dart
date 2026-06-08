// lib/features/audit_log/presentation/views/audit_log_screen.dart
//
// Displays the append-only audit trail for all financial changes.
//
// D1.07 — Trust Layer: Audit Log Display

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocketa_v2/core/themes/pocketa_colors.dart';
import 'package:pocketa_v2/core/themes/pocketa_typography.dart';
import 'package:pocketa_v2/features/audit_log/domain/entities/audit_event.dart';
import 'package:pocketa_v2/features/audit_log/presentation/providers/audit_providers.dart';

class AuditLogScreen extends ConsumerWidget {
  const AuditLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(auditEventsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Change history'),
        elevation: 0,
      ),
      body: eventsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Text(
            'Unable to load history.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
        data: (events) {
          if (events.isEmpty) {
            return const Center(
              child: Text('No changes recorded yet.'),
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
    return ListTile(
      leading: Icon(
        _iconFor(event.eventType),
        color: _colorFor(context, event.eventType),
      ),
      title: Text(
        _titleFor(event),
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        _formatTimestamp(event.timestamp),
        style: Theme.of(context).extension<PocketaTypography>()!.labelSm.copyWith(
          color: Theme.of(context).extension<PocketaColors>()!.inkTertiary,
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
    }
  }

  Color _colorFor(BuildContext context, AuditEventType type) {
    final colors = Theme.of(context).extension<PocketaColors>()!;
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
    }
  }

  String _titleFor(AuditEvent event) {
    final entityLabel = _entityLabel(event.entityType);
    switch (event.eventType) {
      case AuditEventType.created:
        return '$entityLabel added';
      case AuditEventType.updated:
        return '$entityLabel updated';
      case AuditEventType.deleted:
        return '$entityLabel deleted';
      case AuditEventType.confirmed:
        return '$entityLabel confirmed';
      case AuditEventType.exported:
        return '$entityLabel exported';
    }
  }

  String _entityLabel(AuditEntityType type) {
    switch (type) {
      case AuditEntityType.income:
        return 'Income';
      case AuditEntityType.transaction:
        return 'Transaction';
      case AuditEntityType.stsSettings:
        return 'Settings';
      case AuditEntityType.fixedCost:
        return 'Fixed cost';
    }
  }

  String _formatTimestamp(DateTime dt) {
    return DateFormat('MMM d, yyyy · h:mm a').format(dt);
  }
}
