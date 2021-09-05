library timetable_utils;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_machine/time_machine.dart';

// ignore: implementation_imports
import 'package:timetable/src/utils.dart';

import 'model/events/recurring_event.dart';
import 'model/events/uni_event.dart';

export 'package:timetable/src/utils.dart';

extension DateTimeExtension on DateTime {
  bool isMidnight() => hour == 0 && minute == 0 && second == 0;

  DateTime atMidnight() =>
      copyWith(hour: 0, minute: 0, second: 0, millisecond: 0);

  DateTime addDays(int noDays) => add(Duration(days: noDays));

  DateTime subtractDays(int noDays) => subtract(Duration(days: noDays));

  String toStringWithFormat(String format) {
    return DateFormat(format).format(this);
  }

  DateTime at(DateTime time) {
    return copyWith(
      hour: time.hour,
      minute: time.minute,
      second: time.second,
      millisecond: time.millisecond,
    );
  }

  TimeOfDay toTimeOfDay() {
    return TimeOfDay(
      hour: hour,
      minute: minute,
    );
  }

  /// Forcing conversion to avoid hour changes from original toUtc() method from [DateTime]
  DateTime toUtcForced() {
    return copyWith(hour: hour, isUtc: true);
  }
}

extension DateTimeRangeExtension on DateTimeRange {
  bool contains(DateTime dateTime) {
    return dateTime >= start && dateTime <= end;
  }
}

extension DurationExtension on Duration {
  Period toPeriod() {
    return Period(minutes: inMinutes).normalize();
  }
}

extension RecurringUniEventExtension on RecurringUniEvent {
  RecurringUniEvent copyWith({
    DateTime start,
  }) {
    return RecurringUniEvent(
      start: start ?? this.start,
      period: period,
      id: id,
      name: name,
      location: location,
      color: color,
      type: type,
      classHeader: classHeader,
      calendar: calendar,
      relevance: relevance,
      degree: degree,
      addedBy: addedBy,
      editable: editable,
      rrule: rrule,
    );
  }
}

extension UniEventInstanceExtension on UniEventInstance {
  UniEventInstance copyWith({
    DateTime start,
    DateTime end,
  }) {
    return UniEventInstance(
        start: start ?? this.start,
        end: end ?? this.end,
        title: title,
        mainEvent: mainEvent,
        color: color,
        location: location,
        info: info);
  }
}
