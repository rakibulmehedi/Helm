import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/themes/helm_signal_theme.dart';

double _linearize(double channel) {
  return channel <= 0.03928
      ? channel / 12.92
      : pow((channel + 0.055) / 1.055, 2.4) as double;
}

double _relativeLuminance(Color c) {
  final r = _linearize((c.r * 255.0).round().clamp(0, 255) / 255.0);
  final g = _linearize((c.g * 255.0).round().clamp(0, 255) / 255.0);
  final b = _linearize((c.b * 255.0).round().clamp(0, 255) / 255.0);
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

double _contrast(Color a, Color b) {
  final l1 = _relativeLuminance(a);
  final l2 = _relativeLuminance(b);
  return (max(l1, l2) + 0.05) / (min(l1, l2) + 0.05);
}

void main() {
  group('HelmSignalTheme tokens', () {
    test('dark brand tokens match approved Signal Deck palette', () {
      expect(HelmSignalTheme.signalCanvas, const Color(0xFF06100E));
      expect(HelmSignalTheme.signalSurface, const Color(0xFF0E1A17));
      expect(HelmSignalTheme.signalDeck, const Color(0xFF14231F));
      expect(HelmSignalTheme.signalInkPrimary, const Color(0xFFEFF8F4));
      expect(HelmSignalTheme.signalInteractive, const Color(0xFF8BE5C9));
      expect(HelmSignalTheme.signalGlow, const Color(0xFF53C9A7));
    });

    test('critical dark text and CTA tokens meet WCAG AA contrast', () {
      expect(
        _contrast(
          HelmSignalTheme.signalInkPrimary,
          HelmSignalTheme.signalCanvas,
        ),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        _contrast(
          HelmSignalTheme.signalInteractive,
          HelmSignalTheme.signalCanvas,
        ),
        greaterThanOrEqualTo(4.5),
      );
    });

    test('semantic states expose approved Signal Deck colors', () {
      expect(HelmSignalTheme.safe, const Color(0xFF83E3C7));
      expect(HelmSignalTheme.tight, const Color(0xFFD2A75B));
      expect(HelmSignalTheme.atRisk, const Color(0xFFD87868));
      expect(HelmSignalTheme.pending, const Color(0xFF789FB2));
      expect(HelmSignalTheme.protected, const Color(0xFFA69BC4));
    });

    test('shadow constants preserve non-Material depth model', () {
      expect(HelmSignalTheme.decisionDeckShadow.offset.dy, equals(-12));
      expect(HelmSignalTheme.decisionDeckShadow.blurRadius, equals(40));
      expect(HelmSignalTheme.floatingSheetShadow.offset.dy, equals(-8));
      expect(HelmSignalTheme.floatingSheetShadow.blurRadius, equals(32));
    });

    test('stateColor returns correct color for each SignalDeckState', () {
      expect(HelmSignalTheme.stateColor(SignalDeckState.safe), equals(HelmSignalTheme.safe));
      expect(HelmSignalTheme.stateColor(SignalDeckState.tight), equals(HelmSignalTheme.tight));
      expect(HelmSignalTheme.stateColor(SignalDeckState.atRisk), equals(HelmSignalTheme.atRisk));
    });

    test('stateLabel returns correct label for each SignalDeckState', () {
      expect(HelmSignalTheme.stateLabel(SignalDeckState.safe), equals('Stable'));
      expect(HelmSignalTheme.stateLabel(SignalDeckState.tight), equals('Tight'));
      expect(HelmSignalTheme.stateLabel(SignalDeckState.atRisk), equals('At Risk'));
    });
  });
}
