import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/features/onboarding/presentation/views/pages/qualifying_question_page.dart';
import 'package:helm/l10n/app_localizations.dart';

void _noop() {}

void main() {
  group('QualifyingQuestionPage — P4.10-P4.11 conversational qualifier', () {
    Widget buildTestWidget() {
      return MaterialApp(
        theme: AppTheme.light,
        locale: const Locale('en'),
        supportedLocales: const [Locale('en'), Locale('bn')],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: QualifyingQuestionPage(
          onQualified: _noop,
          onDisqualified: _noop,
        ),
      );
    }

    testWidgets('displays pain-point qualifier text', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(
        find.textContaining('Have you ever spent money thinking a'),
        findsOneWidget,
      );
      expect(
        find.textContaining("payment cleared, then realized it hadn't?"),
        findsOneWidget,
      );
    });

    testWidgets('shows platform context (Upwork, Fiverr, Payoneer)', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.textContaining('Upwork, Fiverr, or Payoneer'), findsOneWidget);
    });

    testWidgets('shows "Yes, that happens to me" and "No" buttons', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Yes, that happens to me'), findsOneWidget);
      expect(find.text('No, I always know exactly what cleared'), findsOneWidget);
    });

    testWidgets('shows disqualification screen when user says no', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      await tester.tap(find.text('No, I always know exactly what cleared'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Helm is built for USD-earning freelancers in Bangladesh.'),
        findsOneWidget,
      );
      expect(find.text('Close'), findsOneWidget);
    });

    testWidgets('calls onQualified when user taps yes', (tester) async {
      var wasQualified = false;

      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.light,
        locale: const Locale('en'),
        supportedLocales: const [Locale('en'), Locale('bn')],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: QualifyingQuestionPage(
          onQualified: () => wasQualified = true,
          onDisqualified: () {},
        ),
      ));

      await tester.tap(find.text('Yes, that happens to me'));
      await tester.pumpAndSettle();

      expect(wasQualified, isTrue);
    });

    testWidgets('calls onDisqualified when user taps close on disqualify screen', (tester) async {
      var wasDisqualified = false;

      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.light,
        locale: const Locale('en'),
        supportedLocales: const [Locale('en'), Locale('bn')],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: QualifyingQuestionPage(
          onQualified: () {},
          onDisqualified: () => wasDisqualified = true,
        ),
      ));

      await tester.tap(find.text('No, I always know exactly what cleared'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      expect(wasDisqualified, isTrue);
    });

    testWidgets('12s inactivity timer triggers Bangla rephrase', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Initially, Bangla text not visible
      expect(
        find.textContaining('\u0986\u09AA\u09A8\u09BF \u0995\u09BF'), // আপনি কি
        findsNothing,
      );

      // Advance 13 seconds to trigger timer
      await tester.pump(const Duration(seconds: 13));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('\u0986\u09AA\u09A8\u09BF \u0995\u09BF'), // আপনি কি
        findsOneWidget,
      );
    });

    testWidgets('interaction before 12s cancels timer', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Tap at 5s
      await tester.pump(const Duration(seconds: 5));
      await tester.tap(find.text('Yes, that happens to me'));

      // Advance past 12s — rephrase should not show
      await tester.pump(const Duration(seconds: 10));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('\u0986\u09AA\u09A8\u09BF \u0995\u09BF'), // আপনি কি
        findsNothing,
      );
    });
  });
}
