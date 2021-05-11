import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question.dart';

class FeedbackQuestionDropdown extends FeedbackQuestion {
  FeedbackQuestionDropdown({
    String question,
    String category,
    String type,
    String id,
    List<String> answerOptions,
  })  : options = answerOptions,
        super(question: question, category: category, type: type, id: id);

  List<String> options;
}
