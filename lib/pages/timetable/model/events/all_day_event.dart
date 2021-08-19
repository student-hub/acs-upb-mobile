import 'package:flutter/material.dart';
import 'package:time_machine/time_machine.dart';

import '../../../classes/model/class.dart';
import '../../timetable_utils.dart';
import '../academic_calendar.dart';
import 'uni_event.dart';

class AllDayUniEvent extends UniEvent {
  AllDayUniEvent({
    @required DateTime start,
    @required DateTime end,
    @required String id,
    String name,
    String location,
    Color color,
    UniEventType type,
    ClassHeader classHeader,
    AcademicCalendar calendar,
    List<String> relevance,
    String degree,
    String addedBy,
    bool editable,
  })  : startDate = start,
        endDate = end,
        super(
            name: name,
            location: location,
            start: start.atMidnight(),
            duration: Period.differenceBetweenDates(
                LocalDate.dateTime(start), LocalDate.dateTime(end.addDays(1))),
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
      {DateTimeRange intersectingInterval}) sync* {
    yield UniEventInstance(
      title: name,
      mainEvent: this,
      start: startDate.atMidnight(),
      end: endDate.addDays(1).atMidnight(),
      color: color,
    );
  }
}
