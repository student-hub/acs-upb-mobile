import 'question.dart';

class FeedbackQuestionText extends FeedbackQuestion {
  FeedbackQuestionText({
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
