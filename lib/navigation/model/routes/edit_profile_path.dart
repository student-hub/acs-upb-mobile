part of route_paths;

class EditProfilePath extends RoutePath {
  EditProfilePath() : super(EditProfilePage.routeName);

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

        return const EditProfilePage();
      },
    );
  }
}
