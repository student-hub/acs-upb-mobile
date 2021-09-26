part of route_paths;

class TimetablePath extends RoutePath {
  TimetablePath() : super(TimetablePage.routeName);

  @override
  Widget get page => const TimetablePage();
}
