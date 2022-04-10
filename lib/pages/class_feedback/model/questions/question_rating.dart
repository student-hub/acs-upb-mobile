import 'question.dart';

class FeedbackQuestionRating extends FeedbackQuestion {
  FeedbackQuestionRating({
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
