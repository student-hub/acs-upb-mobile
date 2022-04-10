import 'package:flutter/cupertino.dart';
import 'package:rrule/rrule.dart';

import '../../../classes/model/class.dart';
import '../../../people/model/person.dart';
import '../academic_calendar.dart';
import 'recurring_event.dart';
import 'uni_event.dart';

class ClassEvent extends RecurringUniEvent {
  const ClassEvent({
    @required this.teacher,
    @required final RecurrenceRule rrule,
    @required final DateTime start,
    @required final Duration duration,
    @required final String id,
    final List<String> relevance,
    final String degree,
    final String name,
    final String location,
    final Color color,
    final UniEventType type,
    final ClassHeader classHeader,
    final AcademicCalendar calendar,
    final String addedBy,
    final bool editable,
  }) : super(
            rrule: rrule,
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
            calendar: calendar,
            addedBy: addedBy,
            editable: editable);

  final Person teacher;
}
