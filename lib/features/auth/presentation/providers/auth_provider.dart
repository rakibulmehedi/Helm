// lib/features/auth/presentation/providers/auth_provider.dart
//
// PIN-based auth state management for Helm Trust Layer (D1).
// Uses Hive untyped dynamic box — no new packages required beyond crypto.
//
// Security: PIN stored as SHA-256(salt + pin). Salt generated per-setup.
// Migration: old base64 hashes (no salt key) detected → clear → force re-setup.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:helm/core/constants/app_box_names.dart';
import 'package:helm/features/auth/domain/entities/auth_state.dart';
import 'package:helm/features/auth/domain/pin_hasher.dart';

// ---------------------------------------------------------------------------
// AuthNotifier
// ---------------------------------------------------------------------------

class AuthNotifier extends Notifier<AuthState> {
  static const int _maxAttempts = 5;
  static const String _pinHashKey = 'pin_hash';
  static const String _pinSaltKey = 'pin_salt';
  static const String _pinIsSetupKey = 'pin_is_setup';

  /// In-memory session flag. Resets on cold start (app process kill).
  /// Checked by GoRouter redirect to enforce PIN entry every app-open.
  static bool sessionAuthenticated = false;

  Box<dynamic> get _box => Hive.box<dynamic>(AppBoxNames.authBox);

  @override
  AuthState build() {
    final isSetUp = _box.get(_pinIsSetupKey, defaultValue: false) as bool;
    if (!isSetUp) {
      return const AuthState(status: AuthStatus.setupRequired);
    }
    // Migration guard: setup flag present but no salt key means old base64 hash.
    // Cannot upgrade without the original PIN — force re-setup for security.
    final hasSalt = _box.get(_pinSaltKey) != null;
    if (!hasSalt) {
      _box.delete(_pinHashKey);
      _box.delete(_pinIsSetupKey);
      return const AuthState(status: AuthStatus.setupRequired);
    }
    return const AuthState(status: AuthStatus.locked);
  }

  /// Sets up a new PIN. Generates a fresh salt and stores SHA-256(salt+pin).
  Future<void> setupPin(String pin) async {
    final salt = PinHasher.generateSalt();
    await _box.put(_pinSaltKey, salt);
    await _box.put(_pinHashKey, PinHasher.hashPin(pin, salt));
    await _box.put(_pinIsSetupKey, true);
    sessionAuthenticated = true;
    state = const AuthState(status: AuthStatus.authenticated);
  }

  /// Attempts to authenticate with the provided PIN.
  /// Returns true on success, false on failure.
  /// Blocked only after [_maxAttempts] consecutive failures.
  Future<bool> authenticate(String pin) async {
    if (state.failedAttempts >= _maxAttempts) return false;

    final stored = _box.get(_pinHashKey) as String?;
    final salt = _box.get(_pinSaltKey) as String?;
    if (stored == null || salt == null) return false;

    if (PinHasher.verify(pin, salt, stored)) {
      sessionAuthenticated = true;
      state = const AuthState(status: AuthStatus.authenticated);
      return true;
    }

    final newAttempts = state.failedAttempts + 1;
    state = AuthState(
      status: AuthStatus.locked,
      failedAttempts: newAttempts,
    );
    return false;
  }

  /// Locks the session. PIN is preserved — user must re-enter to unlock.
  void logout() {
    sessionAuthenticated = false;
    state = AuthState(
      status: AuthStatus.locked,
      failedAttempts: state.failedAttempts,
    );
  }

  /// Removes the stored PIN entirely. Resets to setup-required state.
  Future<void> clearPin() async {
    sessionAuthenticated = false;
    await _box.delete(_pinHashKey);
    await _box.delete(_pinSaltKey);
    await _box.delete(_pinIsSetupKey);
    state = const AuthState(status: AuthStatus.setupRequired);
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
