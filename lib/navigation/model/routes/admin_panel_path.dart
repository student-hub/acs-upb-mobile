part of route_paths;

class AdminPanelPath extends RoutePath {
  AdminPanelPath() : super('${AdminPanelPage.routeName}');

  @override
  Widget get page {
    return Builder(
      builder: (context) {
        final authProvider = Provider.of<AuthProvider>(context);

        if (!authProvider.isAuthenticated || authProvider.isAnonymous) {
          return ErrorPage(
            errorMessage: S.current.warningAuthenticationNeeded,
            actionText: S.current.actionLogIn,
            actionOnTap: () => Utils.signOut(context),
          );
        }

        return const AdminPanelPage();
      },
    );
  }
}
