import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/core/themes/helm_signal_theme.dart';
import 'package:helm/core/widgets/signal/helm_signal_horizon.dart';

Widget _wrap(Widget child, {bool disableAnimations = false}) {
  return MaterialApp(
    theme: AppTheme.dark,
    home: MediaQuery(
      data: MediaQueryData(disableAnimations: disableAnimations),
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  group('HelmSignalHorizon', () {
    testWidgets('exposes state semantics and state color', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        _wrap(const HelmSignalHorizon(state: SignalDeckState.tight)),
      );

      expect(
        tester.getSemantics(find.byType(HelmSignalHorizon)).label,
        equals('Signal horizon: Tight'),
      );

      final line = tester.widget<Container>(
        find.byKey(const Key('signal_horizon_line')),
      );
      final decoration = line.decoration! as BoxDecoration;
      expect(decoration.color, equals(HelmSignalTheme.tight));

      handle.dispose();
    });

    testWidgets('does not start pulse animation when motion is disabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const HelmSignalHorizon(
            state: SignalDeckState.safe,
            animatePulse: true,
          ),
          disableAnimations: true,
        ),
      );

      await tester.pump(const Duration(milliseconds: 300));

      expect(tester.hasRunningAnimations, isFalse);
    });
  });
}
