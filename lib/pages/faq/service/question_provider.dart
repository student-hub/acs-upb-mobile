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
      {BuildContext context, int limit}) async {
    final User user =
        Provider.of<AuthProvider>(context, listen: false).currentUserFromCache;
     if (user.uid == 'VZpTKGCbzVWyfJEGRx0x8WFz9vf2')
       await migrateQuestions(context).catchError((e) => debugPrint(e));
    try {
      QuerySnapshot qSnapshot;
      if (user != null) {
        qSnapshot = limit == null
            ? await FirebaseFirestore.instance
                .collection('faq')
                .where('source', whereIn: user.sources)
                .get()
            : await FirebaseFirestore.instance
                .collection('faq')
                .limit(limit)
                .where('source', whereIn: user.sources)
                .get();
      } else {
        qSnapshot = limit == null
            ? await FirebaseFirestore.instance.collection('faq').get()
            : await FirebaseFirestore.instance
                .collection('faq')
                .limit(limit)
                .get();
      }
      return qSnapshot.docs.map(DatabaseQuestion.fromSnap).toList();
    } catch (e) {
      print(e);
      if (context != null) {
        AppToast.show(S.of(context).errorSomethingWentWrong);
      }
      return null;
    }
  }

  Future<void> migrateQuestions(BuildContext context) async {
    final _db =   FirebaseFirestore.instance
        .collection('faq');
    final QuerySnapshot qSnapshot = await _db.get();
    final List<DocumentSnapshot> documents = qSnapshot.docs;

    for (DocumentSnapshot document in documents){
     String id = document.id;
      Map<String,dynamic> data = document.data();
      data['source'] = 'organizations';
      final DocumentReference publicRef =
      _db.doc(id);
      await publicRef.update(data);
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
