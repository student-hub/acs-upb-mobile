// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static m0(provider) => "Sign in with ${provider}";

  static m1(name) => "Welcome, ${name}!";

  static m2(email, provider) => "There is already an account associated with ${email}. Please log in with ${provider} to continue.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "actionLogIn" : MessageLookupByLibrary.simpleMessage("Log in"),
    "actionLogInAnonymously" : MessageLookupByLibrary.simpleMessage("Log in anonymously"),
    "actionRecoverPassword" : MessageLookupByLibrary.simpleMessage("Recover password"),
    "actionSignInWith" : m0,
    "actionSignUp" : MessageLookupByLibrary.simpleMessage("Sign up"),
    "actionSocialLogin" : MessageLookupByLibrary.simpleMessage("Social login"),
    "buttonCancel" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "buttonNext" : MessageLookupByLibrary.simpleMessage("Next"),
    "buttonSave" : MessageLookupByLibrary.simpleMessage("Save"),
    "buttonSend" : MessageLookupByLibrary.simpleMessage("Send"),
    "errorIncorrectPassword" : MessageLookupByLibrary.simpleMessage("The password you entered is incorrect."),
    "errorPasswordsDiffer" : MessageLookupByLibrary.simpleMessage("The two passwords differ."),
    "errorSomethingWentWrong" : MessageLookupByLibrary.simpleMessage("Something went wrong."),
    "fileAcsBanner" : MessageLookupByLibrary.simpleMessage("assets/images/acs_banner_en.png"),
    "labelConfirmPassword" : MessageLookupByLibrary.simpleMessage("Confirm password"),
    "labelEmail" : MessageLookupByLibrary.simpleMessage("Email"),
    "labelName" : MessageLookupByLibrary.simpleMessage("Last & first name"),
    "labelPassword" : MessageLookupByLibrary.simpleMessage("Password"),
    "messageNewUser" : MessageLookupByLibrary.simpleMessage("New user?"),
    "messageRecoverPassword" : MessageLookupByLibrary.simpleMessage("Enter your e-mai in order to be able to reset your password."),
    "messageWelcomeName" : m1,
    "messageWelcomeSimple" : MessageLookupByLibrary.simpleMessage("Welcome!"),
    "navigationHome" : MessageLookupByLibrary.simpleMessage("Home"),
    "navigationMap" : MessageLookupByLibrary.simpleMessage("Map"),
    "navigationProfile" : MessageLookupByLibrary.simpleMessage("Profile"),
    "navigationSettings" : MessageLookupByLibrary.simpleMessage("Settings"),
    "navigationTimetable" : MessageLookupByLibrary.simpleMessage("Timetable"),
    "navigationWebsites" : MessageLookupByLibrary.simpleMessage("Websites"),
    "settingsItemDarkMode" : MessageLookupByLibrary.simpleMessage("Dark mode"),
    "settingsItemLanguage" : MessageLookupByLibrary.simpleMessage("Language"),
    "settingsItemLanguageAuto" : MessageLookupByLibrary.simpleMessage("Auto"),
    "settingsItemLanguageEnglish" : MessageLookupByLibrary.simpleMessage("English"),
    "settingsItemLanguageRomanian" : MessageLookupByLibrary.simpleMessage("Romanian"),
    "settingsTitleLocalization" : MessageLookupByLibrary.simpleMessage("Localization"),
    "settingsTitlePersonalization" : MessageLookupByLibrary.simpleMessage("Personalization"),
    "warningEmailInUse" : m2,
    "warningInternetConnection" : MessageLookupByLibrary.simpleMessage("Please make sure you are connected to the internet."),
    "warningPasswordLength" : MessageLookupByLibrary.simpleMessage("The password must be 6 characters long or more.")
  };
}
