import 'package:acs_upb_mobile/widgets/selectable.dart';
import 'package:flutter/material.dart';

/*class RadioEmoji extends StatefulWidget {
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
}*/

class EmojiFormField extends FormField<Map<int, bool>> {
  EmojiFormField({
    @required Map<int, bool> initialValues,
    @required String question,
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
              const Icon(
                Icons.sentiment_very_dissatisfied,
                color: Colors.red,
              ),
              const Icon(
                Icons.sentiment_dissatisfied,
                color: Colors.redAccent,
              ),
              const Icon(
                Icons.sentiment_neutral,
                color: Colors.amber,
              ),
              const Icon(
                Icons.sentiment_satisfied,
                color: Colors.lightGreen,
              ),
              const Icon(
                Icons.sentiment_very_satisfied,
                color: Colors.green,
              )
            ];
            final List<SelectableController> emojiControllers =
                emojis.map((_) => SelectableController()).toList();
            final emojiSelectables = emojiControllers
                .asMap()
                .map(
                  (i, controller) => MapEntry(
                    i,
                    SelectableIcon(
                      icon: emojis[i],
                      controller: controller,
                      onSelected: (selected) {
                        print('Something was pressed $i $selected');
                        if (selected) {
                          for (final c in emojiControllers) {
                            if (c != controller) {
                              c.deselect();
                            }
                          }
                          controller.select();
                        } else {
                          controller.deselect();
                        }
                      },
                    ),
                  ),
                )
                .values
                .toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '$question',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: emojiSelectables,
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
            );
          },
        );
}

class SelectableIcon extends Selectable {
  const SelectableIcon({
    Key key,
    bool initiallySelected,
    Function(bool) onSelected,
    this.icon,
    SelectableController controller,
  }) : super(
            initiallySelected: initiallySelected ?? false,
            onSelected: onSelected,
            controller: controller);

  final Icon icon;

  @override
  _SelectableIconState createState() => _SelectableIconState(icon);
}

class _SelectableIconState extends SelectableState {
  _SelectableIconState(this.icon);

  Icon icon;

  @override
  void initState() {
    super.initState();
    isSelected = widget.initiallySelected;
  }

  @override
  Widget build(BuildContext context) {
    widget.controller.selectableState = this;

    return GestureDetector(
      onTap: () {
        setState(
          () {
            isSelected = !isSelected;
            widget.onSelected(isSelected);
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(style: BorderStyle.none, width: 1),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: AnimatedContainer(
          //color: isSelected ? Colors.green : Colors.transparent,
          duration: const Duration(seconds: 1),
          width: isSelected ? 100 : 15,
          child: icon,
        ),
      ),
    );
  }
}
