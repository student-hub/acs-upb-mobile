import 'package:acs_upb_mobile/pages/class_feedback/model/class_feedback_answer.dart';
import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question.dart';
import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question_dropdown.dart';
import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question_slider.dart';
import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question_rating.dart';
import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question_text.dart';
import 'package:acs_upb_mobile/pages/people/model/person.dart';
import 'package:acs_upb_mobile/resources/locale_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';

extension ClassFeedbackAnswerExtension on FeedbackAnswer {
  Map<String, dynamic> toData() {
    final Map<String, dynamic> data = {};

    if (questionAnswer != null) data['answer'] = questionAnswer;
    data['dateSubmitted'] = Timestamp.now();
    data['class'] = className;
    data['teacher'] = teacher.name;
    data['assistant'] = assistant.name;

    return data;
  }
}

extension FeedbackQuestionExtension on FeedbackQuestion {
  static FeedbackQuestion fromJSON(dynamic json, String id) {
    if (json['type'] == 'dropdown' && json['options'] != null) {
      final List<dynamic> options = json['options'];
      final List<String> optionsString =
          options.map((e) => e[LocaleProvider.localeString] as String).toList();
      return FeedbackQuestionDropdown(
        category: json['category'],
        question: json['question'][LocaleProvider.localeString],
        id: id,
        answerOptions: optionsString,
      );
    } else if (json['type'] == 'rating') {
      return FeedbackQuestionRating(
        category: json['category'],
        question: json['question'][LocaleProvider.localeString],
        id: id,
      );
    } else if (json['type'] == 'text') {
      return FeedbackQuestionText(
        category: json['category'],
        question: json['question'][LocaleProvider.localeString],
        id: id,
      );
    } else if (json['type'] == 'slider') {
      return FeedbackQuestionSlider(
        category: json['category'],
        question: json['question'][LocaleProvider.localeString],
        id: id,
      );
    } else {
      return FeedbackQuestion(
        category: json['category'],
        question: json['question'][LocaleProvider.localeString],
        id: id,
      );
    }
  }
}

class FeedbackProvider with ChangeNotifier {
  Future<bool> addResponse(FeedbackAnswer response) async {
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

  Future<Map<String, FeedbackQuestion>> fetchQuestions() async {
    try {
      final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('forms')
          .doc('class_feedback_questions')
          .get();
      final Map<String, dynamic> data = documentSnapshot['questions'];
      final Map<String, FeedbackQuestion> questions = {};
      for (final value in data.values) {
        final key = data.keys.firstWhere((element) => data[element] == value);
        questions[key] = FeedbackQuestionExtension.fromJSON(value, key);
      }
      return questions;
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
      return null;
    }
  }

  // Fetch all feedback categories in the format
  // Map<categoryKey, Map<categoryNameEN, categoryNameRO>>
  Future<Map<String, Map<String, String>>> fetchCategories() async {
    try {
      final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('forms')
          .doc('class_feedback_questions')
          .get();
      final Map<String, dynamic> data = documentSnapshot['categories'];
      for (final key in data.keys) {
        data[key] = (data[key] as Map<dynamic, dynamic>)
            .map((key, value) => MapEntry(key?.toString(), value?.toString()));
      }
      return Map<String, Map<String, String>>.from(data);
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
      return null;
    }
  }

  Future<bool> setUserSubmittedFeedbackForClass(
      String uid, String className) async {
    try {
      final DocumentReference ref =
          FirebaseFirestore.instance.collection('users').doc(uid);
      await ref.set({
        'classesFeedback': {className: true}
      }, SetOptions(merge: true));
      notifyListeners();
      return true;
    } catch (e) {
      AppToast.show(S.current.errorSomethingWentWrong);
      return false;
    }
  }

  Future<bool> submitFeedback(
      String uid,
      Map<String, FeedbackQuestion> feedbackQuestions,
      Person assistant,
      Person teacher,
      String className) async {
    try {
      bool responseAddedSuccessfully, userSubmittedFeedbackSuccessfully;
      for (var i = 0; i < feedbackQuestions.length; i++) {
        responseAddedSuccessfully = false;

        final response = FeedbackAnswer(
          assistant: assistant,
          teacher: teacher,
          className: className,
          questionNumber: i.toString(),
          questionAnswer: feedbackQuestions[i.toString()].answer,
        );

        responseAddedSuccessfully = await addResponse(response);
        if (!responseAddedSuccessfully) break;
      }

      userSubmittedFeedbackSuccessfully =
          await setUserSubmittedFeedbackForClass(uid, className);
      if (responseAddedSuccessfully && userSubmittedFeedbackSuccessfully) {
        return true;
      }
      return false;
    } catch (e) {
      AppToast.show(S.current.errorSomethingWentWrong);
      return false;
    }
  }

  Future<bool> userSubmittedFeedbackForClass(
      String uid, String className) async {
    try {
      final DocumentSnapshot snap =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (snap.data()['classesFeedback'] != null &&
          snap.data()['classesFeedback'][className] == true) {
        return true;
      }
      return false;
    } catch (e) {
      AppToast.show(S.current.errorSomethingWentWrong);
      return false;
    }
  }
}
