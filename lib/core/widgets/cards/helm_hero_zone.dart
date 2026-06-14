// lib/core/widgets/cards/helm_hero_zone.dart
// UX-5.10 — Five Card Widgets: HelmHeroZone
//
// The S2S hero container. No visible card border — spatial grouping only.
// Background: colors.canvas (blends with screen background, not surface).
// Purpose: provides spatial breathing room for S2S hero block.
// Usage: wrap HelmAmount (hero size) + HelmLedgerRail + HelmTrustStrip.

import 'package:flutter/material.dart';

import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_spacing.dart';

class HelmHeroZone extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const HelmHeroZone({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<HelmColors>()!;

    return Container(
      padding: padding ??
          const EdgeInsets.all(HelmSpacing.s5),
      decoration: BoxDecoration(
        color: colors.canvas,
        borderRadius: BorderRadius.circular(HelmSpacing.cardRadius),
        // No visible border — this zone exists through spacing alone.
      ),
      child: child,
    );
  }
}
