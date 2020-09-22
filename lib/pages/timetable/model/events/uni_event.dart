import 'dart:core';

import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/timetable/model/academic_calendar.dart';
import 'package:flutter/material.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timetable/timetable.dart';

enum UniEventType {
  lecture,
  lab,
  seminar,
  sports,
  semester,
  holiday,
  examSession,
  other
}

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
      case UniEventType.semester:
        return S.of(context).uniEventTypeSemester;
      case UniEventType.holiday:
        return S.of(context).uniEventTypeHoliday;
      case UniEventType.examSession:
        return S.of(context).uniEventTypeExamSession;
      default:
        return S.of(context).uniEventTypeOther;
    }
  }
}

class UniEvent {
  final String id;
  final Color color;
  final UniEventType type;
  final LocalDateTime start;
  final Period duration;
  final String name;
  final String location;
  final ClassHeader classHeader;
  final AcademicCalendar calendar;
  final List<String> relevance;

  const UniEvent({
    this.name,
    this.location,
    @required this.start,
    @required this.duration,
    @required this.id,
    this.color,
    this.type,
    this.classHeader,
    this.calendar,
    this.relevance
  });

  Iterable<UniEventInstance> generateInstances(
      {DateInterval intersectingInterval}) sync* {
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
