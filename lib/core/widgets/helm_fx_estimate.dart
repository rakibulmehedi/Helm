// lib/core/widgets/helm_fx_estimate.dart
// UX-3 — Core Display Widget: Dual-currency FX estimate row.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../themes/helm_colors.dart';
import '../themes/helm_typography.dart';

class HelmFxEstimate extends StatelessWidget {
  const HelmFxEstimate({
    super.key,
    required this.usdAmount,
    this.fxRate,
  });

  final double usdAmount;
  final double? fxRate;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.textStyles;

    final usdFormatted = '\$${usdAmount.toStringAsFixed(2)}';

    final String bdtText;
    if (fxRate != null) {
      final bdt = usdAmount * fxRate!;
      final bdtFormatted =
          NumberFormat('#,##0', 'en_US').format(bdt.round());
      final rateFormatted = fxRate!.toStringAsFixed(1);
      bdtText = '~৳$bdtFormatted at $rateFormatted';
    } else {
      bdtText = 'FX rate not set';
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          usdFormatted,
          style: typography.monoFinancialMd.copyWith(color: colors.inkPrimary),
        ),
        const Spacer(),
        Text(
          bdtText,
          style: typography.bodySm.copyWith(color: colors.inkSecondary),
        ),
      ],
    );
  }
}
