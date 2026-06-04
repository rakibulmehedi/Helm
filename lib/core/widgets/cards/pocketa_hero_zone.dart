// lib/core/widgets/cards/pocketa_hero_zone.dart
// UX-5.10 — Five Card Widgets: PocketaHeroZone
//
// The S2S hero container. No visible card border — spatial grouping only.
// Background: colors.canvas (blends with screen background, not surface).
// Purpose: provides spatial breathing room for S2S hero block.
// Usage: wrap PocketaAmount (hero size) + PocketaLedgerRail + PocketaTrustStrip.

import 'package:flutter/material.dart';

import 'package:pocketa_v2/core/themes/pocketa_colors.dart';
import 'package:pocketa_v2/core/themes/pocketa_spacing.dart';

class PocketaHeroZone extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const PocketaHeroZone({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<PocketaColors>()!;

    return Container(
      padding: padding ??
          const EdgeInsets.all(PocketaSpacing.s5),
      decoration: BoxDecoration(
        color: colors.canvas,
        borderRadius: BorderRadius.circular(PocketaSpacing.cardRadius),
        // No visible border — this zone exists through spacing alone.
      ),
      child: child,
    );
  }
}
