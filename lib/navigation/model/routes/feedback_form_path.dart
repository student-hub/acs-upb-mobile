part of route_paths;

class FeedbackFormPath extends RoutePath {
  FeedbackFormPath() : super('${FeedbackFormPage.routeName}');

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

        return const FeedbackFormPage();
      },
    );
  }
}
