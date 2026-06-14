// lib/core/widgets/cards/helm_caution_card.dart
// UX-5.10 — Five Card Widgets: HelmCautionCard
//
// Reserve Mode / urgent due card.
// LEFT border rail: 3pt stateAtRisk (isCritical) or stateTight (!isCritical).
// Right + top + bottom border: 1pt colors.divider.
// Background: colors.surface — NEVER red/amber fill.
// Tone: clinical, not alarmist.

import 'package:flutter/material.dart';

import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_spacing.dart';
import 'package:helm/core/themes/helm_typography.dart';

class HelmCautionCard extends StatelessWidget {
  final Widget child;
  final String? title;
  final bool isCritical;

  const HelmCautionCard({
    super.key,
    required this.child,
    this.title,
    this.isCritical = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<HelmColors>()!;
    final typography = Theme.of(context).extension<HelmTypography>()!;

    final Color railColor =
        isCritical ? colors.stateAtRisk : colors.stateTight;

    // Left side has 0pt radius to keep the rail flush and visible.
    // Right side retains the 12pt radius.
    const leftRadius = Radius.zero;
    final rightRadius = Radius.circular(HelmSpacing.cardRadius);

    final borderRadius = BorderRadius.only(
      topLeft: leftRadius,
      bottomLeft: leftRadius,
      topRight: rightRadius,
      bottomRight: rightRadius,
    );

    // Per-side borders:
    //   left  = 3pt rail color
    //   top / right / bottom = 1pt divider
    final border = Border(
      left: BorderSide(color: railColor, width: 3.0),
      top: BorderSide(color: colors.divider, width: HelmSpacing.cardBorder),
      right: BorderSide(color: colors.divider, width: HelmSpacing.cardBorder),
      bottom: BorderSide(color: colors.divider, width: HelmSpacing.cardBorder),
    );

    return ClipRRect(
      borderRadius: borderRadius,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: borderRadius,
          border: border,
        ),
        child: Padding(
          // Extra s2 (8pt) on the left to visually clear the rail.
          padding: const EdgeInsets.only(
            left: HelmSpacing.s4 + HelmSpacing.s2,
            right: HelmSpacing.s4,
            top: HelmSpacing.s4,
            bottom: HelmSpacing.s4,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null) ...[
                Text(
                  title!,
                  style: typography.headingSm.copyWith(
                    color: colors.inkPrimary,
                  ),
                ),
                const SizedBox(height: HelmSpacing.s3),
              ],
              child,
            ],
          ),
        ),
      ),
    );
  }
}
