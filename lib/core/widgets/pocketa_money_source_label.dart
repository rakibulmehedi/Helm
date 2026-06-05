// lib/core/widgets/pocketa_money_source_label.dart
// UX-3 — Core Display Widget: Payment source pill/chip label.

import 'package:flutter/material.dart';

import '../themes/pocketa_colors.dart';
import '../themes/pocketa_typography.dart';

class PocketaMoneySourceLabel extends StatelessWidget {
  const PocketaMoneySourceLabel({
    super.key,
    required this.source,
  });

  final String source;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<PocketaColors>()!;
    final typography = Theme.of(context).extension<PocketaTypography>()!;

    return Container(
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
    );
  }
}
