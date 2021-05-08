import 'package:acs_upb_mobile/generated/l10n.dart';

class AppValidator {
  AppValidator._();

  static String isStrongPassword(String password) {
    assert(password != null);

    if (password.length < 8) {
      return S.current.warningPasswordLength;
    }
    String pattern = r'(?=.*?[A-ZĂÂÎȘȚ]).{8,}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(password)) {
      return S.current.warningPasswordUppercase;
    }

    pattern = r'^(?=.*?[a-zăâîșț]).{8,}$';
    regExp = RegExp(pattern);
    if (!regExp.hasMatch(password)) {
      return S.current.warningPasswordLowercase;
    }

    pattern = r'^(?=.*?[0-9]).{8,}$';
    regExp = RegExp(pattern);
    if (!regExp.hasMatch(password)) {
      return S.current.warningPasswordNumber;
    }

    pattern = r'^(?=.*?[!@#$&*~`%^_+=(){};:"<>/.,\[\]\|\\]).{8,}$';
    regExp = RegExp(pattern);
    if (!regExp.hasMatch(password)) {
      return S.current.warningPasswordSpecialCharacters;
    }
    return null;
  }
}
