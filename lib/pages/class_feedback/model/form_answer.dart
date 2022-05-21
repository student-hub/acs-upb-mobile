class FormAnswer {
  FormAnswer({
    this.questionAnswer,
    this.questionNumber,
  });

  String questionAnswer;
  final String questionNumber;

  Map<String, dynamic> toData() {
    final Map<String, dynamic> data = {};
    if (questionAnswer != null) data['answer'] = questionAnswer;
    data['number'] = questionNumber;
    return data;
  }
}
