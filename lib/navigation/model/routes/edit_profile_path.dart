part of route_paths;

class EditProfilePath extends RoutePath {
  EditProfilePath() : super(EditProfilePage.routeName);

  @override
  Widget get page => const EditProfilePage();
}
