// lib/features/dashboard/presentation/widgets/committed_section.dart
// UX-1.04 — Committed Section
//
// Displays fixed costs due this month ("Already committed").
// Shows an empty state with a setup CTA when fixedCostsDue == 0.

import 'package:flutter/material.dart';

import 'package:pocketa_v2/core/themes/pocketa_colors.dart';
import 'package:pocketa_v2/core/themes/pocketa_spacing.dart';
import 'package:pocketa_v2/core/themes/pocketa_typography.dart';
import 'package:pocketa_v2/core/widgets/cards/pocketa_ledger_card.dart';
import 'package:pocketa_v2/core/widgets/pocketa_amount.dart';
import 'package:pocketa_v2/features/safe_to_spend/domain/entities/safe_to_spend_result.dart';

/// Shows the "Already committed" section: fixed costs due this month.
///
/// When [result.fixedCostsDue] is 0, renders an empty state with an optional
/// [onSetupFixedCosts] CTA link.
class CommittedSection extends StatelessWidget {
  final SafeToSpendResult result;

  /// Called when the user taps the "Set up fixed costs" action.
  final VoidCallback? onSetupFixedCosts;

  const CommittedSection({
    super.key,
    required this.result,
    this.onSetupFixedCosts,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<PocketaColors>()!;
    final typography = Theme.of(context).extension<PocketaTypography>()!;

    final Widget sectionContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Section header
        Text(
          'Fixed costs',
          style: typography.headingSm.copyWith(color: colors.inkPrimary),
        ),
        const SizedBox(height: PocketaSpacing.s1),

        // Sub-label
        Text(
          'Monthly costs due in the next 30 days',
          style: typography.bodySm.copyWith(color: colors.inkSecondary),
        ),

        const SizedBox(height: PocketaSpacing.s3),

        if (result.fixedCostsDue == 0) ...[
          Text(
            'No fixed costs added yet. Add them to improve Safe-to-Spend accuracy.',
            style: typography.bodyMd.copyWith(color: colors.inkTertiary),
          ),
          if (onSetupFixedCosts != null) ...[
            const SizedBox(height: PocketaSpacing.s2),
            GestureDetector(
              onTap: onSetupFixedCosts,
              child: Text(
                'Add fixed costs \u2192',
                style: typography.bodySm.copyWith(color: colors.interactive),
              ),
            ),
          ],
        ] else
          PocketaAmount(
            amount: result.fixedCostsDue,
            size: AmountSize.lg,
          ),
      ],
    );

    return PocketaLedgerCard(
      child: sectionContent,
    );
  }
}
