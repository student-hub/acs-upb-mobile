part of route_paths;

class SignUpPath extends RoutePath {
  SignUpPath() : super(SignUpView.routeName);

  @override
  Widget get page => SignUpView();
}