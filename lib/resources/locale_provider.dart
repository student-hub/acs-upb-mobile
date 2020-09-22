import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:preferences/preference_service.dart';
import 'package:time_machine/time_machine.dart';

class LocaleProvider {
  static String defaultLocale = 'en';
  static List<String> supportedLocales = ['en', 'ro'];
  static Map<String, Culture> cultures;

  static get localeString {
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

  static Locale localeFromString(String preferenceString) {
    switch (preferenceString) {
      case 'auto':
        return localeFromString(Intl.defaultLocale);
      case 'ro':
        return Locale('ro', 'RO');
      case 'en':
        return Locale('en', 'US');
      default:
        return localeFromString(defaultLocale);
    }
  }

  static Locale get locale {
    return localeFromString(localeString);
  }

  static Culture get culture => cultures[localeString];
}
