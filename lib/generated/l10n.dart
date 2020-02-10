// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

class S {
  S(this.localeName);
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return S(localeName);
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  final String localeName;

  String get title {
    return Intl.message(
      'ACS UPB',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  String hello(dynamic name) {
    return Intl.message(
      'Hello, $name!',
      name: 'hello',
      desc: '',
      args: [name],
    );
  }

  String get drawerHeaderHome {
    return Intl.message(
      'Home',
      name: 'drawerHeaderHome',
      desc: '',
      args: [],
    );
  }

  String get drawerItemWebsites {
    return Intl.message(
      'Websites',
      name: 'drawerItemWebsites',
      desc: '',
      args: [],
    );
  }

  String get drawerItemTimetable {
    return Intl.message(
      'Timetable',
      name: 'drawerItemTimetable',
      desc: '',
      args: [],
    );
  }

  String get drawerItemClasses {
    return Intl.message(
      'Classes',
      name: 'drawerItemClasses',
      desc: '',
      args: [],
    );
  }

  String get drawerItemNews {
    return Intl.message(
      'News',
      name: 'drawerItemNews',
      desc: '',
      args: [],
    );
  }

  String get drawerItemMap {
    return Intl.message(
      'Map',
      name: 'drawerItemMap',
      desc: '',
      args: [],
    );
  }

  String get drawerItemPeople {
    return Intl.message(
      'People',
      name: 'drawerItemPeople',
      desc: '',
      args: [],
    );
  }

  String get drawerItemNotes {
    return Intl.message(
      'Notes',
      name: 'drawerItemNotes',
      desc: '',
      args: [],
    );
  }

  String get drawerItemSettings {
    return Intl.message(
      'Settings',
      name: 'drawerItemSettings',
      desc: '',
      args: [],
    );
  }

  String get drawerItemHelp {
    return Intl.message(
      'Help',
      name: 'drawerItemHelp',
      desc: '',
      args: [],
    );
  }

  String get drawerItemContribute {
    return Intl.message(
      'Contribute',
      name: 'drawerItemContribute',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale('en', ''), Locale('ro', ''),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (Locale supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}