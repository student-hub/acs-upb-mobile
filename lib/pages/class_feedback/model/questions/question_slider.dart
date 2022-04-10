import 'question.dart';

class FeedbackQuestionSlider extends FeedbackQuestion {
  FeedbackQuestionSlider({
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
