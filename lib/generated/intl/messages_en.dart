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

  static m2(email) => "There is already an account associated with ${email}.";

  static m3(provider) => "Please log in with ${provider} to continue.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "actionLogIn" : MessageLookupByLibrary.simpleMessage("Log in"),
    "actionLogInAnonymously" : MessageLookupByLibrary.simpleMessage("Log in anonymously"),
    "actionResetPassword" : MessageLookupByLibrary.simpleMessage("Reset password"),
    "actionSendEmail" : MessageLookupByLibrary.simpleMessage("Send e-mail"),
    "actionSignInWith" : m0,
    "actionSignUp" : MessageLookupByLibrary.simpleMessage("Sign up"),
    "actionSocialLogin" : MessageLookupByLibrary.simpleMessage("Social login"),
    "buttonCancel" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "buttonNext" : MessageLookupByLibrary.simpleMessage("Next"),
    "buttonSave" : MessageLookupByLibrary.simpleMessage("Save"),
    "buttonSend" : MessageLookupByLibrary.simpleMessage("Send"),
    "errorAccountDisabled" : MessageLookupByLibrary.simpleMessage("The account has been disabled."),
    "errorEmailInUse" : MessageLookupByLibrary.simpleMessage("There is already an account associated with this e-mail address"),
    "errorEmailNotFound" : MessageLookupByLibrary.simpleMessage("An account associated with that e-mail could not be found. Please sign up instead."),
    "errorIncorrectPassword" : MessageLookupByLibrary.simpleMessage("The password you entered is incorrect."),
    "errorInvalidEmail" : MessageLookupByLibrary.simpleMessage("You need to provide a valid e-mail address."),
    "errorMissingFirstName" : MessageLookupByLibrary.simpleMessage("Please provide your first name(s)."),
    "errorMissingLastName" : MessageLookupByLibrary.simpleMessage("Please provide your last name(s)."),
    "errorNoPassword" : MessageLookupByLibrary.simpleMessage("You need to provide a password."),
    "errorPasswordsDiffer" : MessageLookupByLibrary.simpleMessage("The two passwords differ."),
    "errorSomethingWentWrong" : MessageLookupByLibrary.simpleMessage("Something went wrong."),
    "errorTooManyRequests" : MessageLookupByLibrary.simpleMessage("There have been too many unsuccessful login attempts from this device."),
    "fileAcsBanner" : MessageLookupByLibrary.simpleMessage("assets/images/acs_banner_en.png"),
    "hintEmail" : MessageLookupByLibrary.simpleMessage("john.doe@stud.acs.upb.ro"),
    "hintFirstName" : MessageLookupByLibrary.simpleMessage("John"),
    "hintGroup" : MessageLookupByLibrary.simpleMessage("314CB"),
    "hintLastName" : MessageLookupByLibrary.simpleMessage("Doe"),
    "hintPassword" : MessageLookupByLibrary.simpleMessage("····················"),
    "infoPasswordResetEmailSent" : MessageLookupByLibrary.simpleMessage("Please check your inbox for the password reset e-mail."),
    "labelConfirmPassword" : MessageLookupByLibrary.simpleMessage("Confirm password"),
    "labelEmail" : MessageLookupByLibrary.simpleMessage("Email"),
    "labelFirstName" : MessageLookupByLibrary.simpleMessage("First name"),
    "labelGroup" : MessageLookupByLibrary.simpleMessage("Group"),
    "labelLastName" : MessageLookupByLibrary.simpleMessage("Last name"),
    "labelPassword" : MessageLookupByLibrary.simpleMessage("Password"),
    "messageAccountCreated" : MessageLookupByLibrary.simpleMessage("Account created successfully."),
    "messageNewUser" : MessageLookupByLibrary.simpleMessage("New user?"),
    "messageResetPassword" : MessageLookupByLibrary.simpleMessage("Enter your e-mai in order to receive instructions on how to reset your password."),
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
    "warningPasswordCharacters" : MessageLookupByLibrary.simpleMessage("The password must include lowercase and uppercase letters and at least one number and special character (!@#\$&*~)."),
    "warningPasswordLength" : MessageLookupByLibrary.simpleMessage("The password must be 8 characters long or more."),
    "warningTryAgainLater" : MessageLookupByLibrary.simpleMessage("Please try again later."),
    "warningUseProvider" : m3,
    "websiteCategoryAdministrative" : MessageLookupByLibrary.simpleMessage("Administrative"),
    "websiteCategoryAssociations" : MessageLookupByLibrary.simpleMessage("Associations"),
    "websiteCategoryLearning" : MessageLookupByLibrary.simpleMessage("Learning"),
    "websiteCategoryOthers" : MessageLookupByLibrary.simpleMessage("Others"),
    "websiteCategoryResources" : MessageLookupByLibrary.simpleMessage("Resources")
  };
}
