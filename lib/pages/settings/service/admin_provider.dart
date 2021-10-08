import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question.dart';
import 'package:acs_upb_mobile/pages/settings/model/request.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension PermissionRequestExtension on PermissionRequest {
  static PermissionRequest fromSnap(DocumentSnapshot snap, String requestId) {
    final data = snap.data()[requestId];
    final Map<String, FormQuestion> map = {};
    int i = 0;
    while (data[i.toString()] != null) {
      map[i.toString()] = FormQuestion(
          question: '',
          category: '',
          id: i.toString(),
          answer: data[i.toString()]);
      i++;
    }
    return PermissionRequest(
      userId: data['addedBy'],
      answers: map,
      processed: data['done'],
      dateSubmitted: data['dateSubmitted'],
      accepted: data['accepted'],
      processedBy: data['processedBy'],
    );
  }
}

class AdminProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  AuthProvider _authProvider;

  // ignore: use_setters_to_change_properties
  void updateAuth(AuthProvider authProvider) {
    _authProvider = authProvider;
  }

  Future<List<dynamic>> fetchAllRequestIds() async {
    try {
      final snap =
          await _db.collection('forms').doc('permission_request_answers').get();

      final List<Map<String, dynamic>> list = [];
      final iterable = snap.data().values;
      for (int i = 0; i < iterable.length; ++i) {
        list.add(iterable.elementAt(i));
      }

      list.sort((a, b) {
        return -a['dateSubmitted'].compareTo(b['dateSubmitted']);
      });

      return list.map((e) => e['addedBy']).toList();
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorLoadRequests);
      return null;
    }
  }

  Future<List<dynamic>> fetchUnprocessedRequestIds() async {
    try {
      final snap =
          await _db.collection('forms').doc('permission_request_answers').get();

      final List<Map<String, dynamic>> list = [];
      final iterable = snap.data().values;
      for (int i = 0; i < iterable.length; ++i) {
        list.add(iterable.elementAt(i));
      }

      list
        ..retainWhere((e) => e['done'] == false)
        ..sort((a, b) {
          return -a['dateSubmitted'].compareTo(b['dateSubmitted']);
        });

      return list.map((e) => e['addedBy']).toList();
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorLoadRequests);
      return null;
    }
  }

  Future<PermissionRequest> fetchRequest(String requestId) async {
    try {
      final DocumentSnapshot snap =
          await _db.collection('forms').doc('permission_request_answers').get();
      return PermissionRequestExtension.fromSnap(snap, requestId);
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
      return null;
    }
  }

  Future<User> fetchUserById(final String userId) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (snapshot.data() == null) {
      return null;
    }
    final currentUser = DatabaseUser.fromSnap(snapshot);
    return currentUser;
  }

  Future<void> acceptRequest(String requestId) async {
    return _processRequest(requestId, true);
  }

  Future<void> denyRequest(String requestId) async {
    return _processRequest(requestId, false);
  }

  Future<void> _processRequest(String requestId, bool accepted) async {
    try {
      if (accepted) {
        final request = await fetchRequest(requestId);
        await _giveEditingPermissions(request.userId);
      }
      await _db.collection('forms').doc('permission_request_answers').update({
        '$requestId.processedBy': _authProvider.uid,
        '$requestId.done': true,
        '$requestId.accepted': accepted
      });
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
    }
  }

  Future<void> revertRequest(String requestId) async {
    try {
      final request = await fetchRequest(requestId);
      if (request.accepted == true) {
        await _db
            .collection('users')
            .doc(request.userId)
            .update({'permissionLevel': 0});
        await _db.collection('forms').doc('permission_request_answers').update({
          '$requestId.processedBy': '',
          '$requestId.done': false,
          '$requestId.accepted': false
        });
      } else {
        await _db
            .collection('forms')
            .doc('permission_request_answers')
            .update({'$requestId.done': false});
      }
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
    }
  }

  Future<void> _giveEditingPermissions(String userId) async {
    final user = await fetchUserById(userId);
    if (user.permissionLevel < 3) {
      await _db.collection('users').doc(userId).update({'permissionLevel': 3});
    }
  }
}
