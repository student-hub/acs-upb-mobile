import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:flutter/cupertino.dart';

class AppValidator {
   static Future<bool> isStrongPassword({String password, BuildContext context}) async {
    if (password.length < 8) {
      if (context != null) {
        AppToast.show(S.of(context).warningPasswordLength);
      }
      return false;
    }
    String pattern  = r'(?=.*?[A-ZĂÂÎȘȚ]).{8,}$';
    RegExp regExp = RegExp(pattern);
    if(!regExp.hasMatch(password)){
      if(context != null){
        AppToast.show(S.of(context).warningPasswordUppercase);
      }
      return false;
    }

    pattern = r'^(?=.*?[a-zăâîșț]).{8,}$';
    regExp = RegExp(pattern);
    if(!regExp.hasMatch(password)){
      if(context != null){
        AppToast.show(S.of(context).warningPasswordLowercase);
      }
      return false;
    }

    pattern = r'^(?=.*?[0-9]).{8,}$';
    regExp = RegExp(pattern);
    if(!regExp.hasMatch(password)){
      if(context != null){
        AppToast.show(S.of(context).warningPasswordNumber);
      }
      return false;
    }

    pattern = r'^(?=.*?[!@#$&*~`%^_+=(){};:"<>/.,\[\]\|\\]).{8,}$';
    regExp = RegExp(pattern);
    if(!regExp.hasMatch(password)){
      if(context != null){
        AppToast.show(S.of(context).warningPasswordSpecialCharacters);
      }
      return false;
    }
    return true;
  }

}
