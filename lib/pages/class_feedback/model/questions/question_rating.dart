import 'question.dart';

class FeedbackQuestionRating extends FeedbackQuestion {
  FeedbackQuestionRating({
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
