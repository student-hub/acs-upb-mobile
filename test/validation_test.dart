import 'package:acs_upb_mobile/resources/validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Password Validation', () {
    test("Validation positive", () async {
      expect(
          await AppValidator.isStrongPassword(
              password: 'Aa12345@', context: null),
          true);
    });
    test("Validation negative length", () async {
      expect(
          await AppValidator.isStrongPassword(password: 'Aa1@2', context: null),
          false);
    });
    test("Validation negative uppercase", () async {
      expect(
          await AppValidator.isStrongPassword(
              password: 'bba12345@', context: null),
          false);
    });
    test("Validation negative lowercase", () async {
      expect(
          await AppValidator.isStrongPassword(
              password: 'AAA12345@', context: null),
          false);
    });
    test("Validation negative number", () async {
      expect(
          await AppValidator.isStrongPassword(
              password: 'AAAaaaaaa@', context: null),
          false);
    });
    test("Validation japanese", () async {
      expect(
          await AppValidator.isStrongPassword(
              password: 'こんにちはこんにちは', context: null),
          false);
    });
    test("Validation negative special character", () async {
      expect(
          await AppValidator.isStrongPassword(
              password: 'AAAaaaaaa1', context: null),
          false);
    });
  });
}
