import 'dart:async';

import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/settings/model/request.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

extension RequestExtension on Request {
  Map<String, dynamic> toData() {
    final Map<String, dynamic> data = {};

    if (userId != null) data['addedBy'] = userId;
    if (requestBody != null) data['requestBody'] = requestBody;
    data['done'] = processed;

    return data;
  }
}

class RequestProvider {
  final Firestore _db = Firestore.instance;
  bool userAlreadyRequestedCache;

  Future<bool> makeRequest(Request request, {BuildContext context}) async {
    assert(request.requestBody != null);

    try {
      DocumentReference ref;
      ref = _db.collection('forms').document(request.userId);

      final data = request.toData();
      await ref.setData(data);

      return userAlreadyRequestedCache = true;
    } catch (e) {
      print(e);
      if (context != null) {
        AppToast.show(S.of(context).errorSomethingWentWrong);
      }
      return userAlreadyRequestedCache = false;
    }
  }

  Future<bool> userAlreadyRequested(final String userId,
      {BuildContext context}) async {
    if (userAlreadyRequestedCache != null) return userAlreadyRequestedCache;

    try {
      final DocumentSnapshot snap =
          await _db.collection('forms').document(userId).get();
      if (snap != null) {
        return userAlreadyRequestedCache = true;
      }
      return userAlreadyRequestedCache = false;
    } catch (e) {
      print(e);
      if (context != null) {
        AppToast.show(S.of(context).errorSomethingWentWrong);
      }
      return userAlreadyRequestedCache = false;
    }
  }
}
