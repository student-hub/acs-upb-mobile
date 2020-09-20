import 'package:meta/meta.dart';

class Question {
  String question;
  String answer;
  List<String> tags;

  Question(
      {@required this.question,
      @required this.answer,
      @required this.tags});
}
