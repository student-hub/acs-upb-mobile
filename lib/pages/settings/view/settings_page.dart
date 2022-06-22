import 'dart:io';

import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:pref/pref.dart';
import 'package:provider/provider.dart';

import '../../../authentication/service/auth_provider.dart';
import '../../../generated/l10n.dart';
import '../../../navigation/routes.dart';
import '../../../resources/locale_provider.dart';
import '../../../resources/theme.dart';
import '../../../resources/utils.dart';
import '../../../widgets/icon_text.dart';
import '../../../widgets/scaffold.dart';
import '../../../widgets/toast.dart';
import '../../timetable/service/uni_event_provider.dart';
import '../service/request_provider.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = '/settings';

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Whether the user verified their email; this can be true, false or null if
  // the async check hasn't completed yet.
  bool isVerified;
  bool receiveNotifications;

  // String describing the level of editing permissions that the user has.
  String userPermissionString = '';

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    receiveNotifications =
        authProvider.currentUserFromCache?.receiveNotifications;
    authProvider.isVerified
        .then((final value) => setState(() => isVerified = value));
  }

  @override
  Widget build(final BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    if (userPermissionString.isEmpty) {
      userPermissionString = S.current.infoLoading;
      checkUserPermissionsString()
          .then((final value) => setState(() => userPermissionString = value));
    }

    return AppScaffold(
      title: Text(S.current.navigationSettings),
      body: PrefPage(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height / 3,
                      child: Image.asset(
                          'assets/illustrations/undraw_settings.png')),
                ),
                const SizedBox(height: 10),
                categoryTitle(S.current.settingsTitlePersonalization),
                // TODO(IoanaAlexandru): Make this an option out of 3 (light, dark, auto)
                PrefSwitch(
                  title: Text(S.current.settingsItemDarkMode),
                  pref: 'dark_mode',
                  onChange: (final selected) {
                    if (selected) {
                      EasyDynamicTheme.of(context).changeTheme(dark: true);
                    } else {
                      EasyDynamicTheme.of(context).changeTheme(dark: false);
                    }
                  },
                ),
                if (authProvider.isAuthenticated &&
                    !authProvider.isAnonymous) ...[
                  categoryTitle('Notifications'),
                  ListTile(
                    enabled: true,
                    title: const Text('News'),
                    trailing: Switch(
                      value: receiveNotifications,
                      onChanged: (final selected) {
                        if (selected) {
                          authProvider
                            ..enableReceiveNotifications()
                            ..setMessagingTokenIfNotExist();
                        } else {
                          authProvider
                            ..disableReceiveNotifications()
                            ..removeMessagingTokenIfExists();
                        }
                        setState(() {
                          receiveNotifications = selected;
                        });
                      },
                    ),
                  ),
                ],
                categoryTitle(S.current.settingsTitleLocalization),
                PrefDialogButton(
                  title: Text(S.current.settingsItemLanguage),
                  subtitle: Text(
                      languagePrefString(context, prefService.get('language'))),
                  dialog: PrefDialog(
                    children: [
                      languageRadioPreference(context, 'ro'),
                      languageRadioPreference(context, 'en'),
                      languageRadioPreference(context, 'auto'),
                    ],
                    onlySaveOnSubmit: false,
                  ),
                ),
                categoryTitle(S.current.settingsTitleDataControl),
                ListTile(
                  key: const ValueKey('ask_permissions'),
                  onTap: () {
                    if (authProvider.isAnonymous) {
                      AppToast.show(S.current.messageNotLoggedIn);
                    } else if (isVerified != true) {
                      AppToast.show(
                          S.current.messageEmailNotVerifiedToPerformAction);
                    } else {
                      Navigator.of(context)
                          .pushNamed(Routes.requestPermissions);
                    }
                  },
                  title: Text(S.current.settingsItemEditingPermissions),
                  subtitle: Text(userPermissionString),
                ),
                if (authProvider.isAuthenticated &&
                    !authProvider.isAnonymous &&
                    authProvider.currentUserFromCache.canEditPublicInfo) ...[
                  ListTile(
                    key: const ValueKey('ask_roles'),
                    onTap: () {
                      if (authProvider.isAnonymous) {
                        AppToast.show(S.current.messageNotLoggedIn);
                      } else {
                        Navigator.of(context).pushNamed(Routes.requestRoles);
                      }
                    },
                    title: const Text('Your user roles'),
                    subtitle: const Text('Ask for one or more roles'),
                  ),
                ],
                ListTile(
                  key: const ValueKey('edit_source_selection'),
                  onTap: () {
                    if (authProvider.isAnonymous) {
                      AppToast.show(S.current.messageNotLoggedIn);
                    } else {
                      Navigator.of(context).pushNamed(Routes.sources);
                    }
                  },
                  title: Text(S.current.settingsSourceSelection),
                  subtitle: Text(S.current.settingsSourceSelectionSubtitle),
                ),
                ListTile(
                  onTap: () => Utils.launchURL(Utils.privacyPolicyURL),
                  title: Text(S.current.labelPrivacyPolicy),
                  subtitle: Text(
                    S.current.infoReadThePolicy(Utils.packageInfo.appName),
                  ),
                ),
                Visibility(
                  visible: authProvider.isAuthenticated &&
                      !authProvider.isAnonymous &&
                      authProvider.currentUserFromCache.isAdmin == true,
                  child: ListTile(
                    key: const Key('AdminPanel'),
                    onTap: () =>
                        Navigator.of(context).pushNamed(Routes.adminPanel),
                    title: Text(S.current.settingsItemAdmin),
                    subtitle: Text(S.current.infoAdmin),
                  ),
                ),
                Visibility(
                  visible: Platform.isAndroid || Platform.isIOS,
                  child: categoryTitle(S.current.settingsTitleTimetable),
                ),
                Visibility(
                  visible: Platform.isAndroid || Platform.isIOS,
                  child: ListTile(
                    key: const ValueKey('google_calendar'),
                    onTap: () async {
                      if (authProvider.isAnonymous) {
                        AppToast.show(S.current.messageNotLoggedIn);
                      } else {
                        final eventProvider = Provider.of<UniEventProvider>(
                            context,
                            listen: false);
                        await eventProvider.exportToGoogleCalendar();
                      }
                    },
                    title: Text(S.current.settingsExportToGoogleCalendar),
                    subtitle: Text(S.current.infoExportToGoogleCalendar),
                  ),
                ),
                categoryTitle(S.current.labelFeedback),
                ListTile(
                  key: const ValueKey('feedback_and_issues'),
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.feedbackForm);
                  },
                  title: Text(S.current.settingsFeedbackForm),
                  subtitle: Text(S.current.infoFeedbackForm),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: IconText(
                        icon: FeatherIcons.github,
                        text: S
                            .of(context)
                            .infoAppIsOpenSource(Utils.packageInfo.appName),
                        actionText: S.current.actionContribute,
                        actionArrow: true,
                        align: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .apply(color: Theme.of(context).hintColor),
                        onTap: () => Utils.launchURL(Utils.repoURL),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        '${S.current.labelVersion} ${Utils.packageInfo.version}+${(int.parse(Utils.packageInfo.buildNumber) % 10000).toString()}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .apply(color: Theme.of(context).hintColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget categoryTitle(final String title) => Padding(
        padding: const EdgeInsets.only(left: 10, top: 10),
        child: Text(
          title,
          style: Theme.of(context)
              .coloredTextTheme
              .subtitle2
              .apply(fontWeightDelta: 2),
        ),
      );

  PrefRadio<String> languageRadioPreference(
      final BuildContext context, final String preference) {
    return PrefRadio(
      title: Text(languagePrefString(context, preference)),
      value: preference,
      pref: 'language',
      onSelect: () {
        // Reload settings page
        setState(() {
          S.load(LocaleProvider.localeFromString(preference));
          Navigator.of(context).pop();
        });
      },
    );
  }

  String languagePrefString(
      final BuildContext context, final String preference) {
    switch (preference) {
      case 'en':
        return S.current.settingsItemLanguageEnglish;
      case 'ro':
        return S.current.settingsItemLanguageRomanian;
      case 'auto':
        return S.current.settingsItemLanguageAuto;
      default:
        stderr.writeln('Invalid preference string: $preference');
        return S.current.settingsItemLanguageAuto;
    }
  }

  Future<String> checkUserPermissionsString() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final requestProvider =
        Provider.of<RequestProvider>(context, listen: false);

    if (authProvider.isAuthenticated && !authProvider.isAnonymous) {
      final user = await authProvider.currentUser;
      if (user.isAdmin) {
        return S.current.settingsAdminPermissions;
      } else if (user.canEditPublicInfo) {
        return S.current.settingsPermissionsEdit;
      } else if (user.canAddPublicInfo) {
        return S.current.settingsPermissionsAdd;
      } else if (await requestProvider.userAlreadyRequested(user.uid)) {
        return S.current.settingsPermissionsRequestSent;
      }
    }
    return S.current.settingsPermissionsNone;
  }
}
