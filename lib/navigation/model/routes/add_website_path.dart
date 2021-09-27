part of route_paths;

class AddWebsitePath extends RoutePath {
  AddWebsitePath(String category)
      : category = category ?? 'learning',
        super(
            '${WebsiteView.routeName}/add?category=${category ?? 'learning'}');
  final String category;

  WebsiteCategory get _websiteCategory {
    return WebsiteCategory.values.firstWhere(
        (element) => category == element.toString().split('.').last);
  }

  // TODO(RazvanRotaru): Update path whenever the category is changed
  /// This requires [WebsiteView] to trigger the navigator whenever the dropdown
  /// from here [lib/pages/portal/view/website_view.dart:254] is changed
  /// OR remove [category] attribute which means that the usage from
  /// [lib/pages/portal/view/portal_page.dart:358] will always redirect to
  /// `category = [WebsiteCategory.learning]', which means a button on its parent page
  /// will have no feedback.
  /// OR rename [category] to 'defaultCategory' :bigbrain:
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

        return ChangeNotifierProxyProvider<AuthProvider, FilterProvider>(
          create: (BuildContext context) {
            return Platform.environment.containsKey('FLUTTER_TEST')
                ? Provider.of<FilterProvider>(context)
                : FilterProvider();
          },
          update: (context, authProvider, filterProvider) {
            return filterProvider..updateAuth(authProvider);
          },
          child: WebsiteView(
            website: Website(
                relevance: null,
                id: null,
                isPrivate: true,
                link: '',
                category: _websiteCategory),
          ),
        );
      },
    );
  }
}
