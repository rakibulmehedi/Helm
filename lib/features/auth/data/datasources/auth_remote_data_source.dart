// lib/features/auth/data/datasources/auth_remote_data_source.dart
//
// Abstracted HTTP client for Magic Link auth backend.
// Currently: mock implementation with simulated delays.
// To swap in real backend: implement with http.Client and real API calls.
//
// SECURITY NOTE: This is a client-side mock. It uses cryptographically secure
// random tokens so the mock is not trivially brute-forceable, but production
// MUST validate tokens on a backend server.

import 'dart:math';

import 'package:helm/features/auth/domain/entities/session_entity.dart';

class AuthRemoteDataSource {
  static const _magicLinkRateLimitSeconds = 20;
  static const _magicLinkTokenTtlMinutes = 5;
  static const _sessionTokenLength = 32;

  final Duration tokenTtl;
  final _random = Random.secure();

  AuthRemoteDataSource({this.tokenTtl = const Duration(minutes: _magicLinkTokenTtlMinutes)});

  final _emailTokens = <String, _TokenRecord>{}; // email → latest token
  final _usedTokens = <String>{};

  /// Sends a Magic Link email. Returns true if accepted (202).
  /// In mock mode: auto-issues a valid token so verifyMagicLink can succeed.
  /// Rate limited: max 1 request per [_magicLinkRateLimitSeconds] seconds per email.
  Future<bool> sendMagicLink(String email) async {
    final now = DateTime.now();
    final existing = _emailTokens[email];

    if (existing != null &&
        now.difference(existing.issuedAt).inSeconds <
            _magicLinkRateLimitSeconds) {
      return false;
    }

    final token = _generateToken();
    _emailTokens[email] = _TokenRecord(
      token: token,
      email: email,
      issuedAt: now,
      expiresAt: now.add(tokenTtl),
    );

    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 400));

    return true;
  }

  /// Verifies a Magic Link token and returns a [SessionEntity] if valid.
  /// In mock mode: checks that the token was issued, has not expired, has not
  /// been used, and matches the email it was issued for. In production: backend
  /// validates token, expiry, and single-use.
  Future<SessionEntity?> verifyMagicLink(String token, {String? email}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    if (_usedTokens.contains(token)) return null;

    final record = _emailTokens.values.cast<_TokenRecord?>().firstWhere(
          (r) => r?.token == token,
          orElse: () => null,
        );
    if (record == null) return null;
    if (DateTime.now().isAfter(record.expiresAt)) return null;
    if (email != null && email != record.email) return null;

    _usedTokens.add(token);

    return SessionEntity(
      userId: 'user_${_random.nextInt(9999)}',
      email: record.email,
      token: _generateToken(),
      expiresAt: DateTime.now().add(const Duration(days: 30)),
      createdAt: DateTime.now(),
    );
  }

  /// Returns the most recent mock token issued for [email], or null.
  /// In production: the backend emails the token; here: returned for dev/testing.
  String? getIssuedTokenForEmail(String email) {
    final record = _emailTokens[email];
    if (record == null || DateTime.now().isAfter(record.expiresAt)) return null;
    return record.token;
  }

  String _generateToken() {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(
      _sessionTokenLength,
      (_) => chars[_random.nextInt(chars.length)],
    ).join();
  }
}

class _TokenRecord {
  _TokenRecord({
    required this.token,
    required this.email,
    required this.issuedAt,
    required this.expiresAt,
  });

  final String token;
  final String email;
  final DateTime issuedAt;
  final DateTime expiresAt;
}
