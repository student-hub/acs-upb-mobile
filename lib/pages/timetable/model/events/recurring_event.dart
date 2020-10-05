import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/timetable/model/academic_calendar.dart';
import 'package:acs_upb_mobile/pages/timetable/model/events/uni_event.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:rrule/rrule.dart';
import 'package:time_machine/time_machine.dart';

extension on RecurrenceRule {
  RecurrenceRule copyWith({
    Frequency frequency,
    LocalDateTime until,
    int count,
    int interval,
    Set<int> bySeconds,
    Set<int> byMinutes,
    Set<int> byHours,
    Set<ByWeekDayEntry> byWeekDays,
    Set<int> byMonthDays,
    Set<int> byYearDays,
    Set<int> byWeeks,
    Set<int> byMonths,
    Set<int> bySetPositions,
    DayOfWeek weekStart,
  }) {
    return RecurrenceRule(
      frequency: frequency ?? this.frequency,
      until: until ?? this.until,
      count: count ?? this.count,
      interval: interval ?? this.interval,
      bySeconds: bySeconds ?? this.bySeconds,
      byMinutes: byMinutes ?? this.byMinutes,
      byHours: byHours ?? this.byHours,
      byWeekDays: byWeekDays ?? this.byWeekDays,
      byMonthDays: byMonthDays ?? this.byMonthDays,
      byYearDays: byYearDays ?? this.byYearDays,
      byWeeks: byWeeks ?? this.byWeeks,
      byMonths: byMonths ?? this.byMonths,
      bySetPositions: bySetPositions ?? this.bySetPositions,
      weekStart: weekStart ?? this.weekStart,
    );
  }
}

class RecurringUniEvent extends UniEvent {
  const RecurringUniEvent({
    @required this.rrule,
    @required LocalDateTime start,
    @required Period duration,
    @required String id,
    List<String> relevance,
    String degree,
    String name,
    String location,
    Color color,
    UniEventType type,
    ClassHeader classHeader,
    AcademicCalendar calendar,
  }) : super(
            name: name,
            location: location,
            start: start,
            duration: duration,
            degree: degree,
            relevance: relevance,
            id: id,
            color: color,
            type: type,
            classHeader: classHeader,
            calendar: calendar);

  final RecurrenceRule rrule;

  @override
  Iterable<UniEventInstance> generateInstances(
      {DateInterval intersectingInterval}) sync* {
    if (rrule == null) {
      final LocalDateTime end = start.add(duration);
      if (intersectingInterval != null) {
        if (end.calendarDate < intersectingInterval.start ||
            start.calendarDate > intersectingInterval.end) return;
      }

      yield UniEventInstance(
        id: id,
        title: name,
        mainEvent: this,
        color: color,
        start: start,
        end: start.add(duration),
        location: location,
      );
    } else {
      RecurrenceRule rrule = this.rrule;
      if (calendar != null && rrule.frequency == Frequency.weekly) {
        var weeks = calendar.nonHolidayWeeks;

        // Get the correct sequence of weeks for this event.
        //
        // For example, if the first academic calendar week is 40 and the event
        // starts on week 41 and repeats every two weeks - get every odd-index
        // week in the non holiday weeks.
        // This is necessary because if an "even" week is followed by a one-week
        // holiday, the week that comes after the holiday should be considered
        // an "odd" week, even though its number in the calendar would have the
        // same parity as the week before the holiday.
        if (rrule.interval != 1) {
          weeks = weeks
              .whereIndex((index) =>
                  index % rrule.interval !=
                  weeks.lookup(WeekYearRules.iso
                          .getWeekOfWeekYear(start.calendarDate)) %
                      rrule.interval)
              .toSet();
        }
        rrule = rrule.copyWith(
            frequency: Frequency.daily,
            interval: 1,
            byWeekDays: {ByWeekDayEntry(start.dayOfWeek)},
            byWeeks: weeks);
      }

      // Calculate recurrences
      int i = 0;
      for (final start in rrule.getInstances(start: start)) {
        final LocalDateTime end = start.add(duration);
        if (intersectingInterval != null) {
          if (end.calendarDate < intersectingInterval.start) continue;
          if (start.calendarDate > intersectingInterval.end) break;
        }

        bool skip = false;
        for (final holiday in calendar?.holidays ?? []) {
          final holidayInterval =
              DateInterval(holiday.startDate, holiday.endDate);
          if (holidayInterval.contains(start.calendarDate)) {
            // Skip holidays
            skip = true;
          }
        }

        if (!skip) {
          yield UniEventInstance(
            id: '$id-$i',
            title: name,
            mainEvent: this,
            color: color,
            start: start,
            end: end,
            location: location,
          );
        }

        i++;
      }
    }
  }
}
