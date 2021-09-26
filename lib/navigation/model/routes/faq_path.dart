part of route_paths;

class FaqPath extends RoutePath {
  FaqPath() : super(FaqPage.routeName);

  @override
  Widget get page => FaqPage();
}
