// lib/core/analytics/data/repositories/analytics_repository_impl.dart
//
// Concrete implementation of AnalyticsRepository.

import 'package:helm/core/analytics/domain/analytics_event_entity.dart';
import 'package:helm/core/analytics/domain/analytics_repository.dart';
import 'package:helm/core/analytics/data/datasources/analytics_local_data_source.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsLocalDataSource _localDataSource;

  AnalyticsRepositoryImpl({
    required AnalyticsLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  @override
  Future<void> save(AnalyticsEventEntity event) async {
    await _localDataSource.save(event);
  }

  @override
  Future<List<AnalyticsEventEntity>> getEventsSince(DateTime since) async {
    return _localDataSource.getEventsSince(since);
  }

  @override
  Future<int> getEventCount(String eventName) async {
    return _localDataSource.getEventCount(eventName);
  }

  @override
  Future<AnalyticsEventEntity?> getLastEventOf(String eventName) async {
    return _localDataSource.getLastEventOf(eventName);
  }
}
