// lib/core/widgets/shimmer/pocketa_shimmer.dart
// UX — Loading skeleton system using Pocketa design tokens

import 'package:flutter/material.dart';
import 'package:pocketa_v2/core/themes/pocketa_colors.dart';
import 'package:pocketa_v2/core/themes/pocketa_spacing.dart';

class PocketaShimmer extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const PocketaShimmer({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = PocketaSpacing.cardRadius,
  });

  @override
  State<PocketaShimmer> createState() => _PocketaShimmerState();
}

class _PocketaShimmerState extends State<PocketaShimmer>
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
    final colors = Theme.of(context).extension<PocketaColors>()!;

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
    final colors = Theme.of(context).extension<PocketaColors>()!;

    return Container(
      padding: padding ?? const EdgeInsets.all(PocketaSpacing.s4),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(PocketaSpacing.cardRadius),
        border: Border.all(color: colors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PocketaShimmer(height: 14, width: 120),
          const SizedBox(height: PocketaSpacing.s2),
          const PocketaShimmer(height: 24, width: 80),
          const SizedBox(height: PocketaSpacing.s3),
          const PocketaShimmer(height: 12),
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
        vertical: PocketaSpacing.s3,
        horizontal: PocketaSpacing.s4,
      ),
      child: Row(
        children: [
          PocketaShimmer(
            width: PocketaSpacing.iconLg,
            height: PocketaSpacing.iconLg,
            borderRadius: PocketaSpacing.s1,
          ),
          const SizedBox(width: PocketaSpacing.s3),
          const Expanded(
            child: PocketaShimmer(height: 14),
          ),
          const SizedBox(width: PocketaSpacing.s4),
          const PocketaShimmer(height: 14, width: 60),
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