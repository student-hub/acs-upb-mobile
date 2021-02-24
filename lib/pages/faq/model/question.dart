import 'package:meta/meta.dart';

class Question {
  Question({this.source,
      @required this.question, @required this.answer, @required this.tags});

  String question;
  String answer;
  List<String> tags;
  String source;
}
