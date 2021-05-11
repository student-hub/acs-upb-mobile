class FeedbackQuestion {
  const FeedbackQuestion({
    this.question,
    this.category,
    this.type,
    this.id,
  });

  final String question;
  final String category;
  final String type;
  final String id;

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
