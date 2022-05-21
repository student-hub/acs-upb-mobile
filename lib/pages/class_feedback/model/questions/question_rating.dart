import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question.dart';

class FormQuestionRating extends FormQuestion {
  FormQuestionRating({
    String question,
    String category,
    String id,
    String answer,
  }) : super(
          question: question,
          category: category,
          id: id,
          answer: answer,
        );
}
