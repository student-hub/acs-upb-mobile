import 'package:dart_date/dart_date.dart' show Interval;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Interval;
import 'package:time_machine/time_machine.dart' hide Interval;

import '../../../resources/utils.dart';
import '../timetable_utils.dart';
import 'events/all_day_event.dart';

class AcademicCalendar {
  AcademicCalendar(
      {@required this.id,
      this.semesters = const [],
      this.holidays = const [],
      this.exams = const []});

  String id;
  List<AllDayUniEvent> semesters;
  List<AllDayUniEvent> holidays;
  List<AllDayUniEvent> exams;

  Map<int, Set<int>> _getWeeksByYearInInterval(Interval interval) {
    final Map<int, Set<int>> weeksByYear = {};
    final rule = WeekYearRules.iso;

    final int firstWeek =
        rule.getWeekOfWeekYear(LocalDate.dateTime(interval.start));
    final int lastWeek =
        rule.getWeekOfWeekYear(LocalDate.dateTime(interval.end));

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
    final Map<int, Set<int>> weeksByYear = {};
    final rule = WeekYearRules.iso;

    for (final semester in semesters) {
      for (final entry in _getWeeksByYearInInterval(
              Interval(semester.startDate, semester.endDate))
          .entries) {
        weeksByYear[entry.key] ??= {};
        weeksByYear[entry.key].addAll(entry.value);
      }
    }

    for (final holiday in holidays) {
      final Interval holidayInterval =
          Interval(holiday.startDate, holiday.endDate);
      final Map<int, Set<int>> holidayWeeksByYear =
          _getWeeksByYearInInterval(holidayInterval);

      for (final entry in holidayWeeksByYear.entries) {
        final int year = entry.key;
        final Set<int> weeks = entry.value;

        for (final week in weeks) {
          final DateTime monday = rule
              .getLocalDate(year, week, DayOfWeek.monday, CalendarSystem.iso)
              .toDateTimeUnspecified();
          final DateTime friday = rule
              .getLocalDate(year, week, DayOfWeek.friday, CalendarSystem.iso)
              .toDateTimeUnspecified();

          // If the holiday includes Monday to Friday in a week, exclude week
          // number from [nonHolidayWeeks].
          if (holidayInterval.includes(monday) &&
              holidayInterval.includes(friday)) {
            weeksByYear[year].remove(week);
          }
        }
      }
    }

    return weeksByYear.values.expand((e) => e).toSet();
  }
}
