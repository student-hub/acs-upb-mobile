class FeedbackQuestion {
  FeedbackQuestion({
    this.question,
    this.category,
    this.id,
    this.answer,
  });

  final String question;
  final String category;
  final String id;
  String answer;

  @override
  int get hashCode => question.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is FeedbackQuestion) {
      return other.question == question;
    }
    return false;
  }
}
