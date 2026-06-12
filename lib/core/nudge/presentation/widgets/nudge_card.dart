// lib/core/nudge/presentation/widgets/nudge_card.dart
//
// Single nudge notification card for the notification center.

import 'package:flutter/material.dart';
import 'package:pocketa_v2/core/nudge/domain/nudge_log_entry_entity.dart';
import 'package:pocketa_v2/core/themes/pocketa_colors.dart';
import 'package:pocketa_v2/core/themes/pocketa_spacing.dart';
import 'package:pocketa_v2/core/themes/pocketa_typography.dart';

class NudgeCard extends StatelessWidget {
  final NudgeLogEntryEntity entry;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const NudgeCard({
    super.key,
    required this.entry,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<PocketaColors>()!;
    final typography = Theme.of(context).extension<PocketaTypography>()!;

    return Dismissible(
      key: Key(entry.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: colors.stateAtRisk,
        child: Icon(Icons.delete_outline_rounded, color: colors.surface),
      ),
      onDismissed: (_) => onDismiss?.call(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(PocketaSpacing.s4),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(PocketaSpacing.cardRadius),
            border: Border.all(
              color: entry.isRead ? colors.hairline : colors.interactive.withValues(alpha: 0.3),
              width: PocketaSpacing.cardBorder,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Unread indicator
              if (!entry.isRead)
                Container(
                  margin: const EdgeInsets.only(top: 6, right: 10),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: colors.interactive,
                    shape: BoxShape.circle,
                  ),
                )
              else
                const SizedBox(width: 18),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      entry.title,
                      style: typography.bodyMd.copyWith(
                        fontWeight: entry.isRead ? FontWeight.w400 : FontWeight.w600,
                        color: colors.inkPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry.body,
                      style: typography.bodySm.copyWith(
                        color: colors.inkSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _formatTimestamp(entry.createdAt),
                      style: typography.labelSm.copyWith(
                        color: colors.inkTertiary,
                      ),
                    ),
                  ],
                ),
              ),

              // Chevron
              if (entry.actionRoute != null)
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: colors.inkTertiary,
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';

    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
