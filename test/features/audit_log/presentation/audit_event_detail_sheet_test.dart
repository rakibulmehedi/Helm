// test/features/audit_log/presentation/audit_event_detail_sheet_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';
import 'package:helm/features/audit_log/presentation/widgets/audit_event_detail_sheet.dart';
import 'package:helm/l10n/app_localizations.dart';

void main() {
  testWidgets('shows before and after values', (tester) async {
    final event = AuditEvent(
      id: 'a',
      timestamp: DateTime(2026, 6, 1, 10, 30),
      eventType: AuditEventType.updated,
      entityType: AuditEntityType.income,
      entityId: 'e1',
      previousValue: 'OLD-123',
      newValue: 'NEW-456',
      description: 'Amount changed',
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
          home: Scaffold(body: AuditEventDetailSheet(event: event)),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('OLD-123'), findsOneWidget);
    expect(find.text('NEW-456'), findsOneWidget);
    expect(find.text('Amount changed'), findsOneWidget);
  });
}
