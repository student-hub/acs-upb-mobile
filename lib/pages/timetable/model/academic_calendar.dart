import 'package:acs_upb_mobile/pages/timetable/model/events/all_day_event.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:time_machine/src/calendars/time_machine_calendars.dart';
import 'package:time_machine/time_machine.dart';

class AcademicCalendar {
  List<AllDayUniEvent> semesters;
  List<AllDayUniEvent> holidays;
  List<AllDayUniEvent> exams;

  AcademicCalendar(
      {this.semesters = const [],
      this.holidays = const [],
      this.exams = const []});

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
      for (var entry in _getWeeksByYearInInterval(
              DateInterval(semester.startDate, semester.endDate))
          .entries) {
        weeksByYear[entry.key] ??= {};
        weeksByYear[entry.key].addAll(entry.value);
      }
    }

    for (var holiday in holidays) {
      DateInterval holidayInterval =
          DateInterval(holiday.startDate, holiday.endDate);
      Map<int, Set<int>> holidayWeeksByYear =
          _getWeeksByYearInInterval(holidayInterval);

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
          if (holidayInterval.contains(monday) &&
              holidayInterval.contains(friday)) {
            weeksByYear[year].remove(week);
          }
        }
      }
    }

    return weeksByYear.values.expand((e) => e).toSet();
  }
}
