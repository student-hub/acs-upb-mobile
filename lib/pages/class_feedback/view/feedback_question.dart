import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question.dart';
import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question_dropdown.dart';
import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question_rating.dart';
import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question_slider.dart';
import 'package:acs_upb_mobile/pages/class_feedback/model/questions/question_text.dart';
import 'package:acs_upb_mobile/widgets/radio_emoji.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedbackQuestionFormField extends StatefulWidget {
  const FeedbackQuestionFormField({
    this.question,
    this.answerValues,
    this.formKey,
  });

  final FeedbackQuestion question;
  final List<Map<int, bool>> answerValues;
  final GlobalKey<FormState> formKey;

  @override
  _FeedbackQuestionFormFieldState createState() =>
      _FeedbackQuestionFormFieldState();
}

class _FeedbackQuestionFormFieldState extends State<FeedbackQuestionFormField> {
  bool _enabled = false;

  Widget feedbackQuestionSlider() {
    const double defaultVal = 5;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.question.question,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        Row(
          children: [
            Transform.translate(
              // Offset to bypass slider padding
              offset: const Offset(10, 0),
              child: GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => Dialog(
                      child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue:
                          widget.question.answer ?? defaultVal.toString(),
                      onChanged: (value) => setState(
                          () => widget.question.answer = value ?? defaultVal),
                    ),
                  )),
                ),
                child: Text(
                  (double.tryParse(widget.question.answer ?? '') ?? defaultVal)
                      .toString(),
                  style: Theme.of(context).textTheme.bodyText2.apply(
                      color: _enabled
                          ? Theme.of(context).textTheme.bodyText2.color
                          : Theme.of(context).disabledColor),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTapDown: (_) => setState(() => _enabled = true),
                child: Slider.adaptive(
                  key: const Key('FeedbackSlider'),
                  value: double.tryParse(widget.question.answer ?? '') ??
                      defaultVal,
                  onChanged: !_enabled
                      ? null
                      : (newRating) {
                          setState(() {
                            widget.question.answer = newRating.toString();
                          });
                        },
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: widget.question.answer,
                  activeColor: Theme.of(context).accentColor,
                ),
              ),
            ),
            Transform.translate(
              // Offset to bypass slider & checkbox padding
              offset: const Offset(-20, 0),
              child: Checkbox(
                value: !_enabled,
                onChanged: (bool value) => setState(() {
                  _enabled = !value;
                  if (value) {
                    widget.question.answer = null;
                  }
                }),
                visualDensity: const VisualDensity(),
              ),
            ),
            Transform.translate(
              offset: const Offset(-25, 0),
              child: const Text('N/A'),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget feedbackQuestionRating() {
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
  }

  Widget feedbackQuestionDropdown() {
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
        const SizedBox(height: 16),
      ],
    );
  }

  Widget feedbackQuestionText() {
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
  }

  @override
  Widget build(BuildContext context) {
    if (widget.question is FeedbackQuestionSlider) {
      return feedbackQuestionSlider();
    } else if (widget.question is FeedbackQuestionRating) {
      return feedbackQuestionRating();
    } else if (widget.question is FeedbackQuestionDropdown) {
      return feedbackQuestionDropdown();
    } else if (widget.question is FeedbackQuestionText) {
      return feedbackQuestionText();
    } else {
      return Container();
    }
  }
}
