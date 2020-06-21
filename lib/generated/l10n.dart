// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

class S {
  S();
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return S();
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

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

  String get buttonApply {
    return Intl.message(
      'Apply',
      name: 'buttonApply',
      desc: '',
      args: [],
    );
  }

  String get buttonSet {
    return Intl.message(
      'Set',
      name: 'buttonSet',
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

  String get labelName {
    return Intl.message(
      'Name',
      name: 'labelName',
      desc: '',
      args: [],
    );
  }

  String get labelCategory {
    return Intl.message(
      'Category',
      name: 'labelCategory',
      desc: '',
      args: [],
    );
  }

  String get labelLink {
    return Intl.message(
      'Link',
      name: 'labelLink',
      desc: '',
      args: [],
    );
  }

  String get labelRelevance {
    return Intl.message(
      'Relevance',
      name: 'labelRelevance',
      desc: '',
      args: [],
    );
  }

  String get labelPreview {
    return Intl.message(
      'Preview',
      name: 'labelPreview',
      desc: '',
      args: [],
    );
  }

  String get labelDescription {
    return Intl.message(
      'Description',
      name: 'labelDescription',
      desc: '',
      args: [],
    );
  }

  String get labelCustom {
    return Intl.message(
      'Custom',
      name: 'labelCustom',
      desc: '',
      args: [],
    );
  }

  String get labelType {
    return Intl.message(
      'Type',
      name: 'labelType',
      desc: '',
      args: [],
    );
  }

  String get labelLocation {
    return Intl.message(
      'Location',
      name: 'labelLocation',
      desc: '',
      args: [],
    );
  }

  String get labelColor {
    return Intl.message(
      'Color',
      name: 'labelColor',
      desc: '',
      args: [],
    );
  }

  String get labelStart {
    return Intl.message(
      'Start',
      name: 'labelStart',
      desc: '',
      args: [],
    );
  }

  String get labelEnd {
    return Intl.message(
      'End',
      name: 'labelEnd',
      desc: '',
      args: [],
    );
  }

  String get labelClass {
    return Intl.message(
      'Class',
      name: 'labelClass',
      desc: '',
      args: [],
    );
  }

  String get labelYear {
    return Intl.message(
      'Year',
      name: 'labelYear',
      desc: '',
      args: [],
    );
  }

  String get labelSemester {
    return Intl.message(
      'Semester',
      name: 'labelSemester',
      desc: '',
      args: [],
    );
  }

  String labelTeam(Object name) {
    return Intl.message(
      '$name team',
      name: 'labelTeam',
      desc: '',
      args: [name],
    );
  }

  String get sectionShortcuts {
    return Intl.message(
      'Shortcuts',
      name: 'sectionShortcuts',
      desc: '',
      args: [],
    );
  }

  String get sectionEvents {
    return Intl.message(
      'Events',
      name: 'sectionEvents',
      desc: '',
      args: [],
    );
  }

  String get shortcutTypeMain {
    return Intl.message(
      'Main page',
      name: 'shortcutTypeMain',
      desc: '',
      args: [],
    );
  }

  String get shortcutTypeClassbook {
    return Intl.message(
      'Classbook',
      name: 'shortcutTypeClassbook',
      desc: '',
      args: [],
    );
  }

  String get shortcutTypeResource {
    return Intl.message(
      'Resource',
      name: 'shortcutTypeResource',
      desc: '',
      args: [],
    );
  }

  String get shortcutTypeOther {
    return Intl.message(
      'Other',
      name: 'shortcutTypeOther',
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

  String get hintWebsiteLabel {
    return Intl.message(
      'Google',
      name: 'hintWebsiteLabel',
      desc: '',
      args: [],
    );
  }

  String get hintWebsiteLink {
    return Intl.message(
      'http://google.com',
      name: 'hintWebsiteLink',
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

  String actionSignInWith(Object provider) {
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

  String get actionAddWebsite {
    return Intl.message(
      'Add website',
      name: 'actionAddWebsite',
      desc: '',
      args: [],
    );
  }

  String get actionEditWebsite {
    return Intl.message(
      'Edit website',
      name: 'actionEditWebsite',
      desc: '',
      args: [],
    );
  }

  String get actionDeleteWebsite {
    return Intl.message(
      'Delete website',
      name: 'actionDeleteWebsite',
      desc: '',
      args: [],
    );
  }

  String get actionEnableEditing {
    return Intl.message(
      'Enable editing',
      name: 'actionEnableEditing',
      desc: '',
      args: [],
    );
  }

  String get actionDisableEditing {
    return Intl.message(
      'Disable editing',
      name: 'actionDisableEditing',
      desc: '',
      args: [],
    );
  }

  String get actionJumpToToday {
    return Intl.message(
      'Jump to today',
      name: 'actionJumpToToday',
      desc: '',
      args: [],
    );
  }

  String get actionAddEvent {
    return Intl.message(
      'Add event',
      name: 'actionAddEvent',
      desc: '',
      args: [],
    );
  }

  String get actionEditEvent {
    return Intl.message(
      'Edit event',
      name: 'actionEditEvent',
      desc: '',
      args: [],
    );
  }

  String get actionDeleteEvent {
    return Intl.message(
      'Delete event',
      name: 'actionDeleteEvent',
      desc: '',
      args: [],
    );
  }

  String get actionAddClasses {
    return Intl.message(
      'Add classes',
      name: 'actionAddClasses',
      desc: '',
      args: [],
    );
  }

  String get actionAddShortcut {
    return Intl.message(
      'Add shortcut',
      name: 'actionAddShortcut',
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

  String errorCouldNotLaunchURL(Object url) {
    return Intl.message(
      'Could not launch \'$url\'.',
      name: 'errorCouldNotLaunchURL',
      desc: '',
      args: [url],
    );
  }

  String get errorPermissionDenied {
    return Intl.message(
      'You do not have permission to do that.',
      name: 'errorPermissionDenied',
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

  String warningEmailInUse(Object email) {
    return Intl.message(
      'There is already an account associated with $email.',
      name: 'warningEmailInUse',
      desc: '',
      args: [email],
    );
  }

  String warningUseProvider(Object provider) {
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

  String get warningFilterAlreadyDisabled {
    return Intl.message(
      'Already showing all content.',
      name: 'warningFilterAlreadyDisabled',
      desc: '',
      args: [],
    );
  }

  String get warningFilterAlreadyShowingYours {
    return Intl.message(
      'Already showing only custom websites.',
      name: 'warningFilterAlreadyShowingYours',
      desc: '',
      args: [],
    );
  }

  String get warningInvalidURL {
    return Intl.message(
      'You need to provide a valid URL.',
      name: 'warningInvalidURL',
      desc: '',
      args: [],
    );
  }

  String get warningWebsiteNameExists {
    return Intl.message(
      'A website with the same name already exists.',
      name: 'warningWebsiteNameExists',
      desc: '',
      args: [],
    );
  }

  String get warningNoPrivateWebsite {
    return Intl.message(
      'You have not created any private websites yet.',
      name: 'warningNoPrivateWebsite',
      desc: '',
      args: [],
    );
  }

  String get warningNoPermissionToAddPublicWebsite {
    return Intl.message(
      'You do not have permission to create a public website.',
      name: 'warningNoPermissionToAddPublicWebsite',
      desc: '',
      args: [],
    );
  }

  String get warningAuthenticationNeeded {
    return Intl.message(
      'Please authenticate in order to access this feature.',
      name: 'warningAuthenticationNeeded',
      desc: '',
      args: [],
    );
  }

  String get warningNothingToEdit {
    return Intl.message(
      'There is nothing you have permission to edit.',
      name: 'warningNothingToEdit',
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

  String get navigationClasses {
    return Intl.message(
      'Classes',
      name: 'navigationClasses',
      desc: '',
      args: [],
    );
  }

  String get navigationEventDetails {
    return Intl.message(
      'Event details',
      name: 'navigationEventDetails',
      desc: '',
      args: [],
    );
  }

  String get filterMenuShowAll {
    return Intl.message(
      'Show all',
      name: 'filterMenuShowAll',
      desc: '',
      args: [],
    );
  }

  String get filterMenuShowMine {
    return Intl.message(
      'Show only mine',
      name: 'filterMenuShowMine',
      desc: '',
      args: [],
    );
  }

  String get filterMenuRelevance {
    return Intl.message(
      'Filter by relevance',
      name: 'filterMenuRelevance',
      desc: '',
      args: [],
    );
  }

  String get relevanceOnlyMe {
    return Intl.message(
      'Only me',
      name: 'relevanceOnlyMe',
      desc: '',
      args: [],
    );
  }

  String get relevanceAnyone {
    return Intl.message(
      'Anyone',
      name: 'relevanceAnyone',
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
      'Dark Mode',
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

  String get settingsRelevanceFilter {
    return Intl.message(
      'Relevance filter',
      name: 'settingsRelevanceFilter',
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

  String get uniEventTypeLab {
    return Intl.message(
      'Lab',
      name: 'uniEventTypeLab',
      desc: '',
      args: [],
    );
  }

  String get uniEventTypeSeminar {
    return Intl.message(
      'Seminar',
      name: 'uniEventTypeSeminar',
      desc: '',
      args: [],
    );
  }

  String get uniEventTypeLecture {
    return Intl.message(
      'Lecture',
      name: 'uniEventTypeLecture',
      desc: '',
      args: [],
    );
  }

  String get uniEventTypeSports {
    return Intl.message(
      'Sports',
      name: 'uniEventTypeSports',
      desc: '',
      args: [],
    );
  }

  String get uniEventTypeExam {
    return Intl.message(
      'Exam',
      name: 'uniEventTypeExam',
      desc: '',
      args: [],
    );
  }

  String get uniEventTypeHomework {
    return Intl.message(
      'Homework',
      name: 'uniEventTypeHomework',
      desc: '',
      args: [],
    );
  }

  String get uniEventTypeProject {
    return Intl.message(
      'Project',
      name: 'uniEventTypeProject',
      desc: '',
      args: [],
    );
  }

  String get uniEventTypeTest {
    return Intl.message(
      'Test',
      name: 'uniEventTypeTest',
      desc: '',
      args: [],
    );
  }

  String get uniEventTypePractical {
    return Intl.message(
      'Practical',
      name: 'uniEventTypePractical',
      desc: '',
      args: [],
    );
  }

  String get uniEventTypeResearch {
    return Intl.message(
      'Research',
      name: 'uniEventTypeResearch',
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

  String messageWelcomeName(Object name) {
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

  String get messageWebsitePreview {
    return Intl.message(
      'Try tapping/long-pressing/hovering the preview to test the new website.',
      name: 'messageWebsitePreview',
      desc: '',
      args: [],
    );
  }

  String get messageAddCustomWebsite {
    return Intl.message(
      'Try adding a custom website.',
      name: 'messageAddCustomWebsite',
      desc: '',
      args: [],
    );
  }

  String get messageWebsiteAdded {
    return Intl.message(
      'Website added successfully.',
      name: 'messageWebsiteAdded',
      desc: '',
      args: [],
    );
  }

  String get messageWebsiteEdited {
    return Intl.message(
      'Website modified successfully.',
      name: 'messageWebsiteEdited',
      desc: '',
      args: [],
    );
  }

  String get messageDeleteWebsite {
    return Intl.message(
      'Are you sure you want to delete this website?',
      name: 'messageDeleteWebsite',
      desc: '',
      args: [],
    );
  }

  String get messageWebsiteDeleted {
    return Intl.message(
      'Website deleted successfully.',
      name: 'messageWebsiteDeleted',
      desc: '',
      args: [],
    );
  }

  String get messageDeleteEvent {
    return Intl.message(
      'Are you sure you want to delete this event?',
      name: 'messageDeleteEvent',
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

  String get infoRelevance {
    return Intl.message(
      'Try to choose the most restrictive category.',
      name: 'infoRelevance',
      desc: '',
      args: [],
    );
  }

  String get infoRelevanceExample {
    return Intl.message(
      'For instance, if something is only relevant for "314CB" and "315CB", don\'t just set "CB".',
      name: 'infoRelevanceExample',
      desc: '',
      args: [],
    );
  }

  String get infoPassword {
    return Intl.message(
      'It must contain lower and uppercase letters, one number and one special character (!@#\$&*~), and have a minimum length of 8.',
      name: 'infoPassword',
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
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ro'),
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
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}