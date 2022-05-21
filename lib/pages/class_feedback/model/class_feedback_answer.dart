import 'package:acs_upb_mobile/pages/class_feedback/model/form_answer.dart';
import 'package:acs_upb_mobile/pages/people/model/person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackAnswer extends FormAnswer {
  FeedbackAnswer({
    String questionAnswer,
    final String questionNumber,
    this.className,
    this.teacher,
    this.assistant,
  }) : super(questionAnswer: questionAnswer, questionNumber: questionNumber);

  final String className;
  final Person teacher;
  final Person assistant;

  @override
  Map<String, dynamic> toData() {
    final Map<String, dynamic> data = {};

    if (questionAnswer != null) data['answer'] = questionAnswer;
    data['dateSubmitted'] = Timestamp.now();
    data['class'] = className;
    data['teacher'] = teacher.name;
    data['assistant'] = assistant.name;

    return data;
  }
}
