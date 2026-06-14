// lib/core/nudge/presentation/screens/notification_center_screen.dart
//
// In-app notification center (Phase 3, Group 3C).
// Shows grouped, actionable nudge history with swipe-to-dismiss.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:helm/core/analytics/analytics_service.dart';
import 'package:helm/core/analytics/event_registry.dart';
import 'package:helm/core/local_storage/shared_pref_service.dart';
import 'package:helm/core/nudge/domain/nudge_log_entry_entity.dart';
import 'package:helm/core/nudge/presentation/providers/nudge_providers.dart';
import 'package:helm/core/nudge/presentation/widgets/nudge_card.dart';
import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_spacing.dart';
import 'package:helm/core/themes/helm_typography.dart';
import 'package:helm/core/widgets/helm_toast.dart';

/// Full-screen notification center showing nudge history grouped by date.
class NotificationCenterScreen extends ConsumerWidget {
  const NotificationCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(nudgeListProvider);
    final colors = context.colors;
    final typography = context.textStyles;

    final grouped = _groupByDate(entries);

    return Scaffold(
      backgroundColor: colors.canvas,
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: typography.headingMd,
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          if (entries.isNotEmpty)
            TextButton(
              onPressed: () {
                ref.read(nudgeListProvider.notifier).clearAll();
                HelmToast.show(
                  context,
                  message: 'All notifications cleared',
                  type: ToastType.neutral,
                );
              },
              child: Text(
                'Clear all',
                style: typography.bodySm.copyWith(
                  color: colors.inkTertiary,
                ),
              ),
            ),
        ],
      ),
      body: entries.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(HelmSpacing.s6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.notifications_none_rounded,
                      size: 48,
                      color: colors.inkTertiary,
                    ),
                    const SizedBox(height: HelmSpacing.s4),
                    Text(
                      'No notifications yet',
                      style: typography.bodyLg.copyWith(
                        color: colors.inkSecondary,
                      ),
                    ),
                    const SizedBox(height: HelmSpacing.s2),
                    Text(
                      'Nudges and updates will show here when available.',
                      style: typography.bodySm.copyWith(
                        color: colors.inkTertiary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(HelmSpacing.s4),
              itemCount: grouped.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: HelmSpacing.s4),
              itemBuilder: (context, index) {
                final group = grouped[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: HelmSpacing.s1,
                        bottom: HelmSpacing.s3,
                      ),
                      child: Text(
                        group.label,
                        style: typography.labelMd.copyWith(
                          color: colors.inkSecondary,
                        ),
                      ),
                    ),
                    ...group.entries.map((entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: NudgeCard(
                            entry: entry,
                            onTap: () => _onNudgeTap(
                              context,
                              ref,
                              entry,
                            ),
                            onDismiss: () => _onNudgeDismiss(
                              context,
                              ref,
                              entry,
                            ),
                          ),
                        )),
                  ],
                );
              },
            ),
    );
  }

  void _onNudgeTap(BuildContext context, WidgetRef ref, NudgeLogEntryEntity entry) {
    ref.read(nudgeListProvider.notifier).markRead(entry.id);
    SharedPrefServices.setLastNotificationOpenedAt(DateTime.now());
    ref.read(analyticsProvider).trackEvent(
      TransactionalEvents.notificationOpened,
      properties: {'nudge_id': entry.id},
    );
    if (entry.actionRoute != null && context.mounted) {
      context.go(entry.actionRoute!);
    }
  }

  void _onNudgeDismiss(
      BuildContext context, WidgetRef ref, NudgeLogEntryEntity entry) {
    ref.read(nudgeListProvider.notifier).delete(entry.id);
    HelmToast.show(
      context,
      message: 'Notification removed',
      type: ToastType.neutral,
      actionLabel: 'UNDO',
      onAction: () {
        ref.read(nudgeListProvider.notifier).add(entry);
      },
    );
  }
}

/// Date-group label and its entries.
class _DateGroup {
  final String label;
  final List<NudgeLogEntryEntity> entries;

  const _DateGroup({required this.label, required this.entries});
}

/// Groups entries by relative date: Today, Yesterday, This Week, Older.
List<_DateGroup> _groupByDate(List<NudgeLogEntryEntity> entries) {
  if (entries.isEmpty) return [];

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final weekStart = today.subtract(const Duration(days: 7));

  final todayEntries = <NudgeLogEntryEntity>[];
  final yesterdayEntries = <NudgeLogEntryEntity>[];
  final thisWeekEntries = <NudgeLogEntryEntity>[];
  final olderEntries = <NudgeLogEntryEntity>[];

  for (final entry in entries) {
    final entryDate = DateTime(
      entry.createdAt.year,
      entry.createdAt.month,
      entry.createdAt.day,
    );
    if (entryDate == today) {
      todayEntries.add(entry);
    } else if (entryDate == yesterday) {
      yesterdayEntries.add(entry);
    } else if (entryDate.isAfter(weekStart)) {
      thisWeekEntries.add(entry);
    } else {
      olderEntries.add(entry);
    }
  }

  final groups = <_DateGroup>[];
  if (todayEntries.isNotEmpty) {
    groups.add(_DateGroup(label: 'Today', entries: todayEntries));
  }
  if (yesterdayEntries.isNotEmpty) {
    groups.add(_DateGroup(label: 'Yesterday', entries: yesterdayEntries));
  }
  if (thisWeekEntries.isNotEmpty) {
    groups.add(_DateGroup(label: 'This Week', entries: thisWeekEntries));
  }
  if (olderEntries.isNotEmpty) {
    groups.add(_DateGroup(label: 'Older', entries: olderEntries));
  }

  return groups;
}
