// lib/core/widgets/cards/pocketa_audit_card.dart
// UX-5.10 — Five Card Widgets: PocketaAuditCard
//
// Calculation trace card. Values right-aligned, ledger style.
// Labels left-aligned in bodyMd, values right-aligned in monoFinancialSm.
// Final row uses stronger divider above + weight 600 on label and value.
// Subtraction rows format value as "(tk X)" in inkSecondary.

import 'package:flutter/material.dart';

import 'package:pocketa_v2/core/themes/pocketa_colors.dart';
import 'package:pocketa_v2/core/themes/pocketa_spacing.dart';
import 'package:pocketa_v2/core/themes/pocketa_typography.dart';

class AuditRow {
  final String label;
  final String value;
  final bool isSubtraction;
  final bool isFinal;
  final Color? valueColor;

  const AuditRow({
    required this.label,
    required this.value,
    this.isSubtraction = false,
    this.isFinal = false,
    this.valueColor,
  });
}

class PocketaAuditCard extends StatelessWidget {
  final List<AuditRow> rows;
  final String? title;

  const PocketaAuditCard({
    super.key,
    required this.rows,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<PocketaColors>()!;
    final typography = Theme.of(context).extension<PocketaTypography>()!;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(PocketaSpacing.cardRadius),
        border: Border.all(
          color: colors.divider,
          width: PocketaSpacing.cardBorder,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(PocketaSpacing.s4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: typography.headingSm.copyWith(
                  color: colors.inkPrimary,
                ),
              ),
              const SizedBox(height: PocketaSpacing.s3),
              Divider(
                color: colors.divider,
                height: 1,
                thickness: 1,
              ),
              const SizedBox(height: PocketaSpacing.s3),
            ],
            ...List.generate(rows.length, (index) {
              final row = rows[index];
              final isFirst = index == 0;
              final isLast = index == rows.length - 1;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Divider above — stronger for final row, hairline for regular
                  if (!isFirst) ...[
                    Divider(
                      color: row.isFinal ? colors.divider : colors.hairline,
                      height: 1,
                      thickness: 1,
                    ),
                    SizedBox(
                      height: row.isFinal
                          ? PocketaSpacing.s3
                          : PocketaSpacing.s2,
                    ),
                  ],

                  _AuditRowWidget(
                    row: row,
                    colors: colors,
                    typography: typography,
                  ),

                  // Bottom spacing (except after last row)
                  if (!isLast)
                    SizedBox(
                      height: row.isFinal
                          ? PocketaSpacing.s3
                          : PocketaSpacing.s2,
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _AuditRowWidget extends StatelessWidget {
  final AuditRow row;
  final PocketaColors colors;
  final PocketaTypography typography;

  const _AuditRowWidget({
    required this.row,
    required this.colors,
    required this.typography,
  });

  @override
  Widget build(BuildContext context) {
    final labelStyle = row.isFinal
        ? typography.bodyMd.copyWith(
            color: colors.inkPrimary,
            fontWeight: FontWeight.w600,
          )
        : typography.bodyMd.copyWith(color: colors.inkPrimary);

    final String displayValue =
        row.isSubtraction ? '(${row.value})' : row.value;

    Color resolvedValueColor;
    if (row.valueColor != null) {
      resolvedValueColor = row.valueColor!;
    } else if (row.isSubtraction) {
      resolvedValueColor = colors.inkSecondary;
    } else {
      resolvedValueColor = colors.inkPrimary;
    }

    final valueStyle = row.isFinal
        ? typography.monoFinancialSm.copyWith(
            color: resolvedValueColor,
            fontWeight: FontWeight.w600,
          )
        : typography.monoFinancialSm.copyWith(color: resolvedValueColor);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            row.label,
            style: labelStyle,
          ),
        ),
        const SizedBox(width: PocketaSpacing.s3),
        Text(
          displayValue,
          style: valueStyle,
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}
