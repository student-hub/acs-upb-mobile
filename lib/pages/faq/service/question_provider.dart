import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../../generated/l10n.dart';
import '../../../widgets/toast.dart';
import '../model/question.dart';

class QuestionProvider with ChangeNotifier {
  Future<List<Question>> fetchQuestions({int limit}) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> qSnapshot = limit == null
          ? await FirebaseFirestore.instance.collection('faq').get()
          : await FirebaseFirestore.instance
              .collection('faq')
              .limit(limit)
              .get();
      return qSnapshot.docs.map(DatabaseQuestion.fromSnap).toList();
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
      return null;
    }
  }
}

extension DatabaseQuestion on Question {
  static Question fromSnap(DocumentSnapshot<Map<String, dynamic>> snap) {
    final data = snap.data();

    final String question = data['question'];
    final String answer = data['answer'];
    final List<String> tags = List.from(data['tags']);

    return Question(question: question, answer: answer, tags: tags);
  }
}
