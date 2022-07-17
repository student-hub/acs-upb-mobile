import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../generated/l10n.dart';
import '../../../resources/utils.dart';
import '../../../widgets/toast.dart';
import '../model/role_request.dart';

extension RoleRequestExtension on RoleRequest {
  Map<String, dynamic> toData() {
    final Map<String, dynamic> data = {};

    if (userId != null) data['userId'] = userId;
    if (userEmail != null) data['userEmail'] = userEmail;
    if (roleName != null) data['roleName'] = roleName;
    if (requestBody != null) data['requestBody'] = requestBody;
    data['id'] = id;
    data['accepted'] = false;
    data['processed'] = false;
    data['processedBy'] = null;
    data['dateSubmitted'] = Timestamp.now();

    return data;
  }
}

class RolesProvider {
  Future<bool> makeRequest(final RoleRequest roleRequest) async {
    try {
      final ref = FirebaseFirestore.instance
          .collection('forms')
          .doc('role_request_answers');

      final data = roleRequest.toData();
      await ref.set({roleRequest.id: data}, SetOptions(merge: true));

      return true;
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
      return false;
    }
  }

  Future<bool> userAlreadyRequestedRole(
      final String userId, final String role) async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('forms')
          .doc('role_request_answers')
          .get();

      for (final key in snap.data().keys) {
        if (snap.data()[key]['userId'] == userId &&
            snap.data()[key]['roleName'] == role) {
          return true;
        }
      }

      return false;
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
      return false;
    }
  }
}
