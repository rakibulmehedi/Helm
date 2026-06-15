import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/core/themes/helm_signal_theme.dart';
import 'package:helm/core/widgets/signal/helm_signal_hero.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.dark,
    home: Scaffold(body: child),
  );
}

HelmSignalHero _hero({double safeToSpend = 36000, VoidCallback? onTapTrace}) {
  return HelmSignalHero(
    safeToSpend: safeToSpend,
    state: SignalDeckState.safe,
    runwayLabel: '12 days runway',
    committedSignal: 'COMMITTED ৳24K',
    heldSignal: 'HELD ৳10K',
    pendingSignal: 'PENDING \$600',
    onTapTrace: onTapTrace ?? () {},
  );
}

void main() {
  group('HelmSignalHero', () {
    testWidgets('shows dominant safe-to-spend answer and supporting signals', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(_hero()));

      expect(find.text('SAFE TO SPEND NOW'), findsOneWidget);
      expect(find.text('৳36,000'), findsOneWidget);
      expect(find.text('12 days runway'), findsOneWidget);
      expect(find.text('COMMITTED ৳24K'), findsOneWidget);
      expect(find.text('HELD ৳10K'), findsOneWidget);
      expect(find.text('PENDING \$600'), findsOneWidget);
    });

    testWidgets('updates amount without counter animation', (tester) async {
      await tester.pumpWidget(_wrap(_hero()));
      expect(find.text('৳36,000'), findsOneWidget);

      await tester.pumpWidget(_wrap(_hero(safeToSpend: 42000)));

      expect(find.text('৳42,000'), findsOneWidget);
      expect(find.text('৳36,000'), findsNothing);
      expect(find.byType(TweenAnimationBuilder<double>), findsNothing);
    });

    testWidgets('starts semantics with safe-to-spend summary', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(_wrap(_hero()));

      expect(
        tester.getSemantics(find.byType(HelmSignalHero)).label,
        startsWith('Safe to spend now'),
      );
      expect(
        tester.getSemantics(find.byType(HelmSignalHero)).label,
        isNot(contains('orbital')),
      );

      handle.dispose();
    });

    testWidgets('runs light haptic before trace tap callback', (tester) async {
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
        _wrap(_hero(onTapTrace: () => events.add('trace'))),
      );

      await tester.tap(find.byType(HelmSignalHero));
      await tester.pump();

      expect(
        events,
        containsAllInOrder(['HapticFeedbackType.lightImpact', 'trace']),
      );
    });
  });
}
