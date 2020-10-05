import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/filter/model/filter.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:time_machine/time_machine.dart';

extension UserExtension on User {
  bool get canEditClassInfo => permissionLevel >= 3;
}

extension ShortcutTypeExtension on ShortcutType {
  static ShortcutType fromString(String string) {
    switch (string) {
      case 'main':
        return ShortcutType.main;
      case 'classbook':
        return ShortcutType.classbook;
      case 'resource':
        return ShortcutType.resource;
      default:
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
    if (snap == null) return null;
    final data = snap.data();
    final splitAcronym = data['shortname'].split('-');
    if (splitAcronym.length < 4) {
      return null;
    }
    return ClassHeader(
      id: data['shortname'],
      name: data['fullname'],
      acronym: data['shortname'].split('-')[3],
      category: data['category_path'],
    );
  }
}

extension TimestampExtension on Timestamp {
  LocalDateTime toLocalDateTime() => LocalDateTime.dateTime(toDate())
      .inZoneStrictly(DateTimeZone.utc)
      .withZone(DateTimeZone.local)
      .localDateTime;
}

extension ClassExtension on Class {
  static Class fromSnap({ClassHeader header, DocumentSnapshot snap}) {
    if (snap.data == null) {
      return Class(header: header);
    }
    final data = snap.data();

    final shortcuts = <Shortcut>[];
    for (final s in List<Map<String, dynamic>>.from(data['shortcuts'] ?? [])) {
      shortcuts.add(Shortcut(
        type: ShortcutTypeExtension.fromString(s['type']),
        name: s['name'],
        link: s['link'],
        ownerUid: s['addedBy'],
      ));
    }

    Map<String, double> grading;
    if (snap['grading'] != null) {
      grading = Map<String, double>.from(snap['grading'].map(
          (String name, dynamic value) => MapEntry(name, value.toDouble())));
    }

    final gradingLastUpdated = data['gradingLastUpdated'] == null
        ? null
        : (data['gradingLastUpdated'] as Timestamp).toLocalDateTime();

    return Class(
      header: header,
      shortcuts: shortcuts,
      grading: grading,
      gradingLastUpdated: gradingLastUpdated,
    );
  }
}

class ClassProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<ClassHeader> classHeadersCache;
  List<ClassHeader> userClassHeadersCache;

  Future<List<String>> fetchUserClassIds(
      {String uid, BuildContext context}) async {
    try {
      // TODO(IoanaAlexandru): Get all classes if user is not authenticated
      final DocumentSnapshot snap =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return List<String>.from(snap.data()['classes'] ?? []);
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
      final DocumentReference ref =
          FirebaseFirestore.instance.collection('users').doc(uid);
      await ref.update({'classes': classIds});
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
        final QuerySnapshot qSnapshot =
            await _db.collection('import_moodle').get();
        final List<DocumentSnapshot> docs = qSnapshot.docs;

        return docs
            .map(ClassHeaderExtension.fromSnap)
            .where((e) => e != null)
            .toList();
      } else {
        if (userClassHeadersCache != null) {
          return userClassHeadersCache;
        }
        final headers = <ClassHeader>[];

        // Get only the user's classes
        final List<String> classIds =
            await fetchUserClassIds(uid: uid, context: context) ?? [];
        final List<String> newClassIds = List<String>.from(classIds);

        final CollectionReference col = _db.collection('import_moodle');
        for (final classId in classIds) {
          final QuerySnapshot query =
              await col.where('shortname', isEqualTo: classId).limit(1).get();
          if (query == null || query.docs.isEmpty) {
            // Class doesn't exist, remove it
            newClassIds.remove(classId);
            continue;
          }

          final DocumentSnapshot snap = query.docs.first;
          final ClassHeader header = ClassHeaderExtension.fromSnap(snap);
          if (header != null) {
            headers.add(header);
          }
        }

        // Remove non-existent classes from user data
        if (newClassIds.length != classIds.length) {
          await setUserClassIds(classIds: newClassIds, uid: uid);
        }

        return userClassHeadersCache = headers;
      }
    } catch (e) {
      print(e);
      if (context != null) {
        AppToast.show(S.of(context).errorSomethingWentWrong);
      }
      return null;
    }
  }

  Future<Class> fetchClassInfo(ClassHeader header,
      {BuildContext context}) async {
    try {
      final DocumentSnapshot snap =
          await _db.collection('classes').doc(header.id).get();
      return ClassExtension.fromSnap(header: header, snap: snap);
    } catch (e) {
      print(e);
      if (context != null) {
        AppToast.show(S.of(context).errorSomethingWentWrong);
      }
      return null;
    }
  }

  Future<bool> addShortcut(
      {String classId, Shortcut shortcut, BuildContext context}) async {
    try {
      final DocumentReference doc = _db.collection('classes').doc(classId);
      final DocumentSnapshot snap = await doc.get();

      if (snap.data == null) {
        // Document does not exist
        await doc.set({
          'shortcuts': [shortcut.toData()]
        });
      } else {
        // Document exists
        final shortcuts =
            List<Map<String, dynamic>>.from(snap.data()['shortcuts'] ?? [])
              ..add(shortcut.toData());

        await doc.update({'shortcuts': shortcuts});
      }

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
      final DocumentReference doc = _db.collection('classes').doc(classId);

      final shortcuts = List<Map<String, dynamic>>.from(
          (await doc.get()).data()['shortcuts'] ?? [])
        ..removeAt(shortcutIndex);

      await doc.update({'shortcuts': shortcuts});

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

  Future<bool> setGrading(
      {String classId,
      Map<String, double> grading,
      BuildContext context}) async {
    try {
      final DocumentReference doc = _db.collection('classes').doc(classId);
      final DocumentSnapshot snap = await doc.get();
      final Timestamp now = Timestamp.now();

      if (snap.data == null) {
        // Document does not exist
        await doc.set({'grading': grading, 'gradingLastUpdated': now});
      } else {
        // Document exists
        await doc.update({'grading': grading, 'gradingLastUpdated': now});
      }

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
