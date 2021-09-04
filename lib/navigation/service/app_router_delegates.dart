import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/authentication/view/login_view.dart';
import 'package:acs_upb_mobile/authentication/view/sign_up_view.dart';
import 'package:acs_upb_mobile/main.dart';
import 'package:acs_upb_mobile/navigation/model/navigation_state.dart';
import 'package:acs_upb_mobile/navigation/model/route_paths.dart';
import 'package:acs_upb_mobile/navigation/view/web_shell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

abstract class AppRouterDelegate extends RouterDelegate<RoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
  T _initializeProvider<T extends Listenable>(BuildContext context) {
    final T provider = Provider.of<T>(context)..addListener(notifyListeners);
    return provider;
  }
}

class MainRouterDelegate extends AppRouterDelegate {
  MainRouterDelegate({@required NavigationStateProvider navigationState})
      : _navigatorKey = GlobalKey<NavigatorState>(),
        _navigationState = navigationState {
    _navigationState.addListener(notifyListeners);
  }

  final GlobalKey<NavigatorState> _navigatorKey;
  final NavigationStateProvider _navigationState;

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
        if (!_navigationState.isInitialized)
          MaterialPage(
            child: AppLoadingScreen(),
            key: const ValueKey<String>('LoadingScreen'),
          ),
        if (_navigationState.isInitialized) ...[
          MaterialPage(
            child: LoginView(),
            key: const ValueKey<String>(LoginView.routeName),
          ),
          if (_navigationState.path.location == SignUpView.routeName)
            MaterialPage(
              child: SignUpView(),
              key: const ValueKey<String>(LoginView.routeName),
            ),
          if (_authProvider.isAuthenticated)
            MaterialPage<Widget>(
              child: WebShell(
                navigationState: _navigationState,
              ),
            ),
        ],
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        print('onPopPage called');
        _navigationState.reset();

        // Motivation
        /// This may lead to problems as the key is not always represented by the location
        /// However, if the resulted [routePath] is UnknownPath we may just ignore the current change.
        final key = (route.settings as MaterialPage).key.toString();
        final pathFromKey = key.substring(3, key.length - 3);

        final uri = Uri.parse(pathFromKey);
        final routePath = PathFactory.from(uri);

        if (!(routePath is UnknownPath)) {
          _navigationState.path = routePath;
        }

        return true;
      },
    );
  }

  @override
  RoutePath get currentConfiguration {
    print('\n---------------\n'
        'getConfiguration: $_navigationState'
        '\n-------------');

    if (!_navigationState.isInitialized) {
      return RootPath();
    }

    // if (!_authProvider.isAuthenticated) {
    //   return LoginPath();
    // }

    return _navigationState.path;
  }

  @override
  Future<void> setNewRoutePath(RoutePath configuration) async {
    print('\n---------------\n'
        'setNewRoute: $configuration'
        '\n$_navigationState'
        '\n-------------');

    _navigationState.reset();

    if (configuration is LoginPath) {
      // await _authProvider.signOut();
      if (_authProvider.isAuthenticated) {
        _navigationState.path = HomePath();
        return;
      } else {
        _navigationState.isDrawerExtended = false;
      }
    }

    if (configuration is HomePath) {
      _navigationState.selectedTab = 0;
    } else if (configuration is TimetablePath) {
      _navigationState.selectedTab = 1;
    } else if (configuration is PortalPath) {
      _navigationState.selectedTab = 2;
    } else if (configuration is PeoplePath) {
      _navigationState.selectedTab = 3;
    }

    _navigationState.path = configuration;
  }
}

class InnerRouterDelegate extends AppRouterDelegate {
  InnerRouterDelegate({@required NavigationStateProvider navigationState})
      : _navigationState = navigationState;

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final NavigationStateProvider _navigationState;

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      pages: <Page<dynamic>>[
        MaterialPage(
          child: _navigationState.path.page,
          key: ValueKey<String>(_navigationState.path.location),
        ),
        if (_navigationState.customView != null)
          MaterialPage(
            child: _navigationState.customView,
            key: ValueKey<String>('${_navigationState.customView.hashCode}'),
          )
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        _navigationState.reset();
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
