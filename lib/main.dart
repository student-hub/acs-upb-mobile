import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/authentication/view/login_view.dart';
import 'package:acs_upb_mobile/authentication/view/sign_up_view.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/bottom_navigation_bar.dart';
import 'package:acs_upb_mobile/navigation/routes.dart';
import 'package:acs_upb_mobile/pages/classes/service/class_provider.dart';
import 'package:acs_upb_mobile/pages/faq/service/question_provider.dart';
import 'package:acs_upb_mobile/pages/faq/view/faq_page.dart';
import 'package:acs_upb_mobile/pages/filter/service/filter_provider.dart';
import 'package:acs_upb_mobile/pages/news_feed/service/news_feed_provider.dart';
import 'package:acs_upb_mobile/pages/news_feed/view/news_feed_page.dart';
import 'package:acs_upb_mobile/pages/people/service/person_provider.dart';
import 'package:acs_upb_mobile/pages/portal/service/website_provider.dart';
import 'package:acs_upb_mobile/pages/settings/service/request_provider.dart';
import 'package:acs_upb_mobile/pages/settings/view/settings_page.dart';
import 'package:acs_upb_mobile/resources/locale_provider.dart';
import 'package:acs_upb_mobile/widgets/loading_screen.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:preferences/preferences.dart';
import 'package:provider/provider.dart';
import 'package:time_machine/time_machine.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TimeMachine.initialize({'rootBundle': rootBundle});
  await PrefService.init(prefix: 'pref_');
  PrefService.setDefaultValues({'language': 'auto', 'relevance_filter': true});

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
    ChangeNotifierProvider<WebsiteProvider>(create: (_) => WebsiteProvider()),
    Provider<RequestProvider>(create: (_) => RequestProvider()),
    ChangeNotifierProvider<ClassProvider>(create: (_) => ClassProvider()),
    ChangeNotifierProvider<PersonProvider>(create: (_) => PersonProvider()),
    ChangeNotifierProvider<QuestionProvider>(create: (_) => QuestionProvider()),
    ChangeNotifierProvider<NewsFeedProvider>(create: (_) => NewsFeedProvider()),
    ChangeNotifierProvider<FilterProvider>(
        create: (_) => FilterProvider(global: true)),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({this.navigationObservers});

  final List<NavigatorObserver> navigationObservers;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Color _accentColor = const Color(0xFF43ACCD);

  Widget buildApp(BuildContext context, ThemeData theme) {
    return MaterialApp(
      title: 'ACS UPB Mobile',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        S.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: theme,
      initialRoute: Routes.root,
      routes: {
        Routes.root: (_) => AppLoadingScreen(),
        Routes.home: (_) => const AppBottomNavigationBar(),
        Routes.settings: (_) => SettingsPage(),
        Routes.login: (_) => LoginView(),
        Routes.signUp: (_) => SignUpView(),
        Routes.faq: (_) => FaqPage(),
        Routes.newsFeed: (_) => NewsFeedPage(),
      },
      navigatorObservers: widget.navigationObservers ?? [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: SchedulerBinding.instance.window.platformBrightness,
      data: (brightness) => ThemeData(
        brightness: brightness,
        accentColor: _accentColor,
        // The following two lines are meant to remove the splash effect
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        accentTextTheme: ThemeData().accentTextTheme.apply(
            fontFamily: 'Montserrat',
            bodyColor: _accentColor,
            displayColor: _accentColor),
        toggleableActiveColor: _accentColor,
        fontFamily: 'Montserrat',
        primaryColor: const Color(0xFF4DB5E4),
      ),
      themedWidgetBuilder: (context, theme) {
        return OKToast(
          textStyle: theme.textTheme.button,
          backgroundColor: theme.accentColor.withOpacity(.8),
          position: ToastPosition.bottom,
          child: GestureDetector(
            onTap: () {
              // Remove current focus on tap
              final currentFocus = FocusScope.of(context);
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

class AppLoadingScreen extends StatelessWidget {
  Future<String> _setUpAndChooseStartScreen(BuildContext context) async {
    // Load locale from settings
    await S.load(LocaleProvider.locale);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final bool authenticated = await authProvider.isAuthenticatedFromService;
    return authenticated ? Routes.home : Routes.login;
  }

  @override
  Widget build(BuildContext context) {
    return LoadingScreen(
      navigateAfterFuture: _setUpAndChooseStartScreen(context),
      loadingText: const Text('Setting up...'),
      image: Image.asset('assets/icons/acs_logo.png'),
      loaderColor: Theme.of(context).accentColor,
    );
  }
}
