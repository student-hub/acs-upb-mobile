import 'package:meta/meta.dart';

class User {
  final String uid;
  String firstName;
  String lastName;
  String group;

  User(
      {@required this.uid,
      @required this.firstName,
      @required this.lastName,
      this.group});
}
