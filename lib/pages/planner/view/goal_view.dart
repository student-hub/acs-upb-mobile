import 'package:acs_upb_mobile/pages/planner/model/goal.dart';
import 'package:acs_upb_mobile/pages/timetable/model/events/task_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GoalView extends StatelessWidget {
  const GoalView({Key key, this.goal, this.event}) : super(key: key);
  final Goal goal;
  final TaskEvent event;

//   @override
//   _GoalViewState createState() => _GoalViewState();
// }
//
// class _GoalViewState extends State<GoalView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: goal == null
          ? const Card(
              child: Padding(
                padding: EdgeInsets.all(12),
              ),
            )
          : Row(
              children: [
                Flexible(
                  flex: 4,
                  child: Container(
                    //height: 200,
                    color: Colors.teal,
                    child: Text(goal.taskId),
                  ),
                ),
                const Spacer(flex: 2),
                Flexible(
                  flex: 6,
                  child: Container(
                    // height: 200,
                    color: Colors.teal,
                    child: Text(goal.taskId),
                  ),
                )
              ],
            ),
    );
  }
}
