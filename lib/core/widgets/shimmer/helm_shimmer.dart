// lib/core/widgets/shimmer/helm_shimmer.dart
// UX — Loading skeleton system using Helm design tokens

import 'package:flutter/material.dart';
import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_spacing.dart';

class HelmShimmer extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const HelmShimmer({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = HelmSpacing.cardRadius,
  });

  @override
  State<HelmShimmer> createState() => _HelmShimmerState();
}

class _HelmShimmerState extends State<HelmShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + _animation.value, 0),
              end: Alignment(_animation.value, 0),
              colors: [
                colors.hairline,
                colors.hairline.withValues(alpha: 0.4),
                colors.hairline,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Shimmer variants for common card patterns
// ---------------------------------------------------------------------------

class ShimmerCard extends StatelessWidget {
  final EdgeInsetsGeometry? padding;

  const ShimmerCard({super.key, this.padding});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: padding ?? const EdgeInsets.all(HelmSpacing.s4),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(HelmSpacing.cardRadius),
        border: Border.all(color: colors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HelmShimmer(height: 14, width: 120),
          const SizedBox(height: HelmSpacing.s2),
          const HelmShimmer(height: 24, width: 80),
          const SizedBox(height: HelmSpacing.s3),
          const HelmShimmer(height: 12),
        ],
      ),
    );
  }
}

class ShimmerLedgerRow extends StatelessWidget {
  const ShimmerLedgerRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: HelmSpacing.s3,
        horizontal: HelmSpacing.s4,
      ),
      child: Row(
        children: [
          HelmShimmer(
            width: HelmSpacing.iconLg,
            height: HelmSpacing.iconLg,
            borderRadius: HelmSpacing.s1,
          ),
          const SizedBox(width: HelmSpacing.s3),
          const Expanded(
            child: HelmShimmer(height: 14),
          ),
          const SizedBox(width: HelmSpacing.s4),
          const HelmShimmer(height: 14, width: 60),
        ],
      ),
    );
  }
}

class ShimmerAuditRows extends StatelessWidget {
  final int count;

  const ShimmerAuditRows({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(count, (_) => const ShimmerLedgerRow()),
    );
  }
}