import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../authentication/model/user.dart';
import '../../../authentication/service/auth_provider.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/toast.dart';
import '../model/request.dart';
import '../model/role_request.dart';

extension RequestExtension on Request {
  static Request fromSnap(final DocumentSnapshot<Map<String, dynamic>> snap) {
    final data = snap.data();
    return Request(
      userId: data['addedBy'],
      requestBody: data['requestBody'],
      processed: data['done'],
      dateSubmitted: data['dateSubmitted'],
      accepted: data['accepted'],
      processedBy: data['processedBy'],
      id: snap.id,
    );
  }

  static String getFormId(final DocumentSnapshot snap) {
    return snap.id;
  }
}

extension RoleRequestExtension on RoleRequest {
  static RoleRequest fromSnap(final dynamic data) {
    return RoleRequest(
      userId: data['userId'],
      roleName: data['roleName'],
      requestBody: data['requestBody'],
      processed: data['processed'],
      dateSubmitted: data['dateSubmitted'],
      accepted: data['accepted'],
      processedBy: data['processedBy'],
      requestId: data['id'],
    );
  }
}

class AdminProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  AuthProvider _authProvider;

  // ignore: use_setters_to_change_properties
  void updateAuth(final AuthProvider authProvider) {
    _authProvider = authProvider;
  }

  Future<List<String>> fetchAllAdminRequestIds() async {
    try {
      final qSnapshot = await _db
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

  Future<List<dynamic>> fetchAllRoleRequests() async {
    try {
      final qSnapshot =
          await _db.collection('forms').doc('role_request_answers').get();
      final requests = qSnapshot.data().values.toList()
        ..sort((final a, final b) {
          return b['dateSubmitted'].compareTo(a['dateSubmitted']);
        });
      return requests.map(RoleRequestExtension.fromSnap).toList();
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorLoadRequests);
      return [];
    }
  }

  Future<List<dynamic>> fetchRoleUnprocessedRequests() async {
    try {
      final qSnapshot =
          await _db.collection('forms').doc('role_request_answers').get();
      final requests = qSnapshot.data().values.toList()
        ..retainWhere((final e) => e['processed'] == false)
        ..sort((final a, final b) {
          return b['dateSubmitted'].compareTo(a['dateSubmitted']);
        });
      return requests.map(RoleRequestExtension.fromSnap).toList();
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorLoadRequests);
      return [];
    }
  }

  Future<List<String>> fetchAdminUnprocessedRequestIds() async {
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

  Future<Request> fetchRequest(final String requestId) async {
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

  Future<RoleRequest> fetchRoleRequest(final String requestId) async {
    try {
      final docSnapshot =
          await _db.collection('forms').doc('role_request_answers').get();
      final data = docSnapshot.data().values.toList()
        ..firstWhere((final e) => e['id'] == requestId, orElse: () => null);
      return data != null ? RoleRequestExtension.fromSnap(data) : null;
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

  Future<void> acceptRoleRequest(
          final String newRole, final String requestId) async =>
      _processRoleRequest(newRole, requestId, true);
  Future<void> denyRoleRequest(
          final String newRole, final String requestId) async =>
      _processRoleRequest(newRole, requestId, false);

  Future<void> revertRoleRequest(
      final String role, final String requestId) async {
    try {
      final request = await fetchRoleRequest(requestId);
      if (request == null) {
        return;
      }
      if (request.accepted == true) {
        await _authProvider.removeRole(role);
      }
      await _db.collection('forms').doc('role_request_answers').update({
        '$requestId.processedBy': '',
        '$requestId.processed': false,
        '$requestId.accepted': false,
      });
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
    }
  }

  Future<void> _processRoleRequest(
      final String newRole, final String requestId, final bool accepted) async {
    try {
      await _db.collection('forms').doc('role_request_answers').update({
        '$requestId.accepted': accepted,
        '$requestId.processed': true,
        '$requestId.processedBy': _authProvider.currentUserFromCache.uid,
      });

      if (accepted) {
        await _authProvider.addNewRole(newRole);
      }
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
    }
  }

  Future<void> acceptRequest(final String requestId) async {
    return _processRequest(requestId, true);
  }

  Future<void> denyRequest(final String requestId) async {
    return _processRequest(requestId, false);
  }

  Future<void> revertRequest(final String requestId) async {
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

  Future<void> _processRequest(
      final String requestId, final bool accepted) async {
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

  Future<void> _giveEditingPermissions(final String userId) async {
    final user = await fetchUserById(userId);
    if (user.permissionLevel < 3) {
      await _db.collection('users').doc(userId).update({'permissionLevel': 3});
    }
  }
}
