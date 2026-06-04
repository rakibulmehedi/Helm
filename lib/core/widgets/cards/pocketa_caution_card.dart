// lib/core/widgets/cards/pocketa_caution_card.dart
// UX-5.10 — Five Card Widgets: PocketaCautionCard
//
// Reserve Mode / urgent due card.
// LEFT border rail: 3pt stateAtRisk (isCritical) or stateTight (!isCritical).
// Right + top + bottom border: 1pt colors.divider.
// Background: colors.surface — NEVER red/amber fill.
// Tone: clinical, not alarmist.

import 'package:flutter/material.dart';

import 'package:pocketa_v2/core/themes/pocketa_colors.dart';
import 'package:pocketa_v2/core/themes/pocketa_spacing.dart';
import 'package:pocketa_v2/core/themes/pocketa_typography.dart';

class PocketaCautionCard extends StatelessWidget {
  final Widget child;
  final String? title;
  final bool isCritical;

  const PocketaCautionCard({
    super.key,
    required this.child,
    this.title,
    this.isCritical = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<PocketaColors>()!;
    final typography = Theme.of(context).extension<PocketaTypography>()!;

    final Color railColor =
        isCritical ? colors.stateAtRisk : colors.stateTight;

    // Left side has 0pt radius to keep the rail flush and visible.
    // Right side retains the 12pt radius.
    const leftRadius = Radius.zero;
    final rightRadius = Radius.circular(PocketaSpacing.cardRadius);

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
      top: BorderSide(color: colors.divider, width: PocketaSpacing.cardBorder),
      right: BorderSide(color: colors.divider, width: PocketaSpacing.cardBorder),
      bottom: BorderSide(color: colors.divider, width: PocketaSpacing.cardBorder),
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
            left: PocketaSpacing.s4 + PocketaSpacing.s2,
            right: PocketaSpacing.s4,
            top: PocketaSpacing.s4,
            bottom: PocketaSpacing.s4,
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
                const SizedBox(height: PocketaSpacing.s3),
              ],
              child,
            ],
          ),
        ),
      ),
    );
  }
}
