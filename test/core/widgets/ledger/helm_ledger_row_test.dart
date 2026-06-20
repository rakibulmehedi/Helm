import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/core/widgets/ledger/helm_ledger_row.dart';

Widget _wrap(Widget child) =>
    MaterialApp(theme: AppTheme.light, home: Scaffold(body: child));

void main() {
  testWidgets('renders label and value', (tester) async {
    await tester.pumpWidget(_wrap(
      const HelmLedgerRow(label: 'Already committed', value: '24,000'),
    ));
    expect(find.text('Already committed'), findsOneWidget);
    expect(find.text('24,000'), findsOneWidget);
  });

  testWidgets('muted row exposes muted flag without throwing', (tester) async {
    await tester.pumpWidget(_wrap(
      const HelmLedgerRow(label: 'Not counted yet', value: r'$600', muted: true),
    ));
    expect(find.byType(HelmLedgerRow), findsOneWidget);
    expect(find.text(r'$600'), findsOneWidget);
  });
}
