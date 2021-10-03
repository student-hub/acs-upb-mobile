part of route_paths;

class ClassViewPath extends RoutePath {
  ClassViewPath(this.id) : super('${ClassView.routeName}?id=$id');

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
            actionText: S.current.actionLogIn,
            actionOnTap: () => Utils.signOut(context),
          );
        }

        return FutureBuilder<ClassHeader>(
          future: classProvider.fetchClassHeader(id),
          builder: (BuildContext context, AsyncSnapshot<ClassHeader> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (!snapshot.hasData) {
                return ErrorPage(
                  errorMessage: S.current.errorClassCannotBeEmpty,
                  imgPath: 'assets/illustrations/undraw_empty.png',
                );
              }

              final header = snapshot.data;
              return ChangeNotifierProvider.value(
                value: classProvider,
                child: ClassView(
                  classHeader: header,
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        );
      },
    );
  }
}
