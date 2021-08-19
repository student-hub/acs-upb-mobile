// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

extension DateTimeExtension on DateTime {
  DateTime atMidnight() => DateTime(year, month, day, 0, 0, 0);
  DateTime addDays(int noDays) => add(Duration(days: noDays));

  // from https://github.com/JonasWanke/timetable/blob/a09be6e1e64457e93a448c60ab6851230a3f2a4b/lib/src/utils.dart
  bool operator <(DateTime other) => isBefore(other);
  bool operator <=(DateTime other) =>
      isBefore(other) || isAtSameMomentAs(other);
  bool operator >(DateTime other) => isAfter(other);
  bool operator >=(DateTime other) => isAfter(other) || isAtSameMomentAs(other);

}

extension DateTimeRangeExtension on DateTimeRange {
  bool contains(DateTime dateTime) {
    return dateTime >= start && dateTime <= end;
  }
}


//
// class CalendarDate {
//   CalendarDate(this.year, this.month, this.day);
//
//   int year;
//   int month;
//   int day;
//
//   bool equals(CalendarDate other) {
//     return year == other.year && month == other.month && day == other.day;
//   }
// }
//
// class ClockTime {
//   ClockTime(this.hour, this.minute, this.second);
//
//   int hour;
//   int minute;
//   int second;
//
//   bool equals(ClockTime other) {
//     return hour == other.hour &&
//         minute == other.minute &&
//         second == other.second;
//   }
// }
