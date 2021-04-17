import 'package:flutter/material.dart';

class RadioEmoji extends StatefulWidget {
  const RadioEmoji({
    @required this.value,
  }) : assert(value >= 1 && value <= 5);

  /// Rating value between 1 and 5
  final int value;

  /// Emojis describing feedback status
  static final List<String> emojiIndex = ['😠', '😕', '😐', '☺', '😍'];

  @override
  _RadioEmojiState createState() => _RadioEmojiState();
}

class _RadioEmojiState extends State<RadioEmoji>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  CurvedAnimation animation;

  String emoji;

  @override
  void initState() {
    super.initState();

    emoji = RadioEmoji.emojiIndex[widget.value - 1];

    controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.elasticOut,
    );

    controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(style: BorderStyle.none, width: 1),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Container(
          height: 35,
          child: Text(
            emoji,
            style: TextStyle(
              fontSize: animation.value * 10 + 20.0,
            ),
          ),
        ),
      ),
      onTap: () {
        controller.forward();
      },
    );
  }
}

class EmojiFormField extends FormField<Map<int, bool>> {
  EmojiFormField({
    @required Map<int, bool> initialValues,
    @required String question,
    @required void Function() handleTap,
    @required CurvedAnimation animation,
    String Function(Map<int, bool>) validator,
    Key key,
  }) : super(
          key: key,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          initialValue: initialValues,
          builder: (state) {
            final context = state.context;
            final List<Icon> emojis = [
              Icon(
                Icons.sentiment_very_dissatisfied,
                color: Colors.red,
                size: animation.value * 10 + 20.0,
              ),
              Icon(
                Icons.sentiment_dissatisfied,
                color: Colors.redAccent,
                size: animation.value * 10 + 20.0,
              ),
              Icon(
                Icons.sentiment_neutral,
                color: Colors.amber,
                size: animation.value * 10 + 20.0,
              ),
              Icon(
                Icons.sentiment_satisfied,
                color: Colors.lightGreen,
                size: animation.value * 10 + 20.0,
              ),
              Icon(
                Icons.sentiment_very_satisfied,
                color: Colors.green,
                size: animation.value * 10 + 20.0,
              )
            ];
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
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        height: 45,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: emojis.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: handleTap,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          style: BorderStyle.none, width: 1),
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                                    child: emojis[index],
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    if (state.hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          state.errorText,
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: Theme.of(context).errorColor),
                        ),
                      ),
                  ],
                ),
              ],
            );
          },
        );
}
