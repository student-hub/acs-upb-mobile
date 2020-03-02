import 'package:cloud_firestore/cloud_firestore.dart';
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

  User.fromSnapshot(DocumentSnapshot snapshot)
      : uid = snapshot.documentID,
        firstName = snapshot.data['name']['first'],
        lastName = snapshot.data['name']['last'],
        group = snapshot.data['grpup'];

  Map<String, dynamic> toData() {
    return {
      'name': {'first': firstName, 'last': lastName},
      'group': group
    };
  }
}
