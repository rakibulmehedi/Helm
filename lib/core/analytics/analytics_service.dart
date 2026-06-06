// analytics_service.dart
//
// Local debug-only instrumentation for Pocketa MVP beta.
// All output goes to the debug console via debugPrint — nothing is persisted,
// no user data is transmitted, and no external SDK is involved.
//
// Post-beta: replace LocalAnalyticsService with a Firebase/Mixpanel adapter
// while keeping the AnalyticsService interface unchanged. The provider swap
// is the only required change at the call-site level.

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Abstract contract for analytics instrumentation.
///
/// All feature code must depend on this abstraction, never on the concrete
/// implementation, so the underlying sink can be swapped without touching
/// business logic.
abstract class AnalyticsService {
  /// Record a named event with optional structured properties.
  void trackEvent(String name, {Map<String, dynamic>? properties});

  /// Record a screen-view transition.
  void trackScreen(String name);
}

/// Beta-phase implementation that writes events to the debug console only.
///
/// - Safe for production builds: output is guarded by [kDebugMode].
/// - Zero persistence: no Hive, no SharedPreferences, no file I/O.
/// - Zero transmission: no HTTP calls, no third-party SDK.
class LocalAnalyticsService implements AnalyticsService {
  const LocalAnalyticsService();

  @override
  void trackEvent(String name, {Map<String, dynamic>? properties}) {
    if (kDebugMode) {
      final propsStr =
          properties != null && properties.isNotEmpty ? ' | $properties' : '';
      debugPrint('[BETA_EVENT] $name$propsStr');
    }
  }

  @override
  void trackScreen(String name) {
    if (kDebugMode) {
      debugPrint('[BETA_EVENT] screen_view | {screen: $name}');
    }
  }
}

/// Riverpod provider exposing [AnalyticsService].
///
/// Swap [LocalAnalyticsService] for a remote adapter here after beta without
/// modifying any feature code.
final analyticsProvider = Provider<AnalyticsService>(
  (ref) => const LocalAnalyticsService(),
);
