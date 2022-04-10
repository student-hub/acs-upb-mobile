import 'question.dart';

class FeedbackQuestionText extends FeedbackQuestion {
  FeedbackQuestionText({
    final String question,
    final String category,
    final String id,
    final String answer,
  }) : super(
          question: question,
          category: category,
          id: id,
          answer: answer,
        );
}
