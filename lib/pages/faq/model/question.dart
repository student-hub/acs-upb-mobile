import 'package:meta/meta.dart';

class Question {
  Question(
      {@required this.question, @required this.answer, @required this.tags});

  String question;
  String answer;
  List<String> tags;
}
