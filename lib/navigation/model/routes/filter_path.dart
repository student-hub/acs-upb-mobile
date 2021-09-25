part of route_paths;

class FilterPath extends RoutePath {
  FilterPath() : super(FilterPage.routeName);

  @override
  Widget get page => const FilterPage();
}