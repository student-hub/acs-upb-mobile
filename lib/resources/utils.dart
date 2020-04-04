import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:preferences/preference_service.dart';

class Utils {
  static String defaultLocale = 'en';
  static List<String> supportedLocales = ['en', 'ro'];

  static getLocaleString() {
    var languagePref = PrefService.get('language');
    if (languagePref == 'auto') {
      String systemLocale = Intl.defaultLocale.substring(0, 2);
      if (supportedLocales.contains(systemLocale)) {
        return systemLocale;
      } else {
        return defaultLocale;
      }
    } else {
      return languagePref;
    }
  }

  static Locale getLocaleFromString(String preferenceString) {
    switch (preferenceString) {
      case 'auto':
        return getLocaleFromString(Intl.defaultLocale);
      case 'ro':
        return Locale('ro', 'RO');
      case 'en':
        return Locale('en', 'US');
      default:
        return getLocaleFromString(defaultLocale);
    }
  }

  static Locale getLocale() {
    return getLocaleFromString(getLocaleString());
  }
}
