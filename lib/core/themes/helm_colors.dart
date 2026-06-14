// lib/core/themes/helm_colors.dart
// UX-5.01 — Visual Identity: Color Token Foundation
// DO NOT use withOpacity() for text colors — all text colors are solid pre-resolved hex.
// withValues(alpha:) is reserved for DECORATIVE elements only (rails, dots).

import 'package:flutter/material.dart';

class HelmColors extends ThemeExtension<HelmColors> {
  const HelmColors({
    required this.canvas,
    required this.surface,
    required this.inkPrimary,
    required this.inkSecondary,
    required this.inkTertiary,
    required this.interactive,
    required this.divider,
    required this.hairline,
    required this.stateSafe,
    required this.stateTight,
    required this.stateAtRisk,
    required this.stateHope,
    required this.stateHopeMuted,
  });

  final Color canvas;
  final Color surface;
  final Color inkPrimary;
  final Color inkSecondary;
  final Color inkTertiary;
  final Color interactive;
  final Color divider;
  final Color hairline;
  final Color stateSafe;
  final Color stateTight;
  final Color stateAtRisk;
  final Color stateHope;
  final Color stateHopeMuted;

  // ---------------------------------------------------------------------------
  // Light mode — REFINED system values (doc 08 overrides 07)
  // All text colors are solid pre-resolved hex (no alpha for text).
  // ---------------------------------------------------------------------------
  static const HelmColors light = HelmColors(
    canvas:         Color(0xFFFAFAF6), // warm white background
    surface:        Color(0xFFFFFFFC), // card surfaces (warmer than pure white)
    inkPrimary:     Color(0xFF141413), // all numbers, critical text — 14.8:1 AAA
    inkSecondary:   Color(0xFF3B3A36), // solid equivalent of 60% — labels, timestamps
    inkTertiary:    Color(0xFF6A6760), // solid equivalent of 38% — helper text
    interactive:    Color(0xFF255E5B), // deep teal — every tappable affordance
    divider:        Color(0xFFD8D3C8), // card borders (~12% equivalent)
    hairline:       Color(0xFFE9E5DB), // internal dividers (~8% equivalent)
    stateSafe:      Color(0xFF3D6B3C), // WCAG AA 4.7:1 on #FAFAF6
    stateTight:     Color(0xFF8B6500), // WCAG AA 4.6:1 on #FAFAF6
    stateAtRisk:    Color(0xFF984635), // slightly deeper brick red
    stateHope:      Color(0xFF5A7585), // solid for text (not alpha)
    stateHopeMuted: Color(0xFF9BAAB2), // decorative — expected dots, low-emphasis markers
  );

  // ---------------------------------------------------------------------------
  // Dark mode — hand-tuned for contrast on dark canvases
  // ---------------------------------------------------------------------------
  static const HelmColors dark = HelmColors(
    canvas:         Color(0xFF0E0E0C),
    surface:        Color(0xFF161614),
    inkPrimary:     Color(0xFFF2F1ED), // 15.1:1 contrast
    inkSecondary:   Color(0xFFB0ADA6), // resolved from F2F1ED @60%
    inkTertiary:    Color(0xFF857F77), // resolved from F2F1ED @38%
    interactive:    Color(0xFF4DA09C), // WCAG AA 5.0:1 on #0E0E0C
    divider:        Color(0xFF2A2925), // resolved from F2F1ED @10% darker
    hairline:       Color(0xFF232220), // internal dividers dark
    stateSafe:      Color(0xFF82A887),
    stateTight:     Color(0xFFD4A668),
    stateAtRisk:    Color(0xFFC56A58),
    stateHope:      Color(0xFF7A95A8), // dark mode solid for text
    stateHopeMuted: Color(0xFF5A6E77), // dark mode decorative
  );

  // ---------------------------------------------------------------------------
  // ThemeExtension contract
  // ---------------------------------------------------------------------------
  @override
  HelmColors copyWith({
    Color? canvas,
    Color? surface,
    Color? inkPrimary,
    Color? inkSecondary,
    Color? inkTertiary,
    Color? interactive,
    Color? divider,
    Color? hairline,
    Color? stateSafe,
    Color? stateTight,
    Color? stateAtRisk,
    Color? stateHope,
    Color? stateHopeMuted,
  }) {
    return HelmColors(
      canvas:         canvas         ?? this.canvas,
      surface:        surface        ?? this.surface,
      inkPrimary:     inkPrimary     ?? this.inkPrimary,
      inkSecondary:   inkSecondary   ?? this.inkSecondary,
      inkTertiary:    inkTertiary    ?? this.inkTertiary,
      interactive:    interactive    ?? this.interactive,
      divider:        divider        ?? this.divider,
      hairline:       hairline       ?? this.hairline,
      stateSafe:      stateSafe      ?? this.stateSafe,
      stateTight:     stateTight     ?? this.stateTight,
      stateAtRisk:    stateAtRisk    ?? this.stateAtRisk,
      stateHope:      stateHope      ?? this.stateHope,
      stateHopeMuted: stateHopeMuted ?? this.stateHopeMuted,
    );
  }

  @override
  HelmColors lerp(ThemeExtension<HelmColors>? other, double t) {
    if (other is! HelmColors) return this;
    return HelmColors(
      canvas:         Color.lerp(canvas,         other.canvas,         t)!,
      surface:        Color.lerp(surface,        other.surface,        t)!,
      inkPrimary:     Color.lerp(inkPrimary,     other.inkPrimary,     t)!,
      inkSecondary:   Color.lerp(inkSecondary,   other.inkSecondary,   t)!,
      inkTertiary:    Color.lerp(inkTertiary,    other.inkTertiary,    t)!,
      interactive:    Color.lerp(interactive,    other.interactive,    t)!,
      divider:        Color.lerp(divider,        other.divider,        t)!,
      hairline:       Color.lerp(hairline,       other.hairline,       t)!,
      stateSafe:      Color.lerp(stateSafe,      other.stateSafe,      t)!,
      stateTight:     Color.lerp(stateTight,     other.stateTight,     t)!,
      stateAtRisk:    Color.lerp(stateAtRisk,    other.stateAtRisk,    t)!,
      stateHope:      Color.lerp(stateHope,      other.stateHope,      t)!,
      stateHopeMuted: Color.lerp(stateHopeMuted, other.stateHopeMuted, t)!,
    );
  }
}

// ---------------------------------------------------------------------------
// BuildContext extension — access colors without boilerplate
// ---------------------------------------------------------------------------
extension BuildContextHelmColors on BuildContext {
  HelmColors get colors {
    final theme = Theme.of(this);
    return theme.extension<HelmColors>() ??
        (theme.brightness == Brightness.dark ? HelmColors.dark : HelmColors.light);
  }
}
