// lib/core/analytics/data/datasources/analytics_local_data_source.dart
//
// Interface and Hive implementation for analytics event local persistence.

import 'package:hive/hive.dart';
import 'package:helm/core/constants/app_box_names.dart';
import 'package:helm/core/analytics/domain/analytics_event_entity.dart';
import 'package:helm/core/analytics/models/analytics_event_model.dart';

abstract class AnalyticsLocalDataSource {
  /// Save a new analytics event locally.
  Future<void> save(AnalyticsEventEntity event);

  /// Retrieve all events recorded since the given [since] timestamp.
  Future<List<AnalyticsEventEntity>> getEventsSince(DateTime since);

  /// Count the total number of events recorded with [eventName].
  Future<int> getEventCount(String eventName);

  /// Retrieve the most recently recorded event with [eventName].
  Future<AnalyticsEventEntity?> getLastEventOf(String eventName);
}

class AnalyticsLocalDataSourceImpl implements AnalyticsLocalDataSource {
  Box<AnalyticsEventModel> get _box =>
      Hive.box<AnalyticsEventModel>(AppBoxNames.analyticsEventsBox);

  @override
  Future<void> save(AnalyticsEventEntity event) async {
    final model = AnalyticsEventModel.fromEntity(event);
    await _box.add(model);
  }

  @override
  Future<List<AnalyticsEventEntity>> getEventsSince(DateTime since) async {
    final events = _box.values
        .where((m) => m.timestamp.isAfter(since))
        .map((m) => m.toEntity())
        .toList();
    return events;
  }

  @override
  Future<int> getEventCount(String eventName) async {
    return _box.values.where((m) => m.eventName == eventName).length;
  }

  @override
  Future<AnalyticsEventEntity?> getLastEventOf(String eventName) async {
    final matching = _box.values.where((m) => m.eventName == eventName).toList();
    if (matching.isEmpty) return null;
    // Sort descending by timestamp.
    matching.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return matching.first.toEntity();
  }
}
