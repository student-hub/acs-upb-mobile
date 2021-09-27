part of route_paths;

// TODO(WebTeam): described below
/// Navigating to UnknownPath redirects to a '', therefore the
/// unknown location remains in the history and it creates a loop
///
/// Should we handle this case by popping the unknown location from the history?
class UnknownPath extends RoutePath {
  UnknownPath() : super('');

  @override
  Widget get page {
    return Builder(
      builder: (context) => ErrorPage(
        errorMessage: S.current.labelUnknownLocation,
        imgPath: 'assets/illustrations/undraw_empty.png',
        actionText: S.current.actionNavigateHome,
        actionOnTap: () => AppNavigator.pushNamed(context, HomePage.routeName),
      ),
    );
  }
}
