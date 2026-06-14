// lib/features/auth/domain/entities/auth_state.dart
//
// Core auth domain entity for Helm Trust Layer (D1).
// No Hive dependency — pure domain model.

enum AuthStatus { setupRequired, authenticated, locked }

class AuthState {
  final AuthStatus status;
  final int failedAttempts;
  final DateTime? lockoutUntil;

  const AuthState({
    required this.status,
    this.failedAttempts = 0,
    this.lockoutUntil,
  });

  bool get isSetUp => status != AuthStatus.setupRequired;
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLocked => status == AuthStatus.locked;

  bool get isLockedOut {
    if (lockoutUntil == null) return false;
    return DateTime.now().isBefore(lockoutUntil!);
  }

  AuthState copyWith({
    AuthStatus? status,
    int? failedAttempts,
    DateTime? lockoutUntil,
  }) {
    return AuthState(
      status: status ?? this.status,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      lockoutUntil: lockoutUntil ?? this.lockoutUntil,
    );
  }
}
