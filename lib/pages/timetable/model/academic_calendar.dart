import 'package:acs_upb_mobile/pages/timetable/model/uni_event.dart';
import 'package:acs_upb_mobile/resources/locale_provider.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:time_machine/src/calendars/time_machine_calendars.dart';
import 'package:time_machine/time_machine.dart';

class NamedInterval extends DateInterval {
  final Map<String, String> localizedName;
  final LocalDate start;
  final LocalDate end;

  NamedInterval({this.localizedName, @required this.start, @required this.end})
      : super(start, end);
}

class AcademicCalendar {
  List<NamedInterval> semesters;
  List<NamedInterval> holidays;

  AcademicCalendar({this.semesters = const [], this.holidays = const []});

  Map<int, Set<int>> _getWeeksByYearInInterval(NamedInterval interval) {
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

    for (var holiday in holidays) {
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
        .asMap()
        .map((index, holiday) => MapEntry(
            index,
            UniEventInstance(
              id: 'holiday' + index.toString(),
              title: holiday.localizedName[LocaleProvider.localeString],
              mainEvent: null,
              start: holiday.start.atMidnight(),
              end: holiday.end.addDays(1).atMidnight(),
              // TODO: Set holiday color in settings
              color: Colors.yellow,
            )))
        .values
        .toList();
    return instances;
  }
}
