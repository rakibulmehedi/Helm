import 'package:flutter_test/flutter_test.dart';

import 'package:helm/core/analytics/event_registry.dart';

void main() {
  group('P4 instrumentation events — TransactionalEvents', () {
    test('notificationOpened exists', () {
      expect(
        TransactionalEvents.notificationOpened,
        equals('notification_opened'),
      );
    });

    test('notificationResultedInUpdate exists', () {
      expect(
        TransactionalEvents.notificationResultedInUpdate,
        equals('notification_resulted_in_update'),
      );
    });

    test('onboardingStepCompleted exists', () {
      expect(
        TransactionalEvents.onboardingStepCompleted,
        equals('onboarding_step_completed'),
      );
    });

    test('timeToS2sVisible exists', () {
      expect(
        TransactionalEvents.timeToS2sVisible,
        equals('time_to_s2s_visible'),
      );
    });
  });

  group('P4 instrumentation events — BoundaryEvents', () {
    test('s2sCalcFailure exists', () {
      expect(
        BoundaryEvents.s2sCalcFailure,
        equals('s2s_calc_failure'),
      );
    });
  });

  group('P4 instrumentation events — EventProperties', () {
    test('stepNumber exists', () {
      expect(EventProperties.stepNumber, equals('step_number'));
    });

    test('durationMs exists', () {
      expect(EventProperties.durationMs, equals('duration_ms'));
    });
  });
}
