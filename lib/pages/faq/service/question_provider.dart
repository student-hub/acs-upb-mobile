import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/faq/model/question.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class QuestionProvider with ChangeNotifier {
  Future<List<Question>> fetchQuestions(
      {BuildContext context, int limit}) async {
    try {
      final QuerySnapshot qSnapshot = limit == null
          ? await FirebaseFirestore.instance.collection('faq').get()
          : await FirebaseFirestore.instance
              .collection('faq')
              .limit(limit)
              .get();
      return qSnapshot.docs.map(DatabaseQuestion.fromSnap).toList();
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
    final data = snap.data();

    final String question = data['question'];
    final String answer = data['answer'];
    final List<String> tags = List.from(data['tags']);

    return Question(question: question, answer: answer, tags: tags);
  }
}
