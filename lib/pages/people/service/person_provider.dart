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
  Future<List<Person>> fetchPeople({BuildContext context}) async {
    try {
      final QuerySnapshot qSnapshot =
          await Firestore.instance.collection('people').getDocuments();
      return qSnapshot.documents.map(PersonExtension.fromSnap).toList();
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
        //TODO return person only with name
        return Person(name: personName);
        return null;
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
