part of route_paths;

class SettingsPath extends RoutePath {
  SettingsPath() : super(SettingsPage.routeName);

  @override
  Widget get page => SettingsPage();
}
