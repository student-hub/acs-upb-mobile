import 'package:meta/meta.dart';

class User {
  User(
      {@required this.uid,
      @required this.firstName,
      @required this.lastName,
      this.classes,
      int permissionLevel})
      : permissionLevel = permissionLevel ?? 0;

  String get picturePath => 'users/$uid/picture.png';

  final String uid;

  String firstName;
  String lastName;

  /// Info about the user's assigned group (including degree, year of study, series etc)
  List<String> classes;

  int permissionLevel;

  bool get canAddPublicInfo => permissionLevel >= 3;

  bool get canEditPublicInfo => permissionLevel >= 3;

  bool get isAdmin => permissionLevel >= 4;
}
