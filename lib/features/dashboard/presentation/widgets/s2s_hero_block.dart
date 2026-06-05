// lib/features/dashboard/presentation/widgets/s2s_hero_block.dart
// UX-1.03 — S2S Hero Block
//
// The primary safe-to-spend hero display.
// DASH-011: Label above number. DASH-013: Hero number always inkPrimary.
// DASH-018: 200ms FadeTransition on load (respects disableAnimations).
// DASH-019: Tapping opens calculation trace.
// DASH-033: Never shows "Reserve Mode" — LedgerRail handles its own label text.

import 'package:flutter/material.dart';

import 'package:pocketa_v2/core/themes/pocketa_colors.dart';
import 'package:pocketa_v2/core/themes/pocketa_motion.dart';
import 'package:pocketa_v2/core/themes/pocketa_spacing.dart';
import 'package:pocketa_v2/core/themes/pocketa_typography.dart';
import 'package:pocketa_v2/core/widgets/cards/pocketa_hero_zone.dart';
import 'package:pocketa_v2/core/widgets/pocketa_amount.dart';
import 'package:pocketa_v2/core/widgets/pocketa_ledger_rail.dart';
import 'package:pocketa_v2/core/widgets/pocketa_trust_strip.dart';
import 'package:pocketa_v2/features/safe_to_spend/domain/entities/safe_to_spend_result.dart';

/// Derives the cashflow state from a [SafeToSpendResult].
LedgerState _ledgerState(SafeToSpendResult r) {
  if (r.rawSafeToSpend > 0) return LedgerState.safe;
  if (r.rawSafeToSpend > -r.anxietyBuffer) return LedgerState.tight;
  return LedgerState.atRisk;
}

/// The S2S hero block: label → amount → meaning line → ledger rail → trust strip.
///
/// Wraps everything in [PocketaHeroZone] and applies a [FadeTransition] on load.
/// [onTapTrace] opens the calculation breakdown (DASH-019).
class S2sHeroBlock extends StatefulWidget {
  final SafeToSpendResult result;
  final DateTime updatedAt;

  /// Opens the calculation breakdown when tapped.
  final VoidCallback? onTapTrace;

  const S2sHeroBlock({
    super.key,
    required this.result,
    required this.updatedAt,
    this.onTapTrace,
  });

  @override
  State<S2sHeroBlock> createState() => _S2sHeroBlockState();
}

class _S2sHeroBlockState extends State<S2sHeroBlock>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: PocketaMotion.s2sAppear,
    );
    _opacity = CurvedAnimation(
      parent: _controller,
      curve: PocketaMotion.defaultCurve,
    );

    // Respect system-level reduced-motion preference (DASH-018).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final disableAnimations =
          MediaQuery.of(context).disableAnimations;
      if (disableAnimations) {
        _controller.value = 1.0;
      } else {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// True when there is no data: safeToSpend == 0 AND totalReceivedIncomeBdt == 0.
  bool get _hasNoData =>
      widget.result.safeToSpend == 0 &&
      widget.result.totalReceivedIncomeBdt == 0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<PocketaColors>()!;
    final typography = Theme.of(context).extension<PocketaTypography>()!;

    final Widget heroContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // DASH-011: label appears ABOVE the number.
        Text(
          'SAFE-TO-SPEND',
          style: typography.labelSm.copyWith(
            letterSpacing: 1.5,
            color: colors.inkSecondary,
          ),
        ),
        const SizedBox(height: PocketaSpacing.s1),

        // DASH-013: hero number color is always inkPrimary — PocketaAmount handles
        // this via its default (non-dimmed) rendering.
        // No-data state: show em-dash instead of 0.
        if (_hasNoData)
          Text(
            '—',
            style: typography.displayHero.copyWith(color: colors.inkPrimary),
          )
        else
          const SizedBox.shrink(),

        if (!_hasNoData)
          PocketaAmount(
            amount: widget.result.safeToSpend,
            size: AmountSize.hero,
          ),

        const SizedBox(height: PocketaSpacing.s1),

        Text(
          'after fixed costs & buffer',
          style: typography.bodySm.copyWith(color: colors.inkSecondary),
        ),

        const SizedBox(height: PocketaSpacing.s3),

        PocketaLedgerRail(
          state: _ledgerState(widget.result),
          isHero: true,
        ),

        const SizedBox(height: PocketaSpacing.s3),

        PocketaTrustStrip(
          updatedAt: widget.updatedAt,
          sourceLabel: 'Received only',
          onTapAudit: widget.onTapTrace,
        ),
      ],
    );

    return FadeTransition(
      opacity: _opacity,
      child: GestureDetector(
        onTap: widget.onTapTrace,
        behavior: HitTestBehavior.opaque,
        child: PocketaHeroZone(
          child: heroContent,
        ),
      ),
    );
  }
}
