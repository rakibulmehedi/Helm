import 'package:flutter/material.dart';

abstract final class HelmSignalTheme {
  static const Color signalCanvas = Color(0xFF06100E);
  static const Color signalSurface = Color(0xFF0E1A17);
  static const Color signalDeck = Color(0xFF14231F);
  static const Color signalInkPrimary = Color(0xFFEFF8F4);
  static const Color signalInkSecondary = Color(0xFFA7BBB4);
  static const Color signalInkMuted = Color(0xFF789087);
  static const Color signalInteractive = Color(0xFF8BE5C9);
  static const Color signalGlow = Color(0xFF53C9A7);

  static const Color safe = Color(0xFF83E3C7);
  static const Color tight = Color(0xFFD2A75B);
  static const Color atRisk = Color(0xFFD87868);
  static const Color pending = Color(0xFF789FB2);
  static const Color protected = Color(0xFFA69BC4);

  static Color signalGlass(BuildContext context) =>
      Colors.white.withValues(alpha: 0.07);

  static Color signalBorder(BuildContext context) =>
      Colors.white.withValues(alpha: 0.13);

  static const BoxShadow decisionDeckShadow = BoxShadow(
    color: Color(0x2E000000),
    offset: Offset(0, -12),
    blurRadius: 40,
  );

  static const BoxShadow floatingSheetShadow = BoxShadow(
    color: Color(0x38000000),
    offset: Offset(0, -8),
    blurRadius: 32,
  );

  static Color stateColor(SignalDeckState state) {
    return switch (state) {
      SignalDeckState.safe => safe,
      SignalDeckState.tight => tight,
      SignalDeckState.atRisk => atRisk,
    };
  }

  static String stateLabel(SignalDeckState state) {
    return switch (state) {
      SignalDeckState.safe => 'Stable',
      SignalDeckState.tight => 'Tight',
      SignalDeckState.atRisk => 'At Risk',
    };
  }
}

enum SignalDeckState { safe, tight, atRisk }
