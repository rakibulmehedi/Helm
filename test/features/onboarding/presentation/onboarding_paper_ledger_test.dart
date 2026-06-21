// test/features/onboarding/presentation/onboarding_paper_ledger_test.dart
// Task 15: Paper Ledger reskin — light + dark smoke tests for WelcomeScreen.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/features/onboarding/presentation/views/welcome_screen.dart';
import 'package:helm/l10n/app_localizations.dart';

/// Minimal GoRouter that serves WelcomeScreen at '/' and absorbs any
/// navigation to '/onboarding' so context.go() does not throw in tests.
GoRouter _buildRouter() => GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const WelcomeScreen(),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (_, _) => const Scaffold(body: SizedBox.shrink()),
        ),
      ],
    );

Widget _app(ThemeData theme) {
  final router = _buildRouter();
  return MaterialApp.router(
    routerConfig: router,
    theme: theme,
    locale: const Locale('en'),
    supportedLocales: const [Locale('en'), Locale('bn')],
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
  );
}

void main() {
  testWidgets('welcome renders in light mode', (tester) async {
    await tester.pumpWidget(_app(AppTheme.light));
    await tester.pumpAndSettle();
    expect(find.byType(WelcomeScreen), findsOneWidget);
  });

  testWidgets('welcome renders in dark mode', (tester) async {
    await tester.pumpWidget(_app(AppTheme.dark));
    await tester.pumpAndSettle();
    expect(find.byType(WelcomeScreen), findsOneWidget);
  });
}
