import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timetable/timetable.dart';

enum UniEventType {
  // Classes
  lab,
  seminar,
  lecture,
  sports,
  // Evaluations
  exam,
  homework,
  project,
  test,
  practical,
  research
}

extension UniEventTypeExtension on UniEventType {
  String toLocalizedString(BuildContext context) {
    switch (this) {
      case UniEventType.lab:
        return S.of(context).uniEventTypeLab;
      case UniEventType.seminar:
        return S.of(context).uniEventTypeSeminar;
      case UniEventType.lecture:
        return S.of(context).uniEventTypeLecture;
      case UniEventType.sports:
        return S.of(context).uniEventTypeSports;
      case UniEventType.exam:
        return S.of(context).uniEventTypeExam;
      case UniEventType.homework:
        return S.of(context).uniEventTypeHomework;
      case UniEventType.project:
        return S.of(context).uniEventTypeProject;
      case UniEventType.test:
        return S.of(context).uniEventTypeTest;
      case UniEventType.practical:
        return S.of(context).uniEventTypePractical;
      case UniEventType.research:
        return S.of(context).uniEventTypeResearch;
      default:
        return '';
    }
  }
}

class UniEvent extends Event {
  final String title;
  final Color color;
  final String location;
  final UniEventType type;

  const UniEvent({
    @required String id,
    @required this.title,
    this.color,
    this.location,
    this.type,
    @required LocalDateTime start,
    @required LocalDateTime end,
  })  : assert(title != null),
        super(id: id, start: start, end: end);

  @override
  bool operator ==(dynamic other) =>
      super == other && title == other.title && color == other.color;

  @override
  int get hashCode => hashList([super.hashCode, title, color]);
}
