import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/pages/planner/service/planner_provider.dart';
import 'package:acs_upb_mobile/pages/timetable/model/events/uni_event.dart';
import 'package:acs_upb_mobile/pages/timetable/service/uni_event_provider.dart';
import 'package:acs_upb_mobile/pages/timetable/view/events/event_view.dart';
import 'package:acs_upb_mobile/widgets/info_card.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/tasks_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';

class PlannerView extends StatefulWidget {
  const PlannerView({Key key}) : super(key: key);

  @override
  _PlannerViewState createState() => _PlannerViewState();
}

class _PlannerViewState extends State<PlannerView> {
  List<String> hiddenEvents;
  bool updating;
  Iterable<UniEventInstance> assignments;

  Future<void> updateHiddenEvents() async {
    // If updating is null, hiddenEvents haven't been initialized yet so they're not
    // technically "updating"
    if (updating != null) {
      updating = true;
    }

    final PlannerProvider plannerProvider =
        Provider.of<PlannerProvider>(context, listen: false);
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    hiddenEvents =
        await plannerProvider.fetchUserHiddenEvents(authProvider.uid);

    updating = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    updateHiddenEvents();
  }

  @override
  Widget build(BuildContext context) {
    final PlannerProvider plannerProvider =
        Provider.of<PlannerProvider>(context);
    final UniEventProvider eventProvider =
        Provider.of<UniEventProvider>(context);
    return AppScaffold(
      title: Text(S.current.sectionPlanner),
      body: FutureBuilder(
          future: eventProvider.getAssignments(limit: 100, retrievePast: true),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              assignments = snapshot.data;
              return Column(
                children: [
                  TasksList(
                    events: assignments.toList(),
                    title: 'All',
                  ),
                  TasksList(
                    events: assignments.toList(),
                    title: 'Some',
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
