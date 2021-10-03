import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../authentication/model/user.dart';
import '../../../authentication/service/auth_provider.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/toast.dart';
import '../model/request.dart';

extension RequestExtension on Request {
  static Request fromSnap(DocumentSnapshot<Map<String, dynamic>> snap) {
    final data = snap.data();
    return Request(
      userId: data['addedBy'],
      requestBody: data['requestBody'],
      processed: data['done'],
      type: RequestType.permissions,
      dateSubmitted: data['dateSubmitted'],
      accepted: data['accepted'],
      processedBy: data['processedBy'],
      id: snap.id,
    );
  }

  static String getFormId(DocumentSnapshot snap) {
    return snap.id;
  }
}

class AdminProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  AuthProvider _authProvider;

  // ignore: use_setters_to_change_properties
  void updateAuth(AuthProvider authProvider) {
    _authProvider = authProvider;
  }

  Future<List<String>> fetchAllRequestIds() async {
    try {
      final QuerySnapshot qSnapshot = await _db
          .collection('forms')
          .orderBy('dateSubmitted', descending: true)
          .get();
      return qSnapshot.docs.map(RequestExtension.getFormId).toList();
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorLoadRequests);
      return null;
    }
  }

  Future<List<String>> fetchUnprocessedRequestIds() async {
    try {
      final QuerySnapshot qSnapshot = await _db
          .collection('forms')
          .where('done', isEqualTo: false)
          .orderBy('dateSubmitted', descending: true)
          .get();
      return qSnapshot.docs.map(RequestExtension.getFormId).toList();
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorLoadRequests);
      return null;
    }
  }

  Future<Request> fetchRequest(String requestId) async {
    try {
      final DocumentSnapshot docSnapshot =
          await _db.collection('forms').doc(requestId).get();
      return RequestExtension.fromSnap(docSnapshot);
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
      await _db.collection('forms').doc(requestId).update({
        'processedBy': _authProvider.uid,
        'done': true,
        'accepted': accepted
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
        await _db
            .collection('forms')
            .doc(requestId)
            .update({'processedBy': '', 'done': false, 'accepted': false});
      } else {
        await _db.collection('forms').doc(requestId).update({'done': false});
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
