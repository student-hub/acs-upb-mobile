import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:preferences/preference_service.dart';
import 'package:rrule/rrule.dart';
import 'package:time_machine/time_machine.dart';

mixin Localizable {
  String toLocalizedString(BuildContext context);
}

class LocaleProvider {
  LocaleProvider._();

  static String defaultLocale = 'en';
  static List<String> supportedLocales = ['en', 'ro'];
  static Map<String, Culture> cultures;
  static Map<String, RruleL10n> rruleL10ns;

  static String get localeString {
    final languagePref = PrefService.get('language');
    if (languagePref == 'auto') {
      final systemLocale = Intl.defaultLocale.substring(0, 2);
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
        return const Locale('ro', 'RO');
      case 'en':
        return const Locale('en', 'US');
      default:
        return localeFromString(defaultLocale);
    }
  }

  static Locale get locale {
    return localeFromString(localeString);
  }

  static RruleL10n get rruleL10n => rruleL10ns[localeString];
}
