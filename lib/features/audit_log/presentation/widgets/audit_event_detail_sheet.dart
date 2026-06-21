// lib/features/audit_log/presentation/widgets/audit_event_detail_sheet.dart
//
// Modal detail for one audit event: description, before→after diff, record hash.
// Convention mirrors confirm_received_sheet.dart.
//
// D1.07 — Trust Layer: Audit Log Display

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_spacing.dart';
import 'package:helm/core/themes/helm_typography.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';
import 'package:helm/features/audit_log/presentation/providers/audit_providers.dart';
import 'package:helm/features/audit_log/presentation/utils/audit_event_presentation.dart';
import 'package:helm/l10n/app_localization.dart';

class AuditEventDetailSheet extends ConsumerWidget {
  const AuditEventDetailSheet({super.key, required this.event});

  final AuditEvent event;

  static Future<void> show(BuildContext context, AuditEvent event) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(HelmSpacing.sheetTopRadius),
        ),
      ),
      builder: (_) => AuditEventDetailSheet(event: event),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final typo = context.textStyles;
    final l10n = context.l10n;
    const dash = '—';

    final hashAsync = ref.watch(_eventHashProvider(event.id));

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(HelmSpacing.s5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  auditIconFor(event.eventType),
                  color: auditColorFor(colors, event.eventType),
                  size: HelmSpacing.iconLg,
                ),
                const SizedBox(width: HelmSpacing.s2),
                Expanded(
                  child: Text(
                    auditTitleFor(event, l10n),
                    style: typo.headingSm.copyWith(color: colors.inkPrimary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: HelmSpacing.s4),
            _row(typo, colors, l10n.auditDetailEntity,
                auditEntityLabel(event.entityType, l10n)),
            _row(typo, colors, l10n.auditDetailTimestamp,
                DateFormat('MMM d, yyyy · h:mm a').format(event.timestamp)),
            if (event.description.isNotEmpty)
              _row(typo, colors, l10n.auditDetailDescription,
                  event.description),
            const SizedBox(height: HelmSpacing.s3),
            Divider(color: colors.divider, height: 1),
            const SizedBox(height: HelmSpacing.s3),
            _monoRow(typo, colors, l10n.auditDetailBefore,
                event.previousValue ?? dash),
            const SizedBox(height: HelmSpacing.s2),
            _monoRow(typo, colors, l10n.auditDetailAfter,
                event.newValue ?? dash),
            const SizedBox(height: HelmSpacing.s3),
            _monoRow(
              typo,
              colors,
              l10n.auditDetailRecordHash,
              hashAsync.maybeWhen(data: (h) => h ?? dash, orElse: () => dash),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(
      HelmTypography typo, HelmColors colors, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: HelmSpacing.s2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: typo.labelSm.copyWith(color: colors.inkTertiary)),
          const SizedBox(height: HelmSpacing.s1),
          Text(value,
              style: typo.bodyMd.copyWith(color: colors.inkPrimary)),
        ],
      ),
    );
  }

  Widget _monoRow(
      HelmTypography typo, HelmColors colors, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: typo.labelSm.copyWith(color: colors.inkTertiary)),
        const SizedBox(height: HelmSpacing.s1),
        Text(value,
            style: typo.monoFinancialSm.copyWith(color: colors.inkSecondary)),
      ],
    );
  }
}

/// Resolves the stored hash for one event id.
final _eventHashProvider =
    FutureProvider.family<String?, String>((ref, eventId) async {
  final service = ref.read(auditChainServiceProvider);
  return service.hashFor(eventId);
});
