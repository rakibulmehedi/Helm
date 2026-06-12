// lib/core/nudge/domain/nudge_types.dart
//
// Pure domain enumerations for the Nudge Evaluation Engine (Phase 3).
// No framework dependencies — pure Dart.

/// The type of nudge to deliver.
enum NudgeType {
  /// User has overdue pipeline entries — confirm oldest first.
  confirmOverdue,

  /// Safe-to-spend is at risk — review fixed costs.
  reviewFixedCosts,

  /// 3+ days since last session — re-engagement.
  reEngagement,

  /// 7+ days of consistent tracking — quiet affirmation (no push).
  quietAffirmation,

  /// Pipeline up to date + S2S safe — relief signal (no push).
  reliefSignal,
}

/// Priority level for nudge delivery ordering.
enum NudgePriority {
  /// Requires immediate attention (overdue payment, S2S at risk).
  high,

  /// Should be seen but not urgent.
  medium,

  /// Informational — can wait.
  low,
}

/// Delivery channel for a nudge.
enum NudgeChannel {
  /// Push notification (requires Group 3A / flutter_local_notifications).
  push,

  /// In-app notification center only — no push.
  inAppOnly,

  /// Quiet affirmation — not shown in notification center, displayed inline.
  quiet,
}
