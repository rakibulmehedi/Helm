// lib/features/onboarding/presentation/widgets/onboarding_progress_line.dart
// UX-2.02 — ONB-003: thin 2pt progress line, no step labels, no percentage.

import 'package:flutter/material.dart';
import 'package:pocketa_v2/core/themes/pocketa_colors.dart';

class OnboardingProgressLine extends StatelessWidget {
  final double progress; // 0.0 to 1.0

  const OnboardingProgressLine({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<PocketaColors>()!;
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      tween: Tween<double>(begin: 0, end: progress),
      builder: (context, value, _) {
        return SizedBox(
          height: 2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(1),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: colors.hairline,
              valueColor: AlwaysStoppedAnimation<Color>(colors.interactive),
              minHeight: 2,
            ),
          ),
        );
      },
    );
  }
}
