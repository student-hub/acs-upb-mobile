import 'package:meta/meta.dart';

class User {
  final String uid;
  String firstName;
  String lastName;
  String group;
  int permissionLevel;

  User(
      {@required this.uid,
      @required this.firstName,
      @required this.lastName,
      this.group,
      int permissionLevel})
      : this.permissionLevel = permissionLevel ?? 0;

  bool get canAddPublicWebsite => permissionLevel >= 3;
}
