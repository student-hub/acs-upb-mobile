import 'dart:core';

import 'package:flutter/material.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timetable/timetable.dart';
import '../../../../generated/l10n.dart';
import '../../../classes/model/class.dart';
import '../../timetable_utils.dart';
import '../academic_calendar.dart';

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
  String toLocalizedString() {
    switch (this) {
      case UniEventType.lecture:
        return S.current.uniEventTypeLecture;
      case UniEventType.lab:
        return S.current.uniEventTypeLab;
      case UniEventType.seminar:
        return S.current.uniEventTypeSeminar;
      case UniEventType.sports:
        return S.current.uniEventTypeSports;
      case UniEventType.semester:
        return S.current.uniEventTypeSemester;
      case UniEventType.holiday:
        return S.current.uniEventTypeHoliday;
      case UniEventType.examSession:
        return S.current.uniEventTypeExamSession;
      case UniEventType.other:
        return S.current.uniEventTypeOther;
    }
    return S.current.uniEventTypeOther;
  }

  static List<UniEventType> get classTypes => [
        UniEventType.lecture,
        UniEventType.lab,
        UniEventType.seminar,
        UniEventType.sports
      ];

  static UniEventType fromString(String string) {
    switch (string) {
      case 'lab':
        return UniEventType.lab;
      case 'lecture':
        return UniEventType.lecture;
      case 'seminar':
        return UniEventType.seminar;
      case 'sports':
        return UniEventType.sports;
      case 'semester':
        return UniEventType.semester;
      case 'holiday':
        return UniEventType.holiday;
      case 'examSession':
        return UniEventType.examSession;
      default:
        return UniEventType.other;
    }
  }

  Color get color {
    switch (this) {
      case UniEventType.lecture:
        return Colors.pinkAccent;
      case UniEventType.lab:
        return Colors.blueAccent;
      case UniEventType.seminar:
        return Colors.orangeAccent;
      case UniEventType.sports:
        return Colors.greenAccent;
      case UniEventType.semester:
        return Colors.transparent;
      case UniEventType.holiday:
        return Colors.yellow;
      case UniEventType.examSession:
        return Colors.red;
      case UniEventType.other:
        return Colors.white;
    }
    return Colors.white;
  }
}

class UniEvent {
  const UniEvent({
    @required this.start,
    @required this.duration,
    @required this.id,
    this.name,
    this.location,
    this.color,
    this.type,
    this.classHeader,
    this.calendar,
    this.relevance,
    this.degree,
    this.addedBy,
    bool editable,
  }) : editable = editable ?? true;

  final String id;
  final Color color;
  final UniEventType type;
  final DateTime start;
  final Period duration;
  final String name;
  final String location;
  final ClassHeader classHeader;
  final AcademicCalendar calendar;
  final String degree;
  final List<String> relevance;
  final String addedBy;
  final bool editable;

  String get info {
    return generateInstances().first.dateString;
  }

  Iterable<UniEventInstance> generateInstances(
      {DateTimeRange intersectingInterval}) sync* {
    final DateTime end = start.add(duration.toTime().toDuration);
    if (intersectingInterval != null) {
      if (end < intersectingInterval.start || start > intersectingInterval.end)
        return;
    }

    yield UniEventInstance(
      // id: id,
      title: name,
      mainEvent: this,
      color: color,
      start: start,
      end: start.add(duration.toTime().toDuration),
      location: location,
    );
  }
}

class UniEventInstance extends Event {
  UniEventInstance({
    @required this.title,
    @required this.mainEvent,
    @required DateTime start,
    @required DateTime end,
    Color color,
    this.location,
    this.info,
  })  : color = color ?? mainEvent?.color,
        super(start: start, end: end);

  final UniEvent mainEvent;

  final String title;
  final Color color;
  final String location;
  final String info;

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

  String get dateString => getDateString(useRelativeDayFormat: false);

  String get relativeDateString => getDateString(useRelativeDayFormat: true);

  String getDateString({bool useRelativeDayFormat}) {
    final LocalDateTime defaultStart = LocalDateTime.dateTime(start);
    final LocalDateTime defaultEnd = LocalDateTime.dateTime(this.end);
    final LocalDateTime end = defaultEnd.clockTime.equals(LocalTime(00, 00, 00))
        ? defaultEnd.subtractDays(1)
        : defaultEnd;

    String string = useRelativeDayFormat &&
            defaultStart.calendarDate.equals(LocalDate.today())
        ? S.current.labelToday
        : useRelativeDayFormat &&
                defaultStart.calendarDate
                    .subtractDays(1)
                    .equals(LocalDate.today())
            ? S.current.labelTomorrow
            : defaultStart.calendarDate.toString('dddd, dd MMMM');

    if (!defaultStart.clockTime.equals(LocalTime(00, 00, 00))) {
      string += ' • ${defaultStart.clockTime.toString('HH:mm')}';
    }
    if (defaultStart.calendarDate != defaultEnd.calendarDate) {
      string += ' - ${end.calendarDate.toString('dddd, dd MMMM')}';
    }
    if (!end.clockTime.equals(LocalTime(00, 00, 00))) {
      if (defaultStart.calendarDate != defaultEnd.calendarDate) {
        string += ' • ';
      } else {
        string += '-';
      }
      string += end.clockTime.toString('HH:mm');
    }
    return string;
  }
}
