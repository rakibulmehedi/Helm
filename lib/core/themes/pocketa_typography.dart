// lib/core/themes/pocketa_typography.dart
// UX-5.02 — Visual Identity: Typography Token Foundation
// Rules:
//   - NO italic anywhere
//   - NO fontWeight outside 400-600
//   - NO letterSpacing overrides (use default)
//   - Financial numerals: JetBrains Mono
//   - UI text (Latin): Inter
//   - Bangla text: Hind Siliguri

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pocketa_colors.dart';

class PocketaTypography extends ThemeExtension<PocketaTypography> {
  const PocketaTypography({
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
  // Factory — builds all styles against the active PocketaColors
  // Called once per ThemeData build, not per widget.
  // ---------------------------------------------------------------------------
  static PocketaTypography build(PocketaColors colors) {
    final ink = colors.inkPrimary;

    return PocketaTypography(
      // --- Latin UI (Inter) ---
      displayHero: GoogleFonts.inter(
        fontSize: 64,
        fontWeight: FontWeight.w600,
        height: 1.05,
        color: ink,
      ),
      displayLarge: GoogleFonts.inter(
        fontSize: 40,
        fontWeight: FontWeight.w600,
        height: 1.10,
        color: ink,
      ),
      headingLg: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: ink,
      ),
      headingMd: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.30,
        color: ink,
      ),
      headingSm: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: ink,
      ),
      bodyLg: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.50,
        color: ink,
      ),
      bodyMd: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.50,
        color: ink,
      ),
      bodySm: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: ink,
      ),
      labelMd: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.30,
        color: ink,
      ),
      labelSm: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.25,
        color: ink,
      ),

      // --- Monospace financial (JetBrains Mono) ---
      monoFinancialSm: GoogleFonts.jetBrainsMono(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.40,
        color: ink,
      ),
      monoFinancialMd: GoogleFonts.jetBrainsMono(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        height: 1.30,
        color: ink,
      ),
      monoFinancialLg: GoogleFonts.jetBrainsMono(
        fontSize: 40,
        fontWeight: FontWeight.w600,
        height: 1.10,
        color: ink,
      ),
      monoHero: GoogleFonts.jetBrainsMono(
        fontSize: 64,
        fontWeight: FontWeight.w600,
        height: 1.05,
        color: ink,
      ),

      // --- Bangla locale variants (Hind Siliguri) ---
      bodyLgBn: GoogleFonts.hindSiliguri(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.58,
        color: ink,
      ),
      bodyMdBn: GoogleFonts.hindSiliguri(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.58,
        color: ink,
      ),
      bodySmBn: GoogleFonts.hindSiliguri(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.52,
        color: ink,
      ),
      labelMdBn: GoogleFonts.hindSiliguri(
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
  PocketaTypography copyWith({
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
    return PocketaTypography(
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
  PocketaTypography lerp(ThemeExtension<PocketaTypography>? other, double t) {
    if (other is! PocketaTypography) return this;
    return PocketaTypography(
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
extension BuildContextPocketaTypography on BuildContext {
  PocketaTypography get textStyles => Theme.of(this).extension<PocketaTypography>()!;
}
