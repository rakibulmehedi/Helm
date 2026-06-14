// lib/features/auth/domain/entities/auth_state.dart
//
// Core auth domain entity for Helm Trust Layer (D1).
// No Hive dependency — pure domain model.

enum AuthStatus { setupRequired, authenticated, locked }

class AuthState {
  final AuthStatus status;
  final int failedAttempts;

  const AuthState({
    required this.status,
    this.failedAttempts = 0,
  });

  bool get isSetUp => status != AuthStatus.setupRequired;
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLocked => status == AuthStatus.locked;
}
