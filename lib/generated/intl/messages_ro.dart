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

  static m1(url) => "Nu s-a putut deschide \'${url}\'.";

  static m2(appName) => "${appName} este open source.";

  static m3(forum) => "Acesta este același username pe care îl folosești să te loghezi pe ${forum}.";

  static m4(appName) => "Citește politica ${appName}";

  static m5(name) => "Echipa ${name}";

  static m6(appName) => "De ce dorești să primești permisiuni de editare în ${appName}?";

  static m7(email) => "Sunteți sigur că doriți să schimbați email-ul cu ${email}?";

  static m8(shortcutName) => "Sunteți sigur că doriți să ștergeți \"${shortcutName}\"?";

  static m9(number) => "Trebuie să completezi încă ${number} formulare de feedback!";

  static m10(name) => "Bine ai venit, ${name}!";

  static m11(email) => "Există deja un cont asociat cu adresa ${email}.";

  static m12(n) => "Doar ${n} opțiuni pot fi selectate la un moment dat.";

  static m13(provider) => "Folosiți ${provider} pentru a vă conecta.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "actionAddEvent" : MessageLookupByLibrary.simpleMessage("Adaugă eveniment"),
    "actionAddShortcut" : MessageLookupByLibrary.simpleMessage("Adaugă scurtătură"),
    "actionAddWebsite" : MessageLookupByLibrary.simpleMessage("Adaugă website"),
    "actionChangeEmail" : MessageLookupByLibrary.simpleMessage("Schimbă email"),
    "actionChangePassword" : MessageLookupByLibrary.simpleMessage("Schimbă parola"),
    "actionChooseClasses" : MessageLookupByLibrary.simpleMessage("Alege materii"),
    "actionContribute" : MessageLookupByLibrary.simpleMessage("Contribuie"),
    "actionDeleteAccount" : MessageLookupByLibrary.simpleMessage("Ștergere cont"),
    "actionDeleteEvent" : MessageLookupByLibrary.simpleMessage("Șterge eveniment"),
    "actionDeleteShortcut" : MessageLookupByLibrary.simpleMessage("Șterge scurtătură"),
    "actionDeleteWebsite" : MessageLookupByLibrary.simpleMessage("Șterge website"),
    "actionDisableEditing" : MessageLookupByLibrary.simpleMessage("Dezactivează modul editare"),
    "actionEditEvent" : MessageLookupByLibrary.simpleMessage("Modifică eveniment"),
    "actionEditGrading" : MessageLookupByLibrary.simpleMessage("Modifică punctaj"),
    "actionEditProfile" : MessageLookupByLibrary.simpleMessage("Modifică profil"),
    "actionEditWebsite" : MessageLookupByLibrary.simpleMessage("Modifică website"),
    "actionEnableEditing" : MessageLookupByLibrary.simpleMessage("Activează modul editare"),
    "actionJumpToToday" : MessageLookupByLibrary.simpleMessage("Sari la ziua de azi"),
    "actionLearnMore" : MessageLookupByLibrary.simpleMessage("Află mai multe"),
    "actionLogIn" : MessageLookupByLibrary.simpleMessage("Conectare"),
    "actionLogInAnonymously" : MessageLookupByLibrary.simpleMessage("Conectare anonimă"),
    "actionLogOut" : MessageLookupByLibrary.simpleMessage("Deconectare"),
    "actionOpenFilter" : MessageLookupByLibrary.simpleMessage("Deschide filtru"),
    "actionRefresh" : MessageLookupByLibrary.simpleMessage("Reîncarcă"),
    "actionRequestPermissions" : MessageLookupByLibrary.simpleMessage("Cere permisiuni"),
    "actionResetPassword" : MessageLookupByLibrary.simpleMessage("Resetare parolă"),
    "actionSendEmail" : MessageLookupByLibrary.simpleMessage("Trimite e-mail"),
    "actionSendVerificationAgain" : MessageLookupByLibrary.simpleMessage("Trimite mail din nou?"),
    "actionShowMore" : MessageLookupByLibrary.simpleMessage("Mai multe"),
    "actionSignInWith" : m0,
    "actionSignUp" : MessageLookupByLibrary.simpleMessage("Înregistrare"),
    "actionSocialLogin" : MessageLookupByLibrary.simpleMessage("Rețele sociale"),
    "buttonAccept" : MessageLookupByLibrary.simpleMessage("Acceptă"),
    "buttonApply" : MessageLookupByLibrary.simpleMessage("Aplică"),
    "buttonCancel" : MessageLookupByLibrary.simpleMessage("Anulează"),
    "buttonDeny" : MessageLookupByLibrary.simpleMessage("Refuză"),
    "buttonNext" : MessageLookupByLibrary.simpleMessage("Următorul"),
    "buttonRevert" : MessageLookupByLibrary.simpleMessage("Anulează"),
    "buttonSave" : MessageLookupByLibrary.simpleMessage("Salvează"),
    "buttonSend" : MessageLookupByLibrary.simpleMessage("Trimite"),
    "buttonSet" : MessageLookupByLibrary.simpleMessage("Setează"),
    "errorAccountDisabled" : MessageLookupByLibrary.simpleMessage("Contul a fost dezactivat."),
    "errorAnswerCannotBeEmpty" : MessageLookupByLibrary.simpleMessage("Răspunsul trebuie precizat."),
    "errorAnswerIncorrect" : MessageLookupByLibrary.simpleMessage("Răspunsul introdus nu este corect."),
    "errorClassCannotBeEmpty" : MessageLookupByLibrary.simpleMessage("Materia trebuie precizată."),
    "errorCouldNotLaunchURL" : m1,
    "errorEmailInUse" : MessageLookupByLibrary.simpleMessage("Există deja un cont asociat acestui e-mail."),
    "errorEmailNotFound" : MessageLookupByLibrary.simpleMessage("Nu am putut găsi un cont asociat cu adresa de mail. Vă rugăm să vă înregistrați."),
    "errorEventTypeCannotBeEmpty" : MessageLookupByLibrary.simpleMessage("Tipul de eveniment trebuie precizat."),
    "errorImage" : MessageLookupByLibrary.simpleMessage("Imaginea nu putut fi încărcată."),
    "errorIncorrectPassword" : MessageLookupByLibrary.simpleMessage("Parola introdusă nu este corectă."),
    "errorInsertGoogleEvents" : MessageLookupByLibrary.simpleMessage("Evenimentele nu au putut fi inserate în Google Calendar."),
    "errorInvalidEmail" : MessageLookupByLibrary.simpleMessage("Trebuie să introduceți un e-mail valid."),
    "errorLoadRequests" : MessageLookupByLibrary.simpleMessage("Cererile nu au putut fi încărcate"),
    "errorMissingFirstName" : MessageLookupByLibrary.simpleMessage("Introduceți prenumele."),
    "errorMissingLastName" : MessageLookupByLibrary.simpleMessage("Introduceți numele de familie."),
    "errorNoPassword" : MessageLookupByLibrary.simpleMessage("Trebuie să introduceți parola."),
    "errorPasswordsDiffer" : MessageLookupByLibrary.simpleMessage("Cele două parole diferă."),
    "errorPermissionDenied" : MessageLookupByLibrary.simpleMessage("Nu aveți suficiente permisiuni."),
    "errorPictureSizeToBig" : MessageLookupByLibrary.simpleMessage("Selectați o fotografie care are mai puțin de 5MB."),
    "errorSomethingWentWrong" : MessageLookupByLibrary.simpleMessage("A apărut o problemă."),
    "errorTooManyRequests" : MessageLookupByLibrary.simpleMessage("Au fost trimise prea multe cereri de pe acest dispozitiv."),
    "errorUnknownUser" : MessageLookupByLibrary.simpleMessage("Utilizator Necunoscut"),
    "fileAcsBanner" : MessageLookupByLibrary.simpleMessage("assets/images/acs_banner_ro.png"),
    "filterMenuRelevance" : MessageLookupByLibrary.simpleMessage("Filtrează după relevanță"),
    "filterMenuShowAll" : MessageLookupByLibrary.simpleMessage("Arată tot"),
    "filterMenuShowMine" : MessageLookupByLibrary.simpleMessage("Arată doar pe ale mele"),
    "filterMenuShowUnprocessed" : MessageLookupByLibrary.simpleMessage("Arată fără răspuns"),
    "filterNodeNameBSc" : MessageLookupByLibrary.simpleMessage("Licență"),
    "filterNodeNameMSc" : MessageLookupByLibrary.simpleMessage("Master"),
    "hintEmail" : MessageLookupByLibrary.simpleMessage("john.doe"),
    "hintEvaluation" : MessageLookupByLibrary.simpleMessage("Examen final"),
    "hintFeedback" : MessageLookupByLibrary.simpleMessage("Îmi place aplicația!"),
    "hintFirstName" : MessageLookupByLibrary.simpleMessage("John"),
    "hintFullEmail" : MessageLookupByLibrary.simpleMessage("john.doe@gmail.com"),
    "hintGroup" : MessageLookupByLibrary.simpleMessage("314CB"),
    "hintIssue" : MessageLookupByLibrary.simpleMessage("Când deschid aplicația..."),
    "hintLastName" : MessageLookupByLibrary.simpleMessage("Doe"),
    "hintPassword" : MessageLookupByLibrary.simpleMessage("····················"),
    "hintPoints" : MessageLookupByLibrary.simpleMessage("4.0"),
    "hintWebsiteLabel" : MessageLookupByLibrary.simpleMessage("Google"),
    "hintWebsiteLink" : MessageLookupByLibrary.simpleMessage("http://google.com"),
    "infoAccepted" : MessageLookupByLibrary.simpleMessage("Acceptat"),
    "infoAdmin" : MessageLookupByLibrary.simpleMessage("Trateaza cererile de permisiuni"),
    "infoAppIsOpenSource" : m2,
    "infoClasses" : MessageLookupByLibrary.simpleMessage("materiile care vă interesează"),
    "infoContactInfo" : MessageLookupByLibrary.simpleMessage("În caz că avem nevoie de mai multe informații"),
    "infoDenied" : MessageLookupByLibrary.simpleMessage("Refuzat"),
    "infoEmail" : m3,
    "infoExportToGoogleCalendar" : MessageLookupByLibrary.simpleMessage("Exportă evenimentele filtrate din Orar"),
    "infoFeedbackForm" : MessageLookupByLibrary.simpleMessage("Oferă feedback sau raportează probleme"),
    "infoFormAnonymous" : MessageLookupByLibrary.simpleMessage("Acest formular este anonim."),
    "infoLoading" : MessageLookupByLibrary.simpleMessage("Se încarcă..."),
    "infoMakeSureGroupIsSelected" : MessageLookupByLibrary.simpleMessage("Asigurați-vă că aveți grupa/semigrupa selectată în"),
    "infoPassword" : MessageLookupByLibrary.simpleMessage("Aceasta trebuie să conțină majuscule, minuscule și cel puțin un număr sau un simbol, având minimum 8 caractere."),
    "infoPasswordResetEmailSent" : MessageLookupByLibrary.simpleMessage("Please check your inbox for the password reset e-mail."),
    "infoReadThePolicy" : m4,
    "infoRelevance" : MessageLookupByLibrary.simpleMessage("Încercați să selectați cea mai restrictivă categorie."),
    "infoRelevanceExample" : MessageLookupByLibrary.simpleMessage("De exemplu, dacă ceva este relevant doar pentru \"314CB\" și \"315CB\", nu setați direct \"CB\"."),
    "infoRelevanceNothingSelected" : MessageLookupByLibrary.simpleMessage("Nu selectați nimic dacă este relevant pentru toată lumea."),
    "infoSelect" : MessageLookupByLibrary.simpleMessage("Selectați"),
    "infoYouNeedToSelect" : MessageLookupByLibrary.simpleMessage("Trebuie întâi să selectați"),
    "labelAnswer" : MessageLookupByLibrary.simpleMessage("Răspuns"),
    "labelAskPermissions" : MessageLookupByLibrary.simpleMessage("Cere permisiuni de editare"),
    "labelAssistant" : MessageLookupByLibrary.simpleMessage("Asistent"),
    "labelCategory" : MessageLookupByLibrary.simpleMessage("Categorie"),
    "labelClass" : MessageLookupByLibrary.simpleMessage("Materie"),
    "labelClasses" : MessageLookupByLibrary.simpleMessage("Materii"),
    "labelColor" : MessageLookupByLibrary.simpleMessage("Culoare"),
    "labelConfirmNewPassword" : MessageLookupByLibrary.simpleMessage("Confirmare parolă nouă"),
    "labelConfirmPassword" : MessageLookupByLibrary.simpleMessage("Confirmare parolă"),
    "labelContactInfoOptional" : MessageLookupByLibrary.simpleMessage("Informații de contact (opțional)"),
    "labelCustom" : MessageLookupByLibrary.simpleMessage("Alta"),
    "labelDay" : MessageLookupByLibrary.simpleMessage("Zi"),
    "labelDescription" : MessageLookupByLibrary.simpleMessage("Descriere"),
    "labelEmail" : MessageLookupByLibrary.simpleMessage("Email"),
    "labelEnd" : MessageLookupByLibrary.simpleMessage("Sfârșit"),
    "labelEvaluation" : MessageLookupByLibrary.simpleMessage("Evaluare"),
    "labelEven" : MessageLookupByLibrary.simpleMessage("Pară"),
    "labelFeedback" : MessageLookupByLibrary.simpleMessage("Feedback"),
    "labelFeedbackPolicy" : MessageLookupByLibrary.simpleMessage("politica de feedback"),
    "labelFirstName" : MessageLookupByLibrary.simpleMessage("Prenume"),
    "labelGrade" : MessageLookupByLibrary.simpleMessage("Notă"),
    "labelIssue" : MessageLookupByLibrary.simpleMessage("Issue"),
    "labelLastName" : MessageLookupByLibrary.simpleMessage("Nume"),
    "labelLastUpdated" : MessageLookupByLibrary.simpleMessage("Ultima modificare"),
    "labelLecturer" : MessageLookupByLibrary.simpleMessage("Profesor"),
    "labelLink" : MessageLookupByLibrary.simpleMessage("Link"),
    "labelLocation" : MessageLookupByLibrary.simpleMessage("Locație"),
    "labelName" : MessageLookupByLibrary.simpleMessage("Nume"),
    "labelNewPassword" : MessageLookupByLibrary.simpleMessage("Parolă nouă"),
    "labelNow" : MessageLookupByLibrary.simpleMessage("Acum"),
    "labelOdd" : MessageLookupByLibrary.simpleMessage("Impară"),
    "labelOldPassword" : MessageLookupByLibrary.simpleMessage("Parolă veche"),
    "labelPassword" : MessageLookupByLibrary.simpleMessage("Parolă"),
    "labelPeople" : MessageLookupByLibrary.simpleMessage("Persoane"),
    "labelPermissionsConsent" : MessageLookupByLibrary.simpleMessage("consimțământul pentru drepturi de editare"),
    "labelPersonalInformation" : MessageLookupByLibrary.simpleMessage("Informații personale"),
    "labelPoints" : MessageLookupByLibrary.simpleMessage("Puncte"),
    "labelPreview" : MessageLookupByLibrary.simpleMessage("Previzualizare"),
    "labelPrivacyPolicy" : MessageLookupByLibrary.simpleMessage("Politică de confidențialitate"),
    "labelProfilePicture" : MessageLookupByLibrary.simpleMessage("Imagine profil"),
    "labelRelevance" : MessageLookupByLibrary.simpleMessage("Relevanță"),
    "labelReportType" : MessageLookupByLibrary.simpleMessage("Tip de raport"),
    "labelSemester" : MessageLookupByLibrary.simpleMessage("Semestrul"),
    "labelStart" : MessageLookupByLibrary.simpleMessage("Început"),
    "labelTeam" : m5,
    "labelToday" : MessageLookupByLibrary.simpleMessage("Astăzi"),
    "labelTomorrow" : MessageLookupByLibrary.simpleMessage("Mâine"),
    "labelType" : MessageLookupByLibrary.simpleMessage("Tip"),
    "labelUniversityYear" : MessageLookupByLibrary.simpleMessage("An universitar"),
    "labelUnknown" : MessageLookupByLibrary.simpleMessage("Necunoscut"),
    "labelVersion" : MessageLookupByLibrary.simpleMessage("Versiunea"),
    "labelWebsiteIcon" : MessageLookupByLibrary.simpleMessage("Imagine website"),
    "labelWeek" : MessageLookupByLibrary.simpleMessage("Săptămână"),
    "labelYear" : MessageLookupByLibrary.simpleMessage("Anul"),
    "messageAccountCreated" : MessageLookupByLibrary.simpleMessage("Contul a fost creat cu succes."),
    "messageAccountDeleted" : MessageLookupByLibrary.simpleMessage("Contul a fost șters cu succes."),
    "messageAddCustomWebsite" : MessageLookupByLibrary.simpleMessage("Încercați să adăugați un website."),
    "messageAgreeFeedbackPolicy" : MessageLookupByLibrary.simpleMessage("Înțeleg că acest sondaj este extrem de important pentru dezvoltarea continuă a procesului educațional și voi oferi doar feedback valoros și constructiv pentru această materie."),
    "messageAgreePermissions" : MessageLookupByLibrary.simpleMessage("Voi încărca doar informații corecte si precise. Înțeleg că încărcarea informațiilor eronate sau ofensatoare în mod intenționat va conduce la blocarea permisiunilor mele permanent."),
    "messageAlreadySeeingCurrentWeek" : MessageLookupByLibrary.simpleMessage("Ești deja la săptămâna curentă!"),
    "messageAnnouncedOnMail" : MessageLookupByLibrary.simpleMessage("Veți primi o confirmare pe mail dacă vi se acceptă cererea."),
    "messageAnotherQuestion" : MessageLookupByLibrary.simpleMessage("Ai altă întrebare?"),
    "messageAskPermissionToEdit" : m6,
    "messageButtonAbove" : MessageLookupByLibrary.simpleMessage("de mai sus."),
    "messageCannotBeUndone" : MessageLookupByLibrary.simpleMessage("Această acțiune nu este reversibilă."),
    "messageChangeEmail" : m7,
    "messageChangeEmailSuccess" : MessageLookupByLibrary.simpleMessage("Email-ul a fost schimbat cu succes"),
    "messageChangePasswordSuccess" : MessageLookupByLibrary.simpleMessage("Parola a fost schimbată cu succes."),
    "messageCheckEmailVerification" : MessageLookupByLibrary.simpleMessage("Verificați-vă mail-ul pentru confirmarea contului."),
    "messageDeleteAccount" : MessageLookupByLibrary.simpleMessage("Sunteți sigur că doriți să ștergeți contul?"),
    "messageDeleteEvent" : MessageLookupByLibrary.simpleMessage("Sunteți sigur că doriți să ștergeți acest eveniment?"),
    "messageDeleteShortcut" : m8,
    "messageDeleteWebsite" : MessageLookupByLibrary.simpleMessage("Sunteți sigur că doriți să ștergeți acest website?"),
    "messageEditProfileSuccess" : MessageLookupByLibrary.simpleMessage("Profilul a fost actualizat cu succes."),
    "messageEmailNotVerified" : MessageLookupByLibrary.simpleMessage("Contul nu este verificat."),
    "messageEmailNotVerifiedToPerformAction" : MessageLookupByLibrary.simpleMessage("Contul trebuie să fie verificat pentru a realiza această acțiune."),
    "messageEventAdded" : MessageLookupByLibrary.simpleMessage("Eveniment adăugat cu succes."),
    "messageEventDeleted" : MessageLookupByLibrary.simpleMessage("Eveniment șters cu succes."),
    "messageEventEdited" : MessageLookupByLibrary.simpleMessage("Eveniment modificat cu succes."),
    "messageFeedbackAspects" : MessageLookupByLibrary.simpleMessage("Aspecte cheie pe care le luăm în considerare:"),
    "messageFeedbackHasBeenSent" : MessageLookupByLibrary.simpleMessage("Feedback trimis cu succes."),
    "messageFeedbackLeft" : m9,
    "messageFeedbackMotivation1" : MessageLookupByLibrary.simpleMessage("Datele și confidențialitatea ta sunt respectate. Nu colectăm răspunsuri individuale, ci acestea sunt agregate, astfel încât o opinie să nu poată fi asociată cu un profil anume."),
    "messageFeedbackMotivation2" : MessageLookupByLibrary.simpleMessage("Informațiile partajate vor fi păstrate în baza noastră de date timp de cel puțin 4 ani (durata studiului ciclului de licență), astfel încât să se poată observa evoluția în timp."),
    "messageFeedbackMotivation3" : MessageLookupByLibrary.simpleMessage("Accesul la statistici este permis oricărui student care dorește să afle impresii despre o disciplină în timpul semestrului. Cu toate acestea, în timp ce oportunitatea de a împărtăși feedback este activă, numai studenții care și-au exprimat deja opinia pot analiza ideile altora."),
    "messageFeedbackMotivation4" : MessageLookupByLibrary.simpleMessage("Întregul proces de colectare și afișare a recenziilor este transparent. Fiind o aplicație open-source, codul sursă este accesibil tuturor."),
    "messageFeedbackMotivation5" : MessageLookupByLibrary.simpleMessage("Căutăm în permanență să îmbunătățim legătura dintre diferite generații de studenți. Drept urmare, orice părere este extrem de valoroasă. Toate detaliile furnizate sunt utilizate pro-activ."),
    "messageFeedbackMotivationOverview" : MessageLookupByLibrary.simpleMessage("Împărtășiți-vă experiența, astfel încât generațiile viitoare de studenți să primească statistici despre această materie!"),
    "messageGetStartedByPressing" : MessageLookupByLibrary.simpleMessage("Începeți prin a apăsa butonul"),
    "messageIAgreeToThe" : MessageLookupByLibrary.simpleMessage("Sunt de acord cu "),
    "messageNewUser" : MessageLookupByLibrary.simpleMessage("Utilizator nou?"),
    "messageNoClassesYet" : MessageLookupByLibrary.simpleMessage("Nu ați adăugat nici o materie încă."),
    "messageNotLoggedIn" : MessageLookupByLibrary.simpleMessage("Trebuie să fiți autentificat pentru a realiza această acțiune."),
    "messagePictureUpdatedSuccess" : MessageLookupByLibrary.simpleMessage("Poza a fost actualizată cu succes."),
    "messageReportNotSent" : MessageLookupByLibrary.simpleMessage("Reposrt could not be sent."),
    "messageReportSent" : MessageLookupByLibrary.simpleMessage("Reposrt sent successfully."),
    "messageRequestAlreadyExists" : MessageLookupByLibrary.simpleMessage("Ați trimis deja o cerere. Daca doriți să adăugați una nouă, vă rugăm sa apasați \'Salvare\'."),
    "messageRequestHasBeenSent" : MessageLookupByLibrary.simpleMessage("Cererea a fost transmisă cu succes"),
    "messageResetPassword" : MessageLookupByLibrary.simpleMessage("Introduceți mail-ul pentru a primi instrucțiuni de resetare a parolei."),
    "messageShortcutDeleted" : MessageLookupByLibrary.simpleMessage("Scurtătura a fost ștearsă cu succes."),
    "messageTalkToChatbot" : MessageLookupByLibrary.simpleMessage("Vorbește cu Polly!"),
    "messageTapForMoreInfo" : MessageLookupByLibrary.simpleMessage("Apasă pentru mai multe informații"),
    "messageThereAreNoEventsForSelected" : MessageLookupByLibrary.simpleMessage("Nu există evenimente pentru selecția de "),
    "messageThisCouldAffectOtherStudents" : MessageLookupByLibrary.simpleMessage("Alți studenți ar putea fi afectați."),
    "messageUnderConstruction" : MessageLookupByLibrary.simpleMessage("În construcție"),
    "messageWebsiteAdded" : MessageLookupByLibrary.simpleMessage("Website adăugat cu succes."),
    "messageWebsiteDeleted" : MessageLookupByLibrary.simpleMessage("Website-ul a fost șters cu succes."),
    "messageWebsiteEdited" : MessageLookupByLibrary.simpleMessage("Website modificat cu succes."),
    "messageWebsitePreview" : MessageLookupByLibrary.simpleMessage("Încercați să apăsați, să faceți hover sau să țineți apăsat ca să testați noul website."),
    "messageWelcomeName" : m10,
    "messageWelcomeSimple" : MessageLookupByLibrary.simpleMessage("Bine ai venit!"),
    "messageYouCanContribute" : MessageLookupByLibrary.simpleMessage("Poți contribui la datele din aplicație, dar trebuie mai întâi să ceri permisiuni."),
    "navigationAdmin" : MessageLookupByLibrary.simpleMessage("Cereri permisiuni"),
    "navigationAskPermissions" : MessageLookupByLibrary.simpleMessage("Cere permisiuni"),
    "navigationClassFeedback" : MessageLookupByLibrary.simpleMessage("Feedback"),
    "navigationClassInfo" : MessageLookupByLibrary.simpleMessage("Informații materie"),
    "navigationClasses" : MessageLookupByLibrary.simpleMessage("Materii"),
    "navigationClassesFeedbackChecklist" : MessageLookupByLibrary.simpleMessage("Listă feedback"),
    "navigationEventDetails" : MessageLookupByLibrary.simpleMessage("Detalii eveniment"),
    "navigationFeedbackMotivation" : MessageLookupByLibrary.simpleMessage("Motivație"),
    "navigationFilter" : MessageLookupByLibrary.simpleMessage("Filtru"),
    "navigationHome" : MessageLookupByLibrary.simpleMessage("Acasă"),
    "navigationMap" : MessageLookupByLibrary.simpleMessage("Hartă"),
    "navigationNewsFeed" : MessageLookupByLibrary.simpleMessage("Știri"),
    "navigationPeople" : MessageLookupByLibrary.simpleMessage("Persoane"),
    "navigationPortal" : MessageLookupByLibrary.simpleMessage("Portal"),
    "navigationProfile" : MessageLookupByLibrary.simpleMessage("Profil"),
    "navigationSearch" : MessageLookupByLibrary.simpleMessage("Căutare"),
    "navigationSearchResults" : MessageLookupByLibrary.simpleMessage("Materii găsite"),
    "navigationSettings" : MessageLookupByLibrary.simpleMessage("Setări"),
    "navigationTimetable" : MessageLookupByLibrary.simpleMessage("Orar"),
    "relevanceAnyone" : MessageLookupByLibrary.simpleMessage("Oricine"),
    "relevanceOnlyMe" : MessageLookupByLibrary.simpleMessage("Doar eu"),
    "sectionEvents" : MessageLookupByLibrary.simpleMessage("Evenimente"),
    "sectionEventsComingUp" : MessageLookupByLibrary.simpleMessage("Evenimente următoare"),
    "sectionFAQ" : MessageLookupByLibrary.simpleMessage("Întrebări frecvente"),
    "sectionFeedbackCompleted" : MessageLookupByLibrary.simpleMessage("Feedback completat"),
    "sectionFeedbackNeeded" : MessageLookupByLibrary.simpleMessage("Feedback necesar"),
    "sectionFrequentlyAccessedWebsites" : MessageLookupByLibrary.simpleMessage("Website-uri favorite"),
    "sectionGrading" : MessageLookupByLibrary.simpleMessage("Punctaj"),
    "sectionShortcuts" : MessageLookupByLibrary.simpleMessage("Scurtături"),
    "settingsAdminPermissions" : MessageLookupByLibrary.simpleMessage("Permisiuni de administrator"),
    "settingsExportToGoogleCalendar" : MessageLookupByLibrary.simpleMessage("Exportă evenimentele în Google Calendar"),
    "settingsFeedbackForm" : MessageLookupByLibrary.simpleMessage("Contactează-ne"),
    "settingsItemAdmin" : MessageLookupByLibrary.simpleMessage("Panoul Administratorului"),
    "settingsItemDarkMode" : MessageLookupByLibrary.simpleMessage("Mod Întunecat"),
    "settingsItemEditingPermissions" : MessageLookupByLibrary.simpleMessage("Permisiunile tale de editare"),
    "settingsItemLanguage" : MessageLookupByLibrary.simpleMessage("Limbă"),
    "settingsItemLanguageAuto" : MessageLookupByLibrary.simpleMessage("Auto"),
    "settingsItemLanguageEnglish" : MessageLookupByLibrary.simpleMessage("Engleză"),
    "settingsItemLanguageRomanian" : MessageLookupByLibrary.simpleMessage("Română"),
    "settingsPermissionsAdd" : MessageLookupByLibrary.simpleMessage("Permisiune pentru adăugare de date publice"),
    "settingsPermissionsEdit" : MessageLookupByLibrary.simpleMessage("Permisiune pentru editare de date publice"),
    "settingsPermissionsNone" : MessageLookupByLibrary.simpleMessage("Fără permisiuni speciale"),
    "settingsPermissionsRequestSent" : MessageLookupByLibrary.simpleMessage("Cerere pentru permisiuni trimisă"),
    "settingsRelevanceFilter" : MessageLookupByLibrary.simpleMessage("Filtru de relevanță"),
    "settingsTitleDataControl" : MessageLookupByLibrary.simpleMessage("Control date"),
    "settingsTitleLocalization" : MessageLookupByLibrary.simpleMessage("Localizare"),
    "settingsTitlePersonalization" : MessageLookupByLibrary.simpleMessage("Personalizare"),
    "settingsTitleTimetable" : MessageLookupByLibrary.simpleMessage("Orar"),
    "shortcutTypeClassbook" : MessageLookupByLibrary.simpleMessage("Catalog"),
    "shortcutTypeMain" : MessageLookupByLibrary.simpleMessage("Pagina principală"),
    "shortcutTypeOther" : MessageLookupByLibrary.simpleMessage("Alta"),
    "shortcutTypeResource" : MessageLookupByLibrary.simpleMessage("Resursă"),
    "stringAnd" : MessageLookupByLibrary.simpleMessage("și"),
    "stringAnonymous" : MessageLookupByLibrary.simpleMessage("Anonim"),
    "stringAt" : MessageLookupByLibrary.simpleMessage("la"),
    "stringEmailDomain" : MessageLookupByLibrary.simpleMessage("@stud.acs.upb.ro"),
    "stringForum" : MessageLookupByLibrary.simpleMessage("cs.curs.pub.ro"),
    "uniEventTypeExam" : MessageLookupByLibrary.simpleMessage("Examen"),
    "uniEventTypeExamSession" : MessageLookupByLibrary.simpleMessage("Sesiune de examene"),
    "uniEventTypeHoliday" : MessageLookupByLibrary.simpleMessage("Vacanță"),
    "uniEventTypeHomework" : MessageLookupByLibrary.simpleMessage("Temă"),
    "uniEventTypeLab" : MessageLookupByLibrary.simpleMessage("Laborator"),
    "uniEventTypeLecture" : MessageLookupByLibrary.simpleMessage("Curs"),
    "uniEventTypeOther" : MessageLookupByLibrary.simpleMessage("Altul"),
    "uniEventTypePractical" : MessageLookupByLibrary.simpleMessage("Colocviu"),
    "uniEventTypeProject" : MessageLookupByLibrary.simpleMessage("Proiect"),
    "uniEventTypeResearch" : MessageLookupByLibrary.simpleMessage("Cercetare"),
    "uniEventTypeSemester" : MessageLookupByLibrary.simpleMessage("Semestru"),
    "uniEventTypeSeminar" : MessageLookupByLibrary.simpleMessage("Seminar"),
    "uniEventTypeSports" : MessageLookupByLibrary.simpleMessage("Sport"),
    "uniEventTypeTest" : MessageLookupByLibrary.simpleMessage("Test"),
    "warningAgreeTo" : MessageLookupByLibrary.simpleMessage("Trebuie să fiți de acord cu "),
    "warningAuthenticationNeeded" : MessageLookupByLibrary.simpleMessage("Autentificați-vă pentru a accesa această funcționalitate."),
    "warningEmailInUse" : m11,
    "warningEventNotEditable" : MessageLookupByLibrary.simpleMessage("Acest eveniment nu poate fi modificat."),
    "warningFavouriteWebsitesInitializationFailed" : MessageLookupByLibrary.simpleMessage("Nu se pot citi date despre site-urile favorite."),
    "warningFeedbackAlreadySent" : MessageLookupByLibrary.simpleMessage("Ați trimis deja feedback pentru această materie!"),
    "warningFieldCannotBeEmpty" : MessageLookupByLibrary.simpleMessage("Câmpul nu poate fi gol."),
    "warningFieldCannotBeZero" : MessageLookupByLibrary.simpleMessage("Câmpul nu poate fi zero."),
    "warningFilterAlreadyAll" : MessageLookupByLibrary.simpleMessage("Toate cererile sunt vizibile deja."),
    "warningFilterAlreadyDisabled" : MessageLookupByLibrary.simpleMessage("Întreg conținutul este vizibil deja."),
    "warningFilterAlreadyShowingYours" : MessageLookupByLibrary.simpleMessage("Deja sunt vizibile doar site-urile personale."),
    "warningFilterAlreadyUnprocessed" : MessageLookupByLibrary.simpleMessage("Deja sunt vizibile doar cererile fără răspuns"),
    "warningInternetConnection" : MessageLookupByLibrary.simpleMessage("Asigurați-vă că sunteți conectat la internet."),
    "warningInvalidURL" : MessageLookupByLibrary.simpleMessage("Trebuie să introduceți un URL valid."),
    "warningNoEvents" : MessageLookupByLibrary.simpleMessage("Nu există evenimente de afișat"),
    "warningNoNews" : MessageLookupByLibrary.simpleMessage("Nu au fost postate știri încă."),
    "warningNoPermissionToAddPublicWebsite" : MessageLookupByLibrary.simpleMessage("Nu aveți permisiunea să creați site-uri publice."),
    "warningNoPermissionToEditClassInfo" : MessageLookupByLibrary.simpleMessage("You do not have permission to edit class information."),
    "warningNoPrivateWebsite" : MessageLookupByLibrary.simpleMessage("Nu ați creat nici un website privat încă."),
    "warningNoneYet" : MessageLookupByLibrary.simpleMessage("Nu există încă"),
    "warningNothingToEdit" : MessageLookupByLibrary.simpleMessage("Nu există nimic pentru care să aveți permisiuni de editare."),
    "warningOnlyNOptionsAtATime" : m12,
    "warningPasswordLength" : MessageLookupByLibrary.simpleMessage("Parola trebuie să aibă cel puțin 8 caractere."),
    "warningPasswordLowercase" : MessageLookupByLibrary.simpleMessage("Parola trebuie să conțină cel putin o minusculă."),
    "warningPasswordNumber" : MessageLookupByLibrary.simpleMessage("Parola trebuie să conțină cel puțin un număr."),
    "warningPasswordSpecialCharacters" : MessageLookupByLibrary.simpleMessage("Parola trebuie să conțină cel puțin un simbol."),
    "warningPasswordUppercase" : MessageLookupByLibrary.simpleMessage("Parola trebuie să conțină cel putin o majusculă."),
    "warningRequestEmpty" : MessageLookupByLibrary.simpleMessage("Textul cererii nu poate să fie gol."),
    "warningRequestExists" : MessageLookupByLibrary.simpleMessage("O cerere deja există"),
    "warningSamePassword" : MessageLookupByLibrary.simpleMessage("Parola trebuie sa fie diferită de cea veche."),
    "warningTryAgainLater" : MessageLookupByLibrary.simpleMessage("Încercați mai târziu."),
    "warningUnableToReachNewsFeed" : MessageLookupByLibrary.simpleMessage("Nu am putut încărca fluxul de știri."),
    "warningUseProvider" : m13,
    "warningWebsiteNameExists" : MessageLookupByLibrary.simpleMessage("Există deja un site cu același nume."),
    "warningYouNeedToSelectAssistant" : MessageLookupByLibrary.simpleMessage("Trebuie să selectați asistentul de la această materie."),
    "warningYouNeedToSelectAtLeastOne" : MessageLookupByLibrary.simpleMessage("Trebuie să selectați cel puțin o opțiune."),
    "websiteCategoryAdministrative" : MessageLookupByLibrary.simpleMessage("Administrativ"),
    "websiteCategoryAssociations" : MessageLookupByLibrary.simpleMessage("Asociații"),
    "websiteCategoryLearning" : MessageLookupByLibrary.simpleMessage("Cursuri"),
    "websiteCategoryOthers" : MessageLookupByLibrary.simpleMessage("Altele"),
    "websiteCategoryResources" : MessageLookupByLibrary.simpleMessage("Resurse")
  };
}
