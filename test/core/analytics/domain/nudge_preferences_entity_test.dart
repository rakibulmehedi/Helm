// test/core/analytics/domain/nudge_preferences_entity_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa_v2/core/analytics/domain/nudge_preferences_entity.dart';

void main() {
  test('default preferences: daily, 9am, push+in-app enabled, quiet affirmations on', () {
    final prefs = NudgePreferencesEntity.defaults();
    expect(prefs.cadence, equals(Cadence.daily));
    expect(prefs.checkInTime, equals(const TimeOfDay(hour: 9, minute: 0)));
    expect(prefs.pushEnabled, isTrue);
    expect(prefs.inAppEnabled, isTrue);
    expect(prefs.quietAffirmationsEnabled, isTrue);
  });
}
