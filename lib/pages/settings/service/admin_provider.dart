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
}

class AdminProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Request>> fetchRequests() async {
    try {
      final QuerySnapshot qSnapshot = await _db.collection('forms').get();
      return qSnapshot.docs.map(RequestExtension.fromSnap).toList();
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
      return null;
    }
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
}
