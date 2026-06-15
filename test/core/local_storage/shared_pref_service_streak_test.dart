// test/core/local_storage/shared_pref_service_streak_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:helm/core/local_storage/shared_pref_service.dart';

void main() {
  group('SharedPrefServices tracking streak', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await SharedPrefServices.init();
    });

    test('first increment returns 1 and records today', () async {
      final streak = await SharedPrefServices.incrementTrackingStreak();
      expect(streak, 1);
    });

    test('same-day increment preserves streak', () async {
      await SharedPrefServices.incrementTrackingStreak();
      final streak = await SharedPrefServices.incrementTrackingStreak();
      expect(streak, 1);
      expect(SharedPrefServices.getTrackingStreak(), 1);
    });

    test('consecutive day increments streak', () async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      SharedPreferences.setMockInitialValues({
        'last_active_date': yesterday.toIso8601String().substring(0, 10),
        'tracking_streak': 3,
      });
      await SharedPrefServices.init();

      final streak = await SharedPrefServices.incrementTrackingStreak();
      expect(streak, 4);
    });

    test('gap day resets streak to 1', () async {
      final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));
      SharedPreferences.setMockInitialValues({
        'last_active_date': twoDaysAgo.toIso8601String().substring(0, 10),
        'tracking_streak': 5,
      });
      await SharedPrefServices.init();

      final streak = await SharedPrefServices.incrementTrackingStreak();
      expect(streak, 1);
    });
  });
}
