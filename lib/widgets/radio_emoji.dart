import 'package:acs_upb_mobile/widgets/selectable.dart';
import 'package:flutter/material.dart';

class RadioEmoji extends StatefulWidget {

  const RadioEmoji({
    @required this.value,
    @required this.groupValue,
    @required this.onChange,
    this.emojiController
  }) : assert(value >= 1 && value <= 5);

  /// Rating value between 1 and 5
  final int value;

  /// `groupValue` used to identify the radio button group
  final int groupValue;

  /// everytime the value of radio changes this function will trigger
  final Function onChange;

  /// Emojis describing feedback status
  static final List<String> emojiIndex = ['😠', '😕', '😐', '☺', '😍'];

  final SelectableController emojiController;

  @override
  _RadioEmojiState createState() => _RadioEmojiState();
}

class _RadioEmojiState extends State<RadioEmoji>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  CurvedAnimation animation;

  String emoji;
  bool isSelected;

  // This function will trigger each time the radio emoji button is tapped
  void _handleTap() {
    widget.onChange(widget.value);
    _initializeAnimation();
  }

  void _initializeAnimation() {
    controller.forward();
  }

  void _stopAnimation() {
    controller.value = 0.0;
  }

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

    isSelected = false;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isSelected = widget.value == widget.groupValue;

    if (isSelected == false) _stopAnimation();

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
      onTap: _handleTap,
    );
  }
}
