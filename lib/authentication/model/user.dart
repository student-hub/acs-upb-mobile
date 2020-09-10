import 'package:meta/meta.dart';

class User {
  final String uid;

  String firstName;
  String lastName;

  String degree;
  String domain;
  String year;
  String series;
  String group;
  String picture;

  int permissionLevel;

  User(
      {@required this.uid,
      @required this.firstName,
      @required this.lastName,
      this.degree,
      this.domain,
      this.year,
      this.series,
      this.group,
      int permissionLevel,
      this.picture})
      : this.permissionLevel = permissionLevel ?? 0;

  bool get canAddPublicWebsite => permissionLevel >= 3;

  bool get canEditPublicWebsite => permissionLevel >= 3;
}
