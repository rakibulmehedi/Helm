// test/features/auth/presentation/magic_link_screen_test.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';

import 'package:helm/core/constants/app_box_names.dart';
import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/features/auth/data/models/session_model.dart';
import 'package:helm/features/auth/presentation/views/magic_link_screen.dart';
import 'package:helm/l10n/app_localizations.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(9)) {
      Hive.registerAdapter(SessionModelAdapter());
    }
    await Hive.openBox<SessionModel>(AppBoxNames.sessionBox);
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  group('MagicLinkScreen — email step', () {
    Widget buildTestWidget({Future<void> Function()? onAuthenticated, Future<void> Function()? onGuest}) {
      return ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('en'),
          supportedLocales: const [Locale('en'), Locale('bn')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: MagicLinkScreen(
            onAuthenticated: onAuthenticated ?? () async {},
            onGuest: onGuest ?? () async {},
          ),
        ),
      );
    }

    testWidgets('shows "Sign in to Helm" header', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.text('Sign in to Helm'), findsOneWidget);
    });

    testWidgets('shows email input field', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('shows "Send Magic Link" button', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.text('Send Magic Link'), findsOneWidget);
    });

    testWidgets('shows error when email is empty on tap', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.tap(find.text('Send Magic Link'));
      await tester.pumpAndSettle();
      expect(find.text('Please enter your email address'), findsOneWidget);
    });

    testWidgets('transitions to verifying state after sending magic link', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.enterText(find.byType(TextField), 'freelancer@example.com');
      await tester.tap(find.text('Send Magic Link'));
      await tester.pumpAndSettle();
      expect(find.text('Check your inbox'), findsOneWidget);
    });

    testWidgets('shows "Verify & Sign In" button on verify step', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.enterText(find.byType(TextField), 'freelancer@example.com');
      await tester.tap(find.text('Send Magic Link'));
      await tester.pumpAndSettle();
      expect(find.text('Verify & Sign In'), findsOneWidget);
    });

    testWidgets('shows "Use a different email" link on verify step', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.enterText(find.byType(TextField), 'freelancer@example.com');
      await tester.tap(find.text('Send Magic Link'));
      await tester.pumpAndSettle();
      expect(find.text('← Use a different email'), findsOneWidget);
    });

    testWidgets('returns to email step when "Use a different email" tapped', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.enterText(find.byType(TextField), 'freelancer@example.com');
      await tester.tap(find.text('Send Magic Link'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('← Use a different email'));
      await tester.pumpAndSettle();

      expect(find.text('Sign in to Helm'), findsOneWidget);
    });

    testWidgets('shows error for invalid verification token', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.enterText(find.byType(TextField), 'freelancer@example.com');
      await tester.tap(find.text('Send Magic Link'));
      await tester.pumpAndSettle();

      final verifyField = find.byKey(const Key('magic_link_token_field'));
      await tester.enterText(verifyField, 'invalid_token');
      await tester.tap(find.text('Verify & Sign In'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Invalid or expired'), findsOneWidget);
    });

    testWidgets('shows "Use as Guest" button on email step', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.text('Use as Guest'), findsOneWidget);
    });

    testWidgets('calls onGuest when "Use as Guest" is tapped', (tester) async {
      var guestTapped = false;
      await tester.pumpWidget(buildTestWidget(
        onGuest: () async { guestTapped = true; },
      ));
      await tester.tap(find.text('Use as Guest'));
      await tester.pumpAndSettle();
      expect(guestTapped, isTrue);
    });

    testWidgets('calls onAuthenticated when token is valid',
        skip: true, // Hive write inside FutureProvider deadlocks widget pumpAndSettle
        (tester) async {
      var wasAuthenticated = false;

      await tester.pumpWidget(buildTestWidget(
        onAuthenticated: () async { wasAuthenticated = true; },
      ));

      await tester.enterText(find.byType(TextField), 'freelancer@example.com');
      await tester.tap(find.text('Send Magic Link'));
      await tester.pumpAndSettle();

      final verifyField = find.byKey(const Key('magic_link_token_field'));
      await tester.enterText(verifyField, 'valid_123456');
      await tester.tap(find.text('Verify & Sign In'));
      await tester.runAsync(() => Future<void>.delayed(const Duration(seconds: 2)));
      await tester.pumpAndSettle();

      expect(wasAuthenticated, isTrue);
    });
  });
}
