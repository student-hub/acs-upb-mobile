import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  final IconData icon;
  final String text;

  /// Optional "action" text. If this is specified, it will show after the
  /// [text], have the theme's [accentColor], and will be the trigger area for
  /// [onTap].
  final String actionText;
  final TextStyle style;
  final Function() onTap;

  const IconText(
      {Key key,
      @required this.icon,
      @required this.text,
      this.actionText,
      this.style,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle widgetStyle = style ?? Theme.of(context).textTheme.bodyText1;

    return InkWell(
      onTap: actionText != null && actionText != '' ? null : onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: Icon(
              icon,
              color: widgetStyle.color,
              size: widgetStyle.fontSize + 4,
            ),
          ),
          RichText(
            text: TextSpan(
              style: widgetStyle,
              children: [
                TextSpan(text: text),
                if (actionText != null && actionText != '')
                  TextSpan(
                    text: ' ' + actionText,
                    style: widgetStyle
                        .copyWith(color: Theme.of(context).accentColor)
                        .apply(fontWeightDelta: 2),
                    recognizer: TapGestureRecognizer()..onTap = onTap,
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
