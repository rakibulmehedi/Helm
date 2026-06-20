// lib/core/themes/helm_typography.dart
// UX-5.02 — Visual Identity: Typography Token Foundation
// Rules:
//   - NO italic anywhere
//   - NO fontWeight outside 400-600
//   - NO letterSpacing overrides (use default)
//   - Financial numerals: JetBrains Mono
//   - Display + heading (Latin): Fraunces
//   - UI text (Latin): Inter
//   - Bangla text: Hind Siliguri
//   - All fonts are bundled as assets — no runtime downloads.

import 'package:flutter/material.dart';

import 'helm_colors.dart';

class HelmTypography extends ThemeExtension<HelmTypography> {
  const HelmTypography({
    required this.displayHero,
    required this.displayLarge,
    required this.headingLg,
    required this.headingMd,
    required this.headingSm,
    required this.bodyLg,
    required this.bodyMd,
    required this.bodySm,
    required this.labelMd,
    required this.labelSm,
    required this.monoFinancialSm,
    required this.monoFinancialMd,
    required this.monoFinancialLg,
    required this.monoHero,
    required this.bodyLgBn,
    required this.bodyMdBn,
    required this.bodySmBn,
    required this.labelMdBn,
  });

  // Latin / general UI scale
  final TextStyle displayHero;      // size 64, w600, h1.05 — S2S hero number ONLY
  final TextStyle displayLarge;     // size 40, w600, h1.10 — breakdown totals, onboarding headlines
  final TextStyle headingLg;        // size 22, w600, h1.25 — screen titles
  final TextStyle headingMd;        // size 18, w600, h1.30 — section headers, sheet titles
  final TextStyle headingSm;        // size 15, w600, h1.35 — card titles, list group headers
  final TextStyle bodyLg;           // size 16, w400, h1.50 — default reading text
  final TextStyle bodyMd;           // size 14, w400, h1.50 — secondary body
  final TextStyle bodySm;           // size 13, w400, h1.45 — helper text, captions
  final TextStyle labelMd;          // size 12, w500, h1.30 — form labels
  final TextStyle labelSm;          // size 11, w500, h1.25 — timestamps, tier markers

  // Monospace financial — JetBrains Mono
  final TextStyle monoFinancialSm;  // size 16, w500, h1.40
  final TextStyle monoFinancialMd;  // size 24, w500, h1.30
  final TextStyle monoFinancialLg;  // size 40, w600, h1.10
  final TextStyle monoHero;         // size 64, w600, h1.05

  // Bangla locale variants — Hind Siliguri
  final TextStyle bodyLgBn;         // size 16, w400, h1.58
  final TextStyle bodyMdBn;         // size 14, w400, h1.58
  final TextStyle bodySmBn;         // size 13, w400, h1.52
  final TextStyle labelMdBn;        // size 12, w500, h1.38

