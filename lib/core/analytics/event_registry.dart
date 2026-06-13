// event_registry.dart
//
// Central registry of all analytics event names and property key constants
// used across Pocketa features.
//
// Design rules:
//   - All values are compile-time constants (static const String).
//   - Neither class can be instantiated (private constructor).
//   - Add events here first; never hard-code string literals at call sites.

/// Events that fire in direct response to a user action.
abstract class TransactionalEvents {
  const TransactionalEvents._();

  /// A new entry was added to the pipeline (income or receivable).
  static const String pipelineEntryCreated = 'pipeline_entry_created';

  /// An existing pipeline entry moved between states (e.g. pending → confirmed).
  static const String pipelineStateChanged = 'pipeline_state_changed';

  /// A pipeline entry was confirmed as received/settled.
  static const String pipelineConfirmed = 'pipeline_confirmed';

  /// The Safe-to-Spend screen was opened or brought into focus.
  static const String stsViewed = 'sts_viewed';

  /// The calculation breakdown panel was expanded by the user.
  static const String calculationBreakdownOpened =
      'calculation_breakdown_opened';

  /// A CSV/data export was initiated.
  static const String exportTriggered = 'export_triggered';

  /// The user completed the account deletion flow.
  static const String accountDeleted = 'account_deleted';

  /// The PIN authentication gate was presented to the user.
  static const String pinGateOpened = 'pin_gate_opened';

  /// A PIN authentication attempt succeeded.
  static const String pinAuthSuccess = 'pin_auth_success';

  /// A PIN authentication attempt failed.
  static const String pinAuthFailed = 'pin_auth_failed';

  /// PIN setup was completed for the first time.
  static const String pinSetupCompleted = 'pin_setup_completed';

  /// The user confirmed an undo action on a transaction.
  static const String undoConfirmUsed = 'undo_confirm_used';

  /// The account deletion confirmation dialog was opened.
  static const String accountDeletionRequested = 'account_deletion_requested';

  /// User opened a notification from the notification center.
  static const String notificationOpened = 'notification_opened';

  /// A pipeline entry was updated within 30 minutes of opening a notification.
  static const String notificationResultedInUpdate =
      'notification_resulted_in_update';

  /// An onboarding step was completed (property: step_number).
  static const String onboardingStepCompleted = 'onboarding_step_completed';

  /// Time in ms from dashboard mount to S2S hero rendered.
  static const String timeToS2sVisible = 'time_to_s2s_visible';
}

/// Events that fire when the product crosses a meaningful behavioral threshold.
///
/// These are used to measure product health and user progress, not direct
/// user intent.
abstract class BoundaryEvents {
  const BoundaryEvents._();

  /// Safe-to-Spend dropped into the at-risk zone.
  static const String stsAtRiskEntered = 'sts_at_risk_entered';

  /// The buffer/reserve balance reached zero or went negative.
  static const String reserveDepleted = 'reserve_depleted';

  /// The user added their very first pipeline entry (activation milestone).
  static const String firstPipelineEntry = 'first_pipeline_entry';

  /// A pipeline entry changed state (e.g. Expected→Pending, Pending→Received).
  static const String pipelineStateChanged = 'pipeline_state_changed';

  /// The user completed the onboarding flow for the first time.
  static const String onboardingCompleted = 'onboarding_completed';

  /// A session was started on a new calendar day (DAU signal).
  static const String dailyActiveSession = 'daily_active_session';

  /// Safe-to-Spend calculator threw an exception.
  static const String s2sCalcFailure = 's2s_calc_failure';
}

/// Standard property key constants for event payloads.
///
/// Use these keys when building the [Map<String, dynamic>] passed to
/// [AnalyticsService.trackEvent] so property names are consistent across
/// all call sites.
abstract class EventProperties {
  const EventProperties._();

  /// The state a pipeline entry transitioned away from.
  static const String fromState = 'from_state';

  /// The state a pipeline entry transitioned into.
  static const String toState = 'to_state';

  /// Number of pipeline entries at the time of the event.
  static const String entryCount = 'entry_count';

  /// ISO-8601 date string representing the current session date.
  static const String sessionDate = 'session_date';

  /// Remaining PIN attempts before lockout.
  static const String remainingAttempts = 'remaining_attempts';

  /// The step number during onboarding step completion.
  static const String stepNumber = 'step_number';

  /// Duration in milliseconds (for timing events).
  static const String durationMs = 'duration_ms';
}
