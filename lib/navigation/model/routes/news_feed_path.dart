part of route_paths;

class NewsFeedPath extends RoutePath {
  NewsFeedPath() : super(NewsFeedPage.routeName);

  @override
  Widget get page => NewsFeedPage();
}
