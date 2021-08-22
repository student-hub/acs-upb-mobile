library timetable_utils;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_machine/time_machine.dart';

// ignore: implementation_imports
import 'package:timetable/src/utils.dart';

export 'package:timetable/src/utils.dart';

extension DateTimeExtension on DateTime {
  bool isMidnight() => hour == 0 && minute == 0 && second == 0;

  DateTime atMidnight() => DateTime(year, month, day, 0, 0, 0, 0, 0);

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
