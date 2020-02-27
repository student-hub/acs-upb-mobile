// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ro locale. All the
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
  String get localeName => 'ro';

  static m0(provider) => "Conectare cu ${provider}";

  static m1(name) => "Bine ai venit, ${name}!";

  static m2(email, provider) => "Există deja un cont asociat cu adresa ${email}. Folosiți ${provider} pentru a vă conecta.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "actionLogIn" : MessageLookupByLibrary.simpleMessage("Conectare"),
    "actionLogInAnonymously" : MessageLookupByLibrary.simpleMessage("Conectare anonimă"),
    "actionRecoverPassword" : MessageLookupByLibrary.simpleMessage("Recuperare parolă"),
    "actionSignInWith" : m0,
    "actionSignUp" : MessageLookupByLibrary.simpleMessage("Înregistrare"),
    "actionSocialLogin" : MessageLookupByLibrary.simpleMessage("Rețele sociale"),
    "buttonCancel" : MessageLookupByLibrary.simpleMessage("Anulare"),
    "buttonNext" : MessageLookupByLibrary.simpleMessage("Următorul"),
    "buttonSave" : MessageLookupByLibrary.simpleMessage("Salvare"),
    "buttonSend" : MessageLookupByLibrary.simpleMessage("Trimitere"),
    "errorIncorrectPassword" : MessageLookupByLibrary.simpleMessage("Parola introdusă nu este corectă."),
    "errorPasswordsDiffer" : MessageLookupByLibrary.simpleMessage("Cele două parole diferă."),
    "errorSomethingWentWrong" : MessageLookupByLibrary.simpleMessage("A apărut o problemă."),
    "fileAcsBanner" : MessageLookupByLibrary.simpleMessage("assets/images/acs_banner_ro.png"),
    "labelConfirmPassword" : MessageLookupByLibrary.simpleMessage("Confirmare parolă"),
    "labelEmail" : MessageLookupByLibrary.simpleMessage("Email"),
    "labelName" : MessageLookupByLibrary.simpleMessage("Nume & prenume"),
    "labelPassword" : MessageLookupByLibrary.simpleMessage("Parolă"),
    "messageNewUser" : MessageLookupByLibrary.simpleMessage("Utilizator nou?"),
    "messageRecoverPassword" : MessageLookupByLibrary.simpleMessage("Introduceți mail-ul pentru a afla cum să vă resetați parola."),
    "messageWelcomeName" : m1,
    "messageWelcomeSimple" : MessageLookupByLibrary.simpleMessage("Bine ai venit!"),
    "navigationHome" : MessageLookupByLibrary.simpleMessage("Acasă"),
    "navigationMap" : MessageLookupByLibrary.simpleMessage("Hartă"),
    "navigationProfile" : MessageLookupByLibrary.simpleMessage("Profil"),
    "navigationSettings" : MessageLookupByLibrary.simpleMessage("Setări"),
    "navigationTimetable" : MessageLookupByLibrary.simpleMessage("Orar"),
    "navigationWebsites" : MessageLookupByLibrary.simpleMessage("Platforme"),
    "settingsItemDarkMode" : MessageLookupByLibrary.simpleMessage("Dark mode"),
    "settingsItemLanguage" : MessageLookupByLibrary.simpleMessage("Limbă"),
    "settingsItemLanguageAuto" : MessageLookupByLibrary.simpleMessage("Auto"),
    "settingsItemLanguageEnglish" : MessageLookupByLibrary.simpleMessage("Engleză"),
    "settingsItemLanguageRomanian" : MessageLookupByLibrary.simpleMessage("Română"),
    "settingsTitleLocalization" : MessageLookupByLibrary.simpleMessage("Localizare"),
    "settingsTitlePersonalization" : MessageLookupByLibrary.simpleMessage("Personalizare"),
    "warningEmailInUse" : m2,
    "warningInternetConnection" : MessageLookupByLibrary.simpleMessage("Asigurați-vă că sunteți conectat la internet."),
    "warningPasswordLength" : MessageLookupByLibrary.simpleMessage("Parola trebuie să aibă cel puțin 6 caractere.")
  };
}
