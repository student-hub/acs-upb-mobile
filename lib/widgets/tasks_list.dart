import 'package:acs_upb_mobile/pages/timetable/model/events/uni_event.dart';
import 'package:acs_upb_mobile/pages/timetable/view/events/event_view.dart';
import 'package:acs_upb_mobile/widgets/event_instance_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';

class TasksList extends StatefulWidget {
  const TasksList({
    @required this.events,
    this.title,
  });
  final List<UniEventInstance> events;
  final String title;

  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      shrinkWrap: true,
      itemCount: widget.events.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return ListTile(
              key: ValueKey(widget.title),
              onTap: () => {
                    setState(() {
                      isExpanded = !isExpanded;
                    })
                  },
              leading: const CircleAvatar(
                backgroundColor: Colors.blue,
              ),
              title: Text(widget.title));
        } else {
          return Visibility(
              visible: isExpanded,
              child: EventInstanceListTile(
                  eventInstance: widget.events[index - 1]));
        }
      },
    );
  }
}
