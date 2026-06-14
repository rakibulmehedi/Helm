// lib/features/auth/domain/repositories/auth_repository.dart
//
// Abstract contract for authentication operations.
// Domain layer — no Flutter, no Hive, no package imports.

import 'package:helm/features/auth/domain/entities/session_entity.dart';

abstract class AuthRepository {
  /// Send a Magic Link email to [email]. Returns true if accepted (202).
  /// Does NOT reveal whether the email exists (always returns true on valid format).
  Future<bool> sendMagicLink(String email);

  /// Verify a Magic Link token and return a [SessionEntity] if valid.
  /// Returns null if token is expired, used, or invalid.
  /// Underlying datasource POSTs to backend /auth/verify-magic-link.
  Future<SessionEntity?> verifyMagicLink(String token);

  /// Check if a persisted session exists locally and is not expired.
  /// Does NOT call the server — checks local Hive storage.
  Future<SessionEntity?> getStoredSession();

  /// Persist a session locally for cold-start survival.
  Future<void> storeSession(SessionEntity session);

  /// Clear the locally stored session token (logout).
  Future<void> clearSession();

  /// Check if biometric authentication is available on this device.
  Future<bool> isBiometricAvailable();

  /// Attempt biometric authentication. Returns true if user authenticated.
  Future<bool> authenticateWithBiometrics();
}
