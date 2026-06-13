// lib/features/onboarding/presentation/views/onboarding_screen.dart
// UX-2.09 — 6-step doctrine-aligned onboarding flow.
//
// Scope: qualifier → balance → fixed costs → income pattern → buffer → pipeline → home
// Skipped: email/auth (Screen 2), PIN/biometric (Screen 7) — trust layer, non-goal for UX-2.
//
// Rules enforced:
//   ONB-002: no back button, no AppBar
//   ONB-003: 2pt progress line only, no step numbers
//   ONB-012: after last step, go straight to home (no celebration screen)
//   ONB-014: no confetti, no "Welcome!", no tour

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:pocketa_v2/config/router/route_names.dart';
import 'package:pocketa_v2/core/local_storage/shared_pref_service.dart';
import 'package:pocketa_v2/core/themes/pocketa_colors.dart';
import 'package:pocketa_v2/core/utils/id_generator.dart';
import 'package:pocketa_v2/features/onboarding/domain/onboarding_draft.dart';
import 'package:pocketa_v2/features/onboarding/presentation/views/pages/buffer_comfort_page.dart';
import 'package:pocketa_v2/features/onboarding/presentation/views/pages/fixed_costs_page.dart';
import 'package:pocketa_v2/features/onboarding/presentation/views/pages/income_pattern_page.dart';
import 'package:pocketa_v2/features/onboarding/presentation/views/pages/liquid_balance_page.dart';
import 'package:pocketa_v2/features/onboarding/presentation/views/pages/first_pipeline_page.dart';
import 'package:pocketa_v2/features/onboarding/presentation/views/pages/qualifying_question_page.dart';
import 'package:pocketa_v2/features/onboarding/presentation/widgets/onboarding_progress_line.dart';
import 'package:pocketa_v2/features/income/domain/entities/income_entry_entity.dart';
import 'package:pocketa_v2/features/income/presentation/providers/income_providers.dart';
import 'package:pocketa_v2/features/safe_to_spend/domain/entities/fixed_cost_entry.dart';
import 'package:pocketa_v2/core/analytics/analytics_service.dart';
import 'package:pocketa_v2/core/analytics/event_registry.dart';
import 'package:pocketa_v2/features/safe_to_spend/presentation/providers/safe_to_spend_providers.dart';
import 'package:pocketa_v2/features/settings/presentation/views/cadence_preference_sheet.dart';

