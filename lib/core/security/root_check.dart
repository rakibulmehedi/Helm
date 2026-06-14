// lib/core/security/root_check.dart
//
// Thin abstraction over jailbreak/root detection plugins.
// Returns [RootCheckResult.compromised] when the platform reports that the
// device has been rooted or jailbroken. Provides a mockable seam for tests.

import 'package:flutter/foundation.dart';
import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';

/// Result of a root/jailbreak detection check.
enum RootCheckResult {
  /// Device appears uncompromised.
  safe,

  /// Device appears rooted/jailbroken or check could not be completed.
  compromised,

  /// Check was skipped (e.g. web platform not supported by plugin).
  unknown,
}

/// Abstract root check interface for testability.
abstract interface class RootCheck {
  Future<RootCheckResult> check();
}

/// Production implementation using `jailbreak_root_detection`.
class JailbreakRootCheck implements RootCheck {
  final JailbreakRootDetection _plugin;

  JailbreakRootCheck({JailbreakRootDetection? plugin})
      : _plugin = plugin ?? JailbreakRootDetection();

  @override
  Future<RootCheckResult> check() async {
    // Unsupported platforms (web, desktop) should not block the user.
    if (kIsWeb) return RootCheckResult.unknown;

    try {
      final isJailbroken = await _plugin.isJailBroken;
      final isRealDevice = await _plugin.isRealDevice;

      if (isJailbroken == true) return RootCheckResult.compromised;
      if (isRealDevice == false) {
        // Emulators/simulators are acceptable for debug builds but flagged
        // as unknown in release to avoid false-positive blocking.
        return kReleaseMode ? RootCheckResult.unknown : RootCheckResult.safe;
      }
      return RootCheckResult.safe;
    } on Exception {
      // If the check itself fails, fail-secure: treat as compromised.
      return RootCheckResult.compromised;
    }
  }
}

/// Always-safe stub for tests and unsupported platforms.
class SafeRootCheck implements RootCheck {
  @override
  Future<RootCheckResult> check() async => RootCheckResult.safe;
}

/// Always-compromised stub for testing the blocking screen path.
class CompromisedRootCheck implements RootCheck {
  @override
  Future<RootCheckResult> check() async => RootCheckResult.compromised;
}
