enum AffirmationType { none, pipelineUpToDate, daysTracked }

class Affirmation {
  final AffirmationType type;
  final String copy;
  final int? days;

  const Affirmation({
    required this.type,
    required this.copy,
    this.days,
  });

  static const Affirmation none = Affirmation(type: AffirmationType.none, copy: '');

  static Affirmation compute({
    required int overdueEntryCount,
    required int sessionCount,
  }) {
    if (overdueEntryCount == 0) {
      return const Affirmation(
        type: AffirmationType.pipelineUpToDate,
        copy: 'Pipeline up to date',
      );
    }

    if (sessionCount == 7) {
      return const Affirmation(
        type: AffirmationType.daysTracked,
        copy: '7 days tracked',
        days: 7,
      );
    }

    if (sessionCount == 14) {
      return const Affirmation(
        type: AffirmationType.daysTracked,
        copy: '14 days tracked',
        days: 14,
      );
    }

    return Affirmation.none;
  }
}
