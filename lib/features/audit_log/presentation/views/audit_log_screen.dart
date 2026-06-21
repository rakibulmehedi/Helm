// lib/features/audit_log/presentation/views/audit_log_screen.dart
//
// History tab — Paper Ledger reskin.
// Integrity strip → date-grouped event cards → retention footer.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_spacing.dart';
import 'package:helm/core/themes/helm_typography.dart';
import 'package:helm/features/audit_log/core/audit_log_constants.dart';
import 'package:helm/features/audit_log/presentation/providers/audit_providers.dart';
import 'package:helm/features/audit_log/presentation/utils/audit_history_grouping.dart';
import 'package:helm/features/audit_log/presentation/widgets/audit_event_card.dart';
import 'package:helm/features/audit_log/presentation/widgets/ledger_integrity_strip.dart';
import 'package:helm/l10n/app_localization.dart';

class AuditLogScreen extends ConsumerWidget {
  const AuditLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final typo = context.textStyles;
    final l10n = context.l10n;
    final eventsAsync = ref.watch(auditEventsProvider);

    return Scaffold(
      backgroundColor: colors.canvas,
      appBar: AppBar(
        backgroundColor: colors.canvas,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Text(l10n.changeHistory,
            style: typo.headingSm.copyWith(color: colors.inkPrimary)),
      ),
      body: eventsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => _StateMessage(
            icon: Icons.error_outline, message: l10n.auditLogLoadError),
        data: (events) {
          if (events.isEmpty) {
            return _StateMessage(
                icon: Icons.history, message: l10n.auditLogEmpty);
          }
          final groups = groupByRecency(events, DateTime.now());
          return ListView(
            padding: const EdgeInsets.fromLTRB(
                HelmSpacing.screenEdge,
                0,
                HelmSpacing.screenEdge,
                HelmSpacing.s6),
            children: [
              const LedgerIntegrityStrip(),
              for (final group in groups) ...[
                _GroupHeader(bucket: group.key, count: group.value.length),
                const SizedBox(height: HelmSpacing.s2),
                ...group.value.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: HelmSpacing.s2),
                      child: AuditEventCard(event: e),
                    )),
                const SizedBox(height: HelmSpacing.s3),
              ],
              const SizedBox(height: HelmSpacing.s2),
              Text(
                l10n.historyRetentionNote(kAuditRetentionDays),
                style: typo.labelSm.copyWith(color: colors.inkTertiary),
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.bucket, required this.count});
  final HistoryBucket bucket;
  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.textStyles;
    final l10n = context.l10n;
    final label = switch (bucket) {
      HistoryBucket.today => l10n.historyGroupToday,
      HistoryBucket.yesterday => l10n.historyGroupYesterday,
      HistoryBucket.thisWeek => l10n.historyGroupThisWeek,
      HistoryBucket.earlier => l10n.historyGroupEarlier,
    };
    return Row(
      children: [
        Container(width: 3, height: 14, color: colors.inkSecondary),
        const SizedBox(width: HelmSpacing.s2),
        Text(label, style: typo.labelMd.copyWith(color: colors.inkSecondary)),
        const Spacer(),
        Text('$count', style: typo.labelSm.copyWith(color: colors.inkTertiary)),
      ],
    );
  }
}

class _StateMessage extends StatelessWidget {
  const _StateMessage({required this.icon, required this.message});
  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.textStyles;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(HelmSpacing.s5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: colors.inkTertiary),
            const SizedBox(height: HelmSpacing.s3),
            Text(message,
                style: typo.bodyMd.copyWith(color: colors.inkSecondary),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
