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
  group('HelmColors light mode WCAG AA contrast (≥4.5:1)', () {
    test('stateSafe meets WCAG AA contrast on light canvas (#FAFAF6)', () {
      final contrast = _computeContrast(
        HelmColors.light.stateSafe,
        const Color(0xFFFAFAF6),
      );
      expect(contrast, greaterThanOrEqualTo(4.5));
    });

    test('stateTight meets WCAG AA contrast on light canvas (#FAFAF6)', () {
      final contrast = _computeContrast(
        HelmColors.light.stateTight,
        const Color(0xFFFAFAF6),
      );
      expect(contrast, greaterThanOrEqualTo(4.5));
    });
  });

  group('HelmColors dark mode WCAG AA contrast (≥4.5:1)', () {
    test('interactive meets WCAG AA contrast on dark canvas (#0E0E0C)', () {
      final contrast = _computeContrast(
        HelmColors.dark.interactive,
        const Color(0xFF0E0E0C),
      );
      expect(contrast, greaterThanOrEqualTo(4.5));
    });
  });
}
