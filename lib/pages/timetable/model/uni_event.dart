import 'package:flutter/material.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timetable/timetable.dart';

class UniEvent extends Event {
  final String title;
  final Color color;
  final String location;
  final String type;

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