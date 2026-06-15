import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/core/themes/helm_signal_theme.dart';
import 'package:helm/core/widgets/helm_calculation_trace.dart';
import 'package:helm/features/safe_to_spend/domain/entities/safe_to_spend_result.dart';

void main() {
  testWidgets('calculation trace uses Signal Deck spatial sheet styling', (
    tester,
  ) async {
    final result = SafeToSpendResult(
      totalReceivedIncomeBdt: 78000,
      totalExpenses: 0,
      liquidCash: 78000,
      taxReserve: 0,
      fixedCostsDue: 24000,
      anxietyBuffer: 10000,
      safeToSpend: 44000,
      rawSafeToSpend: 44000,
      pendingIncome: 0,
      expectedIncome: 0,
      horizonNumber: 44000,
      excludedUsdIncome: 0,
      excludedUsdEntryCount: 0,
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(body: HelmCalculationTrace(result: result)),
      ),
    );

    expect(find.text('How we calculated this'), findsOneWidget);

    final sheet = tester.widget<Container>(
      find.byKey(const Key('signal_trace_sheet')),
    );
    final decoration = sheet.decoration! as BoxDecoration;
    expect(decoration.color, HelmSignalTheme.signalDeck);
    expect(decoration.boxShadow, contains(HelmSignalTheme.floatingSheetShadow));

    final title = tester.widget<Text>(find.text('How we calculated this'));
    expect(title.style?.color, HelmSignalTheme.signalInkPrimary);

    final label = tester.widget<Text>(find.text('+ Received income'));
    expect(label.style?.color, HelmSignalTheme.signalInkSecondary);

    final metadata = tester.widget<Text>(
      find.text('Tap any line to learn more'),
    );
    expect(metadata.style?.color, HelmSignalTheme.signalInkMuted);

    await tester.scrollUntilVisible(find.text('tk 44,000.00'), 120);

    final safeToSpendAmount = tester.widget<Text>(find.text('tk 44,000.00'));
    expect(safeToSpendAmount.style?.color, HelmSignalTheme.signalInkPrimary);

    final finalDivider = tester.widgetList<Divider>(find.byType(Divider)).last;
    expect(finalDivider.color, HelmSignalTheme.signalGlow);
  });
}
