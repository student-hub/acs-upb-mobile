import 'package:acs_upb_mobile/authentication/view/login_view.dart';
import 'package:acs_upb_mobile/navigation/model/app_state.dart';
import 'package:acs_upb_mobile/navigation/model/route_paths.dart';
import 'package:acs_upb_mobile/navigation/view/web_shell.dart';
import 'package:acs_upb_mobile/pages/home/home_page.dart';
import 'package:acs_upb_mobile/pages/people/view/people_page.dart';
import 'package:acs_upb_mobile/pages/people/view/person_view.dart';
import 'package:acs_upb_mobile/pages/portal/view/portal_page.dart';
import 'package:acs_upb_mobile/pages/timetable/view/timetable_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainRouterDelegate extends RouterDelegate<RoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
  MainRouterDelegate({@required AppStateProvider appState})
      : _navigatorKey = GlobalKey<NavigatorState>(),
        _appState = appState {
    _appState.addListener(notifyListeners);
  }

  final GlobalKey<NavigatorState> _navigatorKey;
  final AppStateProvider _appState;

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      pages: [
        MaterialPage<Widget>(
          child: WebShell(
            appState: _appState,
          ),
        ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        _appState.profileName = null;
        return true;
      },
    );
  }

  @override
  // TODO(RazvanRotaru): Complete this
  RoutePath get currentConfiguration {
    if (_appState.profileName != null) {
      return ProfilePath(_appState.profileName);
    }

    if (!_appState.isLogged) {
      return LoginPath();
    }

    if (_appState.selectedTab == 0) {
      return HomePath();
    }
    if (_appState.selectedTab == 1) {
      return TimetablePath();
    }
    if (_appState.selectedTab == 2) {
      return PortalPath();
    }
    if (_appState.selectedTab == 3) {
      return PeoplePath();
    }

    return UnknownPath();
  }

  @override
  // TODO(RazvanRotaru): Complete this
  Future<void> setNewRoutePath(RoutePath configuration) async {
    if (!(configuration is ProfilePath)) {
      _appState.profileName = null;
    }

    if (!(configuration is LoginPath)) {
      _appState.isLogged = true;
    }

    if (configuration is HomePath) {
      _appState.selectedTab = 0;
    } else if (configuration is TimetablePath) {
      _appState.selectedTab = 1;
    } else if (configuration is PortalPath) {
      _appState.selectedTab = 2;
    } else if (configuration is PeoplePath) {
      _appState.selectedTab = 3;
    }
  }
}

class InnerRouterDelegate extends RouterDelegate<RoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
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
        MaterialPage(
          child: LoginView(),
          key: const ValueKey<String>(LoginView.routeName),
        ),
        if (_appState.isLogged) ...[
          if (_appState.selectedTab == 0)
            const MaterialPage(
              child: HomePage(),
              key: ValueKey<String>(HomePage.routeName),
            ),
          if (_appState.selectedTab == 1)
            const MaterialPage(
              child: TimetablePage(),
              key: ValueKey<String>(TimetablePage.routeName),
            ),
          if (_appState.selectedTab == 2)
            const MaterialPage(
              child: PortalPage(),
              key: ValueKey<String>(PortalPage.routeName),
            ),
          if (_appState.selectedTab == 3)
            const MaterialPage(
              child: PeoplePage(),
              key: ValueKey<String>(PeoplePage.routeName),
            ),
          if (_appState.profileName != null)
            MaterialPage(
              child: PersonView.fromName(context, _appState.profileName),
              key: ValueKey<String>(_appState.profileName),
            ),
        ]
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        _appState.profileName = null;
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
