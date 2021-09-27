part of route_paths;

class EventViewPath extends RoutePath {
  EventViewPath(this.id) : super('${EventView.routeName}?id=$id');

  final String id;

  // TODO(RazvanRotaru): find a proper method to retrieve Events. Maybes as @IoanaAlexandru
  // TODO(RazvanRotaru): add more restrictive access
  // TODO(RazvanRotaru): should we concern about not handling [UniEventInstance]s?
  @override
  Widget get page {
    return Builder(
      builder: (BuildContext context) {
        final uniEventProvider = Provider.of<UniEventProvider>(context);
        final authProvider = Provider.of<AuthProvider>(context);

        if (!authProvider.isAuthenticated || authProvider.isAnonymous) {
          return ErrorPage(
            errorMessage: S.current.warningAuthenticationNeeded,
            actionText: S.current.actionLogIn,
            actionOnTap: () => Utils.signOut(context),
          );
        }

        return FutureBuilder<UniEvent>(
          future: uniEventProvider.getEventById(id),
          builder: (BuildContext context, AsyncSnapshot<UniEvent> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (!snapshot.hasData || snapshot.hasError) {
                return ErrorPage(
                  errorMessage: S.current.warningNoEvents,
                  imgPath: 'assets/illustrations/undraw_empty.png',
                );
              }

              final event = snapshot.data;
              return EventView(uniEvent: event);
            }
            return const Center(child: CircularProgressIndicator());
          },
        );
      },
    );
  }
}
