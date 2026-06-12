// test/core/analytics/domain/nudge_event_logger_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa_v2/core/analytics/domain/analytics_event_entity.dart';
import 'package:pocketa_v2/core/analytics/domain/analytics_repository.dart';
import 'package:pocketa_v2/core/analytics/domain/nudge_event_logger.dart';

class FakeAnalyticsRepository implements AnalyticsRepository {
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
  late FakeAnalyticsRepository repo;
  late NudgeEventLogger logger;

  setUp(() {
    repo = FakeAnalyticsRepository();
    logger = NudgeEventLogger(repository: repo);
  });

  test('logNudgeSent records nudge_sent event with nudge_id, type, channel', () {
    logger.logNudgeSent('nudge-1', 'overdue_alert', 'in_app');

    expect(repo.events.length, equals(1));
    final e = repo.events.first;
    expect(e.eventName, equals('nudge_sent'));
    expect(e.properties['nudge_id'], equals('nudge-1'));
    expect(e.properties['type'], equals('overdue_alert'));
    expect(e.properties['channel'], equals('in_app'));
  });

  test('logNudgeOpened records nudge_opened event with nudge_id', () {
    logger.logNudgeOpened('nudge-1');

    expect(repo.events.length, equals(1));
    final e = repo.events.first;
    expect(e.eventName, equals('nudge_opened'));
    expect(e.properties['nudge_id'], equals('nudge-1'));
  });

  test('logNudgeDismissed records nudge_dismissed event with reason', () {
    logger.logNudgeDismissed('nudge-1', DismissReason.swiped);

    expect(repo.events.length, equals(1));
    final e = repo.events.first;
    expect(e.eventName, equals('nudge_dismissed'));
    expect(e.properties['nudge_id'], equals('nudge-1'));
    expect(e.properties['reason'], equals('swiped'));
  });

  test('logNudgeActioned records nudge_actioned with action and time_to_action', () {
    logger.logNudgeActioned('nudge-1', 'review_pipeline',
        const Duration(seconds: 5));

    expect(repo.events.length, equals(1));
    final e = repo.events.first;
    expect(e.eventName, equals('nudge_actioned'));
    expect(e.properties['nudge_id'], equals('nudge-1'));
    expect(e.properties['action'], equals('review_pipeline'));
    expect(e.properties['time_to_action_ms'], equals('5000'));
  });

  test('all four lifecycle events are independent', () {
    logger.logNudgeSent('n-1', 'type-a', 'push');
    logger.logNudgeOpened('n-1');
    logger.logNudgeDismissed('n-1', DismissReason.acknowledged);
    logger.logNudgeActioned('n-2', 'confirm', const Duration(seconds: 2));

    expect(repo.events.length, equals(4));
    expect(repo.events[0].eventName, equals('nudge_sent'));
    expect(repo.events[1].eventName, equals('nudge_opened'));
    expect(repo.events[2].eventName, equals('nudge_dismissed'));
    expect(repo.events[3].eventName, equals('nudge_actioned'));
  });
}
