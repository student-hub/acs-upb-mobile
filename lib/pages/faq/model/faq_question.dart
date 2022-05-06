import 'package:meta/meta.dart';

class FaqQuestion {
  FaqQuestion({
    @required this.question,
    @required this.answer,
    @required this.tags,
    this.source,
  });

  String question;
  String answer;
  List<String> tags;
  String source;
}
