// test/core/widgets/helm_locale_text_test.dart
//
// Widget tests for HelmLocaleText.
//
// Verifies:
//   - English locale → Inter font for body/label tokens
//   - Bangla locale  → HindSiliguri font for body/label tokens
//   - Bangla locale  → Inter font for heading tokens (locale-invariant)
//   - Bangla locale  → JetBrains Mono for mono tokens (locale-invariant)
//   - colorOverride is applied correctly
//   - Text content is rendered

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/core/widgets/helm_locale_text.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Pumps [child] inside an English locale context.
Future<void> pumpEn(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: child),
    ),
  );
}

/// Pumps [child] inside a Bangla locale context.
///
/// Uses [Localizations.override] at the widget level so that
/// [Localizations.localeOf(context)] returns Locale('bn') without
/// requiring full globalisation delegates in the test app.
Future<void> pumpBn(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      home: Builder(
        builder: (outerCtx) => Localizations.override(
          context: outerCtx,
          locale: const Locale('bn'),
          child: Scaffold(body: child),
        ),
      ),
    ),
  );
}

/// Returns the resolved [TextStyle] from the first [Text] widget in the tree.
TextStyle _resolvedStyle(WidgetTester tester) {
  final textWidget = tester.widget<Text>(find.byType(Text).first);
  return textWidget.style!;
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('HelmLocaleText — English locale', () {
    testWidgets('renders text content', (tester) async {
      await pumpEn(
        tester,
        const HelmLocaleText('Hello', token: HelmTextToken.bodyMd),
      );
      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('bodyMd → Inter font', (tester) async {
      await pumpEn(
        tester,
        const HelmLocaleText('Body text', token: HelmTextToken.bodyMd),
      );
      final style = _resolvedStyle(tester);
      expect(style.fontFamily, equals('Inter'));
      expect(style.fontSize, equals(14));
    });

    testWidgets('bodyLg → Inter font', (tester) async {
      await pumpEn(
        tester,
        const HelmLocaleText('Large body', token: HelmTextToken.bodyLg),
      );
      expect(_resolvedStyle(tester).fontFamily, equals('Inter'));
      expect(_resolvedStyle(tester).fontSize, equals(16));
    });

    testWidgets('bodySm → Inter font', (tester) async {
      await pumpEn(
        tester,
        const HelmLocaleText('Small body', token: HelmTextToken.bodySm),
      );
      expect(_resolvedStyle(tester).fontFamily, equals('Inter'));
      expect(_resolvedStyle(tester).fontSize, equals(13));
    });

    testWidgets('labelMd → Inter font', (tester) async {
      await pumpEn(
        tester,
        const HelmLocaleText('Label', token: HelmTextToken.labelMd),
      );
      expect(_resolvedStyle(tester).fontFamily, equals('Inter'));
      expect(_resolvedStyle(tester).fontSize, equals(12));
    });
  });

  // -------------------------------------------------------------------------
  group('HelmLocaleText — Bangla locale: body/label tokens switch to Hind Siliguri', () {
    testWidgets('renders text content', (tester) async {
      await pumpBn(
        tester,
        const HelmLocaleText('বাংলা', token: HelmTextToken.bodyMd),
      );
      expect(find.text('বাংলা'), findsOneWidget);
    });

    testWidgets('bodyMd → HindSiliguri with taller line-height', (tester) async {
      await pumpBn(
        tester,
        const HelmLocaleText('Body text', token: HelmTextToken.bodyMd),
      );
      final style = _resolvedStyle(tester);
      expect(style.fontFamily, equals('HindSiliguri'));
      expect(style.fontSize, equals(14));
      expect(style.height, equals(1.58));
    });

    testWidgets('bodyLg → HindSiliguri', (tester) async {
      await pumpBn(
        tester,
        const HelmLocaleText('Large body', token: HelmTextToken.bodyLg),
      );
      final style = _resolvedStyle(tester);
      expect(style.fontFamily, equals('HindSiliguri'));
      expect(style.fontSize, equals(16));
      expect(style.height, equals(1.58));
    });

    testWidgets('bodySm → HindSiliguri', (tester) async {
      await pumpBn(
        tester,
        const HelmLocaleText('Small body', token: HelmTextToken.bodySm),
      );
      final style = _resolvedStyle(tester);
      expect(style.fontFamily, equals('HindSiliguri'));
      expect(style.fontSize, equals(13));
      expect(style.height, equals(1.52));
    });

    testWidgets('labelMd → HindSiliguri', (tester) async {
      await pumpBn(
        tester,
        const HelmLocaleText('Label', token: HelmTextToken.labelMd),
      );
      final style = _resolvedStyle(tester);
      expect(style.fontFamily, equals('HindSiliguri'));
      expect(style.fontSize, equals(12));
      expect(style.height, equals(1.38));
    });
  });

  // -------------------------------------------------------------------------
  group('HelmLocaleText — heading tokens stay Inter regardless of locale', () {
    testWidgets('headingLg stays Inter in bn locale', (tester) async {
      await pumpBn(
        tester,
        const HelmLocaleText('Heading', token: HelmTextToken.headingLg),
      );
      final style = _resolvedStyle(tester);
      expect(style.fontFamily, equals('Inter'));
      expect(style.fontSize, equals(22));
    });

    testWidgets('headingMd stays Inter in bn locale', (tester) async {
      await pumpBn(
        tester,
        const HelmLocaleText('Section', token: HelmTextToken.headingMd),
      );
      expect(_resolvedStyle(tester).fontFamily, equals('Inter'));
      expect(_resolvedStyle(tester).fontSize, equals(18));
    });

    testWidgets('headingSm stays Inter in bn locale', (tester) async {
      await pumpBn(
        tester,
        const HelmLocaleText('Card title', token: HelmTextToken.headingSm),
      );
      expect(_resolvedStyle(tester).fontFamily, equals('Inter'));
      expect(_resolvedStyle(tester).fontSize, equals(15));
    });

    testWidgets('displayHero stays Inter in bn locale', (tester) async {
      await pumpBn(
        tester,
        const HelmLocaleText('Hero', token: HelmTextToken.displayHero),
      );
      expect(_resolvedStyle(tester).fontFamily, equals('Inter'));
      expect(_resolvedStyle(tester).fontSize, equals(64));
    });

    testWidgets('displayLarge stays Inter in bn locale', (tester) async {
      await pumpBn(
        tester,
        const HelmLocaleText('Total', token: HelmTextToken.displayLarge),
      );
      expect(_resolvedStyle(tester).fontFamily, equals('Inter'));
      expect(_resolvedStyle(tester).fontSize, equals(40));
    });

    testWidgets('labelSm stays Inter in bn locale', (tester) async {
      await pumpBn(
        tester,
        const HelmLocaleText('Timestamp', token: HelmTextToken.labelSm),
      );
      expect(_resolvedStyle(tester).fontFamily, equals('Inter'));
      expect(_resolvedStyle(tester).fontSize, equals(11));
    });
  });

  // -------------------------------------------------------------------------
  group('HelmLocaleText — mono tokens stay JetBrainsMono regardless of locale', () {
    testWidgets('monoFinancialSm stays JetBrainsMono in bn locale', (tester) async {
      await pumpBn(
        tester,
        const HelmLocaleText('1,234', token: HelmTextToken.monoFinancialSm),
      );
      final style = _resolvedStyle(tester);
      expect(style.fontFamily, equals('JetBrainsMono'));
      expect(style.fontSize, equals(16));
    });

    testWidgets('monoFinancialMd stays JetBrainsMono in bn locale', (tester) async {
      await pumpBn(
        tester,
        const HelmLocaleText('12,345', token: HelmTextToken.monoFinancialMd),
      );
      expect(_resolvedStyle(tester).fontFamily, equals('JetBrainsMono'));
      expect(_resolvedStyle(tester).fontSize, equals(24));
    });

    testWidgets('monoFinancialLg stays JetBrainsMono in bn locale', (tester) async {
      await pumpBn(
        tester,
        const HelmLocaleText('1,23,456', token: HelmTextToken.monoFinancialLg),
      );
      expect(_resolvedStyle(tester).fontFamily, equals('JetBrainsMono'));
      expect(_resolvedStyle(tester).fontSize, equals(40));
    });

    testWidgets('monoHero stays JetBrainsMono in bn locale', (tester) async {
      await pumpBn(
        tester,
        const HelmLocaleText('12,34,567', token: HelmTextToken.monoHero),
      );
      expect(_resolvedStyle(tester).fontFamily, equals('JetBrainsMono'));
      expect(_resolvedStyle(tester).fontSize, equals(64));
    });
  });

  // -------------------------------------------------------------------------
  group('HelmLocaleText — colorOverride', () {
    testWidgets('applies colorOverride in en locale', (tester) async {
      const overrideColor = Color(0xFFFF0000);
      await pumpEn(
        tester,
        const HelmLocaleText(
          'Tinted',
          token: HelmTextToken.bodyMd,
          colorOverride: overrideColor,
        ),
      );
      expect(_resolvedStyle(tester).color, equals(overrideColor));
    });

    testWidgets('colorOverride applies alongside HindSiliguri in bn locale', (tester) async {
      const overrideColor = Color(0xFF00FF00);
      await pumpBn(
        tester,
        const HelmLocaleText(
          'Tinted Bangla',
          token: HelmTextToken.bodyMd,
          colorOverride: overrideColor,
        ),
      );
      final style = _resolvedStyle(tester);
      expect(style.fontFamily, equals('HindSiliguri'));
      expect(style.color, equals(overrideColor));
    });
  });
}
