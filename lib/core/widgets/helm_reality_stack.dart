// lib/core/widgets/helm_reality_stack.dart
// UX-1.01 — Reality Stack: 4-tier home screen layout scaffold.
//
// A scrollable-column widget that structures home screen content into
// 4 named tiers. Caller wraps in a scroll view; this widget is layout only.

import 'package:flutter/material.dart';

import 'package:helm/core/themes/helm_spacing.dart';

/// Structures the home screen into 4 named tiers with fixed inter-tier spacing.
///
/// Tier order (top to bottom):
/// 1. [heroTier]        — S2S answer + trust strip
/// 2. [pressureTier]    — Already committed + reserve
/// 3. [maintenanceTier] — Conditional action strip (hidden when null)
/// 4. [hopeTier]        — Not counted yet (hope / horizon)
///
/// This widget is NOT a scroll view. Wrap it in a [SingleChildScrollView]
/// or [CustomScrollView] sliver at the call site.
class HelmRealityStack extends StatelessWidget {
  /// S2S answer tier — top of screen.
  final Widget heroTier;

  /// Already committed + reserve tier.
  final Widget pressureTier;

  /// Optional conditional action strip. Hidden (collapsed) when null.
  final Widget? maintenanceTier;

  /// Pipeline / hope tier — not counted in Safe-to-Spend.
  final Widget hopeTier;

  /// Defaults to symmetric horizontal padding of [HelmSpacing.screenEdge].
  final EdgeInsetsGeometry? padding;

  const HelmRealityStack({
    super.key,
    required this.heroTier,
    required this.pressureTier,
    this.maintenanceTier,
    required this.hopeTier,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding ??
        const EdgeInsets.symmetric(horizontal: HelmSpacing.screenEdge);

    return Padding(
      padding: effectivePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tier 1 — Hero
          heroTier,

          // Gap: hero → pressure
          const SizedBox(height: HelmSpacing.s6),

          // Tier 2 — Pressure
          pressureTier,

          // Tier 3 — Maintenance (conditional)
          if (maintenanceTier != null) ...[
            const SizedBox(height: HelmSpacing.s4),
            maintenanceTier!,
          ],

          // Gap: maintenance/pressure → hope
          const SizedBox(height: HelmSpacing.s6),

          // Tier 4 — Hope
          hopeTier,
        ],
      ),
    );
  }
}
