part of route_paths;

class LoginPath extends RoutePath {
  LoginPath() : super(LoginView.routeName);

  @override
  Widget get page => LoginView();
}