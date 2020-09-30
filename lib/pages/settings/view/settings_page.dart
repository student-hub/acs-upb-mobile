import 'dart:io';

import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/resources/custom_icons.dart';
import 'package:acs_upb_mobile/resources/locale_provider.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:acs_upb_mobile/widgets/icon_text.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';

import 'package:acs_upb_mobile/pages/settings/view/ask_permissions.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = '/settings';

  @override
  State<StatefulWidget> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: S.of(context).navigationSettings,
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
                      desc: languagePrefString(
                          context, PrefService.get('language')),
                      dialog: PreferenceDialog(
                        [
                          languageRadioPreference(context, 'ro'),
                          languageRadioPreference(context, 'en'),
                          languageRadioPreference(context, 'auto'),
                        ],
                        onlySaveOnSubmit: false,
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
                        Divider(),
                        FlatButton(
                          onPressed: () => {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AskPermissions())),
                          },
                          child: Text(
                            S.of(context).labelAskPermissions,
                            textAlign: TextAlign.center,
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
      languagePrefString(context, preference),
      preference,
      'language',
      onSelect: () {
        // Reload settings page
        setState(() {
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

  String languagePrefString(BuildContext context, String preference) {
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
}
