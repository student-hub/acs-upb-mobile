import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/authentication/view/login_view.dart';
import 'package:acs_upb_mobile/authentication/view/sign_up_view.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/bottom_navigation_bar.dart';
import 'package:acs_upb_mobile/navigation/routes.dart';
import 'package:acs_upb_mobile/pages/filter/service/filter_provider.dart';
import 'package:acs_upb_mobile/pages/filter/view/filter_page.dart';
import 'package:acs_upb_mobile/pages/settings/settings_page.dart';
import 'package:acs_upb_mobile/resources/storage_provider.dart';
import 'package:acs_upb_mobile/widgets/loading_screen.dart';
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

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
    ChangeNotifierProvider<StorageProvider>(create: (_) => StorageProvider()),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  final List<NavigatorObserver> navigationObservers;

  MyApp({this.navigationObservers});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Color _accentColor = Color(0xFF43ADCD);

  Widget buildApp(BuildContext context, ThemeData theme) {
    return MaterialApp(
      title: "ACS UPB Mobile",
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        S.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: theme,
      initialRoute: Routes.root,
      routes: {
        Routes.root: (_) => buildSplashScreen(context),
        Routes.home: (_) => ChangeNotifierProvider<BottomNavigationBarProvider>(
            child: AppBottomNavigationBar(),
            create: (_) => BottomNavigationBarProvider()),
        Routes.settings: (_) => SettingsPage(),
        Routes.filter: (_) => ChangeNotifierProvider<FilterProvider>(
          child: FilterPage(),
          create: (_) => FilterProvider(),
        ),
        Routes.login: (_) => LoginView(),
        Routes.signUp: (_) => SignUpView(),
      },
      navigatorObservers: widget.navigationObservers ?? [],
    );
  }

  Future<String> chooseStartScreen() async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    bool authenticated = await authProvider.isAuthenticatedAsync;
    return authenticated ? Routes.home : Routes.login;
  }

  Widget buildSplashScreen(BuildContext context) {
    return LoadingScreen(
      navigateAfterFuture: chooseStartScreen(),
      loadingText: Text('Signing in...'),
      image: Image.asset('assets/icons/acs_logo.png'),
      loaderColor: Theme.of(context).accentColor,
    );
  }

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
        return OKToast(
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
            child: buildApp(context, theme),
          ),
        );
      },
    );
  }
}
