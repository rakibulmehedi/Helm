// lib/core/analytics/domain/nudge_event_logger.dart
//
// P2.5 — NudgeEventLogger: structured analytics for nudge lifecycle events.
// Tracks sent, opened, dismissed, and actioned events with consistent properties.

import 'package:helm/core/analytics/domain/analytics_event_entity.dart';
import 'package:helm/core/analytics/domain/analytics_repository.dart';

/// Reasons a nudge can be dismissed by the user.
enum DismissReason {
  swiped,
  tappedOutside,
  acknowledged,
}

/// Structured logger for nudge lifecycle analytics.
///
/// Fires [AnalyticsEventEntity] events through [AnalyticsRepository] for
/// each stage of the nudge lifecycle: sent → opened → dismissed | actioned.
/// Consumer calls the relevant method at the moment the lifecycle event occurs.
class NudgeEventLogger {
  final AnalyticsRepository _repository;

  const NudgeEventLogger({required AnalyticsRepository repository})
      : _repository = repository;

  /// Record that a nudge was delivered to the user.
  void logNudgeSent(String nudgeId, String type, String channel) {
    _repository.save(AnalyticsEventEntity(
      eventName: 'nudge_sent',
      timestamp: DateTime.now().toUtc(),
      properties: {
        'nudge_id': nudgeId,
        'type': type,
        'channel': channel,
      },
    ));
  }

  /// Record that a nudge was opened/viewed by the user.
  void logNudgeOpened(String nudgeId) {
    _repository.save(AnalyticsEventEntity(
      eventName: 'nudge_opened',
      timestamp: DateTime.now().toUtc(),
      properties: {
        'nudge_id': nudgeId,
      },
    ));
  }

  /// Record that a nudge was dismissed without being actioned.
  void logNudgeDismissed(String nudgeId, DismissReason reason) {
    _repository.save(AnalyticsEventEntity(
      eventName: 'nudge_dismissed',
      timestamp: DateTime.now().toUtc(),
      properties: {
        'nudge_id': nudgeId,
        'reason': reason.name,
      },
    ));
  }

  /// Record that a nudge was actioned with the given [action] identifier
  /// and the [timeToAction] measured in milliseconds.
  void logNudgeActioned(String nudgeId, String action, Duration timeToAction) {
    _repository.save(AnalyticsEventEntity(
      eventName: 'nudge_actioned',
      timestamp: DateTime.now().toUtc(),
      properties: {
        'nudge_id': nudgeId,
        'action': action,
        'time_to_action_ms': timeToAction.inMilliseconds.toString(),
      },
    ));
  }
}
