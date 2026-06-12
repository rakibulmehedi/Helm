// lib/core/nudge/presentation/providers/nudge_providers.dart
//
// All Riverpod providers for the Nudge System (Phase 3).

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketa_v2/core/analytics/analytics_service.dart';
import 'package:pocketa_v2/core/nudge/data/datasources/nudge_data_source.dart';
import 'package:pocketa_v2/core/nudge/data/repositories/nudge_repository.dart';
import 'package:pocketa_v2/core/nudge/domain/nudge_effectiveness_service.dart';
import 'package:pocketa_v2/core/nudge/domain/nudge_evaluator.dart';
import 'package:pocketa_v2/core/nudge/domain/nudge_log_entry_entity.dart';

// ── Infrastructure providers ──────────────────────────────────────────────────

/// Provides the Hive-backed [NudgeDataSource].
final nudgeDataSourceProvider = Provider<NudgeDataSource>((ref) {
  return NudgeDataSourceImpl();
});

/// Provides the [NudgeRepository] wired to [nudgeDataSourceProvider].
final nudgeRepositoryProvider = Provider<NudgeRepository>((ref) {
  final dataSource = ref.watch(nudgeDataSourceProvider);
  return NudgeRepositoryImpl(dataSource: dataSource);
});

/// Provides the singleton [NudgeEvaluator] (stateless, pure logic).
final nudgeEvaluatorProvider = Provider<NudgeEvaluator>((ref) {
  return const NudgeEvaluator();
});

/// Provides the [NudgeEffectivenessService].
final nudgeEffectivenessServiceProvider = Provider<NudgeEffectivenessService>(
  (ref) {
    final analyticsRepo = ref.watch(analyticsRepositoryProvider);
    return NudgeEffectivenessService(analyticsRepository: analyticsRepo);
  },
);

// ── State providers ───────────────────────────────────────────────────────────

/// Manages the nudge log list and exposes unread count / CRUD operations.
final nudgeListProvider =
    StateNotifierProvider<NudgeListNotifier, List<NudgeLogEntryEntity>>((ref) {
  final repository = ref.watch(nudgeRepositoryProvider);
  return NudgeListNotifier(repository);
});

/// Computed provider: count of unread nudge entries.
final unreadNudgeCountProvider = Provider<int>((ref) {
  final entries = ref.watch(nudgeListProvider);
  return entries.where((e) => !e.isRead).length;
});

// ── State notifier ────────────────────────────────────────────────────────────

/// Manages the nudge log: persists entries, updates read/actioned status.
class NudgeListNotifier extends StateNotifier<List<NudgeLogEntryEntity>> {
  final NudgeRepository _repository;

  NudgeListNotifier(this._repository) : super([]) {
    _loadAll();
  }

  void _loadAll() {
    state = _repository.getAll();
  }

  /// Add a new nudge log entry.
  void add(NudgeLogEntryEntity entry) {
    _repository.save(entry);
    state = [entry, ...state];
  }

  /// Mark a nudge as read by [id].
  void markRead(String id) {
    _repository.markRead(id);
    state = [
      for (final e in state)
        if (e.id == id) e.copyWith(readAt: DateTime.now()) else e,
    ];
  }

  /// Mark a nudge as actioned by [id].
  void markActioned(String id) {
    _repository.markActioned(id);
    final now = DateTime.now();
    state = [
      for (final e in state)
        if (e.id == id)
          e.copyWith(readAt: now, actionedAt: now)
        else
          e,
    ];
  }

  /// Delete a nudge entry by [id].
  void delete(String id) {
    _repository.delete(id);
    state = state.where((e) => e.id != id).toList();
  }

  /// Clear all nudge entries.
  void clearAll() {
    _repository.clearAll();
    state = [];
  }
}
