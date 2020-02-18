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

  static m0(email, provider) => "There is already an account associated with ${email}. Please log in with ${provider} to continue.";

  static m1(name) => "Hello, ${name}!";

  static m2(email) =>
      "Follow the instructions sent to ${email} to find out how to reset your password.";

  static m3(provider) => "Sign in with ${provider}";

  static m4(name) => "Welcome, ${name}!";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "cancelButtonLabel" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "drawerHeaderHome" : MessageLookupByLibrary.simpleMessage("Home"),
    "drawerHeaderProfile" : MessageLookupByLibrary.simpleMessage("Profile"),
    "drawerItemClasses" : MessageLookupByLibrary.simpleMessage("Classes"),
    "drawerItemContribute" : MessageLookupByLibrary.simpleMessage("Contribute"),
    "drawerItemHelp" : MessageLookupByLibrary.simpleMessage("Help"),
    "drawerItemMap" : MessageLookupByLibrary.simpleMessage("Map"),
    "drawerItemNews" : MessageLookupByLibrary.simpleMessage("News"),
    "drawerItemNotes" : MessageLookupByLibrary.simpleMessage("Notes"),
    "drawerItemPeople" : MessageLookupByLibrary.simpleMessage("People"),
    "drawerItemSettings" : MessageLookupByLibrary.simpleMessage("Settings"),
    "drawerItemTimetable" : MessageLookupByLibrary.simpleMessage("Timetable"),
    "drawerItemWebsites" : MessageLookupByLibrary.simpleMessage("Websites"),
    "emailInUseMessage" : m0,
    "emailLabel" : MessageLookupByLibrary.simpleMessage("Email"),
    "errorOccurred": MessageLookupByLibrary.simpleMessage("An error occured."),
    "hello" : m1,
    "incorrectPassword": MessageLookupByLibrary.simpleMessage(
        "The password you entered is incorrect."),
    "nameLabel" : MessageLookupByLibrary.simpleMessage("Last & first name"),
    "nextButtonLabel" : MessageLookupByLibrary.simpleMessage("Next"),
    "passwordCheckError": MessageLookupByLibrary.simpleMessage(
        "The two passwords differ."),
    "passwordCheckLabel" : MessageLookupByLibrary.simpleMessage("Confirm password"),
    "passwordLabel" : MessageLookupByLibrary.simpleMessage("Password"),
    "passwordLengthWarning": MessageLookupByLibrary.simpleMessage(
        "The password must be 6 characters long or more."),
    "recoverPassword" : MessageLookupByLibrary.simpleMessage("Recover password"),
    "recoverPasswordDialog" : m2,
    "recoverPasswordInstructions": MessageLookupByLibrary.simpleMessage(
        "Enter your e-mai in order to be able to reset your password."),
    "saveLabel" : MessageLookupByLibrary.simpleMessage("Save"),
    "sendLabel" : MessageLookupByLibrary.simpleMessage("Send"),
    "settingsItemDarkMode" : MessageLookupByLibrary.simpleMessage("Dark mode"),
    "settingsItemLanguage" : MessageLookupByLibrary.simpleMessage("Language"),
    "settingsItemLanguageAuto" : MessageLookupByLibrary.simpleMessage("Auto"),
    "settingsItemLanguageEnglish" : MessageLookupByLibrary.simpleMessage("English"),
    "settingsItemLanguageRomanian" : MessageLookupByLibrary.simpleMessage("Romanian"),
    "settingsTitleLocalization" : MessageLookupByLibrary.simpleMessage("Localization"),
    "settingsTitlePersonalization" : MessageLookupByLibrary.simpleMessage("Personalization"),
    "signInLabel" : MessageLookupByLibrary.simpleMessage("Sign in"),
    "signInWith" : m3,
    "signUpLabel" : MessageLookupByLibrary.simpleMessage("Sign up"),
    "title" : MessageLookupByLibrary.simpleMessage("ACS UPB"),
    "troubleSigningInLabel" : MessageLookupByLibrary.simpleMessage("Trouble signing in?"),
    "welcomeName" : m4,
    "welcomeSimple" : MessageLookupByLibrary.simpleMessage("Welcome!")
  };
}
