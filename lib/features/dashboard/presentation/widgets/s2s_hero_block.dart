// lib/features/dashboard/presentation/widgets/s2s_hero_block.dart
// UX-1.03 — S2S Hero Block
//
// The primary safe-to-spend hero display.
// DASH-011: Label above number. DASH-013: Hero number always inkPrimary.
// DASH-018: 200ms FadeTransition on load (respects disableAnimations).
// DASH-019: Tapping opens calculation trace.
// DASH-033: Never shows "Reserve Mode" — LedgerRail handles its own label text.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_motion.dart';
import 'package:helm/core/themes/helm_spacing.dart';
import 'package:helm/core/themes/helm_typography.dart';
import 'package:helm/core/widgets/cards/helm_hero_zone.dart';
import 'package:helm/core/widgets/helm_amount.dart';
import 'package:helm/core/widgets/helm_ledger_rail.dart';
import 'package:helm/core/widgets/helm_trust_strip.dart';
import 'package:helm/features/safe_to_spend/domain/entities/safe_to_spend_result.dart';

/// Derives the cashflow state from a [SafeToSpendResult].
LedgerState _ledgerState(SafeToSpendResult r) {
  if (r.rawSafeToSpend > 0) return LedgerState.safe;
  if (r.rawSafeToSpend > -r.anxietyBuffer) return LedgerState.tight;
  return LedgerState.atRisk;
}

/// The S2S hero block: label → amount → meaning line → ledger rail → trust strip.
///
/// Wraps everything in [HelmHeroZone] and applies a [FadeTransition] on load.
/// [onTapTrace] opens the calculation breakdown (DASH-019).
class S2sHeroBlock extends StatefulWidget {
  final SafeToSpendResult result;
  final DateTime updatedAt;

  /// Opens the calculation breakdown when tapped.
  final VoidCallback? onTapTrace;

  /// Quiet affirmation signal (facts only, no celebration).
  final String? affirmation;

  const S2sHeroBlock({
    super.key,
    required this.result,
    required this.updatedAt,
    this.onTapTrace,
    this.affirmation,
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
      duration: HelmMotion.s2sAppear,
    );
    _opacity = CurvedAnimation(
      parent: _controller,
      curve: HelmMotion.defaultCurve,
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
    final colors = context.colors;
    final typography = context.textStyles;

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
        const SizedBox(height: HelmSpacing.s1),

        // DASH-013: hero number color is always inkPrimary — HelmAmount handles
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
          HelmAmount(
            amount: widget.result.safeToSpend,
            size: AmountSize.hero,
          ),

        const SizedBox(height: HelmSpacing.s1),

        Text(
          'after fixed costs + safety buffer',
          style: typography.bodySm.copyWith(color: colors.inkSecondary),
        ),

        const SizedBox(height: HelmSpacing.s3),

        HelmLedgerRail(
          state: _ledgerState(widget.result),
          isHero: true,
        ),

        const SizedBox(height: HelmSpacing.s3),

        HelmTrustStrip(
          updatedAt: widget.updatedAt,
          sourceLabel: 'Received only',
          onTapAudit: widget.onTapTrace,
          affirmation: widget.affirmation,
        ),
      ],
    );

    return FadeTransition(
      opacity: _opacity,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onTapTrace?.call();
        },
        behavior: HitTestBehavior.opaque,
        child: HelmHeroZone(
          child: heroContent,
        ),
      ),
    );
  }
}
