import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/class_feedback/model/class_feedback_answer.dart';
import 'package:acs_upb_mobile/pages/class_feedback/model/form_answer.dart';
import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question.dart';
import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question_dropdown.dart';
import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question_rating.dart';
import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question_slider.dart';
import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question_text.dart';
import 'package:acs_upb_mobile/pages/classes/model/class.dart';
import 'package:acs_upb_mobile/pages/people/model/person.dart';
import 'package:acs_upb_mobile/pages/settings/model/request.dart';
import 'package:acs_upb_mobile/resources/locale_provider.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

extension FeedbackQuestionExtension on FormQuestion {
  static FormQuestion fromJSON(dynamic json, String id) {
    if (json['type'] == 'dropdown' && json['options'] != null) {
      final List<dynamic> options = json['options'];
      final List<String> optionsString =
          options.map((e) => e[LocaleProvider.localeString] as String).toList();
      return FormQuestionDropdown(
        category: json['category'],
        question: json['question'][LocaleProvider.localeString],
        id: id,
        answerOptions: optionsString,
      );
    } else if (json['type'] == 'rating') {
      return FormQuestionRating(
        category: json['category'],
        question: json['question'][LocaleProvider.localeString],
        id: id,
      );
    } else if (json['type'] == 'text' && json['additional_info'] != null) {
      return FormQuestionText(
        category: json['category'],
        question: json['question'][LocaleProvider.localeString],
        additionalInfo: json['additional_info'][LocaleProvider.localeString],
        id: id,
      );
    } else if (json['type'] == 'text') {
      return FormQuestionText(
        category: json['category'],
        question: json['question'][LocaleProvider.localeString],
        id: id,
      );
    } else if (json['type'] == 'slider') {
      return FormQuestionSlider(
        category: json['category'],
        question: json['question'][LocaleProvider.localeString],
        id: id,
      );
    } else {
      return FormQuestion(
        category: json['category'],
        question: json['question'][LocaleProvider.localeString],
        id: id,
      );
    }
  }
}

class FeedbackProvider with ChangeNotifier {
  Future<bool> _addResponseByQuestion(
      FormAnswer response, String document) async {
    try {
      await FirebaseFirestore.instance
          .collection('forms')
          .doc(document)
          .collection(response.questionNumber)
          .add(response.toData());
      return true;
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
      return false;
    }
  }

  Future<Map<String, FormQuestion>> fetchQuestions(String document) async {
    try {
      final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('forms')
          .doc(document)
          .get();
      final Map<String, dynamic> data = documentSnapshot['questions'];
      final Map<String, FormQuestion> questions = {};
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
  // Map<categoryKey, Map<language, localizedCategoryName>>
  Future<Map<String, Map<String, String>>> fetchCategories(
      String document) async {
    try {
      final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('forms')
          .doc(document)
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

  Future<bool> _setUserSubmittedFeedbackForClass(
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
      Map<String, FormQuestion> feedbackQuestions,
      Person assistant,
      Person teacher,
      String className) async {
    try {
      bool responseAddedSuccessfully, userSubmittedFeedbackSuccessfully;
      for (var i = 0; i < feedbackQuestions.length; i++) {
        if (feedbackQuestions[i.toString()] == null) {
          print('Question ${i.toString()} does not exist, skipping...');
          continue;
        }
        if ([null, '-1', ''].contains(feedbackQuestions[i.toString()].answer)) {
          continue;
        }
        responseAddedSuccessfully = false;

        final response = FeedbackAnswer(
          assistant: assistant,
          teacher: teacher,
          className: className,
          questionNumber: i.toString(),
          questionAnswer: feedbackQuestions[i.toString()].answer,
        );

        responseAddedSuccessfully =
            await _addResponseByQuestion(response, 'class_feedback_answers');
        if (!responseAddedSuccessfully) break;
      }

      userSubmittedFeedbackSuccessfully =
          await _setUserSubmittedFeedbackForClass(uid, className);
      if ((responseAddedSuccessfully ??
              true && userSubmittedFeedbackSuccessfully ??
              true) ||
          (responseAddedSuccessfully && userSubmittedFeedbackSuccessfully)) {
        notifyListeners();
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

  Future<Map<String, bool>> getClassesWithCompletedFeedback(String uid) async {
    try {
      final DocumentSnapshot snap =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (snap.data()['classesFeedback'] != null) {
        return Map<String, bool>.from(snap.data()['classesFeedback']);
      }
      return null;
    } catch (e) {
      AppToast.show(S.current.errorSomethingWentWrong);
      return null;
    }
  }

  Future<String> countClassesWithoutFeedback(
      String uid, Set<ClassHeader> userClasses) async {
    try {
      final Map<String, bool> classesFeedbackCompleted =
          await getClassesWithCompletedFeedback(uid);
      String feedbackFormsLeft;

      if (userClasses != null && classesFeedbackCompleted != null) {
        feedbackFormsLeft = userClasses
            .where(
                (element) => !classesFeedbackCompleted.containsKey(element.id))
            .toSet()
            .length
            .toString();
      } else if (userClasses != null && classesFeedbackCompleted == null) {
        feedbackFormsLeft = userClasses.length.toString();
      }

      return feedbackFormsLeft;
    } catch (e) {
      AppToast.show(S.current.errorSomethingWentWrong);
      return null;
    }
  }

  bool userAlreadyRequestedCache;

  Future<bool> submitRequest(PermissionRequest request) async {
    for (int i = 0; i < request.answers.length; ++i) {
      assert(request.answers[i.toString()].answer != null);
    }

    try {
      DocumentReference ref;
      ref = FirebaseFirestore.instance
          .collection('forms')
          .doc('permission_request_answers');

      final data = request.toData();
      await ref.set({request.userId: data}, SetOptions(merge: true));

      return userAlreadyRequestedCache = true;
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
      return userAlreadyRequestedCache = false;
    }
  }

  Future<bool> userAlreadyRequested(final String userId) async {
    if (userAlreadyRequestedCache != null) return userAlreadyRequestedCache;

    try {
      final DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('forms')
          .doc('permission_request_answers')
          .get();
      if (snap.data().containsKey(userId)) {
        return userAlreadyRequestedCache = true;
      }
      return userAlreadyRequestedCache = false;
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
      return userAlreadyRequestedCache = false;
    }
  }
}
