import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/core/widgets/buttons/button_multiple_types.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  group('AppButton pressed state', () {
    testWidgets('primary button renders and is tappable', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(_wrap(
        AppButton(
          label: 'Test Button',
          onPressed: () => tapped = true,
        ),
      ));
      await tester.pump();

      expect(find.text('Test Button'), findsOneWidget);
      await tester.tap(find.text('Test Button'));
      expect(tapped, isTrue);
    });

    testWidgets('secondary button renders and is tappable', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(_wrap(
        AppButton(
          label: 'Secondary',
          onPressed: () => tapped = true,
          type: AppButtonType.secondary,
        ),
      ));
      await tester.pump();

      expect(find.text('Secondary'), findsOneWidget);
      await tester.tap(find.text('Secondary'));
      expect(tapped, isTrue);
    });

    testWidgets('outline button renders and is tappable', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(_wrap(
        AppButton(
          label: 'Outline',
          onPressed: () => tapped = true,
          type: AppButtonType.outline,
        ),
      ));
      await tester.pump();

      expect(find.text('Outline'), findsOneWidget);
      await tester.tap(find.text('Outline'));
      expect(tapped, isTrue);
    });

    testWidgets('disabled button does not call onPressed', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(_wrap(
        AppButton(
          label: 'Disabled',
          onPressed: () => tapped = true,
          isEnabled: false,
        ),
      ));
      await tester.pump();

      await tester.tap(find.text('Disabled'));
      expect(tapped, isFalse);
    });

    testWidgets('loading state shows spinner', (tester) async {
      await tester.pumpWidget(_wrap(
        AppButton(
          label: 'Loading',
          onPressed: () {},
          isLoading: true,
        ),
      ));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading'), findsNothing);
    });
  });
}
