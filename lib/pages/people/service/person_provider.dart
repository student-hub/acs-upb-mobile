import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/people/model/person.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension PersonExtension on Person {
  static Person fromSnap(DocumentSnapshot snap) {
    return Person(
      name: snap.data['name'],
      email: snap.data['email'],
      phone: snap.data['phone'],
      office: snap.data['office'],
      position: snap.data['position'],
      photo: snap.data['photo'],
    );
  }
}

class PersonProvider with ChangeNotifier {
  Future<List<Person>> fetchPeople(BuildContext context) async {
    try {
      List<Person> people = [];
      List<DocumentSnapshot> documents = [];
      QuerySnapshot qSnapshot =
          await Firestore.instance.collection("people").getDocuments();
      documents.addAll(qSnapshot.documents);
      people.addAll(documents.map((doc) => PersonExtension.fromSnap(doc)));
      //return List<Person>.from(qSnapshot.documents ?? []);
      return people;
    } catch (e) {
      print(e);
      if (context != null) {
        AppToast.show(S.of(context).errorSomethingWentWrong);
      }
      return null;
    }
  }
}
