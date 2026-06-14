// lib/core/widgets/helm_ledger_rail.dart
// UX-5.07 — Ledger Rail: S2S State Visual Signature
//
// The ownable state marker for Safe-to-Spend. Replaces thin accent lines.
// NEVER use color as the sole signal — shape and text label are always present.

import 'package:flutter/material.dart';

import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_spacing.dart';
import 'package:helm/core/themes/helm_typography.dart';

/// The cashflow state to visualize.
enum LedgerState { safe, tight, atRisk }

/// Renders the Helm ledger rail — a short colored bar with a text label
/// beneath it that encodes the current cashflow state.
///
/// - [isHero] true → 3pt height (primary S2S display)
/// - [isHero] false → 1.5pt height (secondary / compact contexts)
///
/// Width adapts to available space:
///   - > 375pt: [HelmSpacing.ledgerRailWidthRegular] (96pt)
///   - <= 375pt: [HelmSpacing.ledgerRailWidth] (72pt)
///
/// Semantics: always includes "Cashflow state: [label]".
class HelmLedgerRail extends StatelessWidget {
  final LedgerState state;

  /// When true the rail is 3pt tall (hero); otherwise 1.5pt (secondary).
  final bool isHero;

  const HelmLedgerRail({
    super.key,
    required this.state,
    this.isHero = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.textStyles;

    final Color railColor = _railColor(colors);
    final String label = _stateLabel();
    final double railHeight =
        isHero ? HelmSpacing.ledgerRailHeight : HelmSpacing.ledgerRailHeightSecondary;

    return Semantics(
      label: 'Cashflow state: $label',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double railWidth = constraints.maxWidth > 375
              ? HelmSpacing.ledgerRailWidthRegular
              : HelmSpacing.ledgerRailWidth;

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rail bar
              Container(
                width: railWidth,
                height: railHeight,
                decoration: BoxDecoration(
                  color: railColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(height: HelmSpacing.s1), // 4pt gap

              // State label — must always be present (accessibility + no color-only signal)
              Text(
                label,
                style: typography.labelSm.copyWith(color: colors.inkSecondary),
              ),
            ],
          );
        },
      ),
    );
  }

  Color _railColor(HelmColors colors) {
    switch (state) {
      case LedgerState.safe:
        return colors.stateSafe;
      case LedgerState.tight:
        return colors.stateTight;
      case LedgerState.atRisk:
        return colors.stateAtRisk;
    }
  }

  String _stateLabel() {
    switch (state) {
      case LedgerState.safe:
        return 'Safe';
      case LedgerState.tight:
        return 'Tight';
      case LedgerState.atRisk:
        return 'At Risk';
    }
  }
}
