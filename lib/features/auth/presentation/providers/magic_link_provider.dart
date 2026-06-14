// lib/features/auth/presentation/providers/magic_link_provider.dart
//
// Riverpod providers for Magic Link flow.
// Uses AuthRepositoryImpl — presentation layer only calls abstract contract.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:helm/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:helm/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:helm/features/auth/domain/entities/session_entity.dart';
import 'package:helm/features/auth/domain/repositories/auth_repository.dart';

// ── Repository provider (singleton) ────────────────────────────────────────

final _authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(_authRemoteDataSourceProvider),
  );
});

// ── Session state ──────────────────────────────────────────────────────────

final sessionProvider = StateProvider<SessionEntity?>((ref) => null);

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(sessionProvider) != null;
});

// ── Magic Link providers ───────────────────────────────────────────────────

final sendMagicLinkProvider =
    FutureProvider.family<bool, String>((ref, email) async {
  final repo = ref.watch(authRepositoryProvider);
  return repo.sendMagicLink(email);
});

final verifyMagicLinkProvider =
    FutureProvider.family<SessionEntity?, String>((ref, token) async {
  final repo = ref.watch(authRepositoryProvider);
  final session = await repo.verifyMagicLink(token);
  if (session != null) {
    ref.read(sessionProvider.notifier).state = session;
  }
  return session;
});

// ── Stored session check (cold start) ──────────────────────────────────────

final storedSessionProvider = FutureProvider<SessionEntity?>((ref) async {
  final repo = ref.watch(authRepositoryProvider);
  return repo.getStoredSession();
});

// ── Logout ─────────────────────────────────────────────────────────────────

final logoutAction = Provider<void Function()>((ref) {
  return () async {
    final repo = ref.watch(authRepositoryProvider);
    await repo.clearSession();
    ref.read(sessionProvider.notifier).state = null;
  };
});
