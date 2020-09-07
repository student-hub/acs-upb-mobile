import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  final IconData icon;
  final String text;

  /// Optional "action" text. If this is specified, it will show after the
  /// [text], have the theme's [accentColor], and will be the trigger area for
  /// [onTap].
  final String actionText;

  /// An arrow pointing right to be shown next to the action text. It is
  /// disabled by default.
  final bool actionArrow;

  final TextStyle style;
  final Function() onTap;
  final TextAlign align;

  const IconText(
      {Key key,
      @required this.icon,
      @required this.text,
      this.actionText,
      this.actionArrow = false,
      this.style,
      this.onTap,
      this.align = TextAlign.left})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = style ?? Theme.of(context).textTheme.bodyText1;
    TextStyle actionStyle = textStyle
        .copyWith(color: Theme.of(context).accentColor)
        .apply(fontWeightDelta: 2);

    return InkWell(
      onTap: actionText != null && actionText != '' ? null : onTap,
      child: RichText(
        textAlign: align,
        text: TextSpan(
          style: textStyle,
          children: [
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Icon(
                  icon,
                  color: textStyle.color,
                  size: textStyle.fontSize + 4,
                ),
              ),
            ),
            TextSpan(text: text),
            WidgetSpan(
              child: IntrinsicWidth(
                child: InkWell(
                  onTap: onTap,
                  child: Row(
                    children: [
                      if (actionText != null && actionText != '')
                        Text(
                          ' ' + actionText,
                          style: actionStyle,
                        ),
                      if (actionArrow)
                        Icon(
                          Icons.arrow_forward_ios,
                          color: actionStyle.color,
                          size: actionStyle.fontSize,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
