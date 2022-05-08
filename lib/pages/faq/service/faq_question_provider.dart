import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/faq/model/faq_question.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FaqQuestionProvider with ChangeNotifier {
  AuthProvider _authProvider;

  // ignore: use_setters_to_change_properties
  void updateAuth(AuthProvider authProvider) {
    _authProvider = authProvider;
  }

  List<String> getUserSources() =>
      _authProvider.currentUserFromCache?.sources ??
      ['official', 'organizations', 'students'];

  Query filterBySource(Query query) =>
      query.where('source', whereIn: getUserSources());

  Future<List<FaqQuestion>> fetchFaqQuestions({int limit}) async {
    try {
      final CollectionReference faqs =
          FirebaseFirestore.instance.collection('faq');
      final QuerySnapshot qSnapshot = limit == null
          ? await filterBySource(faqs).get()
          : await filterBySource(faqs.limit(limit)).get();
      return qSnapshot.docs.map(DatabaseQuestion.fromSnap).toList();
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
      return null;
    }
  }
}

extension DatabaseQuestion on FaqQuestion {
  static FaqQuestion fromSnap(DocumentSnapshot snap) {
    final data = snap.data();

    final String question = data['question'];
    final String answer = data['answer'];
    final List<String> tags = List.from(data['tags']);

    final String source = data['source'];
    return FaqQuestion(
        source: source, question: question, answer: answer, tags: tags);
  }
}
