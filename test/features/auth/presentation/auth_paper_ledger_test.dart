// test/features/auth/presentation/auth_paper_ledger_test.dart
//
// Paper Ledger reskin — Task 17 verification.
// Smoke tests confirming MagicLinkScreen renders without errors in
// both light and dark ThemeData variants.

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

Widget _app(ThemeData theme) => ProviderScope(
      child: MaterialApp(
        theme: theme,
        locale: const Locale('en'),
        supportedLocales: const [Locale('en'), Locale('bn')],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: MagicLinkScreen(
          onAuthenticated: () async {},
          onGuest: () async {},
        ),
      ),
    );

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

  group('Paper Ledger reskin — auth smoke tests', () {
    testWidgets('MagicLinkScreen renders in light mode', (tester) async {
      await tester.pumpWidget(_app(AppTheme.light));
      await tester.pump();
      expect(find.byType(MagicLinkScreen), findsOneWidget);
      expect(find.text('Sign in to Helm'), findsOneWidget);
    });

    testWidgets('MagicLinkScreen renders in dark mode', (tester) async {
      await tester.pumpWidget(_app(AppTheme.dark));
      await tester.pump();
      expect(find.byType(MagicLinkScreen), findsOneWidget);
      expect(find.text('Sign in to Helm'), findsOneWidget);
    });
  });
}
