import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/people/model/person.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';

extension PersonExtension on Person {
  static Person fromSnap(DocumentSnapshot snap) {
    return Person(
        name: snap.data['name'],
        email: snap.data['email'],
        phone: snap.data['phone'],
        office: snap.data['office'],
        position: snap.data['position'],
        photo: snap.data['photo'],
        source: snap.data['source']);
  }
}

class PersonProvider with ChangeNotifier {
  Future<List<Person>> fetchPeople({BuildContext context}) async {
    try {
      final User user = Provider.of<AuthProvider>(context, listen: false)
          .currentUserFromCache;
      final QuerySnapshot qSnapshot = await Firestore.instance
          .collection('people')
          .where('source', whereIn: user.sources)
          .getDocuments();
      return qSnapshot.documents.map(PersonExtension.fromSnap).toList();
    } catch (e) {
      print(e);
      if (context != null) {
        AppToast.show(S.of(context).errorSomethingWentWrong);
      }
      return null;
    }
  }
}
