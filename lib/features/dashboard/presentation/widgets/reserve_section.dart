// lib/features/dashboard/presentation/widgets/reserve_section.dart
// UX-1.05 — Reserve Section
//
// Displays the anxiety buffer as protected money ("Reserve protected").
// Clean typography layout — no card wrapping.

import 'package:flutter/material.dart';

import 'package:pocketa_v2/core/themes/pocketa_colors.dart';
import 'package:pocketa_v2/core/themes/pocketa_spacing.dart';
import 'package:pocketa_v2/core/themes/pocketa_typography.dart';
import 'package:pocketa_v2/core/widgets/pocketa_amount.dart';
import 'package:pocketa_v2/features/safe_to_spend/domain/entities/safe_to_spend_result.dart';

/// Shows the "Reserve protected" section: anxiety buffer kept for peace of mind.
///
/// When [result.anxietyBuffer] is 0, renders a "No buffer set" message.
class ReserveSection extends StatelessWidget {
  final SafeToSpendResult result;

  const ReserveSection({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<PocketaColors>()!;
    final typography = Theme.of(context).extension<PocketaTypography>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Section header
        Text(
          'Safety buffer',
          style: typography.headingSm.copyWith(color: colors.inkPrimary),
        ),
        const SizedBox(height: PocketaSpacing.s1),

        // Sub-label
        Text(
          'Not locked — a safety margin inside the calculation',
          style: typography.bodySm.copyWith(color: colors.inkSecondary),
        ),

        const SizedBox(height: PocketaSpacing.s3),

        if (result.anxietyBuffer == 0)
          Text(
            'No safety buffer set. Safe-to-Spend uses your full liquid BDT.',
            style: typography.bodyMd.copyWith(color: colors.inkTertiary),
          )
        else
          PocketaAmount(
            amount: result.anxietyBuffer,
            size: AmountSize.lg,
          ),
      ],
    );
  }
}
