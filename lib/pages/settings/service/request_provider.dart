import 'dart:async';

import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/settings/model/request.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

extension PermissionRequestExtension on PermissionRequest {
  Map<String, dynamic> toData() {
    final Map<String, dynamic> data = {};

    for (int i = 0; i < answers.length; ++i) {
      if (answers[i].questionAnswer != null) {
        data[i.toString()] = answers[i].questionAnswer;
      }
    }
    data['done'] = processed;
    data['dateSubmitted'] = Timestamp.now();
    data['accepted'] = false;

    return data;
  }
}

class RequestProvider {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  bool userAlreadyRequestedCache;

  Future<bool> makeRequest(PermissionRequest request) async {
    for (int i = 0; i < request.answers.length; ++i) {
      assert(request.answers[i] != null);
    }

    try {
      DocumentReference ref;
      ref = _db.collection('forms').doc('permission_request_answers');

      final data = request.toData();
      await ref.update({request.userId: data});

      return userAlreadyRequestedCache = true;
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
      return userAlreadyRequestedCache = false;
    }
  }

  Future<bool> userAlreadyRequested(final String userId) async {
    if (userAlreadyRequestedCache != null) return userAlreadyRequestedCache;

    try {
      final DocumentSnapshot snap =
          await _db.collection('forms').doc(userId).get();
      if (snap.data() != null) {
        return userAlreadyRequestedCache = true;
      }
      return userAlreadyRequestedCache = false;
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
      return userAlreadyRequestedCache = false;
    }
  }
}
