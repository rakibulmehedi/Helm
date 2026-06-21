// test/features/audit_log/presentation/audit_event_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';
import 'package:helm/features/audit_log/presentation/widgets/audit_event_card.dart';
import 'package:helm/l10n/app_localizations.dart';

void main() {
  testWidgets('tapping a card opens the detail sheet', (tester) async {
    final event = AuditEvent(
      id: 'a',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      eventType: AuditEventType.created,
      entityType: AuditEntityType.income,
      entityId: 'e1',
      newValue: 'NEW-1',
      description: 'Added income',
    );
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('en'),
          supportedLocales: const [Locale('en'), Locale('bn')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Scaffold(body: AuditEventCard(event: event)),
        ),
      ),
    );
    await tester.tap(find.byType(AuditEventCard));
    await tester.pumpAndSettle();
    // The sheet shows the description.
    expect(find.text('Added income'), findsWidgets);
  });
}
