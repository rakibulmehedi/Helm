// test/core/nudge/domain/nudge_effectiveness_service_test.dart
//
// Tests for NudgeEffectivenessService (Phase 3, Group 3E).

import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa_v2/core/analytics/domain/analytics_event_entity.dart';
import 'package:pocketa_v2/core/analytics/domain/analytics_repository.dart';
import 'package:pocketa_v2/core/nudge/domain/nudge_effectiveness_service.dart';
import 'package:pocketa_v2/core/nudge/domain/nudge_log_entry_entity.dart';
import 'package:pocketa_v2/core/nudge/domain/nudge_types.dart';

class FakeEffectivenessRepo implements AnalyticsRepository {
  final List<AnalyticsEventEntity> events = [];

  @override
  Future<void> save(AnalyticsEventEntity event) async {
    events.add(event);
  }

  @override
  Future<List<AnalyticsEventEntity>> getEventsSince(DateTime since) async {
    return events.where((e) => e.timestamp.isAfter(since)).toList();
  }

  @override
  Future<int> getEventCount(String eventName) async {
    return events.where((e) => e.eventName == eventName).length;
  }

  @override
  Future<AnalyticsEventEntity?> getLastEventOf(String eventName) async {
    final matching = events.where((e) => e.eventName == eventName).toList();
    if (matching.isEmpty) return null;
    matching.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return matching.first;
  }
}

void main() {
  group('NudgeEffectivenessService', () {
    final now = DateTime(2026, 6, 12);

    test('computeForType returns correct counts', () async {
      final repo = FakeEffectivenessRepo();
      final service = NudgeEffectivenessService(analyticsRepository: repo);

      // Add some analytics events
      await repo.save(AnalyticsEventEntity(
        eventName: 'nudge_opened',
        timestamp: now,
        properties: {},
      ));
      await repo.save(AnalyticsEventEntity(
        eventName: 'nudge_dismissed',
        timestamp: now,
        properties: {},
      ));

      // Create log entries
      final entries = [
        NudgeLogEntryEntity(
          id: 'n-001',
          nudgeType: NudgeType.confirmOverdue,
          channel: NudgeChannel.push,
          title: 'Test',
          body: 'Body',
          createdAt: now,
          actionedAt: now.add(const Duration(minutes: 5)),
        ),
        NudgeLogEntryEntity(
          id: 'n-002',
          nudgeType: NudgeType.confirmOverdue,
          channel: NudgeChannel.push,
          title: 'Test',
          body: 'Body',
          createdAt: now,
        ),
      ];

      final metrics =
          await service.computeForType(NudgeType.confirmOverdue, entries);

      expect(metrics.sent, equals(2));
      expect(metrics.actioned, equals(1));
      expect(metrics.opened, equals(1));
      expect(metrics.dismissed, equals(1));
    });

    test('computeAll returns metrics for all nudge types', () async {
      final repo = FakeEffectivenessRepo();
      final service = NudgeEffectivenessService(analyticsRepository: repo);

      final entries = [
        NudgeLogEntryEntity(
          id: 'n-101',
          nudgeType: NudgeType.confirmOverdue,
          channel: NudgeChannel.push,
          title: 'T',
          body: 'B',
          createdAt: now,
        ),
        NudgeLogEntryEntity(
          id: 'n-102',
          nudgeType: NudgeType.reEngagement,
          channel: NudgeChannel.push,
          title: 'T',
          body: 'B',
          createdAt: now,
          actionedAt: now.add(const Duration(minutes: 2)),
        ),
      ];

      final results = await service.computeAll(entries);

      expect(results.length, equals(NudgeType.values.length));
      expect(results[NudgeType.confirmOverdue]!.sent, equals(1));
      expect(results[NudgeType.confirmOverdue]!.actioned, equals(0));
      expect(results[NudgeType.reEngagement]!.sent, equals(1));
      expect(results[NudgeType.reEngagement]!.actioned, equals(1));
    });

    test('toReportRow formats metrics correctly', () async {
      final repo = FakeEffectivenessRepo();
      final service = NudgeEffectivenessService(analyticsRepository: repo);

      await repo.save(AnalyticsEventEntity(
        eventName: 'nudge_opened',
        timestamp: now,
        properties: {},
      ));

      final entries = [
        NudgeLogEntryEntity(
          id: 'n-201',
          nudgeType: NudgeType.confirmOverdue,
          channel: NudgeChannel.push,
          title: 'T',
          body: 'B',
          createdAt: now,
          actionedAt: now.add(const Duration(minutes: 3)),
        ),
      ];

      final metrics =
          await service.computeForType(NudgeType.confirmOverdue, entries);
      final row = metrics.toReportRow();

      expect(row['type'], equals('confirmOverdue'));
      expect(row['sent'], equals(1));
      expect(row['opened'], equals(1));
      expect(row['actioned'], equals(1));
      expect(row['actionRate'], isNotEmpty);
    });

    test('empty log produces zero metrics', () async {
      final repo = FakeEffectivenessRepo();
      final service = NudgeEffectivenessService(analyticsRepository: repo);

      final metrics =
          await service.computeForType(NudgeType.confirmOverdue, []);

      expect(metrics.sent, equals(0));
      expect(metrics.opened, equals(0));
      expect(metrics.actioned, equals(0));
      expect(metrics.openRate, equals(0.0));
    });
  });
}
