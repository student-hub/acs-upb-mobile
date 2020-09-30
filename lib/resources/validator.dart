import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:flutter/cupertino.dart';

class AppValidator {
  AppValidator._();

  static String isStrongPassword(String password, BuildContext context) {
    assert(password != null);

    if (password.length < 8) {
      return context != null ? S.of(context).warningPasswordLength : '';
    }
    String pattern = r'(?=.*?[A-ZĂÂÎȘȚ]).{8,}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(password)) {
      return context != null ? S.of(context).warningPasswordUppercase : '';
    }

    pattern = r'^(?=.*?[a-zăâîșț]).{8,}$';
    regExp = RegExp(pattern);
    if (!regExp.hasMatch(password)) {
      return context != null ? S.of(context).warningPasswordLowercase : '';
    }

    pattern = r'^(?=.*?[0-9]).{8,}$';
    regExp = RegExp(pattern);
    if (!regExp.hasMatch(password)) {
      return context != null ? S.of(context).warningPasswordNumber : '';
    }

    pattern = r'^(?=.*?[!@#$&*~`%^_+=(){};:"<>/.,\[\]\|\\]).{8,}$';
    regExp = RegExp(pattern);
    if (!regExp.hasMatch(password)) {
      return context != null
          ? S.of(context).warningPasswordSpecialCharacters
          : '';
    }
    return null;
  }
}
