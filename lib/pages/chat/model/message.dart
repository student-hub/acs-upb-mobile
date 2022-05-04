import 'package:meta/meta.dart';

class Message {
  Message({@required this.index,
  @required this.content,
  @required this.entity,
  @required this.isFlagged});

  String content;
  String entity;
  bool isFlagged;
  int index;

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'entity': entity,
      'isFlagged': isFlagged,
      'content': content
    };
  }
   
}
