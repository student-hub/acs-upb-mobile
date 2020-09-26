import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/faq/model/question.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class QuestionProvider with ChangeNotifier {
  Future<List<Question>> fetchQuestions(
      {BuildContext context, int limit}) async {
    try {
      QuerySnapshot qSnapshot = limit == null
          ? await Firestore.instance.collection("faq").getDocuments()
          : await Firestore.instance
              .collection("faq")
              .limit(limit)
              .getDocuments();
      return qSnapshot.documents
          .map(
              (documentSnapshot) => DatabaseQuestion.fromSnap(documentSnapshot))
          .toList();
    } catch (e) {
      print(e);
      if (context != null) {
        AppToast.show(S.of(context).errorSomethingWentWrong);
      }
      return null;
    }
  }
}

extension DatabaseQuestion on Question {
  static Question fromSnap(DocumentSnapshot snap) {
    String question = snap.data['question'];
    String answer = snap.data['answer'];
    List<String> tags = List.from(snap.data['tags']);
    return Question(question: question, answer: answer, tags: tags);
  }
}
