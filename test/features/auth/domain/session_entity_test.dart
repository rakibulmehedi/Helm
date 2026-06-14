// test/features/auth/domain/session_entity_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:helm/features/auth/domain/entities/session_entity.dart';

void main() {
  group('SessionEntity', () {
    final baseSession = SessionEntity(
      userId: 'user_42',
      email: 'freelancer@example.com',
      token: 'tok_abc123',
      expiresAt: DateTime.now().add(const Duration(days: 30)),
      createdAt: DateTime.now(),
    );

    test('isExpired returns false for future expiry', () {
      final session = SessionEntity(
        userId: 'u1',
        email: 'a@b.com',
        token: 'tok',
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
        createdAt: DateTime.now(),
      );
      expect(session.isExpired, isFalse);
    });

    test('isExpired returns true for past expiry', () {
      final session = SessionEntity(
        userId: 'u1',
        email: 'a@b.com',
        token: 'tok',
        expiresAt: DateTime.now().subtract(const Duration(hours: 1)),
        createdAt: DateTime.now(),
      );
      expect(session.isExpired, isTrue);
    });

    test('remainingTtl is positive for future expiry', () {
      final session = SessionEntity(
        userId: 'u1',
        email: 'a@b.com',
        token: 'tok',
        expiresAt: DateTime.now().add(const Duration(days: 1)),
        createdAt: DateTime.now(),
      );
      expect(session.remainingTtl.inHours, greaterThanOrEqualTo(23));
    });

    test('copyWith updates specified fields', () {
      final updated = baseSession.copyWith(email: 'new@example.com');
      expect(updated.email, equals('new@example.com'));
      expect(updated.userId, equals(baseSession.userId));
      expect(updated.token, equals(baseSession.token));
    });

    test('equality: same userId+token → equal', () {
      final s1 = SessionEntity(
        userId: 'u1', email: 'a@b.com', token: 'tok',
        expiresAt: DateTime.now(), createdAt: DateTime.now(),
      );
      final s2 = SessionEntity(
        userId: 'u1', email: 'c@d.com', token: 'tok',
        expiresAt: DateTime.now().add(const Duration(days: 1)),
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      );
      expect(s1, equals(s2));
    });

    test('equality: different token → not equal', () {
      final s1 = SessionEntity(
        userId: 'u1', email: 'a@b.com', token: 'tok_a',
        expiresAt: DateTime.now(), createdAt: DateTime.now(),
      );
      final s2 = SessionEntity(
        userId: 'u1', email: 'a@b.com', token: 'tok_b',
        expiresAt: DateTime.now(), createdAt: DateTime.now(),
      );
      expect(s1, isNot(equals(s2)));
    });
  });
}
