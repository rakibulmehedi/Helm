import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:helm/core/themes/helm_colors.dart';

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

double _computeContrast(Color a, Color b) {
  final l1 = _relativeLuminance(a);
  final l2 = _relativeLuminance(b);
  final lighter = max(l1, l2);
  final darker = min(l1, l2);
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  const lightCanvas = Color(0xFFF3ECE0);
  const darkCanvas = Color(0xFF1E1813);

  group('HelmColors light mode WCAG AA contrast (>=4.5:1 on paper canvas)', () {
    test('stateSafe on light canvas', () {
      expect(_computeContrast(HelmColors.light.stateSafe, lightCanvas),
          greaterThanOrEqualTo(4.5));
    });
    test('stateTight on light canvas', () {
      expect(_computeContrast(HelmColors.light.stateTight, lightCanvas),
          greaterThanOrEqualTo(4.5));
    });
    test('stateAtRisk on light canvas', () {
      expect(_computeContrast(HelmColors.light.stateAtRisk, lightCanvas),
          greaterThanOrEqualTo(4.5));
    });
    test('inkPrimary on light canvas', () {
      expect(_computeContrast(HelmColors.light.inkPrimary, lightCanvas),
          greaterThanOrEqualTo(7.0));
    });
    test('inkSecondary on light canvas', () {
      expect(_computeContrast(HelmColors.light.inkSecondary, lightCanvas),
          greaterThanOrEqualTo(4.5));
    });
  });

  group('HelmColors dark mode WCAG AA contrast (>=4.5:1 on espresso canvas)', () {
    test('interactive on dark canvas', () {
      expect(_computeContrast(HelmColors.dark.interactive, darkCanvas),
          greaterThanOrEqualTo(4.5));
    });
    test('inkPrimary on dark canvas', () {
      expect(_computeContrast(HelmColors.dark.inkPrimary, darkCanvas),
          greaterThanOrEqualTo(7.0));
    });
    test('stateSafe on dark canvas', () {
      expect(_computeContrast(HelmColors.dark.stateSafe, darkCanvas),
          greaterThanOrEqualTo(4.5));
    });
  });
}
