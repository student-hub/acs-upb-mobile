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
import 'package:acs_upb_mobile/pages/classes/model/class.dart';

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
  Future<bool> _addResponse(FeedbackAnswer response) async {
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
  // Map<categoryKey, Map<language, localizedCategoryName>>
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
      Map<String, FeedbackQuestion> feedbackQuestions,
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

        responseAddedSuccessfully = await _addResponse(response);
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
          snap.data()['classesFeedback'][className]) {
        return true;
      }
      return false;
    } catch (e) {
      AppToast.show(S.current.errorSomethingWentWrong);
      return false;
    }
  }

  Future<int> getNumberOfResponses(String className) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('forms')
          .doc('class_feedback_answers')
          .collection('0')
          .where('class', isEqualTo: className)
          .get();
      final numberOfResponses = querySnapshot.docs.length;
      return numberOfResponses;
    } catch (e) {
      AppToast.show(S.current.errorSomethingWentWrong);
      return null;
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

  Future<Map<int, List<int>>> getGradeAndHoursCorrelation(
      String className) async {
    try {
      // extract grade from question 1
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('forms')
          .doc('class_feedback_answers')
          .collection('1')
          .where('class', isEqualTo: className)
          .get();

      // extract hours from question 15
      final QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
          .collection('forms')
          .doc('class_feedback_answers')
          .collection('15')
          .where('class', isEqualTo: className)
          .get();

      final gradesDocs = querySnapshot.docs
          .where((element) => element['answer'] != null)
          .toList();
      // list of grades (as int) achieved for a class
      final grades = gradesDocs
          .map((e) => double.parse(e.data()['answer']).toInt())
          .toList();

      final hoursDocs = querySnapshot2.docs
          .where((element) => element['answer'] != null)
          .toList();
      // list of hours (as int) spent for a class
      final hours = hoursDocs
          .map((e) => double.parse(e.data()['answer']).toInt())
          .toList();

      print('Grades: $grades');
      print('Hours: $hours');

      Map<int, List<int>> correlation = {};
      int idx = 0;
      for (final elem in grades) {
        if (correlation[elem] == null) correlation[elem] = [];
        correlation[elem].add(hours[idx]);
        idx += 1;
      }
      print(correlation);
      return correlation;
    } catch (e) {
      AppToast.show(S.current.errorSomethingWentWrong);
      return null;
    }
  }

  Future<Map<int, int>> getLectureRatingOverview(String className) async {
    try {
      // extract rating from question 7
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('forms')
          .doc('class_feedback_answers')
          .collection('7')
          .where('class', isEqualTo: className)
          .get();

      // extract rating from question 8
      final QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
          .collection('forms')
          .doc('class_feedback_answers')
          .collection('8')
          .where('class', isEqualTo: className)
          .get();

      final rating7Docs = querySnapshot.docs
          .where((element) =>
              element['answer'] != null && element['answer'] != '-1')
          .toList();

      final rating7 = rating7Docs
          .map((e) => double.parse(e.data()['answer']).toInt())
          .toList();

      final rating8Docs = querySnapshot2.docs
          .where((element) =>
              element['answer'] != null && element['answer'] != '-1')
          .toList();

      final rating8 = rating8Docs
          .map((e) => double.parse(e.data()['answer']).toInt())
          .toList();

      print(rating7);
      print(rating8);

      Map<int, int> occurences = {};

      rating7.forEach((element) => occurences[element] =
          !occurences.containsKey(element) ? (1) : (occurences[element] + 1));

      rating8.forEach((element) => occurences[element] =
      !occurences.containsKey(element) ? (1) : (occurences[element] + 1));

      print(occurences);
      return occurences;
    } catch (e) {
      AppToast.show(S.current.errorSomethingWentWrong);
      return null;
    }
  }
}
