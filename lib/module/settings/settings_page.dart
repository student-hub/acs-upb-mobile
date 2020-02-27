import 'dart:io';

import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/widget/scaffold.dart';
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
    ScreenUtil.init(context, width: 1080, height: 2160, allowFontScaling: true);

    return AppScaffold(
        title: S.of(context).drawerItemSettings,
        settingsAction: false,
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
                          desc: getLanguagePrefString(
                              context, PrefService.get('language')),
                          dialog: PreferenceDialog(
                            [
                              getLanguageRadioPreference(context, 'ro'),
                              getLanguageRadioPreference(context, 'en'),
                              getLanguageRadioPreference(context, 'auto'),
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

  RadioPreference getLanguageRadioPreference(
      BuildContext context, String preference) {
    return RadioPreference(
      getLanguagePrefString(context, preference),
      preference,
      'language',
      onSelect: () {
        S.load(getLocale(context, preference));
        Navigator.of(context).pop();
        // Reload settings page
        setState(() {});
      },
    );
  }

  String getLanguagePrefString(BuildContext context, String preference) {
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

  Locale getLocale(BuildContext context, String preference) {
    switch (preference) {
      case 'en':
        return Locale('en', 'US');
      case 'ro':
        return Locale('ro', 'RO');
      case 'auto':
        return getLocale(context, S.of(context).localeName);
      default:
        stderr.writeln("Invalid preference string: $preference");
        return getLocale(context, S.of(context).localeName);
    }
  }
}
