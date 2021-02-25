import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/faq/model/question.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

class QuestionProvider with ChangeNotifier {
  Future<List<Question>> fetchQuestions(
      {BuildContext context, int limit}) async {
    final User user = Provider.of<AuthProvider>(context, listen: false).currentUserFromCache;
    try {
      final QuerySnapshot qSnapshot = limit == null
          ? await Firestore.instance.collection('faq').where('source',whereIn: user.sources).getDocuments()
          : await Firestore.instance
              .collection('faq')
              .limit(limit)
              .where('source',whereIn: user.sources)
              .getDocuments();
      return qSnapshot.documents.map(DatabaseQuestion.fromSnap).toList();
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
    final String question = snap.data['question'];
    final String answer = snap.data['answer'];
    final List<String> tags = List.from(snap.data['tags']);
    final String source = snap.data['source'];
    return Question(source: source, question: question, answer: answer, tags: tags);
  }
}
