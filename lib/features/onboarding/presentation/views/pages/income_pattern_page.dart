// lib/features/onboarding/presentation/views/pages/income_pattern_page.dart
// UX-2 — Onboarding redesign: Screen 4 (Step 5 in full spec) — Income pattern selection
// UX Improvements:
//   - Uses HelmMotion tokens
//   - Page entry animation
//   - Error state when no pattern selected
//   - Semantics for screen reader support
//   - HapticFeedback on selection

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_motion.dart';
import 'package:helm/core/themes/helm_spacing.dart';
import 'package:helm/core/themes/helm_typography.dart';
import 'package:helm/core/widgets/buttons/button_multiple_types.dart';
import 'package:helm/features/onboarding/domain/income_pattern.dart';

class IncomePatternPage extends StatefulWidget {
  final IncomePattern initialPattern;
  final void Function(IncomePattern pattern) onContinue;

  const IncomePatternPage({
    super.key,
    required this.initialPattern,
    required this.onContinue,
  });

  @override
  State<IncomePatternPage> createState() => _IncomePatternPageState();
}

class _IncomePatternPageState extends State<IncomePatternPage>
    with SingleTickerProviderStateMixin {
  late IncomePattern _selected;
  String? _error;
  late AnimationController _entryController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialPattern;
    _error = null;

    // Page entry animation
    _entryController = AnimationController(
      vsync: this,
      duration: HelmMotion.slow,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entryController, curve: HelmMotion.defaultCurve),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
      _entryController.forward();
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  void _onPatternSelected(IncomePattern pattern) {
    HapticFeedback.selectionClick();
    setState(() {
      _selected = pattern;
      _error = null;
    });
  }

  void _onContinue() {
    if (_selected == IncomePattern.none) {
      setState(() => _error = 'Please select an income pattern to continue.');
      HapticFeedback.heavyImpact();
      return;
    }
    widget.onContinue(_selected);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<HelmColors>()!;
    final typo = Theme.of(context).extension<HelmTypography>()!;

    return Scaffold(
      backgroundColor: colors.canvas,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: HelmSpacing.screenEdge,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: HelmSpacing.s10),
                    // Progress indicator — step 4
                    Semantics(
                      label: 'Onboarding step 4 of 6',
                      child: _ProgressLine(
                        fraction: HelmSpacing.onboardingSteps[2],
                        colors: colors,
                      ),
                    ),
                    const SizedBox(height: HelmSpacing.s8),
                    Text(
                      'How does your income usually arrive?',
                      style: typo.headingLg.copyWith(color: colors.inkPrimary),
                    ),
                    const SizedBox(height: HelmSpacing.s2),
                    Text(
                      'Pick the pattern that fits most of your earnings.',
                      style: typo.bodyLg.copyWith(color: colors.inkSecondary),
                    ),
                    const SizedBox(height: HelmSpacing.s6),
                    _PatternCard(
                      title: 'Marketplace escrow',
                      platform: 'Upwork, Fiverr, Payoneer',
                      subtitle: 'Payment held until milestone or job completion',
                      selected: _selected == IncomePattern.marketplace,
                      onTap: () => _onPatternSelected(IncomePattern.marketplace),
                    ),
                    const SizedBox(height: HelmSpacing.s3),
                    _PatternCard(
                      title: 'Direct client',
                      platform: 'You invoice clients directly',
                      subtitle: 'Payment terms agreed with each client',
                      selected: _selected == IncomePattern.direct,
                      onTap: () => _onPatternSelected(IncomePattern.direct),
                    ),
                    const SizedBox(height: HelmSpacing.s3),
                    _PatternCard(
                      title: 'Retainer / Recurring',
                      platform: 'Same client, same amount each month',
                      subtitle: 'Predictable monthly income',
                      selected: _selected == IncomePattern.retainer,
                      onTap: () => _onPatternSelected(IncomePattern.retainer),
                    ),

                    // Error state
                    if (_error != null) ...[
                      const SizedBox(height: HelmSpacing.s3),
                      Container(
                        padding: const EdgeInsets.all(HelmSpacing.s3),
                        decoration: BoxDecoration(
                          color: colors.stateAtRisk.withValues(alpha: 0.1),
                          borderRadius:
                              BorderRadius.circular(HelmSpacing.s1),
                          border: Border.all(
                            color: colors.stateAtRisk.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              size: HelmSpacing.iconMd,
                              color: colors.stateAtRisk,
                            ),
                            const SizedBox(width: HelmSpacing.s2),
                            Expanded(
                              child: Text(
                                _error!,
                                style: typo.bodySm.copyWith(
                                  color: colors.stateAtRisk,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const Spacer(),
                    AppButton(
                      label: 'Save — sets income pattern',
                      onPressed: _onContinue,
                      isEnabled: true,
                    ),
                    const SizedBox(height: HelmSpacing.s4),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Internal widgets
// ---------------------------------------------------------------------------

class _ProgressLine extends StatelessWidget {
  final double fraction;
  final HelmColors colors;

  const _ProgressLine({required this.fraction, required this.colors});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Container(
              height: HelmSpacing.progressBarHeight,
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                color: colors.hairline,
                borderRadius: BorderRadius.circular(HelmSpacing.progressBarRadius),
              ),
            ),
            Container(
              height: HelmSpacing.progressBarHeight,
              width: constraints.maxWidth * fraction,
              decoration: BoxDecoration(
                color: colors.interactive,
                borderRadius: BorderRadius.circular(HelmSpacing.progressBarRadius),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PatternCard extends StatelessWidget {
  final String title;
  final String platform;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _PatternCard({
    required this.title,
    required this.platform,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<HelmColors>()!;
    final typo = Theme.of(context).extension<HelmTypography>()!;

    return Semantics(
      label: '$title income pattern from $platform. $subtitle',
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: HelmMotion.base,
          curve: HelmMotion.defaultCurve,
          padding: const EdgeInsets.all(HelmSpacing.s4),
          decoration: BoxDecoration(
            color: selected ? colors.surface : colors.canvas,
            borderRadius: BorderRadius.circular(HelmSpacing.cardRadius),
            border: Border.all(
              color: selected ? colors.interactive : colors.divider,
              width: selected ? HelmSpacing.cardBorder * 2 : HelmSpacing.cardBorder,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: typo.headingSm.copyWith(color: colors.inkPrimary),
              ),
              const SizedBox(height: HelmSpacing.s1),
              Text(
                platform,
                style: typo.bodySm.copyWith(color: colors.interactive),
              ),
              const SizedBox(height: HelmSpacing.s1),
              Text(
                subtitle,
                style: typo.bodySm.copyWith(color: colors.inkTertiary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}