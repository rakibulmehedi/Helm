// test/core/analytics/analytics_service_dual_write_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa_v2/core/analytics/analytics_service.dart';
import 'package:pocketa_v2/core/analytics/domain/analytics_event_entity.dart';
import 'package:pocketa_v2/core/analytics/domain/analytics_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pocketa_v2/core/local_storage/shared_pref_service.dart';

class FakeAnalyticsRepository implements AnalyticsRepository {
  final List<AnalyticsEventEntity> savedEvents = [];

  @override
  Future<void> save(AnalyticsEventEntity event) async {
    savedEvents.add(event);
  }

  @override
  Future<List<AnalyticsEventEntity>> getEventsSince(DateTime since) async {
    return savedEvents.where((e) => e.timestamp.isAfter(since)).toList();
  }

  @override
  Future<int> getEventCount(String eventName) async {
    return savedEvents.where((e) => e.eventName == eventName).length;
  }

  @override
  Future<AnalyticsEventEntity?> getLastEventOf(String eventName) async {
    final matching = savedEvents.where((e) => e.eventName == eventName).toList();
    if (matching.isEmpty) return null;
    matching.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return matching.first;
  }
}

void main() {
  late FakeAnalyticsRepository fakeRepo;
  late LocalAnalyticsService service;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SharedPrefServices.init();
    fakeRepo = FakeAnalyticsRepository();
    service = LocalAnalyticsService(repository: fakeRepo);
  });

  test('LocalAnalyticsService writes to repository persistently', () async {
    service.trackEvent('test_event', properties: {'k': 'v'});
    expect(fakeRepo.savedEvents.length, equals(1));
    expect(fakeRepo.savedEvents.first.eventName, equals('test_event'));
    expect(fakeRepo.savedEvents.first.properties['k'], equals('v'));
  });

  test('trackScreen records screen_view event', () async {
    service.trackScreen('dashboard');
    expect(fakeRepo.savedEvents.length, equals(1));
    expect(fakeRepo.savedEvents.first.eventName, equals('screen_view'));
    expect(fakeRepo.savedEvents.first.properties['screen'], equals('dashboard'));
  });
}
