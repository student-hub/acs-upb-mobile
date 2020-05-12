import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/timetable/model/uni_event.dart';
import 'package:acs_upb_mobile/pages/timetable/view/event_view.dart';
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
  TimetableController<UniEventInstance> _controller;

  @override
  void initState() {
    super.initState();
    // TODO: This is a placeholder
    List<UniEvent> events = [
      UniEvent(
        id: '0',
        type: UniEventType.homework,
        properties: {
          'soft': LocalDate.today().at(LocalTime(13, 0, 0)),
          'hard':
              LocalDate.today().at(LocalTime(13, 0, 0)).add(Period(days: 7)),
          'name': 'PC - Tema 1',
        },
      ),
      UniEvent(
        id: '1',
        type: UniEventType.test,
        properties: {
          'name': 'M1 - Parțial',
          'start': LocalDate.today().addDays(1).at(LocalTime(10, 0, 0)),
          'end': LocalDate.today().addDays(1).at(LocalTime(13, 0, 0)),
          'location': 'PR001',
        },
        color: Colors.teal,
      ),
    ];

    _controller = TimetableController(
        // TODO: Make initialTimeRange customizable in settings
        initialTimeRange: InitialTimeRange.range(
            startTime: LocalTime(7, 55, 0), endTime: LocalTime(20, 5, 0)),
        // A basic EventProvider containing a single event.
        eventProvider: EventProvider.list((events
            .map((event) => event.generateInstances())
            .fold(
                [],
                (previousInstances, instances) =>
                    previousInstances + instances))));
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
      needsToBeAuthenticated: true,
      leading: AppScaffoldAction(
        icon: Icons.today,
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
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => EventView(addNew: true),
          )),
        ),
      ],
      body: Timetable<UniEventInstance>(
        controller: _controller,
        eventBuilder: (event) => UniEventWidget(event),
      ),
    );
  }
}
