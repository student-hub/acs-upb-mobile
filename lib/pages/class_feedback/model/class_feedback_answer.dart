import 'package:acs_upb_mobile/pages/people/model/person.dart';

class ClassFeedbackQuestionAnswer {
  ClassFeedbackQuestionAnswer({
    this.questionTextAnswer,
    this.questionNumericAnswer,
    this.teacher,
    this.assistant,
    this.questionNumber,
  });

  final String questionTextAnswer;
  final int questionNumericAnswer;
  final Person teacher;
  final Person assistant;
  final String questionNumber;
}
