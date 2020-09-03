import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  final IconData icon;
  final String text;
  final TextStyle style;
  final Function() onTap;
  final TextAlign align;

  const IconText(
      {Key key,
      @required this.icon,
      @required this.text,
      this.style,
      this.onTap,
      this.align = TextAlign.left})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle widgetStyle = style ?? Theme.of(context).textTheme.bodyText1;

    return InkWell(
      onTap: onTap,
      child: RichText(
        textAlign: align,
        text: TextSpan(
          style: widgetStyle,
          children: [
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Icon(
                  icon,
                  color: widgetStyle.color,
                  size: widgetStyle.fontSize + 4,
                ),
              ),
            ),
            TextSpan(text: text),
          ],
        ),
      ),
    );
  }
}
