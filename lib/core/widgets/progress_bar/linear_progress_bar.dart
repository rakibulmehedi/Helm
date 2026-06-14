import 'package:flutter/material.dart';

import '../../../utils/responsive_utils.dart';
import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_motion.dart';
import 'package:helm/core/themes/helm_spacing.dart';
import 'package:helm/core/themes/helm_typography.dart';

class OnboardingHeader extends StatelessWidget {
  final String title;
  final int? step; // 1, 2, 3, 4
  final int totalSteps;
  final EdgeInsetsGeometry? padding;
  final CrossAxisAlignment alignment;
  final bool isDark;

  const OnboardingHeader({
    super.key,
    required this.title,
    this.step,
    required this.totalSteps,
    this.padding,
    this.alignment = CrossAxisAlignment.start,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<HelmColors>()!;
    final typo = Theme.of(context).extension<HelmTypography>()!;
    final progress =
        (step != null && totalSteps > 0)
            ? (step!.clamp(1, totalSteps) / totalSteps)
            : null;

    return Padding(
      padding:
          padding ??
          EdgeInsets.only(
            top: ResponsiveUtilities.height(context, 0.01),
            bottom: ResponsiveUtilities.height(context, 0.02),
          ),
      child: Column(
        crossAxisAlignment: alignment,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (progress != null) ...[
            TweenAnimationBuilder<double>(
              duration: HelmMotion.slow,
              curve: HelmMotion.defaultCurve,
              tween: Tween<double>(begin: 0, end: progress),
              builder:
                  (context, value, _) => ClipRRect(
                    borderRadius: BorderRadius.circular(HelmSpacing.cardRadius),
                    child: LinearProgressIndicator(
                      value: value,
                      backgroundColor: colors.hairline,
                      color: colors.interactive,
                      minHeight: HelmSpacing.progressBarHeightOnboarding,
                    ),
                  ),
            ),
            SizedBox(height: ResponsiveUtilities.height(context, 0.015)),
          ],
          Text(
            title,
            style: typo.headingMd.copyWith(
              color: colors.inkPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
