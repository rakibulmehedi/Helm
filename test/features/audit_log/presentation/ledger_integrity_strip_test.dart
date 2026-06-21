import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/features/audit_log/data/services/audit_chain_service.dart';
import 'package:helm/features/audit_log/presentation/providers/audit_providers.dart';
import 'package:helm/features/audit_log/presentation/widgets/ledger_integrity_strip.dart';
import 'package:helm/l10n/app_localizations.dart';

Widget _host(Override override) => ProviderScope(
      overrides: [override],
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
        home: const Scaffold(body: LedgerIntegrityStrip()),
      ),
    );

void main() {
  testWidgets('intact → verified copy with count', (tester) async {
    await tester.pumpWidget(_host(
      auditIntegrityProvider.overrideWith((ref) async =>
          const ChainVerification(isIntact: true, verifiedCount: 4)),
    ));
    await tester.pump();
    expect(find.textContaining('4'), findsOneWidget);
    expect(find.textContaining('verified'), findsOneWidget);
  });

  testWidgets('broken → issue copy', (tester) async {
    await tester.pumpWidget(_host(
      auditIntegrityProvider.overrideWith((ref) async =>
          const ChainVerification(
              isIntact: false, verifiedCount: 1, firstBrokenEventId: 'b')),
    ));
    await tester.pump();
    expect(find.textContaining('Integrity issue'), findsOneWidget);
  });
}
