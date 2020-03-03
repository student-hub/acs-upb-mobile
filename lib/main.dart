import 'package:acs_upb_mobile/authentication/auth_provider.dart';
import 'package:acs_upb_mobile/authentication/view/login_view.dart';
import 'package:acs_upb_mobile/authentication/view/sign_up_view.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/bottom_navigation_bar.dart';
import 'package:acs_upb_mobile/navigation/routes.dart';
import 'package:acs_upb_mobile/pages/settings/settings_page.dart';
import 'package:acs_upb_mobile/pages/websites/website_provider.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefService.init(prefix: 'pref_');
  PrefService.setDefaultValues({'language': 'auto'});
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Color _accentColor = Color(0xFF43ADCD);
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
          accentTextTheme: ThemeData().accentTextTheme.apply(
              fontFamily: 'Montserrat',
              bodyColor: _accentColor,
              displayColor: _accentColor),
          toggleableActiveColor: _accentColor,
          appBarTheme: brightness == Brightness.light
              ? AppBarTheme(color: _accentColor)
              : AppBarTheme(),
          fontFamily: 'Montserrat'),
      themedWidgetBuilder: (context, theme) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>(create: (_) => authProvider),
            ChangeNotifierProvider<WebsiteProvider>(create: (_) => WebsiteProvider()),
          ],
          child: OKToast(
            textStyle: theme.textTheme.button,
            backgroundColor: theme.accentColor.withOpacity(.8),
            position: ToastPosition.bottom,
            child: GestureDetector(
              onTap: () {
                // Remove current focus on tap
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: MaterialApp(
                title: "ACS UPB Mobile",
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  S.delegate
                ],
                supportedLocales: S.delegate.supportedLocales,
                theme: theme,
                initialRoute:
                    authProvider.isAuthenticated ? Routes.home : Routes.login,
                routes: {
                  Routes.home: (_) =>
                      ChangeNotifierProvider<BottomNavigationBarProvider>(
                          child: AppBottomNavigationBar(),
                          create: (_) => BottomNavigationBarProvider()),
                  Routes.settings: (_) => SettingsPage(),
                  Routes.login: (_) => LoginView(),
                  Routes.signUp: (_) => SignUpView(),
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
