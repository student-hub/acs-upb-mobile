import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  final IconData icon;
  final String text;
  final TextStyle style;
  final Function() onTap;

  const IconText({Key key, this.icon, this.text, this.style, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: RichText(
        text: TextSpan(
          style: style,
          children: [
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Icon(
                  icon,
                  color: style.color,
                  size: style.fontSize + 4,
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
