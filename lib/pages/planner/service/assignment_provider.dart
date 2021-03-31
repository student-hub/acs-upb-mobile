import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/planner/model/assignment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';

extension AssignmentExtension on Assignment {
  static Assignment fromSnap(DocumentSnapshot snap) {
    final data = snap.data();
    return Assignment(name: data['name']);
  }
}

class AssignmentProvider with ChangeNotifier {
  Future<List<Assignment>> fetchAssignments({BuildContext context}) async {
    try {
      final QuerySnapshot qSnapshot =
          await FirebaseFirestore.instance.collection('assignments').get();
      return qSnapshot.docs.map(AssignmentExtension.fromSnap).toList();
    } catch (e) {
      print(e);
      if (context != null) {
        AppToast.show(S.of(context).errorSomethingWentWrong);
      }
      return null;
    }
  }
}
