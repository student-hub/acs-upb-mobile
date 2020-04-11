import 'dart:io';

import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/resources/locale_provider.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:preferences/preferences.dart';

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
        enableMenu: false,
        body: Builder(
          builder: (BuildContext context) {
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                      height: ScreenUtil().setHeight(800),
                      child: Image.asset(
                          'assets/illustrations/undraw_settings.png')),
                ),
                Expanded(
                  child: PreferencePage(
                    [
                      PreferenceTitle(
                          S.of(context).settingsTitlePersonalization),
                      SwitchPreference(
                        S.of(context).settingsItemDarkMode,
                        "dark_mode",
                        onEnable: () {
                          DynamicTheme.of(context)
                              .setBrightness(Brightness.dark);
                        },
                        onDisable: () {
                          DynamicTheme.of(context)
                              .setBrightness(Brightness.light);
                        },
                        defaultVal: true,
                      ),
                      PreferenceTitle(S.of(context).settingsTitleLocalization),
                      PreferenceDialogLink(S.of(context).settingsItemLanguage,
                          desc: languagePrefString(
                              context, PrefService.get('language')),
                          dialog: PreferenceDialog(
                            [
                              languageRadioPreference(context, 'ro'),
                              languageRadioPreference(context, 'en'),
                              languageRadioPreference(context, 'auto'),
                            ],
                            onlySaveOnSubmit: false,
                          ))
                    ],
                  ),
                ),
              ],
            );
          },
        ));
  }

  RadioPreference languageRadioPreference(
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
        stderr.writeln("Invalid preference string: $preference");
        return S.of(context).settingsItemLanguageAuto;
    }
  }
}
