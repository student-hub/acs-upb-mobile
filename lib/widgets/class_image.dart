import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ClassImage extends StatelessWidget {
  const ClassImage(
      {@required this.backgroundColor,
      @required this.textColor,
      @required this.selectable,
      @required this.selected,
      @required this.text,
      Key key,
      this.actionText,
      this.actionArrow = false,
      this.style,
      this.onTap,
      this.align = TextAlign.left})
      : super(key: key);

  final Color backgroundColor;
  final Color textColor;
  final bool selectable;
  final bool selected;
  final String text;

  /// Optional "action" text. If this is specified, it will show after the
  /// [text], have the theme's `accentColor`, and will be the trigger area for
  /// [onTap].
  final String actionText;

  /// An arrow pointing right to be shown next to the action text. It is
  /// disabled by default.
  final bool actionArrow;

  final TextStyle style;
  final void Function() onTap;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: actionText != null && actionText != '' ? null : onTap,
      child: CircleAvatar(
        backgroundColor: backgroundColor,
        child: Container(
          width: 30,
          child: (selectable && selected)
              ? Icon(
                  Icons.check,
                  color: textColor,
                )
              : Align(
                  alignment: Alignment.center,
                  child: AutoSizeText(
                    text,
                    minFontSize: 0,
                    maxLines: 1,
                    style: TextStyle(
                      color: textColor,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
