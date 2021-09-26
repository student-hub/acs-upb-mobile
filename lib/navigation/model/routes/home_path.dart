part of route_paths;

class HomePath extends RoutePath {
  HomePath() : super(HomePage.routeName);

  @override
  Widget get page => const HomePage();
}
