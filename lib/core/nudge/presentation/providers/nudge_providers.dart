// lib/core/nudge/presentation/providers/nudge_providers.dart
//
// All Riverpod providers for the Nudge System (Phase 3).
// Includes NudgeSessionService provider and notification providers.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helm/core/analytics/analytics_service.dart';
import 'package:helm/core/analytics/domain/nudge_event_logger.dart';
import 'package:helm/core/nudge/data/datasources/nudge_data_source.dart';
import 'package:helm/core/nudge/data/repositories/nudge_repository.dart';
import 'package:helm/core/nudge/domain/nudge_decision.dart';
import 'package:helm/core/nudge/domain/nudge_effectiveness_service.dart';
import 'package:helm/core/nudge/domain/nudge_evaluator.dart';
import 'package:helm/core/nudge/domain/nudge_log_entry_entity.dart';
import 'package:helm/core/nudge/notifications/notification_service.dart';
import 'package:helm/core/local_storage/shared_pref_service.dart';

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

/// Provides the [NudgeEventLogger] for nudge lifecycle analytics.
final nudgeEventLoggerProvider = Provider<NudgeEventLogger>((ref) {
  final analyticsRepo = ref.watch(analyticsRepositoryProvider);
  return NudgeEventLogger(repository: analyticsRepo);
});

/// Provides the [FlutterNotificationService] for push notifications.
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return FlutterNotificationService();
});

/// Provides the [NudgeSessionService] for session-level evaluation.
final nudgeSessionServiceProvider = Provider<NudgeSessionService>((ref) {
  final evaluator = ref.watch(nudgeEvaluatorProvider);
  final nudgeLog = ref.watch(nudgeListProvider.notifier);
  final eventLogger = ref.watch(nudgeEventLoggerProvider);
  final analytics = ref.watch(analyticsProvider);
  return NudgeSessionService(
    evaluator: evaluator,
    nudgeLog: nudgeLog,
    eventLogger: eventLogger,
    analytics: analytics,
  );
});

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

// ── NudgeSessionService (evaluator → log → analytics) ────────────────────────

/// Evaluates nudge conditions and logs the decision to nudge log + analytics.
/// Call on every app session start (dashboard mount).
class NudgeSessionService {
  final NudgeEvaluator _evaluator;
  final NudgeListNotifier _nudgeLog;
  final NudgeEventLogger _eventLogger;
  final AnalyticsService _analytics;

  NudgeSessionService({
    required NudgeEvaluator evaluator,
    required NudgeListNotifier nudgeLog,
    required NudgeEventLogger eventLogger,
    required AnalyticsService analytics,
  })  : _evaluator = evaluator,
        _nudgeLog = nudgeLog,
        _eventLogger = eventLogger,
        _analytics = analytics;

  /// Run evaluation and log any resulting nudge decision.
  NudgeDecision? evaluateAndLog({
    required int overdueCount,
    required int totalEntries,
    required String s2sState,
    required String? oldestOverdueEntryId,
  }) {
    // Compute days since last session from SharedPrefs
    final lastDate = SharedPrefServices.getLastSessionDate();
    final daysSinceLastSession = lastDate.isNotEmpty
        ? DateTime.now().difference(DateTime.parse(lastDate)).inDays
        : 0;

    // Tracking streak: session count as proxy
    final trackingStreak = SharedPrefServices.getSessionCount();

    // Map S2S state string to enum
    final s2sEnum = switch (s2sState) {
      'safe' => S2sState.safe,
      'atRisk' => S2sState.atRisk,
      _ => S2sState.noData,
    };

    final context = NudgeEvaluationContext(
      overdueCount: overdueCount,
      totalEntries: totalEntries,
      s2sState: s2sEnum,
      daysSinceLastSession: daysSinceLastSession,
      trackingStreak: trackingStreak,
      oldestOverdueEntryId: oldestOverdueEntryId,
    );

    final decision = _evaluator.evaluate(context);
    if (decision == null) return null;

    // Log to nudge log
    final logEntry = NudgeLogEntryEntity(
      id: decision.nudgeId,
      nudgeType: decision.nudgeType,
      channel: decision.channel,
      title: decision.title,
      body: decision.body,
      actionRoute: decision.actionRoute,
      targetEntryId: decision.targetEntryId,
      createdAt: DateTime.now(),
    );

    if (decision.isDisplayable) {
      _nudgeLog.add(logEntry);
    }

    // Fire analytics events
    _eventLogger.logNudgeSent(
      decision.nudgeId,
      decision.nudgeType.name,
      decision.channel.name,
    );

    if (decision.isPushable) {
      _analytics.trackEvent('nudge_push_pending', properties: {
        'nudge_id': decision.nudgeId,
        'type': decision.nudgeType.name,
      });
    }

    return decision;
  }
}
