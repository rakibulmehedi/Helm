// lib/core/widgets/ledger/helm_ledger_row.dart
// Paper Ledger — a single committed/reserve/pending row.
// Label (Inter) on the left, money figure (mono, Latin numerals) on the right,
// optional hairline divider beneath.

import 'package:flutter/material.dart';

import '../../themes/helm_colors.dart';
import '../../themes/helm_spacing.dart';
import '../../themes/helm_typography.dart';

class HelmLedgerRow extends StatelessWidget {
  const HelmLedgerRow({
    required this.label,
    required this.value,
    this.muted = false,
    this.showDivider = true,
    super.key,
  });

  final String label;
  final String value;
  final bool muted;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.textStyles;
    final valueColor = muted ? colors.inkTertiary : colors.inkPrimary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: HelmSpacing.s3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: typography.bodySm.copyWith(color: colors.inkSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: HelmSpacing.s3),
              Text(
                value,
                style: typography.monoFinancialSm.copyWith(color: valueColor),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(height: 1, thickness: 1, color: colors.hairline),
      ],
    );
  }
}
