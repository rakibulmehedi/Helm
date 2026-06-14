// lib/features/dashboard/presentation/widgets/not_counted_section.dart
// UX-1.06 — Not Counted Section
//
// Pipeline summary: "Not counted yet".
// CRITICAL UX rules:
//   - MUST be labeled "Not counted yet" — never "Pending income" or "Expected income".
//   - ALL HelmAmount widgets use dimmed: true (hope tier = lower confidence).
//   - Section header uses inkSecondary (NOT inkPrimary) to signal lower prominence.
//   - Must never visually equal usable BDT (stays visually subordinate to S2S).

import 'package:flutter/material.dart';

import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_spacing.dart';
import 'package:helm/core/themes/helm_typography.dart';
import 'package:helm/core/widgets/helm_amount.dart';
import 'package:helm/features/safe_to_spend/domain/entities/safe_to_spend_result.dart';

/// Shows the "Not counted yet" pipeline section.
///
/// Displays [result.pendingIncome] and [result.expectedIncome] with [dimmed: true]
/// to signal these are hope-tier, lower-confidence values.
///
/// When both are 0, shows an empty state with an optional [onAddPipelineEntry] CTA.
class NotCountedSection extends StatelessWidget {
  final SafeToSpendResult result;

  /// Called when the user taps the "Add your first expected payment" action.
  final VoidCallback? onAddPipelineEntry;

  const NotCountedSection({
    super.key,
    required this.result,
    this.onAddPipelineEntry,
  });

  bool get _isEmpty =>
      result.pendingIncome == 0 && result.expectedIncome == 0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<HelmColors>()!;
    final typography = Theme.of(context).extension<HelmTypography>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Section header — inkSecondary (lower prominence vs S2S hero).
        Text(
          'Not counted yet',
          style: typography.headingSm.copyWith(color: colors.inkSecondary),
        ),
        const SizedBox(height: HelmSpacing.s1),

        // Sub-label
        Text(
          'Not counted yet — expected payments',
          style: typography.bodySm.copyWith(color: colors.inkTertiary),
        ),

        const SizedBox(height: HelmSpacing.s3),

        if (_isEmpty) ...[
          Text(
            'Add an expected payment when you invoice or expect money.',
            style: typography.bodySm.copyWith(color: colors.inkTertiary),
          ),
          if (onAddPipelineEntry != null) ...[
            const SizedBox(height: HelmSpacing.s2),
            GestureDetector(
              onTap: onAddPipelineEntry,
              child: Text(
                'Add expected payment \u2192',
                style: typography.bodySm.copyWith(color: colors.interactive),
              ),
            ),
          ],
        ] else ...[
          // Pending income row
          if (result.pendingIncome > 0) ...[
            Text(
              'Pending',
              style: typography.labelSm.copyWith(color: colors.inkSecondary),
            ),
            const SizedBox(height: HelmSpacing.s1),
            HelmAmount(
              amount: result.pendingIncome,
              size: AmountSize.md,
              dimmed: true,
            ),
            const SizedBox(height: HelmSpacing.s3),
          ],

          // Expected income row
          if (result.expectedIncome > 0) ...[
            Text(
              'Expected',
              style: typography.labelSm.copyWith(color: colors.inkSecondary),
            ),
            const SizedBox(height: HelmSpacing.s1),
            HelmAmount(
              amount: result.expectedIncome,
              size: AmountSize.md,
              dimmed: true,
            ),
          ],

          // Horizon number row — below a hairline divider.
          if (result.horizonNumber > 0) ...[
            const SizedBox(height: HelmSpacing.s3),
            Divider(
              color: colors.hairline,
              thickness: 1,
              height: 1,
            ),
            const SizedBox(height: HelmSpacing.s3),
            Text(
              'If all counted:',
              style: typography.bodySm.copyWith(color: colors.inkTertiary),
            ),
            const SizedBox(height: HelmSpacing.s1),
            HelmAmount(
              amount: result.horizonNumber,
              size: AmountSize.md,
              dimmed: true,
            ),
          ],
        ],
      ],
    );
  }
}
