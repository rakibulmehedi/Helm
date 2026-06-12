import 'package:flutter_test/flutter_test.dart';

import 'package:pocketa_v2/features/dashboard/domain/affirmation.dart';

void main() {
  group('Affirmation computation', () {
    test('shows pipeline up to date when 0 overdue entries', () {
      final result = Affirmation.compute(
        overdueEntryCount: 0,
        sessionCount: 0,
      );
      expect(result.type, equals(AffirmationType.pipelineUpToDate));
      expect(result.copy, equals('Pipeline up to date'));
    });

    test('does NOT show pipeline up to date when 1+ overdue entries', () {
      final result = Affirmation.compute(
        overdueEntryCount: 1,
        sessionCount: 0,
      );
      expect(result.type, isNot(equals(AffirmationType.pipelineUpToDate)));
    });

    test('shows 7 days tracked when sessionCount == 7', () {
      final result = Affirmation.compute(
        overdueEntryCount: 1,
        sessionCount: 7,
      );
      expect(result.type, equals(AffirmationType.daysTracked));
      expect(result.days, equals(7));
      expect(result.copy, equals('7 days tracked'));
    });

    test('shows 14 days tracked when sessionCount == 14', () {
      final result = Affirmation.compute(
        overdueEntryCount: 1,
        sessionCount: 14,
      );
      expect(result.type, equals(AffirmationType.daysTracked));
      expect(result.days, equals(14));
      expect(result.copy, equals('14 days tracked'));
    });

    test('shows nothing when pipeline has overdue AND sessionCount < 7', () {
      final result = Affirmation.compute(
        overdueEntryCount: 2,
        sessionCount: 3,
      );
      expect(result.type, equals(AffirmationType.none));
    });

    test('shows pipeline up to date when sessionCount == 7 but no overdue', () {
      final result = Affirmation.compute(
        overdueEntryCount: 0,
        sessionCount: 7,
      );
      expect(result.type, equals(AffirmationType.pipelineUpToDate));
    });

    test('copy has no exclamation marks, emoji, or comparative language', () {
      final pipelineResult = Affirmation.compute(overdueEntryCount: 0, sessionCount: 0);
      expect(pipelineResult.copy, isNot(contains('!')));
      expect(pipelineResult.copy, isNot(contains('great')));
      expect(pipelineResult.copy, isNot(contains('amazing')));

      final days7Result = Affirmation.compute(overdueEntryCount: 1, sessionCount: 7);
      expect(days7Result.copy, isNot(contains('!')));
      expect(days7Result.copy, isNot(contains('streak')));
      expect(days7Result.copy, isNot(contains('fire')));

      final days14Result = Affirmation.compute(overdueEntryCount: 1, sessionCount: 14);
      expect(days14Result.copy, isNot(contains('!')));
      expect(days14Result.copy, isNot(contains('awesome')));
    });
  });
}
