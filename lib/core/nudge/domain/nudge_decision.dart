// lib/core/nudge/domain/nudge_decision.dart
//
// Value object representing a single nudge evaluation result.
// Pure domain — no framework dependencies.

import 'package:flutter/foundation.dart';
import 'package:helm/core/nudge/domain/nudge_types.dart';

/// Immutable result of a single nudge evaluation.
///
/// Carries all information needed to display, log, and deliver the nudge.
@immutable
class NudgeDecision {
  /// Unique identifier for this decision instance.
  final String nudgeId;

  /// What kind of nudge is recommended.
  final NudgeType nudgeType;

  /// How urgently this should be delivered.
  final NudgePriority priority;

  /// Which delivery channel to use.
  final NudgeChannel channel;

  /// Short title (e.g. "Pipeline update needed").
  final String title;

  /// Message body sent to the user.
  final String body;

  /// Optional label for the action button.
  final String? actionLabel;

  /// Optional route path for when the user taps the nudge.
  final String? actionRoute;

  /// If this nudge targets a specific entry, its ID.
  final String? targetEntryId;

  const NudgeDecision({
    required this.nudgeId,
    required this.nudgeType,
    required this.priority,
    required this.channel,
    required this.title,
    required this.body,
    this.actionLabel,
    this.actionRoute,
    this.targetEntryId,
  });

  /// Whether this decision should trigger a push notification.
  bool get isPushable => channel == NudgeChannel.push;

  /// Whether this decision should appear in the notification center.
  bool get isDisplayable =>
      channel == NudgeChannel.push || channel == NudgeChannel.inAppOnly;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NudgeDecision &&
          runtimeType == other.runtimeType &&
          nudgeId == other.nudgeId;

  @override
  int get hashCode => nudgeId.hashCode;
}
