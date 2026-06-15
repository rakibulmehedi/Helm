import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/core/widgets/signal/helm_flow_route.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.dark,
    home: Scaffold(body: child),
  );
}

void main() {
  group('HelmFlowRoute', () {
    testWidgets('renders expected transit usable labels', (tester) async {
      await tester.pumpWidget(
        _wrap(const HelmFlowRoute(activeStage: SignalFlowStage.transit)),
      );

      expect(find.text('EXPECTED'), findsOneWidget);
      expect(find.text('TRANSIT'), findsOneWidget);
      expect(find.text('USABLE'), findsOneWidget);
    });

    testWidgets('announces current flow stage and uses solid text color', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        _wrap(const HelmFlowRoute(activeStage: SignalFlowStage.usable)),
      );

      expect(
        tester.getSemantics(find.byType(HelmFlowRoute)).label,
        equals(
          'Money route: Expected to Transit to Usable. Current stage: Usable',
        ),
      );

      final transitText = tester.widget<Text>(find.text('TRANSIT'));
      expect(transitText.style?.color?.a, equals(1.0));

      handle.dispose();
    });
  });
}
