// test/features/auth/data/auth_remote_data_source_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:helm/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:helm/features/auth/data/datasources/used_magic_link_token_store.dart';

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

    test('rate limit is per-email', () async {
      await ds.sendMagicLink('a@example.com');
      final other = await ds.sendMagicLink('b@example.com');
      expect(other, isTrue);
    });

    test('does not reveal email existence — always returns true on first call',
        () async {
      final ds2 = AuthRemoteDataSource();
      final result = await ds2.sendMagicLink('does_not_exist@example.com');
      expect(result, isTrue);
    });

    test('issues long alphanumeric token', () async {
      await ds.sendMagicLink('freelancer@example.com');
      final token = ds.getIssuedTokenForEmail('freelancer@example.com')!;
      expect(token.length, greaterThanOrEqualTo(32));
      expect(token, matches(r'^[A-Za-z0-9]+$'));
    });
  });

  group('AuthRemoteDataSource — verifyMagicLink', () {
    late AuthRemoteDataSource ds;

    setUp(() {
      ds = AuthRemoteDataSource();
    });

    test('returns null for unknown token', () async {
      final result = await ds.verifyMagicLink('not_a_real_token');
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

    test('returns null for expired token', () async {
      final shortDs = AuthRemoteDataSource(
        tokenTtl: const Duration(milliseconds: 700),
      );
      await shortDs.sendMagicLink('test@example.com');
      final token = shortDs.getIssuedTokenForEmail('test@example.com')!;

      // Expire the issued token record by advancing past its TTL.
      await Future<void>.delayed(const Duration(milliseconds: 800));

      final result = await shortDs.verifyMagicLink(token);
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
      expect(token!.length, greaterThanOrEqualTo(32));
    });

    test('returns null for email with no issued token', () {
      final ds = AuthRemoteDataSource();
      final token = ds.getIssuedTokenForEmail('no_email@example.com');
      expect(token, isNull);
    });
  });

  group('AuthRemoteDataSource — token single-use across instances', () {
    late AuthRemoteDataSource ds;

    setUp(() {
      ds = AuthRemoteDataSource(
        usedTokenStore: InMemoryUsedMagicLinkTokenStore(),
      );
    });

    test('second verify from new data source returns null after first use',
        () async {
      await ds.sendMagicLink('freelancer@example.com');
      final token = ds.getIssuedTokenForEmail('freelancer@example.com')!;

      final first = await ds.verifyMagicLink(token);
      expect(first, isNotNull);

      final ds2 = AuthRemoteDataSource(
        usedTokenStore: ds.usedTokenStore,
      );
      final second = await ds2.verifyMagicLink(token);
      expect(second, isNull);
    });
  });

  group('AuthRemoteDataSource — concurrent calls', () {
    test('concurrent verifyMagicLink for same token returns only one session',
        () async {
      final ds = AuthRemoteDataSource(
        usedTokenStore: InMemoryUsedMagicLinkTokenStore(),
      );
      await ds.sendMagicLink('freelancer@example.com');
      final token = ds.getIssuedTokenForEmail('freelancer@example.com')!;

      final results = await Future.wait([
        ds.verifyMagicLink(token),
        ds.verifyMagicLink(token),
      ]);

      final successful = results.where((r) => r != null).length;
      expect(successful, 1);
    });

    test('concurrent sendMagicLink for same email is rate limited',
        () async {
      final ds = AuthRemoteDataSource();
      final results = await Future.wait([
        ds.sendMagicLink('freelancer@example.com'),
        ds.sendMagicLink('freelancer@example.com'),
      ]);

      expect(results.where((r) => r).length, 1);
      expect(results.where((r) => !r).length, 1);
    });
  });
}
