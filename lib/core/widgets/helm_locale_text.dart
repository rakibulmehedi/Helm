// lib/core/widgets/helm_locale_text.dart
// UX-5.07 — Locale-aware text widget for Bangla / Latin typography switching.
//
// Rules:
//   - Body and label tokens switch to Hind Siliguri when locale is 'bn'.
//   - Heading, display, and mono tokens are locale-invariant.
//   - Callers declare intent via [HelmTextToken] — no fuzzy font matching.

import 'package:flutter/material.dart';
import 'package:helm/core/themes/helm_typography.dart';

// ---------------------------------------------------------------------------
// Typography token enum
// ---------------------------------------------------------------------------

/// Declares which HelmTypography token to use for a piece of text.
///
/// When the active locale is 'bn', [bodyLg], [bodyMd], [bodySm], and [labelMd]
/// are automatically mapped to their Hind Siliguri equivalents. All other
/// tokens are locale-invariant.
///
/// Usage:
/// ```dart
/// HelmLocaleText('Hello world', token: HelmTextToken.bodyMd)
/// ```
enum HelmTextToken {
  // --- Locale-switching tokens (Inter ↔ Hind Siliguri) ---
  bodyLg,
  bodyMd,
  bodySm,
  labelMd,

  // --- Locale-invariant tokens (always Inter) ---
  displayHero,
  displayLarge,
  headingLg,
  headingMd,
  headingSm,
  labelSm,

  // --- Locale-invariant tokens (always JetBrains Mono) ---
  monoFinancialSm,
  monoFinancialMd,
  monoFinancialLg,
  monoHero,
}

// ---------------------------------------------------------------------------
// HelmLocaleText widget
// ---------------------------------------------------------------------------

/// Text widget that auto-selects Bangla or Latin typography based on locale.
///
/// Pass the desired typography token via [token]. When the active locale
/// is 'bn', body and label tokens automatically switch to their Hind Siliguri
/// equivalents. Heading, display, and mono tokens are unaffected.
///
/// Use [colorOverride] to tint the text (e.g. for secondary or error colours)
/// without needing to reconstruct the full TextStyle.
///
/// Example:
/// ```dart
/// HelmLocaleText(
///   'Available balance',
///   token: HelmTextToken.bodyMd,
///   textAlign: TextAlign.center,
/// )
/// ```
class HelmLocaleText extends StatelessWidget {
  const HelmLocaleText(
    this.text, {
    super.key,
    required this.token,
    this.colorOverride,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
  });

  final String text;

  /// The typography token that drives font selection and sizing.
  final HelmTextToken token;

  /// Optional colour override. When null the token's default ink colour is used.
  final Color? colorOverride;

  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isBangla = locale.languageCode == 'bn';

    final typo = context.textStyles;
    TextStyle resolved = _resolveStyle(typo, isBangla);

    if (colorOverride != null) {
      resolved = resolved.copyWith(color: colorOverride);
    }

    return Text(
      text,
      style: resolved,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }

  // ---------------------------------------------------------------------------
  // Token → TextStyle resolution
  // ---------------------------------------------------------------------------

  TextStyle _resolveStyle(HelmTypography typo, bool isBangla) {
    switch (token) {
      // Locale-switching: body & label
      case HelmTextToken.bodyLg:
        return isBangla ? typo.bodyLgBn : typo.bodyLg;
      case HelmTextToken.bodyMd:
        return isBangla ? typo.bodyMdBn : typo.bodyMd;
      case HelmTextToken.bodySm:
        return isBangla ? typo.bodySmBn : typo.bodySm;
      case HelmTextToken.labelMd:
        return isBangla ? typo.labelMdBn : typo.labelMd;

      // Locale-invariant: display & heading (always Inter)
      case HelmTextToken.displayHero:
        return typo.displayHero;
      case HelmTextToken.displayLarge:
        return typo.displayLarge;
      case HelmTextToken.headingLg:
        return typo.headingLg;
      case HelmTextToken.headingMd:
        return typo.headingMd;
      case HelmTextToken.headingSm:
        return typo.headingSm;
      case HelmTextToken.labelSm:
        return typo.labelSm;

      // Locale-invariant: mono financial (always JetBrains Mono)
      case HelmTextToken.monoFinancialSm:
        return typo.monoFinancialSm;
      case HelmTextToken.monoFinancialMd:
        return typo.monoFinancialMd;
      case HelmTextToken.monoFinancialLg:
        return typo.monoFinancialLg;
      case HelmTextToken.monoHero:
        return typo.monoHero;
    }
  }
}
