// test/core/analytics/domain/analytics_event_entity_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/analytics/domain/analytics_event_entity.dart';

void main() {
  test('AnalyticsEventEntity stores eventName, timestamp, properties', () {
    final timestamp = DateTime(2026, 6, 12, 10, 30);
    final entity = AnalyticsEventEntity(
      eventName: 'sts_viewed',
      timestamp: timestamp,
      properties: {'screen': 'dashboard'},
    );
    expect(entity.eventName, equals('sts_viewed'));
    expect(entity.timestamp, equals(timestamp));
    expect(entity.properties['screen'], equals('dashboard'));
  });

  test('entities with same values are equal', () {
    final timestamp = DateTime(2026, 6, 12, 10, 30);
    final a = AnalyticsEventEntity(
      eventName: 'x',
      timestamp: timestamp,
      properties: {'k': 'v'},
    );
    final b = AnalyticsEventEntity(
      eventName: 'x',
      timestamp: timestamp,
      properties: {'k': 'v'},
    );
    expect(a, equals(b));
  });
}
