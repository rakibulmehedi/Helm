// lib/features/onboarding/presentation/widgets/onboarding_progress_line.dart
// UX-2.02 — ONB-003: thin 2pt progress line, no step labels, no percentage.
// UX Improvements:
//   - Uses HelmMotion tokens
//   - Semantics for screen reader support

import 'package:flutter/material.dart';
import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_motion.dart';
import 'package:helm/core/themes/helm_spacing.dart';

class OnboardingProgressLine extends StatelessWidget {
  final double progress; // 0.0 to 1.0

  const OnboardingProgressLine({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    Widget progressBar(double value) {
      return SizedBox(
        height: HelmSpacing.progressBarHeight,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(HelmSpacing.progressBarRadius),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: colors.hairline,
            valueColor: AlwaysStoppedAnimation<Color>(colors.interactive),
            minHeight: HelmSpacing.progressBarHeight,
          ),
        ),
      );
    }

    return Semantics(
      label: 'Onboarding progress: ${(progress * 100).round()}% complete',
      value: '${(progress * 100).round()}%',
      child: disableAnimations
          ? progressBar(progress)
          : TweenAnimationBuilder<double>(
              duration: HelmMotion.base,
              curve: HelmMotion.defaultCurve,
              tween: Tween<double>(begin: 0, end: progress),
              builder: (context, value, _) => progressBar(value),
            ),
    );
  }
}