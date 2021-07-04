import 'package:flutter/widgets.dart';

///
///  Wrapper object for both the route url and widget for page
///
// TODO(vladtf): This class must be replaced either by an interface for routable pages or routable pages to have a @WebRoute(url:"value") annotation
class NavigationRoute {
  NavigationRoute(this.page, this.route);

  final String route;

  final Widget page;
}
