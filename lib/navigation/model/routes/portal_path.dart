part of route_paths;

class PortalPath extends RoutePath {
  PortalPath() : super(PortalPage.routeName);

  @override
  Widget get page => const PortalPage();
}
