import 'package:acs_upb_mobile/authentication/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/navigator.dart';
import 'package:acs_upb_mobile/navigation/routes.dart';
import 'package:acs_upb_mobile/pages/home/home_page.dart';
import 'package:acs_upb_mobile/pages/settings/settings_page.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefService.init(prefix: 'pref_');
  PrefService.setDefaultValues({'language': 'auto'});
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Color _accentColor = Color.fromARGB(255, 67, 172, 205);
  final AuthProvider authProvider;

  MyApp({AuthProvider authProvider})
      : this.authProvider = authProvider ?? AuthProvider();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.dark,
        data: (brightness) => ThemeData(
            brightness: brightness,
            accentColor: _accentColor,
            toggleableActiveColor: _accentColor,
            appBarTheme: brightness == Brightness.light
                ? AppBarTheme(color: _accentColor)
                : AppBarTheme(),
            fontFamily: 'Montserrat'),
        themedWidgetBuilder: (context, theme) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>(create: (_) => authProvider)
            ],
            child: MaterialApp(
                title: "ACS UPB Mobile",
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  S.delegate
                ],
                supportedLocales: S.delegate.supportedLocales,
                theme: theme,
                routes: {
                  Routes.home: (context) => HomePage(),
                  Routes.settings: (context) => SettingsPage(),
                },
                home: AppNavigator()),
          );
        });
  }
}
