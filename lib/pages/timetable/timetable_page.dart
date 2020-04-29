import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timetable/timetable.dart';

class TimetablePage extends StatefulWidget {
  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  TimetableController<BasicEvent> _controller;

  @override
  void initState() {
    super.initState();
    _controller = TimetableController(
      // A basic EventProvider containing a single event.
      eventProvider: EventProvider.list([
        // TODO: This is a placeholder
        BasicEvent(
          id: 0,
          title: 'Test',
          color: Colors.blue,
          start: LocalDate.today().at(LocalTime(13, 0, 0)),
          end: LocalDate.today().at(LocalTime(15, 0, 0)),
        ),
      ]),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: S.of(context).navigationTimetable,
      leading: IconButton(
        icon: Icon(Icons.today),
        onPressed: () => _controller.animateToToday(),
        tooltip: S.of(context).actionJumpToToday,
      ),
      body: Timetable<BasicEvent>(
        controller: _controller,
        eventBuilder: (event) => BasicEventWidget(event),
      ),
    );
  }
}
