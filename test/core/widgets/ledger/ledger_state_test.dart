import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/widgets/ledger/ledger_state.dart';

void main() {
  test('labels map correctly', () {
    expect(ledgerStateLabel(LedgerState.safe), 'Stable');
    expect(ledgerStateLabel(LedgerState.tight), 'Tight');
    expect(ledgerStateLabel(LedgerState.atRisk), 'At Risk');
  });

  testWidgets('colors resolve from HelmColors', (tester) async {
    late BuildContext ctx;
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.light,
      home: Builder(builder: (c) {
        ctx = c;
        return const SizedBox();
      }),
    ));
    expect(ledgerStateColor(ctx, LedgerState.safe), HelmColors.light.stateSafe);
    expect(ledgerStateColor(ctx, LedgerState.tight), HelmColors.light.stateTight);
    expect(ledgerStateColor(ctx, LedgerState.atRisk), HelmColors.light.stateAtRisk);
  });
}
