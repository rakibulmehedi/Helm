// lib/core/analytics/models/analytics_event_model.dart
//
// Hive model representing serialized analytics events.

import 'package:hive/hive.dart';
import 'package:pocketa_v2/core/analytics/domain/analytics_event_entity.dart';

part 'analytics_event_model.g.dart';

@HiveType(typeId: 6)
class AnalyticsEventModel extends HiveObject {
  @HiveField(0)
  final String eventName;

  @HiveField(1)
  final DateTime timestamp;

  @HiveField(2)
  final Map<String, String> properties;

  AnalyticsEventModel({
    required this.eventName,
    required this.timestamp,
    required this.properties,
  });

  AnalyticsEventEntity toEntity() => AnalyticsEventEntity(
        eventName: eventName,
        timestamp: timestamp,
        properties: properties,
      );

  factory AnalyticsEventModel.fromEntity(AnalyticsEventEntity entity) =>
      AnalyticsEventModel(
        eventName: entity.eventName,
        timestamp: entity.timestamp,
        properties: entity.properties,
      );
}
