part of route_paths;

class RootPath extends RoutePath {
  RootPath() : super('/');

  @override
  Widget get page => AppLoadingScreen();
}
