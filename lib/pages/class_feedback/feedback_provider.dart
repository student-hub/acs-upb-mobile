import 'package:acs_upb_mobile/resources/locale_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';

class FeedbackProvider with ChangeNotifier {
  Future<List<dynamic>> fetchQuestions() async {
    try {
      final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('forms')
          .doc('class_feedback_questions')
          .get();
      final Map<String, dynamic> data = documentSnapshot['questions'];
      final List<dynamic> values = data.values.toList();
      return values;
    } catch (e) {
      print(e);
        AppToast.show(S.current.errorSomethingWentWrong);
      return null;
    }
  }

  List<String> getQuestionsByCategory(
      List<dynamic> questions, String category) {
    final List<String> filteredQuestions = [];
    final List<dynamic> filterQuestions = questions
        .where((element) =>
            element is Map<dynamic, dynamic> && element['category'] == category)
        .toList();
    for (final Map<String, dynamic> element in filterQuestions) {
      final List<dynamic> qs = element.values.toList();
      filteredQuestions.add(
          qs[qs.indexWhere((element) => element is Map<dynamic, dynamic>)]
              [LocaleProvider.localeString]);
    }
    return filteredQuestions;
  }
}
