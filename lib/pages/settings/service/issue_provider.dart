import 'dart:async';

import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/settings/model/issue.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

extension IssueExtension on Issue {
  Map<String, dynamic> toData() {
    final Map<String, dynamic> data = {};

    if (email != null) {
      data['email'] = email;
    } else {
      data['email'] = '-';
    }
    if (issueBody != null) data['issueBody'] = issueBody;
    if (type != null) data['type'] = type;

    return data;
  }
}

class IssueProvider {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> makeIssue(Issue issue) async {
    assert(issue.issueBody != null);

    try {
      CollectionReference ref;
      ref = _db.collection('feedback');

      final data = issue.toData();
      await ref.add(data);
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
    }
  }
}
