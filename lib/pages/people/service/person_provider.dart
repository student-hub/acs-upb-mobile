import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/people/model/person.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension PersonExtension on Person {
  static Person fromSnap(DocumentSnapshot snap) {
    final data = snap.data();
    return Person(
      name: data['name'],
      email: data['email'],
      phone: data['phone'],
      office: data['office'],
      position: data['position'],
      photo: data['photo'],
    );
  }
}

class PersonProvider with ChangeNotifier {
  Future<List<Person>> fetchPeople({BuildContext context}) async {
    try {
      final QuerySnapshot qSnapshot =
          await FirebaseFirestore.instance.collection('people').get();
      return qSnapshot.docs.map(PersonExtension.fromSnap).toList();
    } catch (e) {
      print(e);
      if (context != null) {
        AppToast.show(S.of(context).errorSomethingWentWrong);
      }
      return null;
    }
  }

  Future<Person> fetchPerson(String personName, {BuildContext context}) async {
    try {
      // Get person with name [personName]
      final QuerySnapshot query = await Firestore.instance
          .collection('people')
          .where('name', isEqualTo: personName)
          .limit(1)
          .getDocuments();

      if (query == null || query.documents.isEmpty) {
        return Person(name: personName);
      }

      return PersonExtension.fromSnap(query.documents.first);
    } catch (e) {
      print(e);
      if (context != null) {
        AppToast.show(S.of(context).errorSomethingWentWrong);
      }
      return null;
    }
  }
}
