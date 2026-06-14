// test/features/auth/data/auth_remote_data_source_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:helm/features/auth/data/datasources/auth_remote_data_source.dart';

void main() {
  group('AuthRemoteDataSource — sendMagicLink', () {
    late AuthRemoteDataSource ds;

    setUp(() {
      ds = AuthRemoteDataSource();
    });

    test('returns true for valid email request', () async {
      final result = await ds.sendMagicLink('freelancer@example.com');
      expect(result, isTrue);
    });

    test('rate limits: second request within 20s returns false', () async {
      final first = await ds.sendMagicLink('freelancer@example.com');
      expect(first, isTrue);

      final second = await ds.sendMagicLink('freelancer@example.com');
      expect(second, isFalse);
    });

    test('does not reveal email existence — always returns true on first call', () async {
      // New datasource instance, fresh rate limiter
      final ds2 = AuthRemoteDataSource();
      final result = await ds2.sendMagicLink('does_not_exist@example.com');
      expect(result, isTrue);
    });
  });

  group('AuthRemoteDataSource — verifyMagicLink', () {
    late AuthRemoteDataSource ds;

    setUp(() {
      ds = AuthRemoteDataSource();
    });

    test('returns null for invalid prefix token', () async {
      final result = await ds.verifyMagicLink('invalid_999999');
      expect(result, isNull);
    });

    test('returns SessionEntity for valid token after sendMagicLink', () async {
      await ds.sendMagicLink('freelancer@example.com');
      final token = ds.getIssuedTokenForEmail('freelancer@example.com')!;
      final session = await ds.verifyMagicLink(token);
      expect(session, isNotNull);
      expect(session!.email, equals('freelancer@example.com'));
      expect(session.token, isNotEmpty);
      expect(session.isExpired, isFalse);
    });

    test('token is single-use — second verify returns null', () async {
      await ds.sendMagicLink('freelancer@example.com');
      final token = ds.getIssuedTokenForEmail('freelancer@example.com')!;
      final first = await ds.verifyMagicLink(token);
      expect(first, isNotNull);

      final second = await ds.verifyMagicLink(token);
      expect(second, isNull);
    });

    test('returns null for token with invalid prefix', () async {
      final result = await ds.verifyMagicLink('invalid_123456');
      expect(result, isNull);
    });

    test('session TTL is 30 days from now', () async {
      await ds.sendMagicLink('test@example.com');
      final token = ds.getIssuedTokenForEmail('test@example.com')!;
      final session = await ds.verifyMagicLink(token);
      final remaining = session!.remainingTtl;
      expect(remaining.inDays, greaterThanOrEqualTo(29));
      expect(remaining.inDays, lessThanOrEqualTo(31));
    });
  });

  group('AuthRemoteDataSource — getIssuedTokenForEmail', () {
    test('returns token after sendMagicLink', () async {
      final ds = AuthRemoteDataSource();
      await ds.sendMagicLink('test@example.com');
      final token = ds.getIssuedTokenForEmail('test@example.com');
      expect(token, isNotNull);
      expect(token!.startsWith('valid_'), isTrue);
    });

    test('returns null for email with no issued token', () {
      final ds = AuthRemoteDataSource();
      final token = ds.getIssuedTokenForEmail('no_email@example.com');
      expect(token, isNull);
    });
  });
}
