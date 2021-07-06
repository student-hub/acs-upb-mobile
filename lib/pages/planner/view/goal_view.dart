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
          : Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Target Grade',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(fontSize: 16),
                                      overflow: TextOverflow.fade,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              ListTile(
                                key: ValueKey('Target goal'),
                                title: Text(
                                  goal.targetGrade.toString(),
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    //const Spacer(flex: 1),
                    Flexible(
                      flex: 3,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Strategy',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(fontSize: 18),
                                      overflow: TextOverflow.fade,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              ListTile(
                                key: const ValueKey('Strategy'),
                                title: Text(
                                  goal.strategy ?? 'No strategy selected yet',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Indications',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(fontSize: 18),
                                      overflow: TextOverflow.fade,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              ListTile(
                                key: const ValueKey('Indications'),
                                title: Text(
                                  '-> 50% points by Mar 20',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    //const Spacer(flex: 1),
                    // Flexible(
                    //   flex: 6,
                    //   child: Card(
                    //     // height: 200,
                    //
                    //     child: Text(
                    //       goal.taskId,
                    //       textScaleFactor: 2,
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ],
            ),
    );
  }
}
