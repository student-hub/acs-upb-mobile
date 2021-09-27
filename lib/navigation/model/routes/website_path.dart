part of route_paths;

class WebsiteViewPath extends RoutePath {
  WebsiteViewPath(this.id) : super('${WebsiteView.routeName}?id=$id');

  final String id;

  @override
  Widget get page {
    return Builder(
      builder: (BuildContext context) {
        final websiteProvider = Provider.of<WebsiteProvider>(context);
        final authProvider = Provider.of<AuthProvider>(context);

        if (!authProvider.isAuthenticated || authProvider.isAnonymous) {
          return ErrorPage(
            errorMessage: S.current.warningAuthenticationNeeded,
            actionText: S.current.actionLogIn,
            actionOnTap: () => Utils.signOut(context),
          );
        }

        return FutureBuilder<Website>(
          future: websiteProvider.fetchWebsite(id),
          builder: (BuildContext context, AsyncSnapshot<Website> snapshot) {
            final user = authProvider.currentUserFromCache;

            if (snapshot.connectionState == ConnectionState.done) {
              final website = snapshot.data;
              if (website.isPrivate || (user.canEditPublicInfo ?? false)) {
                return ChangeNotifierProvider<FilterProvider>.value(
                  // If testing, use the global (mocked) provider; otherwise instantiate a new local provider
                  value: Platform.environment.containsKey('FLUTTER_TEST')
                      ? Provider.of<FilterProvider>(context)
                      : FilterProvider(
                          defaultDegree: website.degree,
                          defaultRelevance: website.relevance,
                        )
                    ..updateAuth(Provider.of<AuthProvider>(context)),
                  child: WebsiteView(
                    website: website,
                    updateExisting: true,
                  ),
                );
              }
              return ErrorPage(
                errorMessage: S.current.errorPermissionDenied,
                actionText: S.current.actionRequestPermissions,
                actionOnTap: () => AppNavigator.pushNamed(
                    context, RequestPermissionsPage.routeName),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        );
      },
    );
  }
}
