import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/authentication/view/login_view.dart';
import 'package:acs_upb_mobile/authentication/view/sign_up_view.dart';
import 'package:acs_upb_mobile/main.dart';
import 'package:acs_upb_mobile/navigation/model/route_paths.dart';
import 'package:acs_upb_mobile/navigation/service/navigation_provider.dart';
import 'package:acs_upb_mobile/navigation/view/web_shell.dart';
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
  MainRouterDelegate({@required NavigationProvider navigationProvider})
      : _navigatorKey = GlobalKey<NavigatorState>(),
        _navigationProvider = navigationProvider {
    _navigationProvider.addListener(notifyListeners);
  }

  final GlobalKey<NavigatorState> _navigatorKey;
  final NavigationProvider _navigationProvider;
  AuthProvider _authProvider;

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Widget build(BuildContext context) {
    _authProvider ??= _initializeProvider<AuthProvider>(context);

    return Navigator(
      key: _navigatorKey,
      pages: [
        if (!_navigationProvider.isInitialized)
          MaterialPage(
            child: AppLoadingScreen(),
            key: const ValueKey<String>('LoadingScreen'),
          ),
        if (_navigationProvider.isInitialized) ...[
          MaterialPage(
            child: LoginView(),
            key: const ValueKey<String>(LoginView.routeName),
          ),
          if (_navigationProvider.path.location == SignUpView.routeName)
            MaterialPage(
              child: SignUpView(),
              key: const ValueKey<String>(LoginView.routeName),
            ),
          if (_authProvider.isAuthenticated)
            MaterialPage<Widget>(
              child: WebShell(
                navigationProvider: _navigationProvider,
              ),
            ),
        ],
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        _navigationProvider.back();
        return true;
      },
    );
  }

  @override
  RoutePath get currentConfiguration {
    if (!_navigationProvider.isInitialized) {
      return RootPath();
    }

    return _navigationProvider.path;
  }

  @override
  Future<void> setNewRoutePath(RoutePath configuration) async {
    _navigationProvider.reset();

    if (configuration is LoginPath) {
      if (_authProvider.isAuthenticated) {
        _navigationProvider.path = HomePath();
        return;
      } else {
        _navigationProvider.isDrawerExtended = false;
      }
    }

    _navigationProvider.path = configuration;
  }
}

class InnerRouterDelegate extends AppRouterDelegate {
  InnerRouterDelegate({@required NavigationProvider navigationProvider})
      : _navigationProvider = navigationProvider;

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final NavigationProvider _navigationProvider;

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      pages: <Page<dynamic>>[
        MaterialPage(
          child: _navigationProvider.path.page,
          key: ValueKey<String>(_navigationProvider.path.location),
        ),
        if (_navigationProvider.customView != null)
          MaterialPage(
            child: _navigationProvider.customView,
            key: ValueKey<String>('${_navigationProvider.customView.hashCode}'),
          )
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        _navigationProvider.back();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(RoutePath configuration) async {
    return;
  }
}
