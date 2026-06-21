// test/features/audit_log/presentation/audit_event_presentation_test.dart
//
// Exhaustive coverage for audit_event_presentation.dart —
// all 6 event types and 5 entity types across all 4 public functions.
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';
import 'package:helm/features/audit_log/presentation/utils/audit_event_presentation.dart';
import 'package:helm/l10n/app_localizations.dart';

// ── Helpers ───────────────────────────────────────────────────────────────────

class _L10nProbe extends StatelessWidget {
  const _L10nProbe({required this.onBuilt});
  final void Function(AppLocalizations) onBuilt;

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      color: const Color(0xFF000000),
      locale: const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('bn')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, _) {
        onBuilt(AppLocalizations.of(context)!);
        return const SizedBox.shrink();
      },
    );
  }
}

AuditEvent _event(AuditEventType et, AuditEntityType ent) => AuditEvent(
      id: 'x',
      timestamp: DateTime(2026),
      eventType: et,
      entityType: ent,
      entityId: 'e1',
      description: 'desc',
    );

// ── auditIconFor ──────────────────────────────────────────────────────────────

void main() {
  group('auditIconFor', () {
    test('created → add_circle_outline', () {
      expect(auditIconFor(AuditEventType.created), Icons.add_circle_outline);
    });
    test('updated → edit_outlined', () {
      expect(auditIconFor(AuditEventType.updated), Icons.edit_outlined);
    });
    test('deleted → delete_outline', () {
      expect(auditIconFor(AuditEventType.deleted), Icons.delete_outline);
    });
    test('confirmed → check_circle_outline', () {
      expect(auditIconFor(AuditEventType.confirmed), Icons.check_circle_outline);
    });
    test('exported → upload_outlined', () {
      expect(auditIconFor(AuditEventType.exported), Icons.upload_outlined);
    });
    test('unknown → help_outline', () {
      expect(auditIconFor(AuditEventType.unknown), Icons.help_outline);
    });
  });

  // ── auditColorFor ────────────────────────────────────────────────────────────

  group('auditColorFor (light palette)', () {
    const c = HelmColors.light;
    test('created → stateSafe', () {
      expect(auditColorFor(c, AuditEventType.created), c.stateSafe);
    });
    test('updated → interactive', () {
      expect(auditColorFor(c, AuditEventType.updated), c.interactive);
    });
    test('deleted → stateAtRisk', () {
      expect(auditColorFor(c, AuditEventType.deleted), c.stateAtRisk);
    });
    test('confirmed → stateSafe', () {
      expect(auditColorFor(c, AuditEventType.confirmed), c.stateSafe);
    });
    test('exported → stateTight', () {
      expect(auditColorFor(c, AuditEventType.exported), c.stateTight);
    });
    test('unknown → inkTertiary', () {
      expect(auditColorFor(c, AuditEventType.unknown), c.inkTertiary);
    });
  });

  // ── auditEntityLabel ─────────────────────────────────────────────────────────

  group('auditEntityLabel', () {
    testWidgets('all entity types resolve to non-empty strings', (tester) async {
      late AppLocalizations l10n;
      await tester.pumpWidget(_L10nProbe(onBuilt: (v) => l10n = v));

      expect(auditEntityLabel(AuditEntityType.income, l10n), isNotEmpty);
      expect(auditEntityLabel(AuditEntityType.transaction, l10n), isNotEmpty);
      expect(auditEntityLabel(AuditEntityType.stsSettings, l10n), isNotEmpty);
      expect(auditEntityLabel(AuditEntityType.fixedCost, l10n), isNotEmpty);
      expect(auditEntityLabel(AuditEntityType.unknown, l10n), isNotEmpty);
    });

    testWidgets('income label is "Income"', (tester) async {
      late AppLocalizations l10n;
      await tester.pumpWidget(_L10nProbe(onBuilt: (v) => l10n = v));
      expect(auditEntityLabel(AuditEntityType.income, l10n), 'Income');
    });

    testWidgets('stsSettings label is "Settings"', (tester) async {
      late AppLocalizations l10n;
      await tester.pumpWidget(_L10nProbe(onBuilt: (v) => l10n = v));
      expect(auditEntityLabel(AuditEntityType.stsSettings, l10n), 'Settings');
    });
  });

  // ── auditTitleFor ─────────────────────────────────────────────────────────────

  group('auditTitleFor', () {
    testWidgets('created event includes entity label', (tester) async {
      late AppLocalizations l10n;
      await tester.pumpWidget(_L10nProbe(onBuilt: (v) => l10n = v));
      final title = auditTitleFor(
          _event(AuditEventType.created, AuditEntityType.income), l10n);
      expect(title, contains('Income'));
    });

    testWidgets('updated event includes entity label', (tester) async {
      late AppLocalizations l10n;
      await tester.pumpWidget(_L10nProbe(onBuilt: (v) => l10n = v));
      final title = auditTitleFor(
          _event(AuditEventType.updated, AuditEntityType.transaction), l10n);
      expect(title, contains('Transaction'));
    });

    testWidgets('deleted event produces non-empty string', (tester) async {
      late AppLocalizations l10n;
      await tester.pumpWidget(_L10nProbe(onBuilt: (v) => l10n = v));
      final title = auditTitleFor(
          _event(AuditEventType.deleted, AuditEntityType.fixedCost), l10n);
      expect(title, isNotEmpty);
    });

    testWidgets('confirmed event produces non-empty string', (tester) async {
      late AppLocalizations l10n;
      await tester.pumpWidget(_L10nProbe(onBuilt: (v) => l10n = v));
      final title = auditTitleFor(
          _event(AuditEventType.confirmed, AuditEntityType.income), l10n);
      expect(title, isNotEmpty);
    });

    testWidgets('exported event produces non-empty string', (tester) async {
      late AppLocalizations l10n;
      await tester.pumpWidget(_L10nProbe(onBuilt: (v) => l10n = v));
      final title = auditTitleFor(
          _event(AuditEventType.exported, AuditEntityType.stsSettings), l10n);
      expect(title, isNotEmpty);
    });

    testWidgets('unknown event produces non-empty string', (tester) async {
      late AppLocalizations l10n;
      await tester.pumpWidget(_L10nProbe(onBuilt: (v) => l10n = v));
      final title = auditTitleFor(
          _event(AuditEventType.unknown, AuditEntityType.unknown), l10n);
      expect(title, isNotEmpty);
    });
  });
}
