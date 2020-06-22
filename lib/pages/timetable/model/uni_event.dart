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

class UniEvent {
  // TODO: This is just a draft. Need to add at least:
  // - default durations
  // - default start/end dates (beginning/end of semester)
  // - repeatable events
  // - classes, teachers, grades, reminders
  static Map<UniEventType, List<String>> propertiesByType = {
    UniEventType.lab: ['start', 'end', 'location'],
    UniEventType.seminar: ['start', 'end', 'location'],
    UniEventType.lecture: ['start', 'end', 'location'],
    UniEventType.sports: ['start', 'end', 'location'],
    UniEventType.exam: ['start', 'end', 'location', 'description'],
    UniEventType.homework: ['soft', 'hard', 'link', 'description', 'name'],
    UniEventType.project: ['tasks', 'link', 'name'],
    UniEventType.test: ['start', 'end', 'location', 'name'],
  };

  final Map<String, dynamic> properties;

  final String id;
  final Color color;
  final UniEventType type;

  const UniEvent({
    @required this.id,
    this.color,
    this.type,
    @required this.properties,
  });

  List<UniEventInstance> generateInstances() {
    switch (type) {
      case UniEventType.lab:
        // TODO: Handle this case.
        break;
      case UniEventType.seminar:
        // TODO: Handle this case.
        break;
      case UniEventType.lecture:
        // TODO: Handle this case.
        break;
      case UniEventType.sports:
        // TODO: Handle this case.
        break;
      case UniEventType.exam:
        // TODO: Handle this case.
        break;
      case UniEventType.homework:
        LocalDateTime softDeadline = properties['soft'];
        LocalDateTime hardDeadline = properties['hard'];
        return [
          UniEventInstance(
            id: id + '-soft',
            title: properties['name'],
            mainEvent: this,
            color: this.color,
            info: 'soft',
            start: softDeadline,
            end: softDeadline.add(Period(minutes: 10)),
          ),
          UniEventInstance(
            id: id + '-hard',
            title: properties['name'],
            mainEvent: this,
            color: this.color,
            info: 'hard',
            start: hardDeadline,
            end: hardDeadline.add(Period(minutes: 10)),
          )
        ];
        break;
      case UniEventType.project:
        // TODO: Handle this case.
        break;
      case UniEventType.test:
        return [
          UniEventInstance(
            id: id,
            title: properties['name'],
            mainEvent: this,
            color: this.color,
            start: properties['start'],
            end: properties['end'],
            location: properties['location'],
          )
        ];
        break;
      case UniEventType.practical:
        // TODO: Handle this case.
        break;
      case UniEventType.research:
        // TODO: Handle this case.
        break;
    }

    return [
      UniEventInstance(
        id: id,
        title: properties['name'],
        mainEvent: this,
        color: this.color,
        start: properties['start'],
        end: properties['end'],
        location: properties['location'],
      )
    ];
  }
}

class UniEventInstance extends Event {
  final UniEvent mainEvent;
  final String title;

  // The event instance can have a different color or location than the main
  // event, but it cannot have a different type.
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
      : this.color = color ?? mainEvent.color,
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
