// lib/core/analytics/notification_event_stub.dart
//
// D2.05 — Notification event stubs for beta instrumentation.
//
// No notification system exists in the current MVP build.
// These constants are reserved for when flutter_local_notifications
// or similar is added (requires package approval).
//
// When wiring: fire via analyticsProvider.trackEvent(NotificationEvents.sent)
// etc. at the relevant send/open/dismiss call sites.

/// Reserved notification event name constants — not yet wired.
abstract class NotificationEvents {
  const NotificationEvents._();

  /// Fires when a transactional or boundary notification is dispatched.
  static const String sent = 'notification_sent';

  /// Fires when user taps a notification to open the app.
  static const String opened = 'notification_opened';

  /// Fires when user dismisses a notification without tapping.
  static const String dismissed = 'notification_dismissed';
}

/// Property keys for notification events.
abstract class NotificationProperties {
  const NotificationProperties._();

  /// Type of notification (e.g. 'pipeline_overdue', 'confirm_reminder').
  static const String notificationType = 'notification_type';

  /// ISO-8601 timestamp of when the notification was sent.
  static const String sentAt = 'sent_at';

  /// Milliseconds between send and open (for opened events only).
  static const String latencyMs = 'latency_ms';
}