// ONB-003 progress values per step (6 steps)
const List<double> _kStepProgress = [0.0, 0.20, 0.40, 0.55, 0.70, 0.90];

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentStep = 0;
  OnboardingDraft _draft = const OnboardingDraft();

  void _goToStep(int step) {
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
    if (step > 0) {
      ref.read(analyticsProvider).trackEvent(
        TransactionalEvents.onboardingStepCompleted,
        properties: {EventProperties.stepNumber: step.toString()},
      );
    }
  }

  /// Global skip — persists partial draft data, navigates to home.
  Future<void> _skipToHome() async {
    await SharedPrefServices.setLiquidBalanceBdt(_draft.liquidBalanceBdt);
    if (_draft.incomePattern.name.isNotEmpty) {
      await SharedPrefServices.setIncomePattern(_draft.incomePattern.name);
    }
    await SharedPrefServices.setOnboardingCompleted(true);
    ref.read(analyticsProvider).trackEvent(BoundaryEvents.onboardingCompleted);
    if (mounted) context.go(RouteNames.home);
  }

  /// Creates a pipeline entry from onboarding step 6, then completes.
  Future<void> _addPipelineEntryAndComplete(PipelineDraftEntry entry) async {
    final now = DateTime.now();
    final incomeEntity = IncomeEntryEntity(
      id: IdGenerator.uniqueId(),
      clientName: entry.clientName,
      projectName: '',
      amount: entry.amount,
      currency: entry.currency,
      status: IncomeStatus.expected,
      expectedDate: now.add(const Duration(days: 14)),
      createdAt: now,
      updatedAt: now,
    );
    await ref.read(incomeNotifierProvider.notifier).addIncome(incomeEntity);
    await _completeOnboarding();
  }

  /// Persists all draft data then navigates to home (ONB-012).
  /// 320ms transition per ONB-048 is handled by GoRouter's default.
  Future<void> _completeOnboarding() async {
    await SharedPrefServices.setLiquidBalanceBdt(_draft.liquidBalanceBdt);
    await SharedPrefServices.setIncomePattern(_draft.incomePattern.name);

    final fixedCostNotifier = ref.read(fixedCostNotifierProvider.notifier);
    for (final item in _draft.fixedCosts) {
      await fixedCostNotifier.addFixedCost(FixedCostEntry(
        id: IdGenerator.uniqueId(),
        label: item.label,
        amount: item.amount,
        dueDayOfMonth: item.dayOfMonth.clamp(1, 28),
        createdAt: DateTime.now(),
      ));
    }

    // Buffer: store as percentage in StsSettings (D1.11).
    final stsNotifier = ref.read(stsSettingsProvider.notifier);
    await stsNotifier.updateBufferPercent(_draft.bufferPercent.toDouble());

    await SharedPrefServices.setOnboardingCompleted(true);
    // D2P — Beta instrumentation: onboarding completion milestone
    ref.read(analyticsProvider).trackEvent(BoundaryEvents.onboardingCompleted);
    if (mounted) {
      await CadencePreferenceSheet.show(context);
    }
    if (mounted) context.go(RouteNames.home);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<PocketaColors>()!;

    return Scaffold(
      backgroundColor: colors.canvas,
      // ONB-002: no AppBar
      body: Column(
        children: [
          // ONB-003: 2pt progress line at top, no labels
          SafeArea(
            bottom: false,
            child: Stack(
              children: [
                OnboardingProgressLine(
                  progress: _kStepProgress[_currentStep],
                ),
                Positioned(
                  top: 8,
                  right: 16,
                  child: TextButton(
                    key: const Key('onboarding_skip'),
                    onPressed: _skipToHome,
                    child: Text(
                      'Set up later',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: PageView(
              controller: _pageController,
              // ONB-002: user cannot swipe between steps
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Step 0 — Qualifying question
                QualifyingQuestionPage(
                  onQualified: () => _goToStep(1),
                  // Disqualified → back to welcome (no forced app exit on Flutter)
                  onDisqualified: () {
                    if (mounted) context.go(RouteNames.welcome);
                  },
                ),

                // Step 1 — Liquid balance
                LiquidBalancePage(
                  initialBalance: _draft.liquidBalanceBdt,
                  onContinue: (balance) {
                    setState(() {
                      _draft = _draft.copyWith(liquidBalanceBdt: balance);
                    });
                    _goToStep(2);
                  },
                ),

                // Step 2 — Fixed costs
                FixedCostsPage(
                  initialCosts: _draft.fixedCosts,
                  onContinue: (costs) {
                    setState(() {
                      _draft = _draft.copyWith(fixedCosts: costs);
                    });
                    _goToStep(3);
                  },
                ),

                // Step 3 — Income pattern
                IncomePatternPage(
                  initialPattern: _draft.incomePattern,
                  onContinue: (pattern) {
                    setState(() {
                      _draft = _draft.copyWith(incomePattern: pattern);
                    });
                    _goToStep(4);
                  },
                ),

                // Step 4 — Buffer comfort
                BufferComfortPage(
                  initialBufferPercent: _draft.bufferPercent,
                  liquidBalanceBdt: _draft.liquidBalanceBdt,
                  totalFixedCostsBdt: _draft.totalFixedCostsBdt,
                  onContinue: (bufferPct) {
                    setState(() {
                      _draft = _draft.copyWith(bufferPercent: bufferPct);
                    });
                    _goToStep(5);
                  },
                ),

                // Step 5 — First pipeline entry (optional, M5)
                FirstPipelinePage(
                  onAddEntry: (entry) => _addPipelineEntryAndComplete(entry),
                  onSkip: () => _completeOnboarding(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
