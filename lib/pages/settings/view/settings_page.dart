import 'dart:io';

import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/pages/settings/service/request_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/pages/settings/view/source_page.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/routes.dart';
import 'package:acs_upb_mobile/resources/custom_icons.dart';
import 'package:acs_upb_mobile/resources/locale_provider.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:acs_upb_mobile/widgets/icon_text.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';
import 'package:time_machine/time_machine.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = '/settings';

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  PackageInfo _packageInfo = PackageInfo(
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    // package_info_plus is not compatible with flutter_test
    // link to the issue: https://github.com/fluttercommunity/plus_plugins/issues/172
    if (!Platform.environment.containsKey('FLUTTER_TEST')) {
      final info = await PackageInfo.fromPlatform();
      setState(() {
        _packageInfo = info;
      });
    }
  }

  // Whether the user verified their email; this can be true, false or null if
  // the async check hasn't completed yet.
  bool isVerified;

  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false)
        .isVerified
        .then((value) => setState(() => isVerified = value));
    _initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return AppScaffold(
      title: Text(S.of(context).navigationSettings),
      body: Builder(
        builder: (BuildContext context) {
          return Column(
            children: <Widget>[
              Expanded(
                child: PreferencePage(
                  [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                          height: MediaQuery.of(context).size.height / 3,
                          child: Image.asset(
                              'assets/illustrations/undraw_settings.png')),
                    ),
                    PreferenceTitle(S.of(context).settingsTitlePersonalization),
                    SwitchPreference(
                      S.of(context).settingsItemDarkMode,
                      'dark_mode',
                      onEnable: () {
                        DynamicTheme.of(context).setBrightness(Brightness.dark);
                      },
                      onDisable: () {
                        DynamicTheme.of(context)
                            .setBrightness(Brightness.light);
                      },
                      defaultVal: MediaQuery.of(context).platformBrightness ==
                          Brightness.dark,
                    ),
                    PreferenceTitle(S.of(context).settingsTitleLocalization),
                    PreferenceDialogLink(
                      S.of(context).settingsItemLanguage,
                      desc: languagePrefString(PrefService.get('language')),
                      dialog: PreferenceDialog(
                        [
                          languageRadioPreference(context, 'ro'),
                          languageRadioPreference(context, 'en'),
                          languageRadioPreference(context, 'auto'),
                        ],
                        onlySaveOnSubmit: false,
                      ),
                    ),
                    PreferenceTitle(S.of(context).settingsTitleData),
                    ListTile(
                      onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<SourcePage>(
                              builder: (context) => SourcePage())),
                      title: Text(S.of(context).sectionInformationSources),
                      subtitle: FutureBuilder<User>(
                          future: authProvider.currentUser,
                          builder: (context, snap) {
                            if (snap.hasData) {
                              final sources = snap.data.sources;
                              return Text(((sources?.isEmpty ?? true) ||
                                      sources.length == 3)
                                  ? S.of(context).labelAll
                                  : sources
                                      .map(localizedSourceString)
                                      .toList()
                                      .join(', '));
                            } else {
                              return Container();
                            }
                          }),
                    ),
                    ListTile(
                      key: const ValueKey('ask_permissions'),
                      onTap: () {
                        if (authProvider.isAnonymous) {
                          AppToast.show(S.of(context).messageNotLoggedIn);
                        } else if (isVerified != true) {
                          AppToast.show(S
                              .of(context)
                              .messageEmailNotVerifiedToPerformAction);
                        } else {
                          Navigator.of(context)
                              .pushNamed(Routes.requestPermissions);
                        }
                      },
                      title: Text('Editing permissions'),
                      subtitle: FutureBuilder<String>(
                        future: userPermissionsString(),
                        builder: (context, snap) =>
                            snap.hasData ? Text(snap.data) : Container(),
                      ),
                    ),
                    const Divider(),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: IconText(
                            icon: Icons.lock_outline,
                            text: S.of(context).labelPrivacyPolicy,
                            align: TextAlign.center,
                            onTap: () => Utils.launchURL(
                                'https://www.websitepolicies.com/policies/view/IIUFv381',
                                context: context),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: IconText(
                            icon: CustomIcons.github_brands,
                            text: S.of(context).infoAppIsOpenSource,
                            actionText: S.of(context).actionContribute,
                            actionArrow: true,
                            align: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .apply(color: Theme.of(context).hintColor),
                            onTap: () => Utils.launchURL(
                                'https://github.com/acs-upb-mobile/acs-upb-mobile',
                                context: context),
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            '${S.of(context).labelVersion} ${_packageInfo.version}+${_packageInfo.buildNumber}',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyText1.apply(
                                  color: Theme.of(context).disabledColor,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  RadioPreference<String> languageRadioPreference(
      BuildContext context, String preference) {
    return RadioPreference(
      languagePrefString(preference),
      preference,
      'language',
      onSelect: () {
        // Reload settings page
        setState(() {
          Culture.current = LocaleProvider.cultures[preference];
          S.load(LocaleProvider.localeFromString(preference));
          Navigator.of(context).pop();

          // Hack to notify all widgets that something changed, since the
          // localizations delegate doesn't do that. Pretend to change the theme
          // so that listeners have to reload.
          DynamicTheme.of(context)
              .setBrightness(DynamicTheme.of(context).brightness);
        });
      },
    );
  }

  String languagePrefString(String preference) {
    switch (preference) {
      case 'en':
        return S.of(context).settingsItemLanguageEnglish;
      case 'ro':
        return S.of(context).settingsItemLanguageRomanian;
      case 'auto':
        return S.of(context).settingsItemLanguageAuto;
      default:
        stderr.writeln('Invalid preference string: $preference');
        return S.of(context).settingsItemLanguageAuto;
    }
  }

  String localizedSourceString(String source) {
    switch (source) {
      case 'official':
        return S.of(context).sourceOfficial;
      case 'organizations':
        return S.of(context).sourceOrganization;
      case 'students':
        return S.of(context).sourceStudentRepresentative;
      default:
        return source;
    }
  }

  Future<String> userPermissionsString() async {
    final authProvider = Provider.of<AuthProvider>(context);
    final requestProvider = Provider.of<RequestProvider>(context);

    if (authProvider.isAuthenticated && !authProvider.isAnonymous) {
      final user = await authProvider.currentUser;
      if (user.canEditPublicInfo) {
        return 'Permission to edit public info';
      } else if (user.canAddPublicInfo) {
        return 'Permission to add public info';
      } else if (await requestProvider.userAlreadyRequested(user.uid)) {
        return 'Request already sent';
      }
    }
    return 'No permissions';
  }
}
