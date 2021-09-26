part of route_paths;

class ClassFeedbackViewPath extends RoutePath {
  ClassFeedbackViewPath(this.id)
      : super('${ClassFeedbackView.routeName}?id=$id');

  final String id;

  @override
  Widget get page {
    return Builder(
      builder: (BuildContext context) {
        final authProvider = Provider.of<AuthProvider>(context);
        final classProvider = Provider.of<ClassProvider>(context);

        if (!authProvider.isAuthenticated || authProvider.isAnonymous) {
          return ErrorPage(
            errorMessage: S.current.warningAuthenticationNeeded,
          );
        }

        return FutureBuilder<ClassHeader>(
          future: classProvider.fetchClassHeader(id),
          builder: (BuildContext context, AsyncSnapshot<ClassHeader> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (!snapshot.hasData) {
                return ErrorPage(
                  errorMessage: S.current.errorClassCannotBeEmpty,
                );
              }

              final header = snapshot.data;
              return ClassFeedbackView(
                classHeader: header,
              );
            }

            return const CircularProgressIndicator();
          },
        );
      },
    );
  }
}
