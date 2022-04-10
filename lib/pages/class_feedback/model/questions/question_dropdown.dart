import 'question.dart';

class FeedbackQuestionDropdown extends FeedbackQuestion {
  FeedbackQuestionDropdown({
    final String question,
    final String category,
    final String id,
    final List<String> answerOptions,
    final String answer,
  })  : options = answerOptions,
        super(
          question: question,
          category: category,
          id: id,
          answer: answer,
        );

  List<String> options;
}
