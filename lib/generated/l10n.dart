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

  String get welcomeSimple {
    return Intl.message(
      'Welcome!',
      name: 'welcomeSimple',
      desc: '',
      args: [],
    );
  }

  String welcomeName(dynamic name) {
    return Intl.message(
      'Welcome, $name!',
      name: 'welcomeName',
      desc: '',
      args: [name],
    );
  }

  String get emailLabel {
    return Intl.message(
      'Email',
      name: 'emailLabel',
      desc: '',
      args: [],
    );
  }

  String get passwordLabel {
    return Intl.message(
      'Password',
      name: 'passwordLabel',
      desc: '',
      args: [],
    );
  }

  String get passwordCheckLabel {
    return Intl.message(
      'Confirm password',
      name: 'passwordCheckLabel',
      desc: '',
      args: [],
    );
  }

  String get nameLabel {
    return Intl.message(
      'Last & first name',
      name: 'nameLabel',
      desc: '',
      args: [],
    );
  }

  String get signUpLabel {
    return Intl.message(
      'Sign up',
      name: 'signUpLabel',
      desc: '',
      args: [],
    );
  }

  String get signInLabel {
    return Intl.message(
      'Sign in',
      name: 'signInLabel',
      desc: '',
      args: [],
    );
  }

  String get saveLabel {
    return Intl.message(
      'Save',
      name: 'saveLabel',
      desc: '',
      args: [],
    );
  }

  String get sendLabel {
    return Intl.message(
      'Send',
      name: 'sendLabel',
      desc: '',
      args: [],
    );
  }

  String get troubleSigningInLabel {
    return Intl.message(
      'Trouble signing in?',
      name: 'troubleSigningInLabel',
      desc: '',
      args: [],
    );
  }

  String get nextButtonLabel {
    return Intl.message(
      'Next',
      name: 'nextButtonLabel',
      desc: '',
      args: [],
    );
  }

  String get cancelButtonLabel {
    return Intl.message(
      'Cancel',
      name: 'cancelButtonLabel',
      desc: '',
      args: [],
    );
  }

  String signInWith(dynamic provider) {
    return Intl.message(
      'Sign in with $provider',
      name: 'signInWith',
      desc: '',
      args: [provider],
    );
  }

  String get passwordLengthWarning {
    return Intl.message(
      'The password must be 6 characters long or more.',
      name: 'passwordLengthWarning',
      desc: '',
      args: [],
    );
  }

  String get passwordCheckError {
    return Intl.message(
      'The two passwords differ.',
      name: 'passwordCheckError',
      desc: '',
      args: [],
    );
  }

  String get incorrectPassword {
    return Intl.message(
      'The password you entered is incorrect.',
      name: 'incorrectPassword',
      desc: '',
      args: [],
    );
  }

  String get errorOccurred {
    return Intl.message(
      'An error occured.',
      name: 'errorOccurred',
      desc: '',
      args: [],
    );
  }

  String get recoverPassword {
    return Intl.message(
      'Recover password',
      name: 'recoverPassword',
      desc: '',
      args: [],
    );
  }

  String get recoverPasswordInstructions {
    return Intl.message(
      'Enter your e-mai in order to be able to reset your password.',
      name: 'recoverPasswordInstructions',
      desc: '',
      args: [],
    );
  }

  String recoverPasswordDialog(dynamic email) {
    return Intl.message(
      'Follow the instructions sent to $email to find out how to reset your password.',
      name: 'recoverPasswordDialog',
      desc: '',
      args: [email],
    );
  }

  String emailInUseMessage(dynamic email, dynamic provider) {
    return Intl.message(
      'There is already an account associated with $email. Please log in with $provider to continue.',
      name: 'emailInUseMessage',
      desc: '',
      args: [email, provider],
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

  String get drawerHeaderProfile {
    return Intl.message(
      'Profile',
      name: 'drawerHeaderProfile',
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

  String get settingsTitlePersonalization {
    return Intl.message(
      'Personalization',
      name: 'settingsTitlePersonalization',
      desc: '',
      args: [],
    );
  }

  String get settingsItemDarkMode {
    return Intl.message(
      'Dark mode',
      name: 'settingsItemDarkMode',
      desc: '',
      args: [],
    );
  }

  String get settingsTitleLocalization {
    return Intl.message(
      'Localization',
      name: 'settingsTitleLocalization',
      desc: '',
      args: [],
    );
  }

  String get settingsItemLanguage {
    return Intl.message(
      'Language',
      name: 'settingsItemLanguage',
      desc: '',
      args: [],
    );
  }

  String get settingsItemLanguageEnglish {
    return Intl.message(
      'English',
      name: 'settingsItemLanguageEnglish',
      desc: '',
      args: [],
    );
  }

  String get settingsItemLanguageRomanian {
    return Intl.message(
      'Romanian',
      name: 'settingsItemLanguageRomanian',
      desc: '',
      args: [],
    );
  }

  String get settingsItemLanguageAuto {
    return Intl.message(
      'Auto',
      name: 'settingsItemLanguageAuto',
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