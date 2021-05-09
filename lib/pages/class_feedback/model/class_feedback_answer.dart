import 'package:acs_upb_mobile/pages/people/model/person.dart';

class ClassFeedbackAnswer {
  ClassFeedbackAnswer({
    this.questionTextAnswer,
    this.questionNumericAnswer,
    this.className,
    this.teacherName,
    this.assistant,
    this.questionNumber,
  });

  final String questionTextAnswer;
  final String questionNumericAnswer;
  final String className;
  final String teacherName;
  final Person assistant;
  final String questionNumber;
}
