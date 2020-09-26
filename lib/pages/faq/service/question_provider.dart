import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/faq/model/question.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class QuestionsProvider {
  Future<QuerySnapshot> getDocuments(BuildContext context) {
    try {
      return Firestore().collection('faq').getDocuments();
    } catch (e) {
      print(e);
      if (context != null) {
        AppToast.show(S.of(context).errorSomethingWentWrong);
      }
      return null;
    }
  }

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
    List<String> tags = List.from(snap.data['tags']);
    return Question(question: question, answer: answer, tags: tags);
  }
}
