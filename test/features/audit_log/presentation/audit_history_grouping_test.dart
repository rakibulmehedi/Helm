// test/features/audit_log/presentation/audit_history_grouping_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';
import 'package:helm/features/audit_log/presentation/utils/audit_history_grouping.dart';

AuditEvent _at(DateTime t) => AuditEvent(
      id: t.toIso8601String(),
      timestamp: t,
      eventType: AuditEventType.created,
      entityType: AuditEntityType.income,
      entityId: 'x',
      description: 'd',
    );

void main() {
  final now = DateTime(2026, 6, 21, 14, 0); // Sunday afternoon

  group('bucketFor', () {
    test('same day → today', () {
      expect(bucketFor(DateTime(2026, 6, 21, 1, 0), now), HistoryBucket.today);
    });
    test('previous calendar day → yesterday', () {
      expect(bucketFor(DateTime(2026, 6, 20, 23, 0), now), HistoryBucket.yesterday);
    });
    test('within last 7 days but before yesterday → thisWeek', () {
      expect(bucketFor(DateTime(2026, 6, 16, 9, 0), now), HistoryBucket.thisWeek);
    });
    test('older than 7 days → earlier', () {
      expect(bucketFor(DateTime(2026, 6, 10, 9, 0), now), HistoryBucket.earlier);
    });
  });

  group('groupByRecency', () {
    test('orders buckets and omits empties, newest-first within bucket', () {
      final t1 = _at(DateTime(2026, 6, 21, 13, 0)); // today, newer
      final t2 = _at(DateTime(2026, 6, 21, 8, 0)); // today, older
      final e1 = _at(DateTime(2026, 6, 1, 8, 0)); // earlier
      final grouped = groupByRecency([t1, t2, e1], now);
      expect(grouped.map((e) => e.key).toList(),
          [HistoryBucket.today, HistoryBucket.earlier]);
      expect(grouped.first.value, [t1, t2]);
    });
    test('empty input → empty list', () {
      expect(groupByRecency(const [], now), isEmpty);
    });
  });

  group('relativeTimeLabel', () {
    test('under a minute → justNow', () {
      expect(relativeTimeLabel(DateTime(2026, 6, 21, 13, 59, 30), now), 'justNow');
    });
    test('minutes today → mAgo:n', () {
      expect(relativeTimeLabel(DateTime(2026, 6, 21, 13, 30), now), 'mAgo:30');
    });
    test('hours today → hAgo:n', () {
      expect(relativeTimeLabel(DateTime(2026, 6, 21, 11, 0), now), 'hAgo:3');
    });
    test('not today → date', () {
      expect(relativeTimeLabel(DateTime(2026, 6, 19, 11, 0), now), 'date');
    });
  });
}
