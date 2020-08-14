import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/filter/model/filter.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

extension ShortcutTypeExtension on ShortcutType {
  static ShortcutType fromString(String string) {
    switch (string) {
      case 'main':
        return ShortcutType.main;
      case 'classbook':
        return ShortcutType.classbook;
      case 'resource':
        return ShortcutType.resource;
      case 'other':
        return ShortcutType.other;
    }
  }
}

extension ShortcutExtension on Shortcut {
  Map<String, dynamic> toData() {
    return {
      'type': type.toString().split('.').last,
      'name': name,
      'link': link,
      'addedBy': ownerUid
    };
  }
}

extension ClassHeaderExtension on ClassHeader {
  static ClassHeader fromSnap(DocumentSnapshot snap) {
    var splitAcronym = snap.data['shortname'].split('-');
    if (splitAcronym.length < 4) {
      return null;
    }
    return ClassHeader(
      id: snap.documentID,
      name: snap.data['fullname'],
      acronym: snap.data['shortname'].split('-')[3],
      category: snap.data['category_path'],
    );
  }
}

//extension ClassExtension on Class {
//  static Future<Class> fromSnap(
//      {DocumentSnapshot classSnap, DocumentSnapshot subclassSnap}) async {
//    if (subclassSnap == null) {
//      return Class(
//        id: classSnap.documentID,
//        name: classSnap.data['class'],
//        acronym: classSnap.data['acronym'],
//        credits: int.parse(classSnap.data['credits']),
//        degree: classSnap.data['degree'],
//        domain: classSnap.data['domain'],
//        year: classSnap.data['year'],
//        semester: classSnap.data['semester'],
//      );
//    } else {
//      List<Shortcut> shortcuts = [];
//      for (var s in List<Map<String, dynamic>>.from(
//          subclassSnap.data['shortcuts'] ?? [])) {
//        shortcuts.add(Shortcut(
//          type: ShortcutTypeExtension.fromString(s['type']),
//          name: s['name'],
//          link: s['link'],
//          ownerUid: s['addedBy'],
//        ));
//      }
//
//      Map<String, double> grading;
//      if (subclassSnap['grading'] != null) {
//        grading = Map<String, double>.from(subclassSnap['grading'].map(
//            (String name, dynamic value) => MapEntry(name, value.toDouble())));
//      }
//
//      return Class(
//        id: classSnap.documentID + '/' + subclassSnap.documentID,
//        name: classSnap.data['class'],
//        acronym: classSnap.data['acronym'],
//        credits: int.parse(classSnap.data['credits']),
//        degree: classSnap.data['degree'],
//        domain: classSnap.data['domain'],
//        year: classSnap.data['year'],
//        semester: classSnap.data['semester'],
//        series: subclassSnap.data['series'],
//        shortcuts: shortcuts,
//        grading: grading,
//      );
//    }
//  }
//}

class ClassProvider with ChangeNotifier {
  final Firestore _db = Firestore.instance;
  List<ClassHeader> classHeadersCache;
  List<ClassHeader> userClassHeadersCache;

  Future<List<String>> fetchUserClassIds(
      {String uid, BuildContext context}) async {
    try {
      // TODO: Get all classes if user is not authenticated
      DocumentSnapshot snap =
          await Firestore.instance.collection('users').document(uid).get();
      return List<String>.from(snap.data['classes'] ?? []);
    } catch (e) {
      print(e);
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
      await ref.updateData({'classes': classIds});
      userClassHeadersCache = null;
      notifyListeners();
      return true;
    } catch (e) {
      if (context != null) {
        AppToast.show(S.of(context).errorSomethingWentWrong);
      }
      return false;
    }
  }

  Future<List<ClassHeader>> fetchClassHeaders(
      {String uid, Filter filter, BuildContext context}) async {
    try {
      if (uid == null) {
        if (classHeadersCache != null) {
          return classHeadersCache;
        }

        // Get all classes
        QuerySnapshot qSnapshot =
            await _db.collection('import_moodle').getDocuments();
        List<DocumentSnapshot> documents = qSnapshot.documents;

        List<ClassHeader> result = documents
            .map((doc) => ClassHeaderExtension.fromSnap(doc))
            .where((e) => e != null)
            .toList();
//        result.sort((a, b) => a.name.compareTo(b.name));
        return result;
      } else {
        if (userClassHeadersCache != null) {
          return userClassHeadersCache;
        }
        List<ClassHeader> headers = [];

        // Get only the user's classes
        List<String> classIds =
            await fetchUserClassIds(uid: uid, context: context) ?? [];

        CollectionReference col = _db.collection('import_moodle');
        for (var classId in classIds) {
          DocumentSnapshot snap = await col.document(classId).get();
          ClassHeader header = ClassHeaderExtension.fromSnap(snap);
          if (header != null) {
            headers.add(header);
          }
        }

        userClassHeadersCache = headers;
        return userClassHeadersCache;
      }
    } catch (e) {
      print(e);
      if (context != null) {
        AppToast.show(S.of(context).errorSomethingWentWrong);
      }
      return null;
    }
  }

  DocumentReference _getClassDocument(String classId) {
    CollectionReference col = _db.collection('classes');
    var idTokens = classId.split('/');
    if (idTokens.length > 1) {
      // it's a subclass
      return col
          .document(idTokens[0])
          .collection('subclasses')
          .document(idTokens[1]);
    } else {
      // it's a parent class
      return col.document(idTokens[0]);
    }
  }

  Future<bool> addShortcut(
      {String classId, Shortcut shortcut, BuildContext context}) async {
    try {
      DocumentReference doc = _getClassDocument(classId);

      var shortcuts = List<Map<String, dynamic>>.from(
          (await doc.get()).data['shortcuts'] ?? []);
      shortcuts.add(shortcut.toData());

      await doc.updateData({'shortcuts': shortcuts});
      userClassHeadersCache = null;
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      if (context != null) {
        AppToast.show(S.of(context).errorSomethingWentWrong);
      }
      return false;
    }
  }

  Future<bool> deleteShortcut(
      {String classId, int shortcutIndex, BuildContext context}) async {
    try {
      DocumentReference doc = _getClassDocument(classId);

      var shortcuts = List<Map<String, dynamic>>.from(
          (await doc.get()).data['shortcuts'] ?? []);
      shortcuts.removeAt(shortcutIndex);

      await doc.updateData({'shortcuts': shortcuts});
      userClassHeadersCache = null;
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      if (context != null) {
        AppToast.show(S.of(context).errorSomethingWentWrong);
      }
      return false;
    }
  }
}
