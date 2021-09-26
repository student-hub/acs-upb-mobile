part of route_paths;

class AddClassesPath extends RoutePath {
  AddClassesPath() : super(AddClassesPage.routeName);

  @override
  Widget get page {
    return Builder(
      builder: (BuildContext context) {
        final classProvider = Provider.of<ClassProvider>(context);
        final authProvider = Provider.of<AuthProvider>(context);

        if (!authProvider.isAuthenticated || authProvider.isAnonymous) {
          return ErrorPage(
            errorMessage: S.current.warningAuthenticationNeeded,
          );
        }

        return ChangeNotifierProvider.value(
          value: classProvider,
          child: FutureBuilder(
            future: classProvider.fetchUserClassIds(authProvider.uid),
            builder: (context, snap) {
              if (snap.hasData) {
                return AddClassesPage(
                  initialClassIds: snap.data,
                  onSave: (classIds) async {
                    await classProvider.setUserClassIds(
                        classIds, authProvider.uid);
                    AppNavigator.pop(context);
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        );
      },
    );
  }
}
