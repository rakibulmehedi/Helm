import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/core/themes/helm_signal_theme.dart';
import 'package:helm/core/widgets/signal/helm_decision_deck.dart';
import 'package:helm/core/widgets/signal/helm_flow_route.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.dark,
    home: Scaffold(body: child),
  );
}

void main() {
  group('HelmDecisionDeck', () {
    testWidgets('shows one event, one CTA, trace control, and flow route', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          HelmDecisionDeck(
            eventLabel: 'NEXT EVENT',
            eventTitle: 'Client payment expected tomorrow',
            actionLabel: 'REVIEW COMMITMENTS',
            onAction: () {},
            onTrace: () {},
            flowStage: SignalFlowStage.expected,
          ),
        ),
      );

      expect(find.text('NEXT EVENT'), findsOneWidget);
      expect(find.text('Client payment expected tomorrow'), findsOneWidget);
      expect(find.text('REVIEW COMMITMENTS'), findsOneWidget);
      expect(find.text('VIEW TRACE'), findsOneWidget);
      expect(find.text('EXPECTED'), findsOneWidget);
      expect(find.text('TRANSIT'), findsOneWidget);
      expect(find.text('USABLE'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('uses decision shadow and semantic event/action summary', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        _wrap(
          HelmDecisionDeck(
            eventLabel: 'NEXT EVENT',
            eventTitle: 'Client payment expected tomorrow',
            actionLabel: 'REVIEW COMMITMENTS',
            onAction: () {},
            onTrace: () {},
            flowStage: SignalFlowStage.expected,
          ),
        ),
      );

      final deck = tester.widget<Container>(
        find.byKey(const Key('signal_decision_deck')),
      );
      final decoration = deck.decoration! as BoxDecoration;
      expect(
        decoration.boxShadow,
        contains(HelmSignalTheme.decisionDeckShadow),
      );

      expect(
        tester.getSemantics(find.byType(HelmDecisionDeck)).label,
        contains('Client payment expected tomorrow'),
      );
      expect(
        tester.getSemantics(find.byType(HelmDecisionDeck)).label,
        contains('REVIEW COMMITMENTS'),
      );

      handle.dispose();
    });

    testWidgets('runs light haptic before CTA callback and trace callback', (
      tester,
    ) async {
      final events = <String>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'HapticFeedback.vibrate') {
            events.add(call.arguments! as String);
          }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );

      await tester.pumpWidget(
        _wrap(
          HelmDecisionDeck(
            eventLabel: 'NEXT EVENT',
            eventTitle: 'Client payment expected tomorrow',
            actionLabel: 'REVIEW COMMITMENTS',
            onAction: () => events.add('action'),
            onTrace: () => events.add('trace'),
            flowStage: SignalFlowStage.expected,
          ),
        ),
      );

      await tester.tap(find.text('REVIEW COMMITMENTS'));
      await tester.pump();
      await tester.tap(find.text('VIEW TRACE'));
      await tester.pump();

      expect(events.first, equals('HapticFeedbackType.lightImpact'));
      expect(
        events,
        containsAllInOrder(['HapticFeedbackType.lightImpact', 'action']),
      );
      expect(events, contains('trace'));
    });
  });
}
