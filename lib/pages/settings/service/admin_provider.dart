import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/settings/model/request.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension RequestExtension on Request {
  static Request fromSnap(DocumentSnapshot snap) {
    final data = snap.data();
    return Request(
      userId: data['addedBy'],
      requestBody: data['requestBody'],
      processed: data['done'],
      type: RequestType.permissions,
      dateSubmitted: data['dateSubmitted'],
      formId: snap.id,
    );
  }

  static String getFormId(DocumentSnapshot snap) {
    return snap.id;
  }
}

class AdminProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<String>> fetchAllRequests() async {
    try {
      final QuerySnapshot qSnapshot = await _db.collection('forms').get();
      return qSnapshot.docs.map(RequestExtension.getFormId).toList();
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
      return null;
    }
  }

  Future<List<String>> fetchUnprocessedRequests() async {
    try {
      final QuerySnapshot qSnapshot = await _db.collection('forms').where('done', isEqualTo: false).get();
      return qSnapshot.docs.map(RequestExtension.getFormId).toList();
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
      return null;
    }
  }

  Future<Request> fetchRequestData(String requestId) async {
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

  Future<void> acceptRequest(String formId, String userId) async {
    try {
      await _db.collection('users').doc(userId).update({'permissionLevel': 3});
      await _db.collection('forms').doc(formId).update({'done': true});
      notifyListeners();
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
    }
  }

  Future<void> denyRequest(String formId, String userId) async {
    try {
      await _db.collection('forms').doc(formId).update({'done': null});
      notifyListeners();
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
    }
  }

  Future<void> revertAcceptedRequest(String formId, String userId) async {
    try {
      await _db.collection('users').doc(userId).update({'permissionLevel': 0});
      await _db.collection('forms').doc(formId).update({'done': false});
      notifyListeners();
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
    }
  }

  Future<void> revertDeniedRequest(String formId, String userId) async {
    try {
      await _db.collection('forms').doc(formId).update({'done': false});
      notifyListeners();
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
    }
  }
}
