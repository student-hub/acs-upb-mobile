import 'package:flutter/material.dart';
import 'package:rrule/rrule.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timetable/timetable.dart';

class UniEvent {
  final String id;
  final Color color;
  final Map<String, String> localizedType;
  final RecurrenceRule rrule;
  final LocalDateTime start;
  final Period duration;
  final String name;
  final String location;

  const UniEvent({
    this.name,
    this.location,
    this.rrule,
    @required this.start,
    @required this.duration,
    @required this.id,
    this.color,
    this.localizedType,
  });

  List<UniEventInstance> generateInstances() {
    if (rrule == null) {
      return [
        UniEventInstance(
          id: id,
          title: name,
          mainEvent: this,
          color: this.color,
          start: start,
          end: start.add(duration),
          location: location,
        )
      ];
    } else {
      var instances = rrule.getInstances(start: start);
      return instances
          .map((start) => UniEventInstance(
                id: id,
                title: name,
                mainEvent: this,
                color: this.color,
                start: start,
                end: start.add(duration),
                location: location,
              ))
          .toList();
    }
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
