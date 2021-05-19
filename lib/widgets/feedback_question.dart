import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question.dart';
import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question_dropdown.dart';
import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question_input.dart';
import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question_rating.dart';
import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question_text.dart';
import 'package:acs_upb_mobile/widgets/radio_emoji.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';

class FeedbackQuestionForm extends StatelessWidget {
  const FeedbackQuestionForm({
    this.question,
    this.answerValues,
    this.formKey,
  });

  final FeedbackQuestion question;
  final List<Map<int, bool>> answerValues;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    if (question is FeedbackQuestionInput) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.question,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          TextFormField(
            key: const Key('FeedbackInput'),
            decoration: InputDecoration(
              labelText: S.current.labelAnswer,
              prefixIcon: const Icon(Icons.question_answer_outlined),
            ),
            onSaved: (value) {
              question.answer = value;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return S.current.errorAnswerCannotBeEmpty;
              }
              if (!isNumeric(value) ||
                  int.parse(value) < 0 ||
                  int.parse(value) > 10) {
                return S.current.errorAnswerIncorrect;
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
        ],
      );
    } else if (question is FeedbackQuestionRating) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EmojiFormField(
            question: question.question,
            onSaved: (value) {
              question.answer = value.keys
                  .firstWhere((element) => value[element] == true)
                  .toString();
            },
            validator: (selection) {
              if (selection.values.where((e) => e != false).isEmpty) {
                return S.current.warningYouNeedToSelectAtLeastOne;
              }
              return null;
            },
            answerValues: answerValues[int.parse(question.id)],
          ),
          const SizedBox(height: 10),
        ],
      );
    } else if (question is FeedbackQuestionDropdown) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.question,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          DropdownButtonFormField<String>(
            key: const Key('FeedbackDropdown'),
            decoration: InputDecoration(
              labelText: S.current.labelAnswer,
              prefixIcon: const Icon(Icons.list_outlined),
            ),
            onSaved: (value) {
              question.answer = value;
            },
            items: (question as FeedbackQuestionDropdown)
                .options
                .map(
                  (type) => DropdownMenuItem<String>(
                    value: type,
                    child: Text(type.toString()),
                  ),
                )
                .toList(),
            onChanged: (selection) {
              formKey.currentState.validate();
            },
            validator: (selection) {
              if (selection == null) {
                return S.current.errorAnswerCannotBeEmpty;
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
        ],
      );
    } else if (question is FeedbackQuestionText) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.question,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Column(
                children: [
                  TextFormField(
                    key: const Key('FeedbackText'),
                    onSaved: (value) {
                      question.answer = value;
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      );
    } else {
      return Container();
    }
  }
}
