import 'package:meta/meta.dart';

class User {
  User(
      {@required this.uid,
      @required this.firstName,
      @required this.lastName,
      this.classes,
      this.sources,
      this.receiveNotifications,
      this.roles,
      this.bookmarkedNews,
      final int permissionLevel})
      : permissionLevel = permissionLevel ?? 0;

  String get picturePath => 'users/$uid/picture.png';

  final String uid;

  String firstName;
  String lastName;
  List<String> sources;
  List<String> roles;
  bool receiveNotifications;

  /// Info about the user's assigned group (including degree, year of study, series etc)
  List<String> classes;

  /// News items that were bookmarked by the user
  List<String> bookmarkedNews;

  int permissionLevel;

  bool get canAddPublicInfo => permissionLevel >= 3;

  bool get canEditPublicInfo => permissionLevel >= 3;

  bool get isAdmin => permissionLevel >= 4;

  bool get shouldReceiveNotifications => receiveNotifications ?? false;

  String get displayName => '$firstName $lastName';

  List<String> get sourcesList =>
      sources ?? ['official', 'organizations', 'students'];
  List<String> get userRoles => roles ?? [];
}
