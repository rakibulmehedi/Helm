import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_typography.dart';

void main() {
  final t = HelmTypography.build(HelmColors.light);

  group('Display + heading styles use Fraunces', () {
    test('displayHero', () => expect(t.displayHero.fontFamily, 'Fraunces'));
    test('displayLarge', () => expect(t.displayLarge.fontFamily, 'Fraunces'));
    test('headingLg', () => expect(t.headingLg.fontFamily, 'Fraunces'));
    test('headingMd', () => expect(t.headingMd.fontFamily, 'Fraunces'));
    test('headingSm', () => expect(t.headingSm.fontFamily, 'Fraunces'));
  });

  group('Body + label styles use Inter', () {
    test('bodyLg', () => expect(t.bodyLg.fontFamily, 'Inter'));
    test('bodyMd', () => expect(t.bodyMd.fontFamily, 'Inter'));
    test('bodySm', () => expect(t.bodySm.fontFamily, 'Inter'));
    test('labelMd', () => expect(t.labelMd.fontFamily, 'Inter'));
    test('labelSm', () => expect(t.labelSm.fontFamily, 'Inter'));
  });

  group('Money styles use the mono family', () {
    test('monoFinancialSm', () => expect(t.monoFinancialSm.fontFamily, 'JetBrainsMono'));
    test('monoFinancialMd', () => expect(t.monoFinancialMd.fontFamily, 'JetBrainsMono'));
    test('monoFinancialLg', () => expect(t.monoFinancialLg.fontFamily, 'JetBrainsMono'));
    test('monoHero', () => expect(t.monoHero.fontFamily, 'JetBrainsMono'));
  });

  group('Bangla styles use Hind Siliguri', () {
    test('bodyLgBn', () => expect(t.bodyLgBn.fontFamily, 'HindSiliguri'));
    test('labelMdBn', () => expect(t.labelMdBn.fontFamily, 'HindSiliguri'));
  });

  test('weights stay within 400-600', () {
    for (final s in [t.displayHero, t.headingLg, t.bodyMd, t.labelSm]) {
      final w = s.fontWeight!.value;
      expect(w, inInclusiveRange(FontWeight.w400.value, FontWeight.w600.value));
    }
  });
}
