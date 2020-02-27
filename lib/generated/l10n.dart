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

  String get buttonNext {
    return Intl.message(
      'Next',
      name: 'buttonNext',
      desc: '',
      args: [],
    );
  }

  String get buttonCancel {
    return Intl.message(
      'Cancel',
      name: 'buttonCancel',
      desc: '',
      args: [],
    );
  }

  String get buttonSave {
    return Intl.message(
      'Save',
      name: 'buttonSave',
      desc: '',
      args: [],
    );
  }

  String get buttonSend {
    return Intl.message(
      'Send',
      name: 'buttonSend',
      desc: '',
      args: [],
    );
  }

  String get labelEmail {
    return Intl.message(
      'Email',
      name: 'labelEmail',
      desc: '',
      args: [],
    );
  }

  String get labelPassword {
    return Intl.message(
      'Password',
      name: 'labelPassword',
      desc: '',
      args: [],
    );
  }

  String get labelConfirmPassword {
    return Intl.message(
      'Confirm password',
      name: 'labelConfirmPassword',
      desc: '',
      args: [],
    );
  }

  String get labelName {
    return Intl.message(
      'Last & first name',
      name: 'labelName',
      desc: '',
      args: [],
    );
  }

  String get actionSignUp {
    return Intl.message(
      'Sign up',
      name: 'actionSignUp',
      desc: '',
      args: [],
    );
  }

  String get actionLogIn {
    return Intl.message(
      'Log in',
      name: 'actionLogIn',
      desc: '',
      args: [],
    );
  }

  String get actionLogInAnonymously {
    return Intl.message(
      'Log in anonymously',
      name: 'actionLogInAnonymously',
      desc: '',
      args: [],
    );
  }

  String get actionSocialLogin {
    return Intl.message(
      'Social login',
      name: 'actionSocialLogin',
      desc: '',
      args: [],
    );
  }

  String actionSignInWith(dynamic provider) {
    return Intl.message(
      'Sign in with $provider',
      name: 'actionSignInWith',
      desc: '',
      args: [provider],
    );
  }

  String get actionRecoverPassword {
    return Intl.message(
      'Recover password',
      name: 'actionRecoverPassword',
      desc: '',
      args: [],
    );
  }

  String get errorSomethingWentWrong {
    return Intl.message(
      'Something went wrong.',
      name: 'errorSomethingWentWrong',
      desc: '',
      args: [],
    );
  }

  String get errorPasswordsDiffer {
    return Intl.message(
      'The two passwords differ.',
      name: 'errorPasswordsDiffer',
      desc: '',
      args: [],
    );
  }

  String get errorIncorrectPassword {
    return Intl.message(
      'The password you entered is incorrect.',
      name: 'errorIncorrectPassword',
      desc: '',
      args: [],
    );
  }

  String get errorNoPassword {
    return Intl.message(
      'You need to provide a password.',
      name: 'errorNoPassword',
      desc: '',
      args: [],
    );
  }

  String get errorInvalidEmail {
    return Intl.message(
      'You need to provide a valid e-mail address.',
      name: 'errorInvalidEmail',
      desc: '',
      args: [],
    );
  }

  String get errorEmailNotFound {
    return Intl.message(
      'An account associated with that e-mail could not be found. Please sign up instead.',
      name: 'errorEmailNotFound',
      desc: '',
      args: [],
    );
  }

  String get errorAccountDisabled {
    return Intl.message(
      'The account has been disabled.',
      name: 'errorAccountDisabled',
      desc: '',
      args: [],
    );
  }

  String get errorTooManyRequests {
    return Intl.message(
      'There have been too many unsuccessful login attempts from this device.',
      name: 'errorTooManyRequests',
      desc: '',
      args: [],
    );
  }

  String get warningInternetConnection {
    return Intl.message(
      'Please make sure you are connected to the internet.',
      name: 'warningInternetConnection',
      desc: '',
      args: [],
    );
  }

  String get warningPasswordLength {
    return Intl.message(
      'The password must be 6 characters long or more.',
      name: 'warningPasswordLength',
      desc: '',
      args: [],
    );
  }

  String warningEmailInUse(dynamic email) {
    return Intl.message(
      'There is already an account associated with $email.',
      name: 'warningEmailInUse',
      desc: '',
      args: [email],
    );
  }

  String warningUseProvider(dynamic provider) {
    return Intl.message(
      'Please log in with $provider to continue.',
      name: 'warningUseProvider',
      desc: '',
      args: [provider],
    );
  }

  String get warningTryAgainLater {
    return Intl.message(
      'Please try again later.',
      name: 'warningTryAgainLater',
      desc: '',
      args: [],
    );
  }

  String get navigationHome {
    return Intl.message(
      'Home',
      name: 'navigationHome',
      desc: '',
      args: [],
    );
  }

  String get navigationTimetable {
    return Intl.message(
      'Timetable',
      name: 'navigationTimetable',
      desc: '',
      args: [],
    );
  }

  String get navigationWebsites {
    return Intl.message(
      'Websites',
      name: 'navigationWebsites',
      desc: '',
      args: [],
    );
  }

  String get navigationMap {
    return Intl.message(
      'Map',
      name: 'navigationMap',
      desc: '',
      args: [],
    );
  }

  String get navigationProfile {
    return Intl.message(
      'Profile',
      name: 'navigationProfile',
      desc: '',
      args: [],
    );
  }

  String get navigationSettings {
    return Intl.message(
      'Settings',
      name: 'navigationSettings',
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

  String get messageWelcomeSimple {
    return Intl.message(
      'Welcome!',
      name: 'messageWelcomeSimple',
      desc: '',
      args: [],
    );
  }

  String messageWelcomeName(dynamic name) {
    return Intl.message(
      'Welcome, $name!',
      name: 'messageWelcomeName',
      desc: '',
      args: [name],
    );
  }

  String get messageNewUser {
    return Intl.message(
      'New user?',
      name: 'messageNewUser',
      desc: '',
      args: [],
    );
  }

  String get messageRecoverPassword {
    return Intl.message(
      'Enter your e-mai in order to be able to reset your password.',
      name: 'messageRecoverPassword',
      desc: '',
      args: [],
    );
  }

  String get fileAcsBanner {
    return Intl.message(
      'assets/images/acs_banner_en.png',
      name: 'fileAcsBanner',
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