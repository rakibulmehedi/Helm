// test/core/nudge/domain/nudge_log_entry_entity_test.dart
//
// Tests for NudgeLogEntryEntity (Phase 3, Group 3C domain).

import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/nudge/domain/nudge_log_entry_entity.dart';
import 'package:helm/core/nudge/domain/nudge_types.dart';

void main() {
  group('NudgeLogEntryEntity', () {
    final now = DateTime(2026, 6, 12, 10, 0, 0);

    test('stores read status, type, timestamp, body, actionRoute', () {
      final entry = NudgeLogEntryEntity(
        id: 'n-001',
        nudgeType: NudgeType.confirmOverdue,
        channel: NudgeChannel.push,
        title: 'Test title',
        body: 'Test body',
        actionRoute: '/pipeline',
        targetEntryId: 'entry-1',
        createdAt: now,
      );

      expect(entry.id, equals('n-001'));
      expect(entry.nudgeType, equals(NudgeType.confirmOverdue));
      expect(entry.channel, equals(NudgeChannel.push));
      expect(entry.title, equals('Test title'));
      expect(entry.body, equals('Test body'));
      expect(entry.actionRoute, equals('/pipeline'));
      expect(entry.targetEntryId, equals('entry-1'));
      expect(entry.createdAt, equals(now));
      expect(entry.isRead, isFalse);
      expect(entry.isActioned, isFalse);
    });

    test('isRead returns true when readAt is set', () {
      final entry = NudgeLogEntryEntity(
        id: 'n-002',
        nudgeType: NudgeType.reEngagement,
        channel: NudgeChannel.push,
        title: 'Title',
        body: 'Body',
        createdAt: now,
        readAt: now.add(const Duration(minutes: 5)),
      );

      expect(entry.isRead, isTrue);
      expect(entry.timeToRead, equals(const Duration(minutes: 5)));
    });

    test('isActioned returns true when actionedAt is set', () {
      final entry = NudgeLogEntryEntity(
        id: 'n-003',
        nudgeType: NudgeType.reviewFixedCosts,
        channel: NudgeChannel.inAppOnly,
        title: 'Title',
        body: 'Body',
        createdAt: now,
        actionedAt: now.add(const Duration(minutes: 10)),
      );

      expect(entry.isActioned, isTrue);
      expect(entry.timeToAction, equals(const Duration(minutes: 10)));
    });

    test('copyWith preserves non-overridden fields', () {
      final entry = NudgeLogEntryEntity(
        id: 'n-004',
        nudgeType: NudgeType.reliefSignal,
        channel: NudgeChannel.quiet,
        title: 'Original',
        body: 'Body',
        createdAt: now,
      );

      final updated = entry.copyWith(readAt: now);
      expect(updated.id, equals('n-004'));
      expect(updated.title, equals('Original'));
      expect(updated.readAt, equals(now));
    });

    test('copyWith can clear readAt and actionedAt', () {
      final entry = NudgeLogEntryEntity(
        id: 'n-005',
        nudgeType: NudgeType.confirmOverdue,
        channel: NudgeChannel.push,
        title: 'Title',
        body: 'Body',
        createdAt: now,
        readAt: now,
        actionedAt: now,
      );

      final cleared = entry.copyWith(clearReadAt: true, clearActionedAt: true);
      expect(cleared.isRead, isFalse);
      expect(cleared.isActioned, isFalse);
    });

    test('equality is based on id', () {
      final a = NudgeLogEntryEntity(
        id: 'same-id',
        nudgeType: NudgeType.confirmOverdue,
        channel: NudgeChannel.push,
        title: 'A',
        body: 'Body A',
        createdAt: now,
      );
      final b = NudgeLogEntryEntity(
        id: 'same-id',
        nudgeType: NudgeType.reEngagement,
        channel: NudgeChannel.inAppOnly,
        title: 'B',
        body: 'Body B',
        createdAt: now.add(const Duration(hours: 1)),
      );

      expect(a == b, isTrue);
      expect(a.hashCode, equals(b.hashCode));
    });
  });
}
