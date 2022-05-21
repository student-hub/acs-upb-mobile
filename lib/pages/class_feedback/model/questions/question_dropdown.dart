import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question.dart';

class FormQuestionDropdown extends FormQuestion {
  FormQuestionDropdown({
    String question,
    String category,
    String id,
    List<String> answerOptions,
    String answer,
  })  : options = answerOptions,
        super(
          question: question,
          category: category,
          id: id,
          answer: answer,
        );

  List<String> options;
}
