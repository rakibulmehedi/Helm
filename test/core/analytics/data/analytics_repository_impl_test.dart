// test/core/analytics/data/analytics_repository_impl_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/analytics/domain/analytics_event_entity.dart';
import 'package:helm/core/analytics/data/repositories/analytics_repository_impl.dart';
import 'package:helm/core/analytics/data/datasources/analytics_local_data_source.dart';

class FakeAnalyticsLocalDataSource implements AnalyticsLocalDataSource {
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
  late FakeAnalyticsLocalDataSource fakeDataSource;
  late AnalyticsRepositoryImpl repository;

  setUp(() {
    fakeDataSource = FakeAnalyticsLocalDataSource();
    repository = AnalyticsRepositoryImpl(localDataSource: fakeDataSource);
  });

  test('repository delegates save to data source', () async {
    final event = AnalyticsEventEntity(
      eventName: 'test',
      timestamp: DateTime.now(),
      properties: {},
    );
    await repository.save(event);
    expect(fakeDataSource.events.length, equals(1));
    expect(fakeDataSource.events.first.eventName, equals('test'));
  });

  test('repository delegates queries to data source', () async {
    final now = DateTime.now();
    final event1 = AnalyticsEventEntity(
      eventName: 'test',
      timestamp: now.subtract(const Duration(minutes: 5)),
      properties: {},
    );
    final event2 = AnalyticsEventEntity(
      eventName: 'test2',
      timestamp: now,
      properties: {},
    );

    await repository.save(event1);
    await repository.save(event2);

    final count = await repository.getEventCount('test');
    expect(count, equals(1));

    final since = await repository.getEventsSince(now.subtract(const Duration(minutes: 2)));
    expect(since.length, equals(1));
    expect(since.first.eventName, equals('test2'));

    final last = await repository.getLastEventOf('test');
    expect(last?.eventName, equals('test'));
  });
}
