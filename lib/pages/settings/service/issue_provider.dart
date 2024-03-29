import 'dart:async';

import 'package:acs_upb_mobile/pages/settings/model/issue.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

extension IssueExtension on Issue {
  Map<String, dynamic> toData() {
    final Map<String, dynamic> data = {};

    if (email != null && email.isNotEmpty) {
      data['email'] = email;
    }
    if (issueBody != null) data['issueBody'] = issueBody;
    if (type != null) data['type'] = type;

    return data;
  }
}

class IssueProvider {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<bool> makeIssue(Issue issue) async {
    assert(issue.issueBody != null);

    try {
      CollectionReference ref;
      ref = _db.collection('feedback');

      final data = issue.toData();
      await ref.add(data);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
