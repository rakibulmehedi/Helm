// lib/core/widgets/pocketa_ledger_rail.dart
// UX-5.07 — Ledger Rail: S2S State Visual Signature
//
// The ownable state marker for Safe-to-Spend. Replaces thin accent lines.
// NEVER use color as the sole signal — shape and text label are always present.

import 'package:flutter/material.dart';

import 'package:pocketa_v2/core/themes/pocketa_colors.dart';
import 'package:pocketa_v2/core/themes/pocketa_spacing.dart';
import 'package:pocketa_v2/core/themes/pocketa_typography.dart';

/// The cashflow state to visualize.
enum LedgerState { safe, tight, atRisk }

/// Renders the Pocketa ledger rail — a short colored bar with a text label
/// beneath it that encodes the current cashflow state.
///
/// - [isHero] true → 3pt height (primary S2S display)
/// - [isHero] false → 1.5pt height (secondary / compact contexts)
///
/// Width adapts to available space:
///   - > 375pt: [PocketaSpacing.ledgerRailWidthRegular] (96pt)
///   - <= 375pt: [PocketaSpacing.ledgerRailWidth] (72pt)
///
/// Semantics: always includes "Cashflow state: [label]".
class PocketaLedgerRail extends StatelessWidget {
  final LedgerState state;

  /// When true the rail is 3pt tall (hero); otherwise 1.5pt (secondary).
  final bool isHero;

  const PocketaLedgerRail({
    super.key,
    required this.state,
    this.isHero = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<PocketaColors>()!;
    final typography = Theme.of(context).extension<PocketaTypography>()!;

    final Color railColor = _railColor(colors);
    final String label = _stateLabel();
    final double railHeight =
        isHero ? PocketaSpacing.ledgerRailHeight : PocketaSpacing.ledgerRailHeightSecondary;

    return Semantics(
      label: 'Cashflow state: $label',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double railWidth = constraints.maxWidth > 375
              ? PocketaSpacing.ledgerRailWidthRegular
              : PocketaSpacing.ledgerRailWidth;

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

              const SizedBox(height: PocketaSpacing.s1), // 4pt gap

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

  Color _railColor(PocketaColors colors) {
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
        return 'Reserve Mode';
    }
  }
}
