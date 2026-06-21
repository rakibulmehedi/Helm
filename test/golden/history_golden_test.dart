// test/golden/history_golden_test.dart
//
// Golden tests for the History tab (AuditLogScreen) — Paper Ledger reskin.
// Run with: fvm flutter test test/golden/history_golden_test.dart --update-goldens
// Verify with: fvm flutter test test/golden/history_golden_test.dart
//
// Tagged 'golden' so CI can exclude them (macOS baselines differ from Linux rendering):
//   flutter test --exclude-tags golden
//
// Stability note: All seeded events fall in the `earlier` bucket (>7 days ago)
// so the card labels render as 'MMM d' (e.g. "Jun 9"), which is fully
// deterministic regardless of when the test is run. This avoids the
// relative-label drift that occurs when events are in the today bucket
// (AuditEventCard calls DateTime.now() internally for hAgo/mAgo tokens).

@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/features/audit_log/data/services/audit_chain_service.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';
import 'package:helm/features/audit_log/presentation/providers/audit_providers.dart';
import 'package:helm/features/audit_log/presentation/views/audit_log_screen.dart';
import 'package:helm/l10n/app_localizations.dart';

// Fixed reference time — 2026-06-21 14:00 UTC.
// Both seeded events are >7 days before this date so they land in the
// `earlier` bucket and render deterministic date labels ("Jun 9", "Jun 1").
final _ref = DateTime(2026, 6, 21, 14, 0);

List<AuditEvent> _events() => [
      AuditEvent(
        id: 'a',
        timestamp: _ref.subtract(const Duration(days: 12)), // Jun 9 — earlier
        eventType: AuditEventType.created,
        entityType: AuditEntityType.income,
        entityId: 'e1',
        newValue: '100',
        description: 'Added income',
      ),
      AuditEvent(
        id: 'b',
        timestamp: _ref.subtract(const Duration(days: 20)), // Jun 1 — earlier
        eventType: AuditEventType.confirmed,
        entityType: AuditEntityType.income,
        entityId: 'e2',
        description: 'Confirmed received',
      ),
    ];

Widget _app(ThemeData theme) => ProviderScope(
      overrides: [
        auditEventsProvider.overrideWith((ref) async => _events()),
        auditIntegrityProvider.overrideWith((ref) async =>
            const ChainVerification(isIntact: true, verifiedCount: 2)),
      ],
      child: MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: MaterialApp(
          theme: theme,
          locale: const Locale('en'),
          supportedLocales: const [Locale('en'), Locale('bn')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const AuditLogScreen(),
        ),
      ),
    );

void main() {
  testWidgets('history light golden', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_app(AppTheme.light));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(AuditLogScreen),
      matchesGoldenFile('goldens/history_light.png'),
    );
  });

  testWidgets('history dark golden', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_app(AppTheme.dark));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(AuditLogScreen),
      matchesGoldenFile('goldens/history_dark.png'),
    );
  });
}
