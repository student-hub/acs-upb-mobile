import 'package:acs_upb_mobile/pages/class_feedback/model/class_feedback_answer.dart';
import 'package:acs_upb_mobile/resources/locale_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';

extension ClassFeedbackQuestionAnswerExtension on ClassFeedbackQuestionAnswer {
  Map<String, dynamic> toData() {
    final Map<String, dynamic> data = {};

    if (questionTextAnswer != null) data['answer'] = questionTextAnswer;
    if (questionNumericAnswer != null) data['rating'] = questionNumericAnswer;
    data['dateSubmitted'] = Timestamp.now();
    data['class'] = className;
    data['teacher'] = teacherName;
    data['assistant'] = assistant.name;

    return data;
  }
}

class FeedbackProvider with ChangeNotifier {
  Future<bool> addResponse(ClassFeedbackQuestionAnswer response) async {
    try {
      await FirebaseFirestore.instance
          .collection('forms')
          .doc('class_feedback_answers')
          .collection(response.questionNumber)
          .add(response.toData());
      return true;
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
      return false;
    }
  }

  Future<Map<String, dynamic>> fetchQuestions() async {
    try {
      final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('forms')
          .doc('class_feedback_questions')
          .get();
      final Map<String, dynamic> data = documentSnapshot['questions'];
      return data;
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
      return null;
    }
  }

  List<String> getQuestionsByCategoryAndType(
      List<dynamic> questions, String category, String type) {
    final List<String> filteredQuestions = [];
    final List<dynamic> filterQuestions = questions
        .where((element) =>
            element is Map<dynamic, dynamic> &&
            element['category'] == category &&
            element['type'] == type)
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
