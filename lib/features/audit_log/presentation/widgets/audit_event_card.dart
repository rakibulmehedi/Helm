// lib/features/audit_log/presentation/widgets/audit_event_card.dart
//
// Tappable Paper Ledger card for one audit event. Opens AuditEventDetailSheet.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_spacing.dart';
import 'package:helm/core/themes/helm_typography.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';
import 'package:helm/features/audit_log/presentation/utils/audit_event_presentation.dart';
import 'package:helm/features/audit_log/presentation/utils/audit_history_grouping.dart';
import 'package:helm/features/audit_log/presentation/widgets/audit_event_detail_sheet.dart';
import 'package:helm/l10n/app_localization.dart';

class AuditEventCard extends StatelessWidget {
  const AuditEventCard({super.key, required this.event});

  final AuditEvent event;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.textStyles;
    final l10n = context.l10n;

    return InkWell(
      borderRadius: BorderRadius.circular(HelmSpacing.cardRadius),
      onTap: () => AuditEventDetailSheet.show(context, event),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(HelmSpacing.cardRadius),
          border: Border.all(color: colors.divider, width: HelmSpacing.cardBorder),
        ),
        child: Padding(
          padding: const EdgeInsets.all(HelmSpacing.s3),
          child: Row(
            children: [
              Icon(auditIconFor(event.eventType),
                  color: auditColorFor(colors, event.eventType),
                  size: HelmSpacing.iconMd),
              const SizedBox(width: HelmSpacing.s3),
              Expanded(
                child: Text(auditTitleFor(event, l10n),
                    style: typo.bodyMd
                        .copyWith(color: colors.inkPrimary, fontWeight: FontWeight.w500)),
              ),
              const SizedBox(width: HelmSpacing.s2),
              Text(_relative(l10n),
                  style: typo.labelSm.copyWith(color: colors.inkTertiary)),
            ],
          ),
        ),
      ),
    );
  }

  String _relative(AppLocalizations l10n) {
    final token = relativeTimeLabel(event.timestamp, DateTime.now());
    if (token == 'justNow') return l10n.auditRelativeJustNow;
    if (token.startsWith('mAgo:')) {
      return l10n.auditRelativeMinutesAgo(int.parse(token.substring(5)));
    }
    if (token.startsWith('hAgo:')) {
      return l10n.auditRelativeHoursAgo(int.parse(token.substring(5)));
    }
    return DateFormat('MMM d').format(event.timestamp);
  }
}
