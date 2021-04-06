import 'package:acs_upb_mobile/widgets/radio_emoji.dart';
import 'package:acs_upb_mobile/widgets/selectable.dart';
import 'package:flutter/material.dart';

class FeedbackFormField extends StatelessWidget {
  const FeedbackFormField({@required this.id,
    @required this.question,
    @required this.groupValue,
    @required this.radioHandler,
    this.emojiController,
    this.error});

  /// `id` will be treated as a key and also the row number
  final int id;

  /// `question` you want to ask
  final String question;

  /// `groupValue` is used to identify if the radio button is selected or not
  ///
  /// if (groupValue == value) then it means that radio button is selected
  final int groupValue;

  /// `error` to be displayed below emojis row
  ///
  /// mostly used if no option is selected
  final String error;

  /// This function that will handle all radio button row values
  final Function radioHandler;

  /// Determines the number of radio buttons according to their taste
  ///
  /// 😠 😕 😐 ☺ 😍
  static final List<int> _radioButtons = [1, 2, 3, 4, 5];

  final SelectableController emojiController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '$question',
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _radioButtons.map((value) {
            return RadioEmoji(
              value: value,
              groupValue: groupValue,
              onChange: radioHandler,
              emojiController: emojiController,
            );
          }).toList(),
        ),
        const SizedBox(
          height: 2,
        ),
        Visibility(
          visible: error != null,
          child: Text(
            '$error',
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
