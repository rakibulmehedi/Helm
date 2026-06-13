// lib/features/auth/data/repositories/auth_repository_impl.dart
//
// Implements AuthRepository using AuthRemoteDataSource (API) + Hive (local storage).
// Clean architecture gate: only datasources + domain entities cross this boundary.

import 'package:hive_flutter/hive_flutter.dart';

import 'package:pocketa_v2/core/constants/app_box_names.dart';
import 'package:pocketa_v2/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:pocketa_v2/features/auth/data/models/session_model.dart';
import 'package:pocketa_v2/features/auth/domain/entities/session_entity.dart';
import 'package:pocketa_v2/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  // ── Session persistence key ─────────────────────────────────────────────

  static const String _sessionKey = 'magic_link_session';

  Box<SessionModel> get _box => Hive.box<SessionModel>(AppBoxNames.sessionBox);

  // ── Magic Link ──────────────────────────────────────────────────────────

  @override
  Future<bool> sendMagicLink(String email) async {
    if (!_isValidEmail(email)) return false;
    return remoteDataSource.sendMagicLink(email);
  }

  @override
  Future<SessionEntity?> verifyMagicLink(String token) async {
    if (token.isEmpty) return null;

    final session = await remoteDataSource.verifyMagicLink(token);
    if (session != null) {
      await storeSession(session);
    }
    return session;
  }

  // ── Local session storage ───────────────────────────────────────────────

  @override
  Future<SessionEntity?> getStoredSession() async {
    if (!Hive.isBoxOpen(AppBoxNames.sessionBox)) return null;

    final model = _box.get(_sessionKey);
    if (model == null) return null;

    final session = model.toEntity();
    if (session.isExpired) {
      await clearSession();
      return null;
    }
    return session;
  }

  @override
  Future<void> storeSession(SessionEntity session) async {
    await _box.put(_sessionKey, SessionModel.fromEntity(session));
  }

  @override
  Future<void> clearSession() async {
    await _box.delete(_sessionKey);
  }

  // ── Biometric ───────────────────────────────────────────────────────────

  @override
  Future<bool> isBiometricAvailable() async {
    // local_auth package pending Chief Architect approval.
    // Returns false by default — PIN is the fallback.
    return false;
  }

  @override
  Future<bool> authenticateWithBiometrics() async {
    // local_auth package pending Chief Architect approval.
    return false;
  }

  // ── Helpers ─────────────────────────────────────────────────────────────

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim());
  }
}
