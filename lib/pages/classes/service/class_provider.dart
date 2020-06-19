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
        id: classSnap.documentID,
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
        id: classSnap.documentID + '/' + subclassSnap.documentID,
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

  Future<List<String>> fetchUserClassIds(
      {String uid, BuildContext context}) async {
    try {
      DocumentSnapshot snap =
          await Firestore.instance.collection('users').document(uid).get();
      return List<String>.from(snap.data['classes'] ?? []);
    } catch (e) {
      if (context != null) {
        AppToast.show(S.of(context).errorSomethingWentWrong);
      }
      return null;
    }
  }

  Future<bool> setUserClassIds(
      {List<String> classIds, String uid, BuildContext context}) async {
    try {
      DocumentReference ref =
          Firestore.instance.collection('users').document(uid);
      await ref.setData({'classes': classIds});
      notifyListeners();
      return true;
    } catch (e) {
      if (context != null) {
        AppToast.show(S.of(context).errorSomethingWentWrong);
      }
      return false;
    }
  }

  Future<List<Class>> fetchClasses(
      {String uid, Filter filter, BuildContext context}) async {
    try {
      if (uid == null) {
        // Get all classes
        QuerySnapshot qSnapshot =
            await _db.collection('classes').getDocuments();
        List<DocumentSnapshot> documents = qSnapshot.documents;

        // Get query results as a list of lists (including subclasses)
        var results = Future.wait(documents.map((doc) async {
          CollectionReference subclasses =
              doc.reference.collection('subclasses');
          if (subclasses != null) {
            var subdocs = (await subclasses.getDocuments()).documents;
            if (subdocs.length > 0) {
              return subdocs
                  .map(((subdoc) => ClassExtension.fromSnap(
                      classSnap: doc, subclassSnap: subdoc)))
                  .toList();
            }
          }
          return [ClassExtension.fromSnap(classSnap: doc)];
        }).toList());

        // Flatten
        return (await results).expand((i) => i).toList();
      } else {
        List<Class> classes = [];
        // Get only the user's classes
        List<String> classIds =
            await fetchUserClassIds(uid: uid, context: context);

        CollectionReference col = _db.collection('classes');
        for (var classId in classIds) {
          var idTokens = classId.split('/');
          if (idTokens.length > 1) {
            // it's a subclass
            var parent = await col.document(idTokens[0]).get();
            var child = await col
                .document(idTokens[0])
                .collection('subclasses')
                .document(idTokens[1])
                .get();
            classes.add(ClassExtension.fromSnap(
                classSnap: parent, subclassSnap: child));
          } else {
            // it's a parent class
            classes.add(ClassExtension.fromSnap(
                classSnap: await col.document(classId).get()));
          }
        }
        return classes;
      }
    } catch (e) {
      if (context != null) {
        AppToast.show(S.of(context).errorSomethingWentWrong);
      }
      return null;
    }
  }
}
