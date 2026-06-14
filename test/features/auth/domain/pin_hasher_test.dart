// test/features/auth/domain/pin_hasher_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:helm/features/auth/domain/pin_hasher.dart';

void main() {
  group('PinHasher.hashPin', () {
    test('same pin + salt produces same hash', () {
      const pin = '123456';
      const salt = 'abc123defsalt99abc123defsalt99ab';
      expect(PinHasher.hashPin(pin, salt), equals(PinHasher.hashPin(pin, salt)));
    });

    test('different salt produces different hash', () {
      const pin = '123456';
      expect(
        PinHasher.hashPin(pin, 'salt_one_salt_one_salt_one_salt_'),
        isNot(equals(PinHasher.hashPin(pin, 'salt_two_salt_two_salt_two_salt_'))),
      );
    });

    test('different pin produces different hash', () {
      const salt = 'same_salt_value_same_salt_value_';
      expect(
        PinHasher.hashPin('123456', salt),
        isNot(equals(PinHasher.hashPin('567890', salt))),
      );
    });

    test('hash is 64-char lowercase hex (PBKDF2, 256-bit)', () {
      final hash = PinHasher.hashPin('999999', 'testsalt_testsalt_testsalt_tes');
      expect(hash.length, 64);
      expect(RegExp(r'^[0-9a-f]+$').hasMatch(hash), isTrue);
    });

    test('matches PBKDF2-HMAC-SHA256 known vector (100k iterations)', () {
      // Known answer for PBKDF2-HMAC-SHA256, password "password", salt "salt",
      // 100,000 iterations, 32 bytes.
      const expected =
          '0394a2ede332c9a13eb82e9b24631604c31df978b4e2f0fbd2c549944f9d79a5';
      expect(
        PinHasher.hashPin('password', 'salt'),
        equals(expected),
      );
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
      const pin = '432109';
      const salt = 'fixed_test_salt_x_fixed_test_salt_';
      final hash = PinHasher.hashPin(pin, salt);
      expect(PinHasher.verify(pin, salt, hash), isTrue);
    });

    test('wrong pin verifies false', () {
      const salt = 'fixed_test_salt_x_fixed_test_salt_';
      final hash = PinHasher.hashPin('432109', salt);
      expect(PinHasher.verify('999999', salt, hash), isFalse);
    });
  });
}
