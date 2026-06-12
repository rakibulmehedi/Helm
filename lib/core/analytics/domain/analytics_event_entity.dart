// lib/core/analytics/domain/analytics_event_entity.dart
//
// Pure Dart representation of an analytics event.
// Used across domain and presentation layers.

import 'package:flutter/foundation.dart';

@immutable
class AnalyticsEventEntity {
  final String eventName;
  final DateTime timestamp;
  final Map<String, String> properties;

  const AnalyticsEventEntity({
    required this.eventName,
    required this.timestamp,
    required this.properties,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnalyticsEventEntity &&
          runtimeType == other.runtimeType &&
          eventName == other.eventName &&
          timestamp == other.timestamp &&
          mapEquals(properties, other.properties);

  @override
  int get hashCode =>
      eventName.hashCode ^ timestamp.hashCode ^ properties.hashCode;

  @override
  String toString() {
    return 'AnalyticsEventEntity(eventName: $eventName, timestamp: $timestamp, properties: $properties)';
  }
}
