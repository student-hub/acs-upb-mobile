import 'dart:async';

import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/settings/model/request.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

extension RequestExtension on Request {
  Map<String, String> toData() {
    final Map<String, String> data = {};

    if (userId != null) data['addedBy'] = userId;
    if (requestBody != null) data['requestBody'] = requestBody;

    return data;
  }
}

class RequestProvider {
  final Firestore _db = Firestore.instance;

  Future<bool> makeRequest(Request request, {BuildContext context}) async {
    assert(request.requestBody != null);

    try {
      DocumentReference ref;
      ref = _db.collection('forms').document(request.userId);

      var data = request.toData();
      await ref.setData(data);

      return true;
    } catch (e) {
      print(e);
      if (context != null) {
        AppToast.show(S.of(context).errorSomethingWentWrong);
      }
      return false;
    }
  }

  Future<bool> userAlreadyRequested(final String userId,
      {BuildContext context}) async {
    try {
      DocumentSnapshot snap =
          await _db.collection('forms').document(userId).get();
      if (snap != null) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      if (context != null) {
        AppToast.show(S.of(context).errorSomethingWentWrong);
      }
      return false;
    }
  }
}
