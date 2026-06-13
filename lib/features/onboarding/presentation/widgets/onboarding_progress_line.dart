// lib/features/onboarding/presentation/widgets/onboarding_progress_line.dart
// UX-2.02 — ONB-003: thin 2pt progress line, no step labels, no percentage.
// UX Improvements:
//   - Uses PocketaMotion tokens
//   - Semantics for screen reader support

import 'package:flutter/material.dart';
import 'package:pocketa_v2/core/themes/pocketa_colors.dart';
import 'package:pocketa_v2/core/themes/pocketa_motion.dart';
import 'package:pocketa_v2/core/themes/pocketa_spacing.dart';

class OnboardingProgressLine extends StatelessWidget {
  final double progress; // 0.0 to 1.0

  const OnboardingProgressLine({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<PocketaColors>()!;

    return Semantics(
      label: 'Onboarding progress: ${(progress * 100).round()}% complete',
      value: '${(progress * 100).round()}%',
      child: TweenAnimationBuilder<double>(
        duration: PocketaMotion.base,
        curve: PocketaMotion.defaultCurve,
        tween: Tween<double>(begin: 0, end: progress),
        builder: (context, value, _) {
          return SizedBox(
            height: PocketaSpacing.progressBarHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(PocketaSpacing.progressBarRadius),
              child: LinearProgressIndicator(
                value: value,
                backgroundColor: colors.hairline,
                valueColor: AlwaysStoppedAnimation<Color>(colors.interactive),
                minHeight: PocketaSpacing.progressBarHeight,
              ),
            ),
          );
        },
      ),
    );
  }
}