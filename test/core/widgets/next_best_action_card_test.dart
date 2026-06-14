// test/core/widgets/next_best_action_card_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/core/widgets/next_best_action_card.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: child,
      ),
    );
  }

  group('NextBestActionCard widget tests', () {
    testWidgets('shows overdue variant when overdue count > 0', (tester) async {
      await tester.pumpWidget(buildTestableWidget(
        const NextBestActionCard(
          variant: ActionVariant.overdue,
          count: 2,
        ),
      ));

      expect(find.text('2 payments overdue'), findsOneWidget);
      expect(find.text('Update status of overdue pipeline payments.'), findsOneWidget);
      expect(find.text('Review'), findsOneWidget);
    });

    testWidgets('shows atRisk variant when S2S is tight', (tester) async {
      await tester.pumpWidget(buildTestableWidget(
        const NextBestActionCard(
          variant: ActionVariant.atRisk,
        ),
      ));

      expect(find.text('Safe-to-spend is tight'), findsOneWidget);
      expect(find.text('Review your fixed monthly costs to release pressure.'), findsOneWidget);
      expect(find.text('Review fixed costs'), findsOneWidget);
    });

    testWidgets('shows relief variant when pipeline up to date', (tester) async {
      await tester.pumpWidget(buildTestableWidget(
        const NextBestActionCard(
          variant: ActionVariant.relief,
        ),
      ));

      expect(find.text('Pipeline up to date'), findsOneWidget);
      expect(find.text('All payments are on schedule and tracked.'), findsOneWidget);
      expect(find.text('Review'), findsNothing);
    });

    testWidgets('shows setup variant when pipeline empty', (tester) async {
      await tester.pumpWidget(buildTestableWidget(
        const NextBestActionCard(
          variant: ActionVariant.setup,
        ),
      ));

      expect(find.text('Add your first expected payment'), findsOneWidget);
      expect(find.text('Track upcoming income to compute Safe-to-Spend.'), findsOneWidget);
      expect(find.text('Add payment'), findsOneWidget);
    });

    testWidgets('triggers callback when button is tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(buildTestableWidget(
        NextBestActionCard(
          variant: ActionVariant.setup,
          onActionPressed: () {
            tapped = true;
          },
        ),
      ));

      await tester.tap(find.text('Add payment'));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });

    testWidgets('Semantics announces correctly', (tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(buildTestableWidget(
        const NextBestActionCard(
          variant: ActionVariant.relief,
        ),
      ));

      expect(
        tester.getSemantics(find.byType(NextBestActionCard)).label,
        equals('Pipeline up to date. All payments are on schedule and tracked.'),
      );
      handle.dispose();
    });
  });
}
