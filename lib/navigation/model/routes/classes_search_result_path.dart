part of route_paths;

class ClassesSearchResultPath extends RoutePath {
  ClassesSearchResultPath(String location)
      : classIds = location.split('&'),
        super(location);

  final List<String> classIds;

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

        return FutureBuilder<Set<ClassHeader>>(
          future: classProvider.fetchClassHeadersByIds(classIds),
          builder:
              (BuildContext context, AsyncSnapshot<Set<ClassHeader>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (!snapshot.hasData) {
                return ErrorPage(
                  errorMessage: S.current.errorClassCannotBeEmpty,
                  imgPath: 'assets/illustrations/undraw_empty.png',
                );
              }

              final classesSearched = snapshot.data;
              return SearchedClassesView(
                classHeaders: classesSearched.toList(),
              );
            }

            return const CircularProgressIndicator();
          },
        );
      },
    );
  }
}
