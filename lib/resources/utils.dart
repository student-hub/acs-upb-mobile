import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:preferences/preference_service.dart';

class Utils {
  static getLocale(BuildContext context) {
    var languagePref = PrefService.get('language');
    return languagePref == 'auto' ? S.of(context).localeName : languagePref;
  }
}
