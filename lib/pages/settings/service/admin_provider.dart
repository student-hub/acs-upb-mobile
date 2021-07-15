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
    );
  }
}

class AdminProvider with ChangeNotifier {
  Future<List<Request>> fetchRequests() async {
    try {
      final QuerySnapshot qSnapshot =
          await FirebaseFirestore.instance.collection('forms').get();
      return qSnapshot.docs.map(RequestExtension.fromSnap).toList();
    } catch (e) {
      print('$e <- provider err');
      AppToast.show(S.current.errorSomethingWentWrong);
      return null;
    }
  }
}
