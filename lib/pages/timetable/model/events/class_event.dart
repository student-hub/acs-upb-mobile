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
    @required RecurrenceRule rrule,
    @required DateTime start,
    @required Duration duration,
    @required String id,
    List<String> relevance,
    String degree,
    String name,
    String location,
    Color color,
    UniEventType type,
    ClassHeader classHeader,
    AcademicCalendar calendar,
    String addedBy,
    bool editable,
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
