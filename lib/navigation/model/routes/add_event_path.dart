part of route_paths;

// TODO(RazvanRotaru): find a proper method to retrieve Events. Maybes as @IoanaAlexandru
class AddEventPath extends RoutePath {
  AddEventPath([this.id])
      : super(id == null
            ? AddEventView.routeName
            : '${AddEventView.routeName}?id=$id');

  final String id;

  @override
  Widget get page {
    return Builder(
      builder: (BuildContext context) {
        final uniEventProvider = Provider.of<UniEventProvider>(context);
        final authProvider = Provider.of<AuthProvider>(context);

        if (!authProvider.isAuthenticated || authProvider.isAnonymous) {
          return ErrorPage(
            errorMessage: S.current.warningAuthenticationNeeded,
          );
        }

        if (id == null) {
          return AddEventView(
            initialEvent: UniEvent(
                start: LocalDateTime.now(),
                duration: const Period(hours: 2),
                id: null),
          );
        }

        // TODO(RazvanRotaru): this case might not work
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
              return AddEventView(initialEvent: event);
            }
            return const Center(child: CircularProgressIndicator());
          },
        );
      },
    );
  }
}
