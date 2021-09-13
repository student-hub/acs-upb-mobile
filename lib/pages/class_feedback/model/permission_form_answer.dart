import 'package:acs_upb_mobile/pages/class_feedback/model/form_answer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PermissionAnswer extends FormAnswer {
  PermissionAnswer({
    String questionAnswer,
    final String questionNumber,
    this.userId,
  }) : super(questionAnswer: questionAnswer, questionNumber: questionNumber);

  final String userId;

  @override
  Map<String, dynamic> toData() {
    final Map<String, dynamic> data = {};

    if (userId != null) data['addedBy'] = userId;
    if (questionAnswer != null) data['answer'] = questionAnswer;
    data['dateSubmitted'] = Timestamp.now();
    data['done'] = false;
    data['accepted'] = false;

    return data;
  }
}
