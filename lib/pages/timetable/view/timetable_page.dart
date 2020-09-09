import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/classes/service/class_provider.dart';
import 'package:acs_upb_mobile/pages/classes/view/classes_page.dart';
import 'package:acs_upb_mobile/pages/timetable/model/uni_event.dart';
import 'package:acs_upb_mobile/pages/timetable/view/uni_event_widget.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrule/rrule.dart';
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
    var startDate = LocalDate.today();
    var twoHours = Period(hours: 2);
    var threeHours = Period(hours: 3);

    var lab = {'ro': 'Laborator', 'en': 'Laboratory'},
        seminar = {'ro': 'seminar', 'en': 'seminar'},
        lecture = {'ro': 'Lecture', 'en': 'Curs'};

    var rrule = RecurrenceRule(
        frequency: Frequency.weekly,
        until: startDate.add(Period(weeks: 5)).atMidnight(),);

    List<UniEvent> events = [
      UniEvent(
        rrule: rrule,
        id: '3',
        localizedType: lab,
        name: 'USO',
        start: startDate.at(LocalTime(8, 0, 0)),
        duration: twoHours,
        location: 'EG306',
        color: Colors.blue,
      ),
      UniEvent(
        rrule: rrule,
        id: '4',
        localizedType: lab,
        name: 'PC',
        start: startDate.at(LocalTime(10, 0, 0)),
        duration: twoHours,
        location: 'EG105',
        color: Colors.blue,
      ),
      UniEvent(
        rrule: rrule,
        id: '5',
        localizedType: seminar,
        name: 'LS1',
        start: startDate.at(LocalTime(12, 0, 0)),
        duration: twoHours,
        location: 'PR103b',
        color: Colors.lime,
      ),
      UniEvent(
        rrule: rrule,
        id: '6',
        localizedType: lecture,
        name: 'PL',
        start: startDate.addDays(1).at(LocalTime(9, 0, 0)),
        duration: threeHours,
        location: 'AN001',
        color: Colors.orange,
      ),
      UniEvent(
        rrule: rrule,
        id: '7',
        localizedType: seminar,
        name: 'M1',
        start: startDate.addDays(1).at(LocalTime(14, 0, 0)),
        duration: twoHours,
        location: 'EC102',
        color: Colors.lime,
      ),
      UniEvent(
        rrule: rrule,
        id: '8',
        localizedType: lab,
        name: 'PL',
        start: startDate.addDays(1).at(LocalTime(16, 0, 0)),
        duration: twoHours,
        location: 'EG311',
        color: Colors.blue,
      ),
      UniEvent(
        rrule: rrule,
        id: '9',
        localizedType: lab,
        name: 'USO',
        start: startDate.addDays(1).at(LocalTime(18, 0, 0)),
        duration: twoHours,
        location: 'EG306',
        color: Colors.blue,
      ),
      UniEvent(
        rrule: rrule,
        id: '2',
        localizedType: lecture,
        name: 'M2',
        start: startDate.addDays(2).at(LocalTime(11, 0, 0)),
        duration: twoHours,
        location: 'AN001',
        color: Colors.orange,
      ),
      UniEvent(
        rrule: rrule,
        id: '10',
        localizedType: seminar,
        name: 'M2',
        start: startDate.addDays(2).at(LocalTime(14, 0, 0)),
        duration: twoHours,
        location: 'AN217',
        color: Colors.lime,
      ),
      UniEvent(
        rrule: rrule,
        id: '11',
        localizedType: lecture,
        name: 'PC',
        start: startDate.addDays(3).at(LocalTime(11, 0, 0)),
        duration: twoHours,
        location: 'PR001',
        color: Colors.orange,
      ),
      UniEvent(
        rrule: rrule,
        id: '12',
        localizedType: seminar,
        name: 'L',
        start: startDate.addDays(3).at(LocalTime(14, 0, 0)),
        duration: twoHours,
        location: 'AN217',
        color: Colors.lime,
      ),
      UniEvent(
        rrule: rrule,
        id: '13',
        localizedType: lecture,
        name: 'L',
        start: startDate.addDays(4).at(LocalTime(8, 0, 0)),
        duration: twoHours,
        location: 'AN034',
        color: Colors.orange,
      ),
    ];

    _controller = TimetableController(
        // TODO: Make initialTimeRange customizable in settings
        initialTimeRange: InitialTimeRange.range(
            startTime: LocalTime(7, 55, 0), endTime: LocalTime(20, 5, 0)),
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
        ),
      ],
      body: Timetable<UniEventInstance>(
        controller: _controller,
        eventBuilder: (event) => UniEventWidget(event),
      ),
    );
  }
}
