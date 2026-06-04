// lib/core/themes/pocketa_motion.dart
// UX-5.04 — Visual Identity: Motion Token Foundation
// Plain Dart class with static constants — NOT a ThemeExtension.
// Rule: ease-out curves ONLY. No springs, no bounces, no duration > 320ms.

// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flutter/material.dart';

class PocketaMotion {
  // ---------------------------------------------------------------------------
  // Timing tokens
  // ---------------------------------------------------------------------------
  static const Duration instant   = Duration.zero;
  static const Duration fast      = Duration(milliseconds: 120);
  static const Duration base      = Duration(milliseconds: 200);
  static const Duration medium    = Duration(milliseconds: 240);
  static const Duration slow      = Duration(milliseconds: 320);
  static const Duration s2sAppear = Duration(milliseconds: 200); // S2S fade-in only

  // ---------------------------------------------------------------------------
  // Curves — ease-out ONLY
  // Forbidden: Curves.bounceIn/Out, Curves.elasticIn/Out, duration > 320ms
  // ---------------------------------------------------------------------------
  static const Curve defaultCurve = Curves.easeOut;
  static final Curve sheetCurve   = const Cubic(0.2, 0, 0, 1);

  // ---------------------------------------------------------------------------
  // Breakdown drawer stagger
  // ---------------------------------------------------------------------------
  static const Duration drawerRowStagger    = Duration(milliseconds: 24);
  static const Duration drawerReducedMotion = Duration(milliseconds: 80);
}
