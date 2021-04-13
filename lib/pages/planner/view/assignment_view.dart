import 'package:acs_upb_mobile/pages/planner/model/assignment.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';

class AssignmentView extends StatefulWidget {
  const AssignmentView({Key key, this.assignmentInstance}) : super(key: key);
  final Assignment assignmentInstance;
  @override
  _AssignmentViewState createState() => _AssignmentViewState();
}

class _AssignmentViewState extends State<AssignmentView> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(title: Text(S.of(context).navigationEventDetails));
  }
}
