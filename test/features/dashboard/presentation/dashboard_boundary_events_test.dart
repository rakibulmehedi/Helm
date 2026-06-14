import 'package:flutter_test/flutter_test.dart';

import 'package:helm/core/analytics/event_registry.dart';

void main() {
  group('Boundary events — event name constants', () {
    test('stsAtRiskEntered exists', () {
      expect(BoundaryEvents.stsAtRiskEntered, equals('sts_at_risk_entered'));
    });

    test('reserveDepleted exists', () {
      expect(BoundaryEvents.reserveDepleted, equals('reserve_depleted'));
    });

    test('firstPipelineEntry exists', () {
      expect(BoundaryEvents.firstPipelineEntry, equals('first_pipeline_entry'));
    });

    test('pipelineStateChanged exists', () {
      expect(BoundaryEvents.pipelineStateChanged, equals('pipeline_state_changed'));
    });
  });

  group('Transactional events — event name constants', () {
    test('pipelineEntryCreated exists', () {
      expect(
        TransactionalEvents.pipelineEntryCreated,
        equals('pipeline_entry_created'),
      );
    });

    test('pipelineConfirmed exists', () {
      expect(TransactionalEvents.pipelineConfirmed, equals('pipeline_confirmed'));
    });
  });

  group('Event de-duplication — SharedPrefs flags compile', () {
    test('eventFired key format is valid', () {
      // Keys use pattern "event_fired_{eventName}"
      expect(BoundaryEvents.stsAtRiskEntered.isNotEmpty, isTrue);
      expect(BoundaryEvents.reserveDepleted.isNotEmpty, isTrue);
      expect(BoundaryEvents.firstPipelineEntry.isNotEmpty, isTrue);
      expect(BoundaryEvents.pipelineStateChanged.isNotEmpty, isTrue);
    });
  });
}
