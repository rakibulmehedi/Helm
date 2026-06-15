// lib/features/auth/data/datasources/used_magic_link_token_store.dart
//
// Persistence contract for used Magic Link tokens.
//
// SECURITY NOTE: This is a client-side mitigation. Production MUST validate
// token single-use on the backend.

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'package:helm/core/constants/app_box_names.dart';

/// Stores tokens that have already been consumed by [verifyMagicLink].
/// Implementations must be safe to call from async code.
abstract interface class UsedMagicLinkTokenStore {
  /// Returns true if [token] has already been used.
  Future<bool> contains(String token);

  /// Records [token] as used.
  Future<void> add(String token);
}

/// In-memory store for unit tests and ephemeral sessions.
class InMemoryUsedMagicLinkTokenStore implements UsedMagicLinkTokenStore {
  final _used = <String>{};

  @override
  Future<bool> contains(String token) async => _used.contains(token);

  @override
  Future<void> add(String token) async {
    _used.add(token);
  }
}

/// Hive-backed store using the encrypted [AppBoxNames.authBox].
/// Tokens are stored under a SHA-256 hash key so the raw token is not kept
/// in the key itself.
class HiveUsedMagicLinkTokenStore implements UsedMagicLinkTokenStore {
  static const String _keyPrefix = 'used_magic_link_token_';

  Box<dynamic> get _box => Hive.box<dynamic>(AppBoxNames.authBox);

  String _hashToken(String token) {
    final bytes = utf8.encode(token);
    return sha256.convert(bytes).toString();
  }

  @override
  Future<bool> contains(String token) async {
    if (!Hive.isBoxOpen(AppBoxNames.authBox)) return false;
    final key = '$_keyPrefix${_hashToken(token)}';
    return _box.get(key, defaultValue: false) as bool;
  }

  @override
  Future<void> add(String token) async {
    if (!Hive.isBoxOpen(AppBoxNames.authBox)) return;
    final key = '$_keyPrefix${_hashToken(token)}';
    await _box.put(key, true);
  }
}
