import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/authentication/view/edit_profile_page.dart';
import 'package:acs_upb_mobile/authentication/view/login_view.dart';
import 'package:acs_upb_mobile/main.dart';
import 'package:acs_upb_mobile/navigation/model/app_state.dart';
import 'package:acs_upb_mobile/navigation/model/route_paths.dart';
import 'package:acs_upb_mobile/navigation/view/web_shell.dart';
import 'package:acs_upb_mobile/pages/class_feedback/view/class_feedback_checklist.dart';
import 'package:acs_upb_mobile/pages/faq/view/faq_page.dart';
import 'package:acs_upb_mobile/pages/home/home_page.dart';
import 'package:acs_upb_mobile/pages/news_feed/view/news_feed_page.dart';
import 'package:acs_upb_mobile/pages/people/view/people_page.dart';
import 'package:acs_upb_mobile/pages/people/view/person_view.dart';
import 'package:acs_upb_mobile/pages/portal/view/portal_page.dart';
import 'package:acs_upb_mobile/pages/timetable/view/timetable_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class AppRouterDelegate extends RouterDelegate<RoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
  T _initializeProvider<T extends Listenable>(BuildContext context) {
    final T provider = Provider.of<T>(context)..addListener(notifyListeners);
    return provider;
  }
}

class MainRouterDelegate extends AppRouterDelegate {
  MainRouterDelegate({@required AppStateProvider appState})
      : _navigatorKey = GlobalKey<NavigatorState>(),
        _appState = appState {
    _appState.addListener(notifyListeners);
  }

  final GlobalKey<NavigatorState> _navigatorKey;
  final AppStateProvider _appState;

  // Providers
  AuthProvider _authProvider;

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Widget build(BuildContext context) {
    _authProvider ??= _initializeProvider<AuthProvider>(context);

    return Navigator(
      key: _navigatorKey,
      pages: [
        if (!_appState.isInitialized)
          MaterialPage(
            child: AppLoadingScreen(),
            key: const ValueKey<String>('LoadingScreen'),
          ),
        if (_appState.isInitialized) ...[
          MaterialPage(
            child: LoginView(),
            key: const ValueKey<String>(LoginView.routeName),
          ),
          if (_authProvider.isAuthenticated)
            MaterialPage<Widget>(
              child: WebShell(
                appState: _appState,
              ),
            ),
        ],
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        print('onPopPage called');
        _appState.resetParams();
        return true;
      },
    );
  }

  @override
// TODO(RazvanRotaru): Complete this
  RoutePath get currentConfiguration {
    print('\n---------------\n'
        'getConfiguration: $_appState'
        '\n-------------');

    if (!_appState.isInitialized) {
      return RootPath();
    }

    print('IS INITIALIZED');

    if (!_authProvider.isAuthenticated) {
      return LoginPath();
    }

    if (_appState.profileName != null) {
      return ProfilePath(_appState.profileName);
    }

    if (_appState.showFaq) {
      return FaqPath();
    }

    if (_appState.showNewsFeed) {
      return NewsFeedPath();
    }

    if (_appState.editProfile) {
      return EditProfilePath();
    }

    if (_appState.selectedTab != null) {
      switch (_appState.selectedTab) {
        case 0:
          return HomePath();
        case 1:
          return TimetablePath();
        case 2:
          return PortalPath();
        case 3:
          return PeoplePath();
        default:
          return HomePath();
      }
    }

    return UnknownPath();
  }

  @override
// TODO(RazvanRotaru): Complete this
  Future<void> setNewRoutePath(RoutePath configuration) async {
    print('\n---------------\n'
        'setNewRoute: $configuration');
    if (!_appState.isInitialized) {
      return;
    }

    print('IS INITIALIZED');

    _appState.resetParams();
    if (configuration is ProfilePath) {
      _appState.profileName = configuration.name;
    } else {
      _appState.profileName = null;
    }

    _appState
      ..showFaq = configuration is FaqPath
      ..showNewsFeed = configuration is NewsFeedPath
      ..editProfile = configuration is EditProfilePath;

    if (configuration is HomePath) {
      _appState.selectedTab = 0;
    } else if (configuration is TimetablePath) {
      _appState.selectedTab = 1;
    } else if (configuration is PortalPath) {
      _appState.selectedTab = 2;
    } else if (configuration is PeoplePath) {
      _appState.selectedTab = 3;
    }

    print('\n$_appState'
        '\n-------------');
  }
}

class InnerRouterDelegate extends AppRouterDelegate {
  InnerRouterDelegate({@required AppStateProvider appState})
      : _appState = appState;

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final AppStateProvider _appState;

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      pages: <Page<dynamic>>[
        const MaterialPage(
          child: HomePage(),
          key: PageStorageKey('Home'),
        ),
        if (_appState.selectedTab == 1)
          const MaterialPage(
            child: TimetablePage(),
            // key: ValueKey<String>(TimetablePage.routeName),
          ),
        if (_appState.selectedTab == 2)
          const MaterialPage(
            child: PortalPage(),
            key: PageStorageKey('Portal'),
            // key: ValueKey<String>(PortalPage.routeName),
          ),
        if (_appState.selectedTab == 3)
          const MaterialPage(
            child: PeoplePage(),
            key: PageStorageKey('People'),
          ),
        if (_appState.profileName != null)
          MaterialPage(
            child: PersonView.fromName(context, _appState.profileName),
            key: ValueKey<String>(_appState.profileName),
          ),
        if (_appState.showFaq)
          MaterialPage(
            child: FaqPage(),
          ),
        if (_appState.showNewsFeed)
          MaterialPage(
            child: NewsFeedPage(),
          ),
        if (_appState.editProfile)
          const MaterialPage(
            child: EditProfilePage(),
          ),
        if (_appState.userClasses != null)
          MaterialPage(
            child: ClassFeedbackChecklist(
              classes: _appState.userClasses,
            ),
          ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        _appState.resetParams();
        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(RoutePath configuration) async {
    assert(false);
  }
}
