part of route_paths;

class ProfilePath extends RoutePath {
  ProfilePath(this.name)
      : super('${PersonView.routeName}?name=${name.replaceAll(' ', '%20')}');

  String name;

  @override
  Widget get page {
    return Builder(
      builder: (BuildContext context) {
        return FutureBuilder(
          future: Provider.of<PersonProvider>(context, listen: false)
              .fetchPerson(name),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (!snapshot.hasData) {
                return ErrorPage(
                  errorMessage: S.current.labelUnknown,
                );
              }

              final Person personData = snapshot.data;

              if (personData.office == null || personData.email == null) {
                return ErrorPage(
                  errorMessage: S.current.labelUnknown,
                );
              }

              return PersonView(
                person: personData,
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );
  }
}
