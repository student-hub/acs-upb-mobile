import 'package:acs_upb_mobile/navigation/model/navigation_state.dart';
import 'package:acs_upb_mobile/navigation/model/route_paths.dart';
import 'package:acs_upb_mobile/navigation/service/app_router_delegates.dart';
import 'package:acs_upb_mobile/pages/timetable/view/timetable_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppNavigator {
  static Future<T> push<T extends Object>(BuildContext context, Route<T> route,
      {@required String webPath}) {
    if (kIsWeb) {
      assert(webPath != null);
      assert(route is MaterialPageRoute);

      Provider.of<NavigationStateProvider>(context, listen: false)
        ..path = PathFactory.from(Uri.parse(webPath))
        ..customView = (route as MaterialPageRoute).buildContent(context);
      _webNavigationChecks(context, webPath);

      return Future.value(null);
    } else {
      return Navigator.of(context).push(route);
    }
  }

  static Future<T> pushNamed<T extends Object>(
    BuildContext context,
    String routeName, {
    Object arguments,
  }) {
    if (kIsWeb) {
      Provider.of<NavigationStateProvider>(context, listen: false).path =
          PathFactory.from(Uri.parse(routeName));
      _webNavigationChecks(context, routeName);

      return Future.value(null);
    } else {
      return Navigator.of(context)
          .pushNamed<T>(routeName, arguments: arguments);
    }
  }

  static Future<T> pushNamedAndRemoveUntil<T extends Object>(
    BuildContext context,
    String newRouteName,
    RoutePredicate predicate, {
    Object arguments,
  }) {
    if (kIsWeb) {
      Provider.of<NavigationStateProvider>(context, listen: false).path =
          PathFactory.from(Uri.parse(newRouteName));
      _webNavigationChecks(context, newRouteName);

      return Future.value(null);
    } else {
      return Navigator.of(context).pushNamedAndRemoveUntil<T>(
          newRouteName, predicate,
          arguments: arguments);
    }
  }

  static Future<T> pushReplacement<T extends Object, TO extends Object>(
    BuildContext context,
    Route<T> newRoute, {
    @required String webPath,
    TO result,
  }) {
    if (kIsWeb) {
      assert(webPath != null);
      assert(newRoute is MaterialPageRoute);
      Provider.of<NavigationStateProvider>(context, listen: false)
        ..path = PathFactory.from(Uri.parse(webPath))
        ..customView = (newRoute as MaterialPageRoute).buildContent(context);
      _webNavigationChecks(context, webPath);

      return Future.value(null);
    } else {
      return Navigator.of(context)
          .pushReplacement<T, TO>(newRoute, result: result);
    }
  }

  static Future<T> pushReplacementNamed<T extends Object, TO extends Object>(
    BuildContext context,
    String routeName, {
    TO result,
    Object arguments,
  }) {
    if (kIsWeb) {
      Provider.of<NavigationStateProvider>(context, listen: false).path =
          PathFactory.from(Uri.parse(routeName));
      _webNavigationChecks(context, routeName);

      return Future.value(null);
    } else {
      return Navigator.of(context).pushReplacementNamed(routeName,
          arguments: arguments, result: result);
    }
  }

  static void pop<T extends Object>(BuildContext context, [T result]) {
    if (kIsWeb) {}
    Navigator.of(context).pop<T>(result);
  }

  static void popUntil(BuildContext context, RoutePredicate predicate) {
    Navigator.of(context).popUntil(predicate);
  }

  static void _webNavigationChecks(BuildContext context, String routeName) {
    final path = PathFactory.from(Uri.parse(routeName));
    final stateProvider =
        Provider.of<NavigationStateProvider>(context, listen: false);

    switch (path.runtimeType) {
      case HomePath:
        stateProvider.selectedTab = 0;
        break;
      case TimetablePath:
        stateProvider.selectedTab = 1;
        break;
      case PortalPath:
        stateProvider.selectedTab = 2;
        break;
      case PeoplePath:
        stateProvider.selectedTab = 3;
        break;
      case LoginPath:
        stateProvider.isDrawerExtended = false;
        break;
    }
  }
}
