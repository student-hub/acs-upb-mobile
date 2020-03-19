import 'dart:io';

import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:preferences/preference_service.dart';

class Utils {
  static getLocaleString(BuildContext context) {
    var languagePref = PrefService.get('language');
    return languagePref == 'auto' ? S.of(context).localeName : languagePref;
  }

  static Locale getLocaleFromString(BuildContext context, String preferenceString) {
    switch (preferenceString) {
      case 'en':
        return Locale('en', 'US');
      case 'ro':
        return Locale('ro', 'RO');
      case 'auto':
        return getLocaleFromString(context, S.of(context).localeName);
      default:
        stderr.writeln("Invalid preference string: $preferenceString");
        return getLocaleFromString(context, S.of(context).localeName);
    }
  }

  static Locale getLocale(BuildContext context) {
    return getLocaleFromString(context, getLocaleString(context));
  }
}
