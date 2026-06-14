import 'package:flutter_test/flutter_test.dart';
import 'package:helm/features/onboarding/domain/income_pattern.dart';
import 'package:helm/features/onboarding/domain/onboarding_draft.dart';

void main() {
  group('OnboardingDraft defaults', () {
    test('has sensible defaults', () {
      const draft = OnboardingDraft();
      expect(draft.liquidBalanceBdt, 0.0);
      expect(draft.fixedCosts, isEmpty);
      expect(draft.incomePattern, IncomePattern.marketplace);
      expect(draft.bufferPercent, 15);
    });
  });

  group('OnboardingDraft.copyWith', () {
    test('copies liquidBalanceBdt', () {
      const draft = OnboardingDraft();
      final updated = draft.copyWith(liquidBalanceBdt: 50000);
      expect(updated.liquidBalanceBdt, 50000);
      expect(updated.bufferPercent, 15); // unchanged
    });

    test('copies fixedCosts', () {
      const draft = OnboardingDraft();
      final costs = [
        const FixedCostDraftItem(label: 'Rent', amount: 15000, dayOfMonth: 1),
      ];
      final updated = draft.copyWith(fixedCosts: costs);
      expect(updated.fixedCosts.length, 1);
      expect(updated.fixedCosts.first.label, 'Rent');
    });

    test('copies incomePattern', () {
      const draft = OnboardingDraft();
      final updated = draft.copyWith(incomePattern: IncomePattern.direct);
      expect(updated.incomePattern, IncomePattern.direct);
    });

    test('copies bufferPercent', () {
      const draft = OnboardingDraft();
      final updated = draft.copyWith(bufferPercent: 25);
      expect(updated.bufferPercent, 25);
    });

    test('preserves unmodified fields', () {
      final draft = const OnboardingDraft().copyWith(
        liquidBalanceBdt: 100000,
        bufferPercent: 30,
      );
      final updated = draft.copyWith(incomePattern: IncomePattern.retainer);
      expect(updated.liquidBalanceBdt, 100000);
      expect(updated.bufferPercent, 30);
      expect(updated.incomePattern, IncomePattern.retainer);
    });
  });

  group('OnboardingDraft computed properties', () {
    test('bufferAmountBdt calculates correctly', () {
      final draft = const OnboardingDraft().copyWith(
        liquidBalanceBdt: 100000,
        bufferPercent: 15,
      );
      expect(draft.bufferAmountBdt, 15000.0);
    });

    test('bufferAmountBdt is zero when balance is zero', () {
      const draft = OnboardingDraft();
      expect(draft.bufferAmountBdt, 0.0);
    });

    test('totalFixedCostsBdt sums all costs', () {
      final draft = const OnboardingDraft().copyWith(
        fixedCosts: [
          const FixedCostDraftItem(label: 'Rent', amount: 15000, dayOfMonth: 1),
          const FixedCostDraftItem(
              label: 'Internet', amount: 1500, dayOfMonth: 10),
          const FixedCostDraftItem(
              label: 'Electric', amount: 3000, dayOfMonth: 15),
        ],
      );
      expect(draft.totalFixedCostsBdt, 19500.0);
    });

    test('totalFixedCostsBdt is zero with no costs', () {
      const draft = OnboardingDraft();
      expect(draft.totalFixedCostsBdt, 0.0);
    });

    test('previewSafeToSpend calculates correctly', () {
      final draft = const OnboardingDraft().copyWith(
        liquidBalanceBdt: 100000,
        bufferPercent: 15,
        fixedCosts: [
          const FixedCostDraftItem(label: 'Rent', amount: 15000, dayOfMonth: 1),
        ],
      );
      // 100000 - 15000 (buffer) - 15000 (rent) = 70000
      expect(draft.previewSafeToSpend, 70000.0);
    });

    test('previewSafeToSpend can be negative', () {
      final draft = const OnboardingDraft().copyWith(
        liquidBalanceBdt: 10000,
        bufferPercent: 30,
        fixedCosts: [
          const FixedCostDraftItem(label: 'Rent', amount: 15000, dayOfMonth: 1),
        ],
      );
      // 10000 - 3000 (buffer) - 15000 (rent) = -8000
      expect(draft.previewSafeToSpend, -8000.0);
    });

    test('previewSafeToSpend with zero balance', () {
      const draft = OnboardingDraft();
      expect(draft.previewSafeToSpend, 0.0);
    });
  });
}
