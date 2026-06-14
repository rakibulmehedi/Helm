// lib/core/security/constants/security_keys.dart
//
// Central registry of secure-storage key names and Hive-related constants.
// These are identifiers, not secrets — the actual AES key is stored in the
// platform keystore via flutter_secure_storage.

abstract final class SecurityKeys {
  /// Name of the 256-bit AES key persisted in secure storage.
  static const String hiveAesKey = 'helm_hive_aes_key_v1';

  /// Length in bytes of the Hive AES-256 encryption key.
  static const int hiveAesKeyLength = 32;

  /// Box key for the encrypted auth state managed by AuthNotifier.
  static const String authFailedAttempts = 'auth_failed_attempts';
  static const String authLockoutUntil = 'auth_lockout_until';
  static const String authSessionAuthenticated = 'auth_session_authenticated';
  static const String authMagicLinkSessionToken = 'auth_magic_link_session_token';

  /// PIN storage keys.
  static const String pinHashKey = 'pin_hash';
  static const String pinSaltKey = 'pin_salt';
  static const String pinIsSetupKey = 'pin_is_setup';
  static const String pinHashVersionKey = 'pin_hash_version';
}