  // ---------------------------------------------------------------------------
  // Factory — builds all styles against the active HelmColors
  // Called once per ThemeData build, not per widget.
  // ---------------------------------------------------------------------------
  static HelmTypography build(HelmColors colors) {
    final ink = colors.inkPrimary;

    return HelmTypography(
      // --- Latin UI (Inter) ---
      displayHero: TextStyle(
        fontFamily: 'Fraunces',
        fontSize: 64,
        fontWeight: FontWeight.w600,
        height: 1.05,
        color: ink,
      ),
      displayLarge: TextStyle(
        fontFamily: 'Fraunces',
        fontSize: 40,
        fontWeight: FontWeight.w600,
        height: 1.10,
        color: ink,
      ),
      headingLg: TextStyle(
        fontFamily: 'Fraunces',
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: ink,
      ),
      headingMd: TextStyle(
        fontFamily: 'Fraunces',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.30,
        color: ink,
      ),
      headingSm: TextStyle(
        fontFamily: 'Fraunces',
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: ink,
      ),
      bodyLg: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.50,
        color: ink,
      ),
      bodyMd: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.50,
        color: ink,
      ),
      bodySm: TextStyle(
        fontFamily: 'Inter',
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: ink,
      ),
      labelMd: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.30,
        color: ink,
      ),
      labelSm: TextStyle(
        fontFamily: 'Inter',
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.25,
        color: ink,
      ),

      // --- Monospace financial (JetBrains Mono) ---
      monoFinancialSm: TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.40,
        color: ink,
      ),
      monoFinancialMd: TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: 24,
        fontWeight: FontWeight.w500,
        height: 1.30,
        color: ink,
      ),
      monoFinancialLg: TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: 40,
        fontWeight: FontWeight.w600,
        height: 1.10,
        color: ink,
      ),
      monoHero: TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: 64,
        fontWeight: FontWeight.w600,
        height: 1.05,
        color: ink,
      ),

      // --- Bangla locale variants (Hind Siliguri) ---
      bodyLgBn: TextStyle(
        fontFamily: 'HindSiliguri',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.58,
        color: ink,
      ),
      bodyMdBn: TextStyle(
        fontFamily: 'HindSiliguri',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.58,
        color: ink,
      ),
      bodySmBn: TextStyle(
        fontFamily: 'HindSiliguri',
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.52,
        color: ink,
      ),
      labelMdBn: TextStyle(
        fontFamily: 'HindSiliguri',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.38,
        color: ink,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ThemeExtension contract
  // ---------------------------------------------------------------------------
  @override
  HelmTypography copyWith({
    TextStyle? displayHero,
    TextStyle? displayLarge,
    TextStyle? headingLg,
    TextStyle? headingMd,
    TextStyle? headingSm,
    TextStyle? bodyLg,
    TextStyle? bodyMd,
    TextStyle? bodySm,
    TextStyle? labelMd,
    TextStyle? labelSm,
    TextStyle? monoFinancialSm,
    TextStyle? monoFinancialMd,
    TextStyle? monoFinancialLg,
    TextStyle? monoHero,
    TextStyle? bodyLgBn,
    TextStyle? bodyMdBn,
    TextStyle? bodySmBn,
    TextStyle? labelMdBn,
  }) {
    return HelmTypography(
      displayHero:     displayHero     ?? this.displayHero,
      displayLarge:    displayLarge    ?? this.displayLarge,
      headingLg:       headingLg       ?? this.headingLg,
      headingMd:       headingMd       ?? this.headingMd,
      headingSm:       headingSm       ?? this.headingSm,
      bodyLg:          bodyLg          ?? this.bodyLg,
      bodyMd:          bodyMd          ?? this.bodyMd,
      bodySm:          bodySm          ?? this.bodySm,
      labelMd:         labelMd         ?? this.labelMd,
      labelSm:         labelSm         ?? this.labelSm,
      monoFinancialSm: monoFinancialSm ?? this.monoFinancialSm,
      monoFinancialMd: monoFinancialMd ?? this.monoFinancialMd,
      monoFinancialLg: monoFinancialLg ?? this.monoFinancialLg,
      monoHero:        monoHero        ?? this.monoHero,
      bodyLgBn:        bodyLgBn        ?? this.bodyLgBn,
      bodyMdBn:        bodyMdBn        ?? this.bodyMdBn,
      bodySmBn:        bodySmBn        ?? this.bodySmBn,
      labelMdBn:       labelMdBn       ?? this.labelMdBn,
    );
  }

  @override
  HelmTypography lerp(ThemeExtension<HelmTypography>? other, double t) {
    if (other is! HelmTypography) return this;
    return HelmTypography(
      displayHero:     TextStyle.lerp(displayHero,     other.displayHero,     t)!,
      displayLarge:    TextStyle.lerp(displayLarge,    other.displayLarge,    t)!,
      headingLg:       TextStyle.lerp(headingLg,       other.headingLg,       t)!,
      headingMd:       TextStyle.lerp(headingMd,       other.headingMd,       t)!,
      headingSm:       TextStyle.lerp(headingSm,       other.headingSm,       t)!,
      bodyLg:          TextStyle.lerp(bodyLg,          other.bodyLg,          t)!,
      bodyMd:          TextStyle.lerp(bodyMd,          other.bodyMd,          t)!,
      bodySm:          TextStyle.lerp(bodySm,          other.bodySm,          t)!,
      labelMd:         TextStyle.lerp(labelMd,         other.labelMd,         t)!,
      labelSm:         TextStyle.lerp(labelSm,         other.labelSm,         t)!,
      monoFinancialSm: TextStyle.lerp(monoFinancialSm, other.monoFinancialSm, t)!,
      monoFinancialMd: TextStyle.lerp(monoFinancialMd, other.monoFinancialMd, t)!,
      monoFinancialLg: TextStyle.lerp(monoFinancialLg, other.monoFinancialLg, t)!,
      monoHero:        TextStyle.lerp(monoHero,        other.monoHero,        t)!,
      bodyLgBn:        TextStyle.lerp(bodyLgBn,        other.bodyLgBn,        t)!,
      bodyMdBn:        TextStyle.lerp(bodyMdBn,        other.bodyMdBn,        t)!,
      bodySmBn:        TextStyle.lerp(bodySmBn,        other.bodySmBn,        t)!,
      labelMdBn:       TextStyle.lerp(labelMdBn,       other.labelMdBn,       t)!,
    );
  }
}

// ---------------------------------------------------------------------------
// BuildContext extension — access typography without boilerplate
// ---------------------------------------------------------------------------
extension BuildContextHelmTypography on BuildContext {
  HelmTypography get textStyles {
    final theme = Theme.of(this);
    return theme.extension<HelmTypography>() ??
        HelmTypography.build(
          theme.extension<HelmColors>() ??
              (theme.brightness == Brightness.dark
                  ? HelmColors.dark
                  : HelmColors.light),
        );
  }
}
