// test/core/analytics/analytics_session_dedup_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/analytics/analytics_service.dart';
import 'package:helm/core/analytics/event_registry.dart';
import 'package:helm/core/local_storage/shared_pref_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'analytics_service_dual_write_test.dart';

void main() {
  late FakeAnalyticsRepository fakeRepo;
  late LocalAnalyticsService service;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SharedPrefServices.init();
    fakeRepo = FakeAnalyticsRepository();
    service = LocalAnalyticsService(repository: fakeRepo);
  });

  test('daily_active_session fires only once per calendar day', () async {
    // Fire first time today
    service.trackEvent(BoundaryEvents.dailyActiveSession);
    expect(fakeRepo.savedEvents.length, equals(1));
    expect(
      fakeRepo.savedEvents.first.eventName,
      equals(BoundaryEvents.dailyActiveSession),
    );

    // Fire again on same day -> should be deduplicated
    service.trackEvent(BoundaryEvents.dailyActiveSession);
    expect(fakeRepo.savedEvents.length, equals(1));

    // Manually modify last session date in shared preferences to yesterday
    final yesterdayStr = DateTime.now()
        .subtract(const Duration(days: 1))
        .toIso8601String()
        .substring(0, 10);
    await SharedPrefServices.setLastSessionDate(yesterdayStr);

    // Fire on a new day -> should record the event
    service.trackEvent(BoundaryEvents.dailyActiveSession);
    expect(fakeRepo.savedEvents.length, equals(2));
  });
}
