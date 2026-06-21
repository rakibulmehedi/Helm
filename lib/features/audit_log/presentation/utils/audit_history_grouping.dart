// lib/features/audit_log/presentation/utils/audit_history_grouping.dart
//
// Pure, locale-free helpers for the History tab: recency bucketing and a
// relative-time token (the widget layer localizes the token).

import 'package:helm/features/audit_log/domain/entities/audit_event.dart';

enum HistoryBucket { today, yesterday, thisWeek, earlier }

DateTime _midnight(DateTime t) => DateTime(t.year, t.month, t.day);

HistoryBucket bucketFor(DateTime eventTime, DateTime now) {
  final today = _midnight(now);
  final eventDay = _midnight(eventTime);
  final dayDelta = today.difference(eventDay).inDays;
  if (dayDelta <= 0) return HistoryBucket.today;
  if (dayDelta == 1) return HistoryBucket.yesterday;
  if (dayDelta <= 7) return HistoryBucket.thisWeek;
  return HistoryBucket.earlier;
}

/// Groups [newestFirst] into ordered buckets (today→earlier), omitting empty
/// buckets and preserving newest-first order within each bucket.
List<MapEntry<HistoryBucket, List<AuditEvent>>> groupByRecency(
  List<AuditEvent> newestFirst,
  DateTime now,
) {
  final byBucket = <HistoryBucket, List<AuditEvent>>{};
  for (final event in newestFirst) {
    byBucket.putIfAbsent(bucketFor(event.timestamp, now), () => []).add(event);
  }
  return HistoryBucket.values
      .where(byBucket.containsKey)
      .map((b) => MapEntry(b, byBucket[b]!))
      .toList();
}

/// Returns a locale-free token: `'justNow'`, `'mAgo:<n>'`, `'hAgo:<n>'`, or `'date'`.
String relativeTimeLabel(DateTime eventTime, DateTime now) {
  if (bucketFor(eventTime, now) != HistoryBucket.today) return 'date';
  final diff = now.difference(eventTime);
  if (diff.inMinutes < 1) return 'justNow';
  if (diff.inMinutes < 60) return 'mAgo:${diff.inMinutes}';
  return 'hAgo:${diff.inHours}';
}
