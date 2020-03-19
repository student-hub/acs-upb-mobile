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
    final String name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
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

  String get labelFirstName {
    return Intl.message(
      'First name',
      name: 'labelFirstName',
      desc: '',
      args: [],
    );
  }

  String get labelLastName {
    return Intl.message(
      'Last name',
      name: 'labelLastName',
      desc: '',
      args: [],
    );
  }

  String get labelGroup {
    return Intl.message(
      'Group',
      name: 'labelGroup',
      desc: '',
      args: [],
    );
  }

  String get hintEmail {
    return Intl.message(
      'john.doe',
      name: 'hintEmail',
      desc: '',
      args: [],
    );
  }

  String get hintPassword {
    return Intl.message(
      '····················',
      name: 'hintPassword',
      desc: '',
      args: [],
    );
  }

  String get hintFirstName {
    return Intl.message(
      'John',
      name: 'hintFirstName',
      desc: '',
      args: [],
    );
  }

  String get hintLastName {
    return Intl.message(
      'Doe',
      name: 'hintLastName',
      desc: '',
      args: [],
    );
  }

  String get hintGroup {
    return Intl.message(
      '314CB',
      name: 'hintGroup',
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

  String get actionLogOut {
    return Intl.message(
      'Log out',
      name: 'actionLogOut',
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

  String get actionResetPassword {
    return Intl.message(
      'Reset password',
      name: 'actionResetPassword',
      desc: '',
      args: [],
    );
  }

  String get actionSendEmail {
    return Intl.message(
      'Send e-mail',
      name: 'actionSendEmail',
      desc: '',
      args: [],
    );
  }

  String get actionSendVerificationAgain {
    return Intl.message(
      'Send e-mail again?',
      name: 'actionSendVerificationAgain',
      desc: '',
      args: [],
    );
  }

  String get actionDeleteAccount {
    return Intl.message(
      'Delete account',
      name: 'actionDeleteAccount',
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

  String get errorMissingFirstName {
    return Intl.message(
      'Please provide your first name(s).',
      name: 'errorMissingFirstName',
      desc: '',
      args: [],
    );
  }

  String get errorMissingLastName {
    return Intl.message(
      'Please provide your last name(s).',
      name: 'errorMissingLastName',
      desc: '',
      args: [],
    );
  }

  String get errorEmailInUse {
    return Intl.message(
      'There is already an account associated with this e-mail address',
      name: 'errorEmailInUse',
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
      'There have been too many requests from this device.',
      name: 'errorTooManyRequests',
      desc: '',
      args: [],
    );
  }

  String errorCouldNotLaunchURL(dynamic url) {
    return Intl.message(
      'Could not launch \'$url\'.',
      name: 'errorCouldNotLaunchURL',
      desc: '',
      args: [url],
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
      'The password must be 8 characters long or more.',
      name: 'warningPasswordLength',
      desc: '',
      args: [],
    );
  }

  String get warningPasswordCharacters {
    return Intl.message(
      'The password must include lowercase and uppercase letters and at least one number and special character (!@#\$&*~).',
      name: 'warningPasswordCharacters',
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

  String get navigationPortal {
    return Intl.message(
      'Portal',
      name: 'navigationPortal',
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

  String get navigationFilter {
    return Intl.message(
      'Filter',
      name: 'navigationFilter',
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

  String get websiteCategoryLearning {
    return Intl.message(
      'Learning',
      name: 'websiteCategoryLearning',
      desc: '',
      args: [],
    );
  }

  String get websiteCategoryAdministrative {
    return Intl.message(
      'Administrative',
      name: 'websiteCategoryAdministrative',
      desc: '',
      args: [],
    );
  }

  String get websiteCategoryAssociations {
    return Intl.message(
      'Associations',
      name: 'websiteCategoryAssociations',
      desc: '',
      args: [],
    );
  }

  String get websiteCategoryResources {
    return Intl.message(
      'Resources',
      name: 'websiteCategoryResources',
      desc: '',
      args: [],
    );
  }

  String get websiteCategoryOthers {
    return Intl.message(
      'Others',
      name: 'websiteCategoryOthers',
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

  String get messageEmailNotVerified {
    return Intl.message(
      'Account is not verified.',
      name: 'messageEmailNotVerified',
      desc: '',
      args: [],
    );
  }

  String get messageAccountCreated {
    return Intl.message(
      'Account created successfully.',
      name: 'messageAccountCreated',
      desc: '',
      args: [],
    );
  }

  String get messageAccountDeleted {
    return Intl.message(
      'Account deleted successfully.',
      name: 'messageAccountDeleted',
      desc: '',
      args: [],
    );
  }

  String get messageCheckEmailVerification {
    return Intl.message(
      'Please check your email for account verification.',
      name: 'messageCheckEmailVerification',
      desc: '',
      args: [],
    );
  }

  String get messageResetPassword {
    return Intl.message(
      'Enter your e-mai in order to receive instructions on how to reset your password.',
      name: 'messageResetPassword',
      desc: '',
      args: [],
    );
  }

  String get messageDeleteAccount {
    return Intl.message(
      'Are you sure you want to delete your account?',
      name: 'messageDeleteAccount',
      desc: '',
      args: [],
    );
  }

  String get messageCannotBeUndone {
    return Intl.message(
      'This action cannot be undone.',
      name: 'messageCannotBeUndone',
      desc: '',
      args: [],
    );
  }

  String get messageUnderConstruction {
    return Intl.message(
      'Under construction',
      name: 'messageUnderConstruction',
      desc: '',
      args: [],
    );
  }

  String get infoPasswordResetEmailSent {
    return Intl.message(
      'Please check your inbox for the password reset e-mail.',
      name: 'infoPasswordResetEmailSent',
      desc: '',
      args: [],
    );
  }

  String get stringEmailDomain {
    return Intl.message(
      '@stud.acs.upb.ro',
      name: 'stringEmailDomain',
      desc: '',
      args: [],
    );
  }

  String get stringAnonymous {
    return Intl.message(
      'Anonymous',
      name: 'stringAnonymous',
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
      Locale.fromSubtags(languageCode: 'en'), Locale.fromSubtags(languageCode: 'ro'),
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