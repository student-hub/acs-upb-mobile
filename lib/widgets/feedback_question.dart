import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question.dart';
import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question_dropdown.dart';
import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question_slider.dart';
import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question_rating.dart';
import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question_text.dart';
import 'package:acs_upb_mobile/widgets/radio_emoji.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';

class FeedbackQuestionForm extends StatefulWidget {
  const FeedbackQuestionForm({
    this.question,
    this.answerValues,
    this.formKey,
  });

  final FeedbackQuestion question;
  final List<Map<int, bool>> answerValues;
  final GlobalKey<FormState> formKey;

  @override
  _FeedbackQuestionFormState createState() => _FeedbackQuestionFormState();
}

class _FeedbackQuestionFormState extends State<FeedbackQuestionForm> {
  @override
  Widget build(BuildContext context) {
    if (widget.question is FeedbackQuestionSlider) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.question.question,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          Slider.adaptive(
            value: widget.question.answer != null
                ? double.parse(widget.question.answer)
                : 0,
            onChanged: (newRating) {
              setState(() {
                widget.question.answer = newRating.toString();
              });
            },
            max: 10,
            divisions: 10,
            label: widget.question.answer,
            activeColor: Theme.of(context).accentColor,
          ),
          const SizedBox(height: 10),
        ],
      );
    } else if (widget.question is FeedbackQuestionRating) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EmojiFormField(
            question: widget.question.question,
            onSaved: (value) {
              widget.question.answer = value.keys
                  .firstWhere((element) => value[element] == true,
                      orElse: () => -1)
                  .toString();
            },
            answerValues: widget.answerValues[int.parse(widget.question.id)],
          ),
          const SizedBox(height: 10),
        ],
      );
    } else if (widget.question is FeedbackQuestionDropdown) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.question.question,
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
              widget.question.answer = value;
            },
            items: (widget.question as FeedbackQuestionDropdown)
                .options
                .map(
                  (type) => DropdownMenuItem<String>(
                    value: type,
                    child: Text(type.toString()),
                  ),
                )
                .toList(),
            onChanged: (selection) {
              widget.formKey.currentState.validate();
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
    } else if (widget.question is FeedbackQuestionText) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.question.question,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.all(2),
            child: Column(
              children: [
                TextFormField(
                  key: const Key('FeedbackText'),
                  onSaved: (value) {
                    widget.question.answer = value;
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ],
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
