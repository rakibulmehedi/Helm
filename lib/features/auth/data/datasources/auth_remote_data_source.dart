// lib/features/auth/data/datasources/auth_remote_data_source.dart
//
// Abstracted HTTP client for Magic Link auth backend.
// Currently: mock implementation with simulated delays.
// To swap in real backend: implement with http.Client and real API calls.

import 'dart:math';

import 'package:helm/features/auth/domain/entities/session_entity.dart';

class AuthRemoteDataSource {
  static const _magicLinkRateLimitSeconds = 20;

  DateTime? _lastMagicLinkRequest;
  final _issuedTokens = <String>{};
  final _usedTokens = <String>{};
  final _emailTokens = <String, String>{}; // email → latest token

  /// Sends a Magic Link email. Returns true if accepted (202).
  /// In mock mode: auto-issues a valid token so verifyMagicLink can succeed.
  /// Rate limited: max 1 request per [_magicLinkRateLimitSeconds] seconds.
  Future<bool> sendMagicLink(String email) async {
    final now = DateTime.now();

    if (_lastMagicLinkRequest != null &&
        now.difference(_lastMagicLinkRequest!).inSeconds < _magicLinkRateLimitSeconds) {
      return false;
    }

    _lastMagicLinkRequest = now;

    // Auto-issue mock token for this email
    final token = 'valid_${Random().nextInt(999999).toString().padLeft(6, '0')}';
    _issuedTokens.add(token);
    _emailTokens[email] = token;

    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 400));

    return true;
  }

  /// Verifies a Magic Link token and returns a [SessionEntity] if valid.
  /// In mock mode: any token with `valid_` prefix that hasn't been used already
  /// is accepted. In production: backend validates token, expiry, and single-use.
  Future<SessionEntity?> verifyMagicLink(String token) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    if (token.startsWith('valid_') && !_usedTokens.contains(token)) {
      _usedTokens.add(token);

      return SessionEntity(
        userId: 'user_${Random().nextInt(9999)}',
        email: 'freelancer@example.com',
        token: 'session_${Random().nextInt(999999).toString().padLeft(6, '0')}',
        expiresAt: DateTime.now().add(const Duration(days: 30)),
        createdAt: DateTime.now(),
      );
    }

    return null;
  }

  /// Returns the most recent mock token issued for [email], or null.
  /// In production: the backend emails the token; here: returned for dev/testing.
  String? getIssuedTokenForEmail(String email) {
    return _emailTokens[email];
  }
}
