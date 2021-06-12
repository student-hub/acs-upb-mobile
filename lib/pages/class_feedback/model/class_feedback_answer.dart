import 'package:acs_upb_mobile/pages/people/model/person.dart';

class FeedbackAnswer {
  FeedbackAnswer({
    this.questionAnswer,
    this.className,
    this.teacher,
    this.assistant,
    this.questionNumber,
  });

  String questionAnswer;
  final String className;
  final Person teacher;
  final Person assistant;
  final String questionNumber;
}
