// lib/core/security/root_check_provider.dart
//
// Riverpod provider for the production root/jailbreak check.
// Override with [SafeRootCheck] in tests.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:helm/core/security/root_check.dart';

/// Default production root check.
final rootCheckProvider = Provider<RootCheck>(
  (ref) => JailbreakRootCheck(),
);
