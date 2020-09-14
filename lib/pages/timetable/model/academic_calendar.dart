import 'package:acs_upb_mobile/pages/timetable/model/uni_event.dart';
import 'package:flutter/material.dart';
import 'package:time_machine/time_machine.dart';

class AcademicCalendar {
  List<DateInterval> semesters;
  Map<String, DateInterval> holidays;

  AcademicCalendar() {
    // TODO: Get data from database
    var startDate = LocalDate.today()
        .subtract(Period(days: LocalDate.today().dayOfWeek.value - 1));

    semesters = [
      DateInterval(
        startDate,
        startDate.add(Period(weeks: 5)),
      ),
      DateInterval(
        startDate.add(Period(weeks: 6)),
        startDate.add(Period(weeks: 9)),
      ),
    ];
    holidays = {
      'Vacanța 1': DateInterval(
        startDate.addWeeks(2).addDays(2),
        startDate.addWeeks(2).addDays(5),
      ),
      'Vacanța intersemestrială': DateInterval(
        startDate.addWeeks(6),
        startDate.addWeeks(7),
      ),
      'Vacanța 2': DateInterval(
        startDate.addWeeks(8),
        startDate.addWeeks(8).addDays(3),
      ),
    };
  }

  List<UniEventInstance> generateHolidayInstances() {
    var instances = holidays
        .map((holiday, interval) => MapEntry(
            holiday,
            UniEventInstance(
              id: holiday,
              title: holiday,
              mainEvent: null,
              start: interval.start.atMidnight(),
              end: interval.end.atMidnight(),
              // TODO: Set holiday color in settings
              color: Colors.yellow,
            )))
        .values
        .toList();
    return instances;
  }

  List<UniEvent> get holidayEvents => holidays
      .map((holiday, interval) => MapEntry(
          holiday,
          UniEvent(
            id: holiday,
            name: holiday,
            start: interval.start.atMidnight(),
            duration:
                Period.differenceBetweenDates(interval.start, interval.end),
            // TODO: Set holiday color in settings
            color: Colors.yellow,
          )))
      .values
      .toList();
}
