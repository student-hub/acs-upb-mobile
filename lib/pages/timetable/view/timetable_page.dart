import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/timetable/model/uni_event.dart';
import 'package:acs_upb_mobile/pages/timetable/view/uni_event_widget.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timetable/timetable.dart';

class TimetablePage extends StatefulWidget {
  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  TimetableController<UniEvent> _controller;

  @override
  void initState() {
    super.initState();
    _controller = TimetableController(
      // A basic EventProvider containing a single event.
      eventProvider: EventProvider.list([
        // TODO: This is a placeholder
        UniEvent(
          id: '0',
          title: 'PC',
          type: 'Laborator',
          location: 'EG105',
          color: Colors.blue,
          start: LocalDate.today().at(LocalTime(13, 0, 0)),
          end: LocalDate.today().at(LocalTime(15, 0, 0)),
        ),
        UniEvent(
          id: '1',
          title: 'USO',
          type: 'Curs',
          location: 'PR001',
          color: Colors.teal,
          start: LocalDate.today().addDays(1).at(LocalTime(10, 0, 0)),
          end: LocalDate.today().addDays(1).at(LocalTime(13, 0, 0)),
        ),
        UniEvent(
          id: '2',
          title: 'PL',
          type: 'Test',
          location: 'EG206',
          color: Colors.orange,
          start: LocalDate.today().addDays(1).at(LocalTime(13, 0, 0)),
          end: LocalDate.today().addDays(1).at(LocalTime(14, 0, 0)),
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
      actions: [
        AppScaffoldAction(
          icon: Icons.class_,
          tooltip: S.of(context).navigationClasses,
        ),
        AppScaffoldAction(
          icon: Icons.add,
          tooltip: S.of(context).actionAddEvent,
        ),
      ],
      body: Timetable<UniEvent>(
        controller: _controller,
        eventBuilder: (event) => UniEventWidget(event),
      ),
    );
  }
}
