import 'package:flutter/cupertino.dart';

class Assignment {
  Assignment({this.name, this.deadline});
  //final String id;
  final String name;
  final String deadline;

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is Assignment) {
      return other.name == name;
    }
    return false;
  }
}
