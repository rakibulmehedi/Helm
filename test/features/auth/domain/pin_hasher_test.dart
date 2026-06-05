// test/features/auth/domain/pin_hasher_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:pocketa_v2/features/auth/domain/pin_hasher.dart';

void main() {
  group('PinHasher.hashPin', () {
    test('same pin + salt produces same hash', () {
      const pin = '1234';
      const salt = 'abc123defsalt99';
      expect(PinHasher.hashPin(pin, salt), equals(PinHasher.hashPin(pin, salt)));
    });

    test('different salt produces different hash', () {
      const pin = '1234';
      expect(
        PinHasher.hashPin(pin, 'salt_one'),
        isNot(equals(PinHasher.hashPin(pin, 'salt_two'))),
      );
    });

    test('different pin produces different hash', () {
      const salt = 'same_salt_value';
      expect(
        PinHasher.hashPin('1234', salt),
        isNot(equals(PinHasher.hashPin('5678', salt))),
      );
    });

    test('hash is 64-char lowercase hex (SHA-256)', () {
      final hash = PinHasher.hashPin('9999', 'testsalt');
      expect(hash.length, 64);
      expect(RegExp(r'^[0-9a-f]+$').hasMatch(hash), isTrue);
    });
  });

  group('PinHasher.generateSalt', () {
    test('salt is 32-char lowercase hex (16 bytes)', () {
      final salt = PinHasher.generateSalt();
      expect(salt.length, 32);
      expect(RegExp(r'^[0-9a-f]+$').hasMatch(salt), isTrue);
    });

    test('generateSalt produces unique values', () {
      final s1 = PinHasher.generateSalt();
      final s2 = PinHasher.generateSalt();
      expect(s1, isNot(equals(s2)));
    });
  });

  group('PinHasher.verify', () {
    test('correct pin verifies true', () {
      const pin = '4321';
      const salt = 'fixed_test_salt_x';
      final hash = PinHasher.hashPin(pin, salt);
      expect(PinHasher.verify(pin, salt, hash), isTrue);
    });

    test('wrong pin verifies false', () {
      const salt = 'fixed_test_salt_x';
      final hash = PinHasher.hashPin('4321', salt);
      expect(PinHasher.verify('9999', salt, hash), isFalse);
    });
  });
}
