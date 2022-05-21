import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question.dart';

class FormQuestionText extends FormQuestion {
  FormQuestionText({
    String question,
    String category,
    String id,
    String answer,
    this.additionalInfo,
  }) : super(
          question: question,
          category: category,
          id: id,
          answer: answer,
        );

  final String additionalInfo;
}
