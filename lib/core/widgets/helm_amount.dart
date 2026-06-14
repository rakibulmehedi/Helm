// lib/core/widgets/helm_amount.dart
// UX-5.06 — Financial Amount Display Widget
//
// Renders monetary amounts using JetBrains Mono via HelmTypography tokens.
// Always use NumberFormatter for locale-correct BDT/USD formatting.

import 'package:flutter/material.dart';

import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_typography.dart';
import 'package:helm/core/utils/number_formatter.dart';

/// Which currency to display.
enum AmountCurrency { bdt, usd }

/// Display size for the amount, mapping to HelmTypography monospace tokens.
enum AmountSize {
  /// monoFinancialSm — small supplementary amounts
  sm,

  /// monoFinancialMd — standard card amounts
  md,

  /// monoFinancialLg — prominent section amounts
  lg,

  /// displayHero — S2S hero number (64pt)
  hero,
}

/// Displays a financial amount using Helm's monospace type system.
///
/// - BDT amounts use lakh/crore grouping via [NumberFormatter.formatBDT].
/// - USD amounts use Western grouping via [NumberFormatter.formatUSD].
/// - [dimmed] reduces emphasis to [HelmColors.inkTertiary] (used for hope tier).
/// - [semanticLabel] overrides the accessibility label when provided.
class HelmAmount extends StatelessWidget {
  final double amount;
  final AmountCurrency currency;
  final AmountSize size;

  /// When true, renders in inkTertiary to signal a lower-confidence / hope-tier value.
  final bool dimmed;

  /// Optional override for the Semantics label. When null, the formatted string is used.
  final String? semanticLabel;

  const HelmAmount({
    super.key,
    required this.amount,
    this.currency = AmountCurrency.bdt,
    this.size = AmountSize.md,
    this.dimmed = false,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<HelmColors>()!;
    final typography = Theme.of(context).extension<HelmTypography>()!;

    final String displayText = _formattedAmount();
    final Color textColor = dimmed ? colors.inkTertiary : colors.inkPrimary;
    final TextStyle style = _resolveStyle(typography).copyWith(color: textColor);

    return Semantics(
      label: semanticLabel ?? displayText,
      child: Text(
        displayText,
        style: style,
        textScaler: TextScaler.noScaling, // financial figures must not reflow
      ),
    );
  }

  String _formattedAmount() {
    switch (currency) {
      case AmountCurrency.bdt:
        return NumberFormatter.formatBDT(amount);
      case AmountCurrency.usd:
        return NumberFormatter.formatUSD(amount);
    }
  }

  TextStyle _resolveStyle(HelmTypography typography) {
    switch (size) {
      case AmountSize.sm:
        return typography.monoFinancialSm;
      case AmountSize.md:
        return typography.monoFinancialMd;
      case AmountSize.lg:
        return typography.monoFinancialLg;
      case AmountSize.hero:
        return typography.displayHero;
    }
  }
}
