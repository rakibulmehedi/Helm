import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/core/widgets/ledger/helm_ledger_hero.dart';
import 'package:helm/core/widgets/ledger/ledger_state.dart';

Widget _wrap(Widget child) =>
    MaterialApp(theme: AppTheme.light, home: Scaffold(body: child));

HelmLedgerHero _hero({VoidCallback? onTap, bool unavailable = false}) =>
    HelmLedgerHero(
      safeToSpend: 36000,
      state: LedgerState.safe,
      runwayLabel: 'Covers 17 days at your usual pace',
      committedValue: '24,000',
      reserveValue: '10,000',
      pendingValue: r'$600',
      showUnavailable: unavailable,
      onTapTrace: onTap ?? () {},
    );

void main() {
  testWidgets('shows formatted amount and runway', (tester) async {
    await tester.pumpWidget(_wrap(_hero()));
    expect(find.textContaining('36,000'), findsOneWidget);
    expect(find.text('Covers 17 days at your usual pace'), findsOneWidget);
  });

  testWidgets('shows em dash when unavailable', (tester) async {
    await tester.pumpWidget(_wrap(_hero(unavailable: true)));
    expect(find.textContaining('—'), findsOneWidget);
  });

  testWidgets('tapping invokes onTapTrace', (tester) async {
    var tapped = false;
    TestWidgetsFlutterBinding.ensureInitialized();
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(SystemChannels.platform, (_) async => null);
    await tester.pumpWidget(_wrap(_hero(onTap: () => tapped = true)));
    await tester.tap(find.byType(HelmLedgerHero));
    await tester.pump();
    expect(tapped, isTrue);
  });
}
