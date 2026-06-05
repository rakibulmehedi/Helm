// lib/features/onboarding/domain/onboarding_draft.dart
// UX-2.01 — Onboarding: in-memory draft model.
// Holds all data collected across the 5 onboarding screens before final save.

import 'income_pattern.dart';

/// A single fixed cost item captured during onboarding.
class FixedCostDraftItem {
  final String label;
  final double amount;
  final int dayOfMonth;

  const FixedCostDraftItem({
    required this.label,
    required this.amount,
    required this.dayOfMonth,
  });
}

/// In-memory draft of all onboarding inputs.
/// Not persisted until onboarding completes.
class OnboardingDraft {
  final double liquidBalanceBdt;
  final List<FixedCostDraftItem> fixedCosts;
  final IncomePattern incomePattern;
  final int bufferPercent; // one of: 5, 15, 25, 30

  const OnboardingDraft({
    this.liquidBalanceBdt = 0.0,
    this.fixedCosts = const [],
    this.incomePattern = IncomePattern.marketplace,
    this.bufferPercent = 15,
  });

  OnboardingDraft copyWith({
    double? liquidBalanceBdt,
    List<FixedCostDraftItem>? fixedCosts,
    IncomePattern? incomePattern,
    int? bufferPercent,
  }) {
    return OnboardingDraft(
      liquidBalanceBdt: liquidBalanceBdt ?? this.liquidBalanceBdt,
      fixedCosts: fixedCosts ?? this.fixedCosts,
      incomePattern: incomePattern ?? this.incomePattern,
      bufferPercent: bufferPercent ?? this.bufferPercent,
    );
  }

  double get bufferAmountBdt => liquidBalanceBdt * bufferPercent / 100;

  double get totalFixedCostsBdt =>
      fixedCosts.fold(0.0, (sum, item) => sum + item.amount);

  double get previewSafeToSpend =>
      liquidBalanceBdt - bufferAmountBdt - totalFixedCostsBdt;
}
