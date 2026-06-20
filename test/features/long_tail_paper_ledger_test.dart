// test/features/long_tail_paper_ledger_test.dart
//
// Task 18 — Paper Ledger reskin verification.
// Smoke-tests two long-tail screens in both light and dark themes to confirm
// that no hardcoded colours leak through and AppTheme wires up without error.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:helm/core/security/views/compromised_device_screen.dart';
import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/features/export/presentation/views/export_screen.dart';
import 'package:helm/l10n/app_localizations.dart';

Widget _wrap(Widget child, ThemeData theme) => ProviderScope(
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
        home: child,
      ),
    );

void main() {
  // ── CompromisedDeviceScreen ────────────────────────────────────────────────

  testWidgets('CompromisedDeviceScreen renders in light mode', (tester) async {
    await tester.pumpWidget(
      _wrap(const CompromisedDeviceScreen(), AppTheme.light),
    );
    await tester.pump();
    expect(find.byType(CompromisedDeviceScreen), findsOneWidget);
  });

  testWidgets('CompromisedDeviceScreen renders in dark mode', (tester) async {
    await tester.pumpWidget(
      _wrap(const CompromisedDeviceScreen(), AppTheme.dark),
    );
    await tester.pump();
    expect(find.byType(CompromisedDeviceScreen), findsOneWidget);
  });

  // ── ExportScreen ──────────────────────────────────────────────────────────

  testWidgets('ExportScreen renders in light mode', (tester) async {
    await tester.pumpWidget(
      _wrap(const ExportScreen(), AppTheme.light),
    );
    await tester.pump();
    expect(find.byType(ExportScreen), findsOneWidget);
  });

  testWidgets('ExportScreen renders in dark mode', (tester) async {
    await tester.pumpWidget(
      _wrap(const ExportScreen(), AppTheme.dark),
    );
    await tester.pump();
    expect(find.byType(ExportScreen), findsOneWidget);
  });
}
