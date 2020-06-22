import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/classes/service/class_provider.dart';
import 'package:acs_upb_mobile/pages/classes/view/classes_page.dart';
import 'package:acs_upb_mobile/pages/timetable/model/uni_event.dart';
import 'package:acs_upb_mobile/pages/timetable/view/event_view.dart';
import 'package:acs_upb_mobile/pages/timetable/view/uni_event_widget.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    var startDate = LocalDate(2020, 6, 22);
    List<UniEvent> events = [
      UniEvent(
        id: '3',
        type: UniEventType.lab,
        properties: {
          'name': 'USO',
          'start': startDate.at(LocalTime(8, 0, 0)),
          'end': startDate.at(LocalTime(10, 0, 0)),
          'location': 'EG306',
        },
        color: Colors.blue,
      ),
      UniEvent(
        id: '4',
        type: UniEventType.lab,
        properties: {
          'name': 'PC',
          'start': startDate.at(LocalTime(10, 0, 0)),
          'end': startDate.at(LocalTime(12, 0, 0)),
          'location': 'EG105',
        },
        color: Colors.blue,
      ),
      UniEvent(
        id: '5',
        type: UniEventType.seminar,
        properties: {
          'name': 'LS1',
          'start': startDate.at(LocalTime(12, 0, 0)),
          'end': startDate.at(LocalTime(14, 0, 0)),
          'location': 'PR103b',
        },
        color: Colors.lime,
      ),
      UniEvent(
        id: '6',
        type: UniEventType.lecture,
        properties: {
          'name': 'PL',
          'start': startDate.addDays(1).at(LocalTime(9, 0, 0)),
          'end': startDate.addDays(1).at(LocalTime(12, 0, 0)),
          'location': 'AN001',
        },
        color: Colors.orange,
      ),
      UniEvent(
        id: '7',
        type: UniEventType.seminar,
        properties: {
          'name': 'M1',
          'start': startDate.addDays(1).at(LocalTime(14, 0, 0)),
          'end': startDate.addDays(1).at(LocalTime(16, 0, 0)),
          'location': 'EC102',
        },
        color: Colors.lime,
      ),
      UniEvent(
        id: '8',
        type: UniEventType.lab,
        properties: {
          'name': 'PL',
          'start': startDate.addDays(1).at(LocalTime(16, 0, 0)),
          'end': startDate.addDays(1).at(LocalTime(18, 0, 0)),
          'location': 'EG311',
        },
        color: Colors.blue,
      ),
      UniEvent(
        id: '9',
        type: UniEventType.lab,
        properties: {
          'name': 'USO',
          'start': startDate.addDays(1).at(LocalTime(18, 0, 0)),
          'end': startDate.addDays(1).at(LocalTime(20, 0, 0)),
          'location': 'EG306',
        },
        color: Colors.blue,
      ),
      UniEvent(
        id: '1',
        type: UniEventType.test,
        properties: {
          'name': 'M1 - Parțial',
          'start': startDate.addDays(2).at(LocalTime(8, 0, 0)),
          'end': startDate.addDays(2).at(LocalTime(11, 0, 0)),
          'location': 'AN001',
        },
        color: Colors.teal,
      ),
      UniEvent(
        id: '2',
        type: UniEventType.lecture,
        properties: {
          'name': 'M2',
          'start': startDate.addDays(2).at(LocalTime(11, 0, 0)),
          'end': startDate.addDays(2).at(LocalTime(14, 0, 0)),
          'location': 'AN001',
        },
        color: Colors.orange,
      ),
      UniEvent(
        id: '10',
        type: UniEventType.seminar,
        properties: {
          'name': 'M2',
          'start': startDate.addDays(2).at(LocalTime(14, 0, 0)),
          'end': startDate.addDays(2).at(LocalTime(16, 0, 0)),
          'location': 'AN217',
        },
        color: Colors.lime,
      ),
      UniEvent(
        id: '11',
        type: UniEventType.lecture,
        properties: {
          'name': 'PC',
          'start': startDate.addDays(3).at(LocalTime(11, 0, 0)),
          'end': startDate.addDays(3).at(LocalTime(14, 0, 0)),
          'location': 'PR001',
        },
        color: Colors.orange,
      ),
      UniEvent(
        id: '12',
        type: UniEventType.seminar,
        properties: {
          'name': 'L',
          'start': startDate.addDays(3).at(LocalTime(14, 0, 0)),
          'end': startDate.addDays(3).at(LocalTime(16, 0, 0)),
          'location': 'AN217',
        },
        color: Colors.lime,
      ),
      UniEvent(
        id: '13',
        type: UniEventType.lecture,
        properties: {
          'name': 'L',
          'start': startDate.addDays(4).at(LocalTime(8, 0, 0)),
          'end': startDate.addDays(4).at(LocalTime(10, 0, 0)),
          'location': 'AN034',
        },
        color: Colors.orange,
      ),
      UniEvent(
        id: '0',
        type: UniEventType.homework,
        properties: {
          'soft': startDate.addDays(5).at(LocalTime(23, 00, 0)),
          'hard':
          startDate.at(LocalTime(23, 0, 0)).add(Period(days: 7)),
          'name': 'PC - Tema 1',
        },
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
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
                value: Provider.of<ClassProvider>(context),
                child: ClassesPage()),
          )),
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
