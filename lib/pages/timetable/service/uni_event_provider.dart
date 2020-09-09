import 'dart:async';

import 'package:acs_upb_mobile/pages/timetable/model/academic_calendar.dart';
import 'package:acs_upb_mobile/pages/timetable/model/uni_event.dart';
import 'package:flutter/material.dart';
import 'package:rrule/rrule.dart';
import 'package:time_machine/src/date_interval.dart';
import 'package:time_machine/src/localdate.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timetable/timetable.dart';

class UniEventProvider extends EventProvider<UniEventInstance>
    with ChangeNotifier {
  AcademicCalendar calendar = AcademicCalendar();

  Stream<List<UniEventInstance>> get _events {
    // TODO: This is a placeholder
    var startDate = calendar.semesters[0].start.calendarDate;
    var twoHours = Period(hours: 2);
    var threeHours = Period(hours: 3);

    var lab = {'ro': 'Laborator', 'en': 'Laboratory'},
        seminar = {'ro': 'seminar', 'en': 'seminar'},
        lecture = {'ro': 'Lecture', 'en': 'Curs'};

    var rrule = RecurrenceRule(
      frequency: Frequency.weekly,
      until: calendar.semesters[1].end,
    );

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

    return Stream.value(calendar.generateHolidayInstances() +
        (events
            .map((event) => event.generateInstances(calendar: calendar))
            .fold(
                [],
                (previousInstances, instances) =>
                    previousInstances + instances)));
  }

  @override
  Stream<Iterable<UniEventInstance>> getAllDayEventsIntersecting(
      DateInterval interval) {
    return _events
        .map((events) => events.allDayEvents.intersectingInterval(interval));
  }

  @override
  Stream<Iterable<UniEventInstance>> getPartDayEventsIntersecting(
      LocalDate date) {
    return _events.map((events) => events.partDayEvents.intersectingDate(date));
  }
}
