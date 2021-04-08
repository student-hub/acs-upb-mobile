import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/planner/model/assignment.dart';
import 'package:acs_upb_mobile/pages/timetable/model/events/uni_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:acs_upb_mobile/pages/classes/service/class_provider.dart';

extension AssignmentExtension on Assignment {
  static Assignment fromSnap(DocumentSnapshot snap) {
    final json = snap.data();
    return Assignment(
        id: 'ti0QcVZFj7N2ZCtJ50WW632V41D3',
        type: UniEventTypeExtension.fromString(json['type']),
        name: json['name'],
        // Convert time to UTC and then to local time
        start: (json['start'] as Timestamp).toLocalDateTime().calendarDate,
        end: (json['end'] as Timestamp).toLocalDateTime().calendarDate,
        addedBy: json['addedBy']);
  }
}

class AssignmentProvider with ChangeNotifier {
  Future<List<Assignment>> fetchAssignments({BuildContext context}) async {
    try {
      final QuerySnapshot qSnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('type', isEqualTo: 'assignment')
          //.collection('assignments')
          .get();
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
