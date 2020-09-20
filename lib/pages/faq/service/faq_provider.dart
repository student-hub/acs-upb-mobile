import 'package:acs_upb_mobile/pages/faq/model/question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionsService {
  Future<QuerySnapshot> getDocuments() =>
      Firestore().collection('faq').getDocuments();

  List<Question> getQuestions(QuerySnapshot snapshot) {
    return snapshot.documents
        .map((documentSnapshot) => DatabaseQustion.fromSnap(documentSnapshot))
        .toList();
  }
}

extension DatabaseQustion on Question {
  static Question fromSnap(DocumentSnapshot snap) {
    String question = snap.data['question'];
    String answer = snap.data['answer'];
    String category = snap.data['category'];
    return Question(question: question, answer: answer, category: category);
  }
}
