import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../generated/l10n.dart';
import '../../../resources/utils.dart';
import '../../../widgets/toast.dart';
import '../model/role_request.dart';

extension RoleRequestExtension on RoleRequest {
  Map<String, dynamic> toData() {
    final Map<String, dynamic> data = {};

    if (userId != null) data['userId'] = userId;
    if (roleName != null) data['roleName'] = roleName;
    if (requestBody != null) data['requestBody'] = requestBody;
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
      await FirebaseFirestore.instance
          .collection('forms')
          .doc('role_request_answers')
          .collection(roleRequest.userId)
          .add(roleRequest.toData());

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
          .collection(userId)
          .get();

      final result = snap.docs.any((doc) => doc.data()['roleName'] == role);

      return false;
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
      return false;
    }
  }
}
