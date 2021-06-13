import 'package:flutter/cupertino.dart';

class Goal {
  Goal({
    @required this.taskId,
    this.targetGrade,
  });
  final String taskId;
  final double targetGrade;
}
