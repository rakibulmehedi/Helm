// lib/core/themes/helm_motion.dart
// UX-5.04 — Visual Identity: Motion Token Foundation
// Plain Dart class with static constants — NOT a ThemeExtension.
// Rule: ease-out curves ONLY. No springs, no bounces, no duration > 320ms.

// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flutter/material.dart';

class HelmMotion {
  // ---------------------------------------------------------------------------
  // Timing tokens
  // ---------------------------------------------------------------------------
  static const Duration instant = Duration.zero;
  static const Duration fast = Duration(milliseconds: 120);
  static const Duration base = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 240);
  static const Duration slow = Duration(milliseconds: 320);
  static const Duration s2sAppear = Duration(
    milliseconds: 200,
  ); // S2S fade-in only

  // ---------------------------------------------------------------------------
  // Curves — ease-out ONLY
  // Forbidden: Curves.bounceIn/Out, Curves.elasticIn/Out, duration > 320ms
  // ---------------------------------------------------------------------------
  static const Curve defaultCurve = Curves.easeOut;
  static final Curve sheetCurve = const Cubic(0.2, 0, 0, 1);

  // ---------------------------------------------------------------------------
  // Breakdown drawer stagger
  // ---------------------------------------------------------------------------
  static const Duration drawerRowStagger = Duration(milliseconds: 24);
  static const Duration drawerReducedMotion = Duration(milliseconds: 80);

  // ---------------------------------------------------------------------------
  // Signal Deck motion tokens — visual layer only, no business logic.
  // ---------------------------------------------------------------------------
  static const Duration signalTapFeedback = Duration(milliseconds: 90);
  static const Duration signalSmallStateChange = Duration(milliseconds: 180);
  static const Duration signalDeckTransition = Duration(milliseconds: 260);
  static const Duration signalFullScreenTransition = Duration(
    milliseconds: 320,
  );

  static const double signalControlPressMass = 1.0;
  static const double signalControlPressStiffness = 650.0;
  static const double signalControlPressDamping = 48.0;
  static const double signalControlPressedScale = 0.975;

  static const double signalDeckSettleMass = 1.0;
  static const double signalDeckSettleStiffness = 420.0;
  static const double signalDeckSettleDamping = 38.0;
  static const double signalDeckSettleMaxTravel = 12.0;

  static const double signalPipelineMass = 1.0;
  static const double signalPipelineStiffness = 360.0;
  static const double signalPipelineDamping = 34.0;
}
