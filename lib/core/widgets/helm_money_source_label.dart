// lib/core/widgets/helm_money_source_label.dart
// UX-3 — Core Display Widget: Payment source pill/chip label.

import 'package:flutter/material.dart';

import '../themes/helm_colors.dart';
import '../themes/helm_typography.dart';

class HelmMoneySourceLabel extends StatelessWidget {
  const HelmMoneySourceLabel({
    super.key,
    required this.source,
  });

  final String source;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.textStyles;

    return Semantics(
      label: 'Payment source: $source',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: colors.interactive.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          source,
          style: typography.labelSm.copyWith(color: colors.interactive),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
