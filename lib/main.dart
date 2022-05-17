import 'dart:io';

import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pref/pref.dart';
import 'package:provider/provider.dart';
import 'package:rrule/rrule.dart';
import 'package:timetable/timetable.dart';

import 'authentication/service/auth_provider.dart';
import 'authentication/view/login_view.dart';
import 'authentication/view/sign_up_view.dart';
import 'generated/l10n.dart';
import 'navigation/bottom_navigation_bar.dart';
import 'navigation/routes.dart';
import 'pages/class_feedback/service/feedback_provider.dart';
import 'pages/classes/service/class_provider.dart';
import 'pages/faq/service/faq_question_provider.dart';
import 'pages/faq/view/faq_page.dart';
import 'pages/filter/service/filter_provider.dart';
import 'pages/filter/view/filter_page.dart';
import 'pages/news_feed/service/news_provider.dart';
import 'pages/news_feed/view/news_feed_page.dart';
import 'pages/people/service/person_provider.dart';
import 'pages/portal/service/website_provider.dart';
import 'pages/settings/service/admin_provider.dart';
import 'pages/settings/service/issue_provider.dart';
import 'pages/settings/service/request_provider.dart';
import 'pages/settings/view/admin_page.dart';
import 'pages/settings/view/feedback_form.dart';
import 'pages/settings/view/request_permissions.dart';
import 'pages/settings/view/settings_page.dart';
import 'pages/settings/view/source_page.dart';
import 'pages/timetable/service/uni_event_provider.dart';
import 'resources/locale_provider.dart';
import 'resources/remote_config.dart';
import 'resources/theme.dart';
import 'resources/utils.dart';
import 'widgets/loading_screen.dart';

// FIXME: Our university website certificates have some issues, so we say we
// trust them regardless.
// Remove this in the future.
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(final SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (final X509Certificate cert, final String host, final int port) {
        return host == 'acs.pub.ro' ||
            host == 'cs.pub.ro' ||
            host == 'aii.pub.ro';
      };
  }
}

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();

  // package_info_plus is not compatible with flutter_test
  // link to the issue: https://github.com/fluttercommunity/plus_plugins/issues/172
  Utils.packageInfo = await PackageInfo.fromPlatform();

  await Firebase.initializeApp();

  final authProvider = AuthProvider();
  final classProvider = ClassProvider();
  final personProvider = PersonProvider();
  final feedbackProvider = FeedbackProvider();

  prefService = await PrefServiceShared.init(
      prefix: 'pref_',
      defaults: {'language': 'auto', 'relevance_filter': true});

  runApp(
    EasyDynamicThemeWidget(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(
              create: (final _) => authProvider),
          Provider<RequestProvider>(create: (final _) => RequestProvider()),
          Provider<IssueProvider>(create: (final _) => IssueProvider()),
          ChangeNotifierProvider<ClassProvider>(
              create: (final _) => classProvider),
          ChangeNotifierProvider<FeedbackProvider>(
              create: (final _) => feedbackProvider),
          ChangeNotifierProvider<PersonProvider>(
              create: (final _) => personProvider),
          ChangeNotifierProvider<NewsProvider>(
              create: (final _) => NewsProvider()),
          ChangeNotifierProxyProvider<AuthProvider, FilterProvider>(
            create: (final _) => FilterProvider(global: true),
            update: (final context, final authProvider, final filterProvider) {
              return filterProvider..updateAuth(authProvider);
            },
          ),
          ChangeNotifierProxyProvider<AuthProvider, FaqQuestionProvider>(
            create: (final _) => FaqQuestionProvider(),
            update:
                (final context, final authProvider, final faqQuestionProvider) {
              return faqQuestionProvider..updateAuth(authProvider);
            },
          ),
          ChangeNotifierProxyProvider<AuthProvider, WebsiteProvider>(
            create: (final _) => WebsiteProvider(),
            update: (final context, final authProvider, final websiteProvider) {
              return websiteProvider..updateAuth(authProvider);
            },
          ),
          ChangeNotifierProxyProvider2<ClassProvider, FilterProvider,
              UniEventProvider>(
            create: (final _) => UniEventProvider(
              authProvider: authProvider,
              personProvider: personProvider,
            ),
            update: (final context, final classProvider, final filterProvider,
                final uniEventProvider) {
              return uniEventProvider
                ..updateClasses(classProvider)
                ..updateFilter(filterProvider);
            },
          ),
          ChangeNotifierProxyProvider<AuthProvider, AdminProvider>(
            create: (final _) => AdminProvider(),
            update: (final context, final authProvider, final adminProvider) {
              return adminProvider..updateAuth(authProvider);
            },
          ),
        ],
        child: PrefService(
          service: prefService,
          child: const MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({this.navigationObservers});

  final List<NavigatorObserver> navigationObservers;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(final BuildContext context) {
    return OKToast(
      textStyle: lightThemeData.textTheme.button,
      backgroundColor: primaryColor.withOpacity(.8),
      position: ToastPosition.bottom,
      child: GestureDetector(
        onTap: () {
          // Remove current focus on tap
          final currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: MaterialApp(
          title: Utils.packageInfo.appName,
          themeMode: EasyDynamicTheme.of(context).themeMode,
          theme: lightThemeData,
          darkTheme: darkThemeData,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            S.delegate,
            const TimetableLocalizationsDelegate(),
          ],
          supportedLocales: S.delegate.supportedLocales,
          initialRoute: Routes.root,
          routes: {
            Routes.root: (final _) => AppLoadingScreen(),
            Routes.home: (final _) => const AppBottomNavigationBar(),
            Routes.settings: (final _) => SettingsPage(),
            Routes.sources: (final _) => SourcePage(),
            Routes.login: (final _) => LoginView(),
            Routes.signUp: (final _) => SignUpView(),
            Routes.faq: (final _) => FaqPage(),
            Routes.filter: (final _) => const FilterPage(),
            Routes.newsFeed: (final _) => NewsFeedPage(),
            Routes.requestPermissions: (final _) => RequestPermissionsPage(),
            Routes.adminPanel: (final _) => const AdminPanelPage(),
            Routes.feedbackForm: (final _) => FeedbackFormPage(),
          },
          navigatorObservers: widget.navigationObservers ?? [],
        ),
      ),
    );
  }
}

class AppLoadingScreen extends StatelessWidget {
  Future<String> _setUpAndChooseStartScreen(final BuildContext context) async {
    // Make initializations if this is not a test
    if (!Platform.environment.containsKey('FLUTTER_TEST')) {
      await RemoteConfigService.initialize();
      await prefService.setDefaultValues({
        'dark_mode':
            // ignore: use_build_context_synchronously
            MediaQuery.of(context).platformBrightness == Brightness.dark
      });

      if (kDebugMode || kProfileMode) {
        await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
      } else if (kReleaseMode) {
        await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
      }

      // TODO(IoanaAlexandru): Make `rrule` package support Romanian
      LocaleProvider.rruleL10ns ??= {'en': await RruleL10nEn.create()};
    }

    // Load locale from settings
    await S.load(LocaleProvider.locale);

    // Choose start screen
    // ignore: use_build_context_synchronously
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return authProvider.isAuthenticated ? Routes.home : Routes.login;
  }

  @override
  Widget build(final BuildContext context) {
    return LoadingScreen(
      navigateAfterFuture: _setUpAndChooseStartScreen(context),
      image: Image.asset('assets/icons/acs_logo.png'),
      loaderColor: Theme.of(context).primaryColor,
    );
  }
}
