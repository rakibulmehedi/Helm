// lib/core/widgets/cards/pocketa_ledger_card.dart
// UX-5.10 — Five Card Widgets: PocketaLedgerCard
//
// Standard money fact card. The most common card type.
// Background: colors.surface, 1pt colors.divider border, 12pt radius.
// Supports optional title, trailing widget, and tap handling.

import 'package:flutter/material.dart';

import 'package:pocketa_v2/core/themes/pocketa_colors.dart';
import 'package:pocketa_v2/core/themes/pocketa_spacing.dart';
import 'package:pocketa_v2/core/themes/pocketa_typography.dart';

class PocketaLedgerCard extends StatelessWidget {
  final Widget child;
  final String? title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  const PocketaLedgerCard({
    super.key,
    required this.child,
    this.title,
    this.trailing,
    this.onTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<PocketaColors>()!;
    final typography = Theme.of(context).extension<PocketaTypography>()!;

    final resolvedPadding = padding ?? const EdgeInsets.all(PocketaSpacing.s4);
    final borderRadius = BorderRadius.circular(PocketaSpacing.cardRadius);

    Widget cardContent = Padding(
      padding: resolvedPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    title!,
                    style: typography.headingSm.copyWith(
                      color: colors.inkPrimary,
                    ),
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: PocketaSpacing.s2),
                  trailing!,
                ],
              ],
            ),
            const SizedBox(height: PocketaSpacing.s3),
          ],
          child,
        ],
      ),
    );

    Widget decorated = DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: borderRadius,
        border: Border.all(
          color: colors.divider,
          width: PocketaSpacing.cardBorder,
        ),
      ),
      child: cardContent,
    );

    if (onTap != null) {
      return Semantics(
        button: true,
        child: Material(
          color: Colors.transparent,
          borderRadius: borderRadius,
          child: InkWell(
            onTap: onTap,
            borderRadius: borderRadius,
            splashColor: colors.interactive.withValues(alpha: 0.06),
            highlightColor: colors.interactive.withValues(alpha: 0.04),
            child: decorated,
          ),
        ),
      );
    }

    return decorated;
  }
}
