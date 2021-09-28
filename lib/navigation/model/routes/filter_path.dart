part of route_paths;

// TODO(RazvanRotaru): Ask @IoanaAlexandru what is the use of this, do we need authentication checks?
class FilterPath extends RoutePath {
  FilterPath() : super(FilterPage.routeName);

  @override
  Widget get page => const FilterPage();
}
