// lib/core/utils/id_generator.dart
//
// Lightweight unique ID generator for local-first entities.
// Produces a 20-character string combining a millisecond timestamp
// with a random suffix to avoid collisions even if two transactions
// are created in the same millisecond.

import 'dart:math';

abstract final class IdGenerator {
  static final _random = Random.secure();

  /// Generates a locally-unique ID: `<timestamp_ms>_<random_6_chars>`.
  ///
  /// Example output: `1716345600123_a3f9c1`
  static String uniqueId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final suffix = _randomHex(6);
    return '${timestamp}_$suffix';
  }

  static String _randomHex(int length) {
    const chars = '0123456789abcdef';
    return List.generate(length, (_) => chars[_random.nextInt(chars.length)]).join();
  }
}
