import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/faq/model/question.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

class QuestionProvider with ChangeNotifier {
  Future<List<Question>> fetchQuestions(
      {int limit, BuildContext context}) async {
    final User user =
        Provider.of<AuthProvider>(context, listen: false).currentUserFromCache;
    try {
      final CollectionReference faqs =
          FirebaseFirestore.instance.collection('faq');
      final List<String> userSources = user?.sources ?? ['official'];
      print(userSources);
      final QuerySnapshot qSnapshot = limit == null
          ? await faqs.where('source', whereIn: userSources).get()
          : await faqs.where('source', whereIn: userSources).limit(limit).get();
      return qSnapshot.docs.map(DatabaseQuestion.fromSnap).toList();
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
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

    final String source = data['source'];
    return Question(
        source: source, question: question, answer: answer, tags: tags);
  }
}
