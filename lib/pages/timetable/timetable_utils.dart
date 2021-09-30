library timetable_utils;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: implementation_imports
import 'package:timetable/src/utils.dart';
import 'package:timetable/timetable.dart';
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

  DateTime at({DateTime dateTime, TimeOfDay timeOfDay}) {
    if (dateTime != null) {
      return copyWith(
          hour: dateTime.hour,
          minute: dateTime.minute,
          second: dateTime.second,
          millisecond: dateTime.millisecond);
    } else if (timeOfDay != null) {
      return copyWith(
          hour: timeOfDay.hour,
          minute: timeOfDay.minute,
          second: 0,
          millisecond: 0);
    } else {
      return null;
    }
  }

  TimeOfDay toTimeOfDay() {
    return TimeOfDay(
      hour: hour,
      minute: minute,
    );
  }
}

extension MonthController on DateController {
  String get currentMonth => DateTime(
        value?.date?.year,
        value?.date?.month,
        1,
        0,
        0,
        0,
      ).toStringWithFormat('MMMM');
}
