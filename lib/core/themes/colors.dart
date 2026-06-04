// DEPRECATED: Use PocketaColors ThemeExtension instead.
// This file remains only for backward compatibility during migration.
// TODO: Remove after all references migrated to pocketa_colors.dart
export 'pocketa_colors.dart';

import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Colors
  static const Color primary = Color(0xFF2453FF);
  static const Color primaryLight = Color(0xFF6785FF);
  static const Color primaryDark = Color(0xFF0031CB);

  static const Color secondary = Color(0xFFF57C00);
  static const Color secondaryLight = Color(0xFFFFAD42);
  static const Color secondaryDark = Color(0xFFBB4D00);

  // Neutral / Grayscale
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF6B7280);
  static const Color greyLight = Color(0xFFE5E7EB);
  static const Color greyDark = Color(0xFF374151);

  // Backgrounds
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF1A1A1A);
  static const Color cardLight = Color(0xFFF9FAFB);
  static const Color cardDark = Color(0xFF2C2C2C);

  // Text Colors
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFFF9FAFB);
  static const Color textDark = Color(0xFF1F2937);

  // Status Colors
  static const Color success = Color(0xFF10B981);    // Green
  static const Color warning = Color(0xFFF59E0B);    // Amber
  static const Color error = Color(0xFFEF4444);      // Red
  static const Color info = Color(0xFF3B82F6);       // Blue

  // Border & Shadow
  static const Color border = Color(0xFFD1D5DB);
  static const Color shadow = Color(0x1A000000); // 10% opacity black
}
