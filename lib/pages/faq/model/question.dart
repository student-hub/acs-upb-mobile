import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class Question {
  String question;
  String answer;
  String category;

  DocumentReference reference;

  Question(
      {@required this.question,
      @required this.answer,
      @required this.category});

  Question.fromMap(Map<String, dynamic> map, {this.reference})
      : question = map['question'],
        answer = map['answer'],
        category = map['category'];

  Question.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
