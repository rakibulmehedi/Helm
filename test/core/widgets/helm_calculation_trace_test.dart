import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/widgets/helm_calculation_trace.dart';
import 'package:helm/features/safe_to_spend/domain/entities/safe_to_spend_result.dart';
import 'package:helm/l10n/app_localizations.dart';

const _result = SafeToSpendResult(
  liquidCash: 100000,
  safeToSpend: 45000,
  rawSafeToSpend: 45000,
  fixedCostsDue: 15000,
  anxietyBuffer: 5000,
  taxReserve: 10000,
  totalReceivedIncomeBdt: 100000,
  totalExpenses: 25000,
  pendingIncome: 20000,
  expectedIncome: 30000,
  horizonNumber: 75000,
  excludedUsdIncome: 0,
  excludedUsdEntryCount: 0,
);

void main() {
  testWidgets('trace sheet renders on paper surface', (tester) async {
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
      home: const Scaffold(body: HelmCalculationTrace(result: _result)),
    ));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('signal_trace_sheet')), findsOneWidget);

    final container = tester.widget<Container>(
      find.byKey(const Key('signal_trace_sheet')),
    );
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, HelmColors.light.surface);
  });
}
