import 'question.dart';

class FeedbackQuestionDropdown extends FeedbackQuestion {
  FeedbackQuestionDropdown({
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
