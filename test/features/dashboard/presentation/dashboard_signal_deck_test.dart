import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('dashboard composes Paper Ledger widgets instead of Reality Stack', () {
    final source = File(
      'lib/features/dashboard/presentation/views/dashboard_screen.dart',
    ).readAsStringSync();

    expect(source, contains('HelmLedgerHero'));
    expect(source, contains('HelmNextEventCard'));
    expect(source, contains('showUnavailable: _showUnavailableAmount'));
    expect(source, isNot(contains('HelmRealityStack(')));
  });

  test('dashboard keeps trace opening instrumentation', () {
    final source = File(
      'lib/features/dashboard/presentation/views/dashboard_screen.dart',
    ).readAsStringSync();

    expect(source, contains('TransactionalEvents.calculationBreakdownOpened'));
    expect(source, contains('HelmCalculationTrace.show'));
  });

  test('dashboard does not label expected income as pending', () {
    final source = File(
      'lib/features/dashboard/presentation/views/dashboard_screen.dart',
    ).readAsStringSync();

    expect(
      source,
      contains('_compactBdtValue(stsResult.pendingIncome)'),
    );
    expect(source, isNot(contains('pendingIncome + stsResult.expectedIncome')));
  });
}
