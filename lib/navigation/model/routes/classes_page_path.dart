part of route_paths;

class ClassesPagePath extends RoutePath {
  ClassesPagePath() : super(ClassesPage.routeName);

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

        return ChangeNotifierProvider.value(
          value: Provider.of<ClassProvider>(context),
          child: const ClassesPage(),
        );
      },
    );
  }
}
