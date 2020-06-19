import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/filter/model/filter.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

extension ClassExtension on Class {
  static Class fromSnap(
      {DocumentSnapshot classSnap, DocumentSnapshot subclassSnap}) {
    if (subclassSnap == null) {
      return Class(
        name: classSnap.data['class'],
        acronym: classSnap.data['acronym'],
        credits: int.parse(classSnap.data['credits']),
        degree: classSnap.data['degree'],
        domain: classSnap.data['domain'],
        year: classSnap.data['year'],
        semester: classSnap.data['semester'],
      );
    } else {
      return Class(
        name: classSnap.data['class'],
        acronym: classSnap.data['acronym'],
        credits: int.parse(classSnap.data['credits']),
        degree: classSnap.data['degree'],
        domain: classSnap.data['domain'],
        year: classSnap.data['year'],
        semester: classSnap.data['semester'],
        series: subclassSnap.data['series'],
      );
    }
  }
}

class ClassProvider with ChangeNotifier {
  final Firestore _db = Firestore.instance;

  Future<List<Class>> fetchClasses(
      {Filter filter, BuildContext context}) async {
    try {
      QuerySnapshot qSnapshot = await _db.collection('classes').getDocuments();

      // Get query results as a list of lists (including subclasses)
      var results = Future.wait(qSnapshot.documents.map((doc) async {
        CollectionReference subclasses = doc.reference.collection('subclasses');
        if (subclasses != null) {
          var subdocs = (await subclasses.getDocuments()).documents;
          if (subdocs.length > 0) {
            return subdocs.map(((subdoc) => ClassExtension.fromSnap(
                classSnap: doc, subclassSnap: subdoc))).toList();
          }
        }
        return [ClassExtension.fromSnap(classSnap: doc)];
      }).toList());

      // Flatten results
      return (await results).expand((i) => i).toList();
    } catch (e) {
      if (context != null) {
        AppToast.show(S.of(context).errorSomethingWentWrong);
      }
      return null;
    }
  }
}
