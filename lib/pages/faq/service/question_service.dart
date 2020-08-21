import 'package:acs_upb_mobile/pages/faq/model/question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionsService {
  Future<QuerySnapshot> getDocuments() =>
      Firestore().collection('faq').getDocuments();

  List<Question> getQuestions(QuerySnapshot snapshot) {
    return snapshot.documents
        .map((documentSnapshot) => Question.fromSnapshot(documentSnapshot))
        .toList();
  }
}
