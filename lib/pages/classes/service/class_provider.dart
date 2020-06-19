import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/filter/model/filter.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

extension ClassExtension on Class {
  static Class fromSnap(DocumentSnapshot snap) {
    return Class(
      name: snap.data['class'],
      acronym: snap.data['acronym'],
      credits: int.parse(snap.data['credits']),
      degree: snap.data['degree'],
      domain: snap.data['domain'],
      year: snap.data['year'],
      semester: snap.data['semester'],
    );
  }
}

class ClassProvider with ChangeNotifier {
  final Firestore _db = Firestore.instance;

  Future<List<Class>> fetchClasses({Filter filter, BuildContext context}) async {
    try {
      QuerySnapshot qSnapshot = await _db.collection('classes').getDocuments();

      return qSnapshot.documents
          .map((doc) => ClassExtension.fromSnap(doc))
          .toList();
    } catch (e) {
      if (context != null) {
        AppToast.show(S
            .of(context)
            .errorSomethingWentWrong);
      }
      return null;
    }
  }
}
