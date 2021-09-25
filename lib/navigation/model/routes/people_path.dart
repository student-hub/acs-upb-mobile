part of route_paths;

class PeoplePath extends RoutePath {
  PeoplePath() : super(PeoplePage.routeName);

  @override
  Widget get page => const PeoplePage();
}
