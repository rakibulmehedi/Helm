// lib/core/themes/app_theme.dart
// UX-5.05 — Rebuilt using Helm design token foundation.
//
// Preserves AppThemeData.lightTheme / AppThemeData.darkTheme signatures
// so main.dart continues to compile without modification.
//
// New AppTheme.light / AppTheme.dark static getters are the forward-looking API.
// AppThemeData delegates to AppTheme internally.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_language.dart';
import 'colors.dart'; // exports AppColors (legacy) + HelmColors (via re-export)
import 'helm_motion.dart';
import 'helm_spacing.dart';
import 'helm_typography.dart';

// ---------------------------------------------------------------------------
// AppTheme — new token-based API (ThemeMode.system only)
// ---------------------------------------------------------------------------
class AppTheme {
  static ThemeData get light => _buildTheme(isLight: true);
  static ThemeData get dark  => _buildTheme(isLight: false);

  static ThemeData _buildTheme({required bool isLight}) {
    final colors     = isLight ? HelmColors.light : HelmColors.dark;
    final typography = HelmTypography.build(colors);

    return ThemeData(
      useMaterial3: true,
      brightness: isLight ? Brightness.light : Brightness.dark,
      scaffoldBackgroundColor: colors.canvas,

      // ── ColorScheme ────────────────────────────────────────────────────────
      // NOT ColorScheme.fromSeed — hand-mapped from HelmColors tokens.
      colorScheme: ColorScheme(
        brightness:   isLight ? Brightness.light : Brightness.dark,
        primary:      colors.interactive,
        onPrimary:    colors.surface,
        secondary:    colors.interactive,
        onSecondary:  colors.surface,
        error:        colors.stateAtRisk,
        onError:      colors.surface,
        surface:      colors.surface,
        onSurface:    colors.inkPrimary,
      ),

      // ── ThemeExtensions ────────────────────────────────────────────────────
      extensions: <ThemeExtension<dynamic>>[colors, typography],

      // ── AppBar ─────────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: colors.canvas,
        foregroundColor: colors.inkPrimary,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),

      // ── Card — zero elevation, hairline border ─────────────────────────────
      cardTheme: CardThemeData(
        elevation: 0,
        color: colors.surface,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HelmSpacing.cardRadius),
          side: BorderSide(
            color: colors.divider,
            width: HelmSpacing.cardBorder,
          ),
        ),
      ),

      // ── ElevatedButton ─────────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: colors.interactive,
          foregroundColor: colors.surface,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(HelmSpacing.buttonRadius),
          ),
          textStyle: typography.headingSm,
          animationDuration: HelmMotion.base,
        ),
      ),

      // ── TextButton ─────────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.interactive,
          textStyle: typography.bodyMd,
        ),
      ),

      // ── InputDecoration ────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(HelmSpacing.cardRadius),
          borderSide: BorderSide(color: colors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(HelmSpacing.cardRadius),
          borderSide: BorderSide(color: colors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(HelmSpacing.cardRadius),
          borderSide: BorderSide(color: colors.interactive, width: 2),
        ),
        labelStyle: typography.labelMd.copyWith(color: colors.inkSecondary),
        hintStyle:  typography.bodyMd.copyWith(color: colors.inkTertiary),
      ),

      // ── Divider ────────────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: colors.hairline,
        thickness: HelmSpacing.cardBorder,
        space: 0,
      ),

      // ── BottomNavigationBar ────────────────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.surface,
        selectedItemColor: colors.interactive,
        unselectedItemColor: colors.inkTertiary,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),

      // ── TextTheme — mapped from HelmTypography ──────────────────────────
      textTheme: TextTheme(
        displayLarge:  typography.displayLarge,
        displayMedium: typography.displayHero,
        titleLarge:    typography.headingLg,
        titleMedium:   typography.headingMd,
        titleSmall:    typography.headingSm,
        bodyLarge:     typography.bodyLg,
        bodyMedium:    typography.bodyMd,
        bodySmall:     typography.bodySm,
        labelLarge:    typography.labelMd,
        labelSmall:    typography.labelSm,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// AppThemeData — legacy API preserved for main.dart backward compatibility.
// Delegates to AppTheme._buildTheme internally; lang param kept for signature
// compatibility but typography is now handled via HelmTypography extension.
// TODO: Remove lang parameter after all callers migrate to context.textStyles.
// ---------------------------------------------------------------------------
class AppThemeData {
  static ThemeData lightTheme(BuildContext context, AppLanguage lang) =>
      AppTheme.light;

  static ThemeData darkTheme(BuildContext context, AppLanguage lang) =>
      AppTheme.dark;
}

// ---------------------------------------------------------------------------
// getFontStyle — retained for backward compatibility with feature files
// that have not yet migrated to HelmTypography.
// TODO: Remove after all feature files migrate to context.textStyles.*
// ---------------------------------------------------------------------------
TextStyle getFontStyle(
  AppLanguage lang,
  double size,
  FontWeight weight,
  Color color,
) {
  return lang == AppLanguage.bangla
      ? GoogleFonts.hindSiliguri(
          fontSize: size,
          fontWeight: weight,
          color: color,
        )
      : GoogleFonts.inter(
          fontSize: size,
          fontWeight: weight,
          color: color,
        );
}
