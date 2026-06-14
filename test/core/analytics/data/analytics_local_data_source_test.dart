// test/core/analytics/data/analytics_local_data_source_test.dart

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:helm/core/analytics/data/datasources/analytics_local_data_source.dart';
import 'package:helm/core/analytics/domain/analytics_event_entity.dart';
import 'package:helm/core/analytics/models/analytics_event_model.dart';
import 'package:helm/core/constants/app_box_names.dart';

void main() {
  late Directory tempDir;
  late AnalyticsLocalDataSourceImpl dataSource;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(AnalyticsEventModelAdapter());
    }
    await Hive.openBox<AnalyticsEventModel>(AppBoxNames.analyticsEventsBox);
    dataSource = AnalyticsLocalDataSourceImpl();
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  test('persists AnalyticsEventModel to Hive box and retrieves it', () async {
    final event = AnalyticsEventEntity(
      eventName: 'sts_viewed',
      timestamp: DateTime.now().toUtc(),
      properties: {'screen': 'dashboard'},
    );
    await dataSource.save(event);

    final events = await dataSource.getEventsSince(
      DateTime.now().subtract(const Duration(hours: 1)),
    );
    expect(events.length, equals(1));
    expect(events.first.eventName, equals('sts_viewed'));
    expect(events.first.properties['screen'], equals('dashboard'));
  });

  test('getEventCount returns count of specific events', () async {
    final event1 = AnalyticsEventEntity(
      eventName: 'a',
      timestamp: DateTime.now().toUtc(),
      properties: {},
    );
    final event2 = AnalyticsEventEntity(
      eventName: 'b',
      timestamp: DateTime.now().toUtc(),
      properties: {},
    );
    await dataSource.save(event1);
    await dataSource.save(event2);
    await dataSource.save(event1);

    expect(await dataSource.getEventCount('a'), equals(2));
    expect(await dataSource.getEventCount('b'), equals(1));
    expect(await dataSource.getEventCount('c'), equals(0));
  });

  test('getLastEventOf returns the most recent event', () async {
    final now = DateTime.now().toUtc();
    final event1 = AnalyticsEventEntity(
      eventName: 'test',
      timestamp: now.subtract(const Duration(minutes: 5)),
      properties: {'id': '1'},
    );
    final event2 = AnalyticsEventEntity(
      eventName: 'test',
      timestamp: now,
      properties: {'id': '2'},
    );

    await dataSource.save(event1);
    await dataSource.save(event2);

    final last = await dataSource.getLastEventOf('test');
    expect(last?.properties['id'], equals('2'));
  });
}
