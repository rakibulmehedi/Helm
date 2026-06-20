// lib/features/dashboard/presentation/widgets/committed_section.dart
// UX-1.04 — Committed Section
//
// Displays fixed costs due this month ("Already committed").
// Shows an empty state with a setup CTA when fixedCostsDue == 0.

import 'package:flutter/material.dart';

import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_spacing.dart';
import 'package:helm/core/themes/helm_typography.dart';
import 'package:helm/core/widgets/cards/helm_ledger_card.dart';
import 'package:helm/core/widgets/helm_amount.dart';
import 'package:helm/l10n/app_localization.dart';
import 'package:helm/features/safe_to_spend/domain/entities/safe_to_spend_result.dart';

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
    final colors = context.colors;
    final typography = context.textStyles;

    final Widget sectionContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Section header
        Text(
          context.l10n.fixedCostsSectionTitle,
          style: typography.headingSm.copyWith(color: colors.inkPrimary),
        ),
        const SizedBox(height: HelmSpacing.s1),

        // Sub-label
        Text(
          context.l10n.fixedCostsSectionSubtitle,
          style: typography.bodySm.copyWith(color: colors.inkSecondary),
        ),

        const SizedBox(height: HelmSpacing.s3),

        if (result.fixedCostsDue == 0) ...[
          Text(
            context.l10n.fixedCostsEmpty,
            style: typography.bodyMd.copyWith(color: colors.inkTertiary),
          ),
          if (onSetupFixedCosts != null) ...[
            const SizedBox(height: HelmSpacing.s2),
            GestureDetector(
              onTap: onSetupFixedCosts,
              child: Text(
                context.l10n.addFixedCostsLink,
                style: typography.bodySm.copyWith(color: colors.interactive),
              ),
            ),
          ],
        ] else
          HelmAmount(
            amount: result.fixedCostsDue,
            size: AmountSize.lg,
          ),
      ],
    );

    return HelmLedgerCard(
      child: sectionContent,
    );
  }
}
