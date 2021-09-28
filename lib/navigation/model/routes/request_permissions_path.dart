part of route_paths;

class RequestPermissionsPath extends RoutePath {
  RequestPermissionsPath() : super(RequestPermissionsPage.routeName);

  @override
  Widget get page {
    return Builder(
      builder: (BuildContext context) {
        final authProvider = Provider.of<AuthProvider>(context);

        if (!authProvider.isAuthenticated || authProvider.isAnonymous) {
          return ErrorPage(
            errorMessage: S.current.warningAuthenticationNeeded,
            actionText: S.current.actionLogIn,
            actionOnTap: () => Utils.signOut(context),
          );
        }

        return RequestPermissionsPage();
      },
    );
  }
}
