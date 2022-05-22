import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../generated/l10n.dart';
import '../../../resources/utils.dart';
import '../../../widgets/toast.dart';
import '../model/role_request.dart';

extension RoleRequestExtension on RoleRequest {
  Map<String, dynamic> toData() {
    final Map<String, dynamic> data = {};

    if (userId != null) data['addedBy'] = userId;
    if (requestBody != null) data['requestBody'] = requestBody;
    data['done'] = processed;
    data['dateSubmitted'] = Timestamp.now();
    data['type'] = type.toShortString();
    data['roleName'] = roleName;
    data['accepted'] = false;

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
}
