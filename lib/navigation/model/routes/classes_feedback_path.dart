part of route_paths;

class ClassesFeedbackPath extends RoutePath {
  ClassesFeedbackPath() : super(ClassFeedbackChecklist.routeName);

  @override
  Widget get page {
    return Builder(
      builder: (BuildContext context) {
        final authProvider = Provider.of<AuthProvider>(context);
        final classProvider = Provider.of<ClassProvider>(context);

        if (!authProvider.isAuthenticated || authProvider.isAnonymous) {
          return ErrorPage(
            errorMessage: S.current.warningAuthenticationNeeded,
            actionText: S.current.actionLogIn,
            actionOnTap: () => Utils.signOut(context),
          );
        }

        return FutureBuilder<List<ClassHeader>>(
          future: classProvider.fetchClassHeaders(uid: authProvider.uid),
          builder: (BuildContext context,
              AsyncSnapshot<List<ClassHeader>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (!snapshot.hasData) {
                return ErrorPage(
                  errorMessage: S.current.errorClassCannotBeEmpty,
                  imgPath: 'assets/illustrations/undraw_empty.png',
                );
              }

              final headers = snapshot.data.toSet();
              return ClassFeedbackChecklist(
                classes: headers,
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        );
      },
    );
  }
}
