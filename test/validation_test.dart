import 'package:acs_upb_mobile/resources/validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  // TODO: Correct the test so isStringPassword would get a context;
  group('Password Validation', () {

    test('Valid password', () async {
      expect(
          AppValidator.isStrongPassword(
              password: 'Aa12345@', context: null),
          null);
    });

    test('Invalid password - length', () async {
      expect(
          AppValidator.isStrongPassword(password: 'Aa1@2', context: null),
          null);
    });

    test('Invalid password - uppercase', () async {
      expect(
          AppValidator.isStrongPassword(
              password: 'bba12345@', context: null),
          null);
    });

    test('Invalid password - lowercase', () async {
      expect(
          AppValidator.isStrongPassword(
              password: 'AAA12345@', context: null),
          null);
    });

    test('Invalid password - number', () async {
      expect(
          AppValidator.isStrongPassword(
              password: 'AAAaaaaaa@', context: null),
          null);
    });

    test('Invalid password - Japanese', () async {
      expect(
          AppValidator.isStrongPassword(
              password: 'こんにちはこんにちは', context: null),
          null);
    });

    test('Invalid password - special character', () async {
      expect(
          AppValidator.isStrongPassword(
              password: 'AAAaaaaaa1', context: null),
          null);
    });
  });
}
