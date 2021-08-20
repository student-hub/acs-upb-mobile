library timetable_utils;

// ignore: implementation_imports
import 'package:timetable/src/utils.dart';
import 'package:timetable/timetable.dart';
import 'package:flutter/material.dart';
export 'package:timetable/src/utils.dart';

extension DateTimeExtension on DateTime {
  DateTime atMidnight() => DateTime(year, month, day, 0, 0, 0, 0, 0);

  DateTime addDays(int noDays) => add(Duration(days: noDays));
}

extension DateTimeRangeExtension on DateTimeRange {
  bool contains(DateTime dateTime) {
    return dateTime >= start && dateTime <= end;
  }
}
