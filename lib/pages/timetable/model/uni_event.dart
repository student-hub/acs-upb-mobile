import 'dart:core';

import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/timetable/model/academic_calendar.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:flutter/material.dart';
import 'package:rrule/rrule.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timetable/timetable.dart';

enum UniEventType { lecture, lab, seminar, sports, other }

extension UniEventTypeExtension on UniEventType {
  String toLocalizedString(BuildContext context) {
    switch (this) {
      case UniEventType.lecture:
        return S.of(context).uniEventTypeLecture;
      case UniEventType.lab:
        return S.of(context).uniEventTypeLab;
      case UniEventType.seminar:
        return S.of(context).uniEventTypeSeminar;
      case UniEventType.sports:
        return S.of(context).uniEventTypeSports;
      default:
        return S.of(context).uniEventTypeOther;
    }
  }
}

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

class UniEvent {
  final String id;
  final Color color;
  final UniEventType type;
  final RecurrenceRule rrule;
  final LocalDateTime start;
  final Period duration;
  final String name;
  final String location;
  final ClassHeader classHeader;
  final AcademicCalendar calendar;

  const UniEvent({
    this.name,
    this.location,
    this.rrule,
    @required this.start,
    @required this.duration,
    @required this.id,
    this.color,
    this.type,
    this.classHeader,
    this.calendar,
  });

  Iterable<UniEventInstance> generateInstances(
      {DateInterval intersectingInterval}) sync* {
    String name = this.name ?? classHeader?.acronym ?? '';

    if (rrule == null) {
      LocalDateTime end = start.add(duration);
      if (intersectingInterval != null) {
        if (end.calendarDate < intersectingInterval.start ||
            start.calendarDate > intersectingInterval.end) return;
      }

      yield UniEventInstance(
        id: id,
        title: name,
        mainEvent: this,
        color: this.color,
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
                  index % rrule.interval ==
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
      for (var start in rrule.getInstances(start: start)) {
        LocalDateTime end = start.add(duration);
        if (intersectingInterval != null) {
          if (end.calendarDate < intersectingInterval.start) continue;
          if (start.calendarDate > intersectingInterval.end) break;
        }

        bool skip = false;
        calendar?.holidays?.forEach((holiday) {
          if (holiday.contains(start.calendarDate)) {
            // Skip holidays
            skip = true;
          }
        });

        if (!skip) {
          yield UniEventInstance(
            id: id + '-' + i.toString(),
            title: name,
            mainEvent: this,
            color: this.color,
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

class UniEventInstance extends Event {
  final UniEvent mainEvent;
  final String title;

  final Color color;
  final String location;
  final String info;

  UniEventInstance(
      {@required String id,
      @required this.title,
      @required this.mainEvent,
      Color color,
      this.location,
      this.info,
      @required LocalDateTime start,
      @required LocalDateTime end})
      : this.color = color ?? mainEvent?.color,
        super(id: id, start: start, end: end);

  @override
  bool operator ==(dynamic other) =>
      super == other &&
      color == other.color &&
      location == other.location &&
      mainEvent == other.mainEvent &&
      title == other.title;

  @override
  int get hashCode =>
      hashList([super.hashCode, color, location, mainEvent, title]);
}
