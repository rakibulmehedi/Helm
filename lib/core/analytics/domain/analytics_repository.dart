// lib/core/analytics/domain/analytics_repository.dart
//
// Abstract repository contract specifying analytics persistence operations.

import 'package:helm/core/analytics/domain/analytics_event_entity.dart';

abstract interface class AnalyticsRepository {
  /// Save a new analytics event to local storage.
  Future<void> save(AnalyticsEventEntity event);

  /// Retrieve all events recorded since the given [since] timestamp.
  Future<List<AnalyticsEventEntity>> getEventsSince(DateTime since);

  /// Count the total number of events recorded with [eventName].
  Future<int> getEventCount(String eventName);

  /// Retrieve the most recently recorded event with [eventName].
  Future<AnalyticsEventEntity?> getLastEventOf(String eventName);
}
