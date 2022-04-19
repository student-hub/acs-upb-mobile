import 'package:flutter/material.dart' hide Interval;

import '../../../classes/model/class.dart';
import '../../timetable_utils.dart';
import '../academic_calendar.dart';
import 'uni_event.dart';

class AllDayUniEvent extends UniEvent {
  AllDayUniEvent({
    @required final DateTime start,
    @required final DateTime end,
    @required final String id,
    final String name,
    final String location,
    final Color color,
    final UniEventType type,
    final ClassHeader classHeader,
    final AcademicCalendar calendar,
    final List<String> relevance,
    final String degree,
    final String addedBy,
    final bool editable,
  })  : startDate = start,
        endDate = end,
        super(
            name: name,
            location: location,
            start: start.atMidnight(),
            duration: Interval(start, end.addDays(1)).duration,
            id: id,
            color: color,
            type: type,
            classHeader: classHeader,
            calendar: calendar,
            relevance: relevance,
            degree: degree,
            addedBy: addedBy,
            editable: editable);

  DateTime startDate;
  DateTime endDate;

  @override
  Iterable<UniEventInstance> generateInstances(
      {final Interval intersectingInterval}) sync* {
    yield UniEventInstance(
      title: name,
      mainEvent: this,
      start: startDate.atMidnight().copyWith(isUtc: true),
      end: endDate.addDays(1).atMidnight().copyWith(isUtc: true),
      color: color,
    );
  }
}
