import 'package:acs_upb_mobile/pages/timetable/model/uni_event.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:time_machine/src/calendars/time_machine_calendars.dart';
import 'package:time_machine/time_machine.dart';

class AcademicCalendar {
  List<DateInterval> semesters;
  Map<String, DateInterval> holidays;

  AcademicCalendar() {
    // TODO: Get data from database
    var startDate = LocalDate.today().subtract(
        Period(weeks: 2, days: LocalDate.today().dayOfWeek.value - 1));

    semesters = [
      DateInterval(
        startDate,
        startDate.add(Period(weeks: 4, days: 5)),
      ),
      DateInterval(
        startDate.add(Period(weeks: 6)),
        startDate.add(Period(weeks: 10, days: 5)),
      ),
    ];
    holidays = {
      'Vacanța 1': DateInterval(
        startDate.addWeeks(2).addDays(2),
        startDate.addWeeks(2).addDays(5),
      ),
      'Vacanța intersemestrială': DateInterval(
        startDate.addWeeks(5),
        startDate.addWeeks(5).addDays(6),
      ),
      'Vacanța 2': DateInterval(
        startDate.addWeeks(8),
        startDate.addWeeks(8).addDays(5),
      ),
    };
  }

  Map<int, Set<int>> _getWeeksByYearInInterval(DateInterval interval) {
    Map<int, Set<int>> weeksByYear = {};
    var rule = WeekYearRules.iso;

    int firstWeek = rule.getWeekOfWeekYear(interval.start);
    int lastWeek = rule.getWeekOfWeekYear(interval.end);

    if (interval.start.year == interval.end.year) {
      weeksByYear[interval.start.year] = range(firstWeek, lastWeek + 1).toSet();
    } else {
      weeksByYear[interval.start.year] = range(
              firstWeek,
              rule.getWeeksInWeekYear(interval.start.year, CalendarSystem.iso) +
                  1)
          .toSet();
      weeksByYear[interval.end.year] = range(1, lastWeek + 1).toSet();
    }

    return weeksByYear;
  }

  Set<int> get nonHolidayWeeks {
    Map<int, Set<int>> weeksByYear = {};
    var rule = WeekYearRules.iso;

    for (var semester in semesters) {
      for (var entry in _getWeeksByYearInInterval(semester).entries) {
        weeksByYear[entry.key] ??= {};
        weeksByYear[entry.key].addAll(entry.value);
      }
    }

    for (var holiday in holidays.values) {
      Map<int, Set<int>> holidayWeeksByYear =
          _getWeeksByYearInInterval(holiday);

      for (var entry in holidayWeeksByYear.entries) {
        int year = entry.key;
        Set<int> weeks = entry.value;

        for (var week in weeks) {
          LocalDate monday = rule.getLocalDate(
              year, week, DayOfWeek.monday, CalendarSystem.iso);
          LocalDate friday = rule.getLocalDate(
              year, week, DayOfWeek.friday, CalendarSystem.iso);

          // If the holiday includes Monday to Friday in a week, exclude week
          // number from [nonHolidayWeeks].
          if (holiday.contains(monday) && holiday.contains(friday)) {
            weeksByYear[year].remove(week);
          }
        }
      }
    }

    return weeksByYear.values.expand((e) => e).toSet();
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
              end: interval.end.at(LocalTime(23, 59, 0)),
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
