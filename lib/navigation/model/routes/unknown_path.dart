part of route_paths;

class UnknownPath extends RoutePath {
  UnknownPath() : super('');

  @override
  Widget get page {
    return const ErrorPage(
      errorMessage: '404! Unknown location',
      imgPath: 'assets/illustrations/undraw_empty.png',
    );
  }
}
