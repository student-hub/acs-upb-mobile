import 'package:acs_upb_mobile/pages/timetable/model/uni_event.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:time_machine/time_machine.dart';

class TimeInterval {
  LocalDateTime start;
  LocalDateTime end;

  TimeInterval({@required this.start, @required this.end});

  /// Check if [time] is included in this time interval.
  bool includes(LocalDateTime time) => start <= time && time <= end;
}

class AcademicCalendar {
  List<TimeInterval> semesters;
  Map<String, TimeInterval> holidays;

  AcademicCalendar() {
    // TODO: Get data from database
    var startDate = LocalDate.today()
        .subtract(Period(days: LocalDate.today().dayOfWeek.value - 1))
        .atMidnight();

    semesters = [
      TimeInterval(
        start: startDate,
        end: startDate.add(Period(weeks: 5)),
      ),
      TimeInterval(
        start: startDate.add(Period(weeks: 6)),
        end: startDate.add(Period(weeks: 9)),
      ),
    ];
    holidays = {
      'Vacanța 1': TimeInterval(
        start: startDate.addWeeks(2).addDays(2),
        end: startDate.addWeeks(2).addDays(5),
      ),
      'Vacanța intersemestrială': TimeInterval(
        start: startDate.addWeeks(6),
        end: startDate.addWeeks(7),
      ),
      'Vacanța 2': TimeInterval(
        start: startDate.addWeeks(8),
        end: startDate.addWeeks(8).addDays(3),
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
              start: interval.start,
              end: interval.end,
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
            start: interval.start,
            duration:
                Period.differenceBetweenDateTime(interval.start, interval.end),
            // TODO: Set holiday color in settings
            color: Colors.yellow,
          )))
      .values
      .toList();
}
