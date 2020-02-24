import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  final List<Color> colors;
  final String text;
  final Color textColor;
  final void Function() onTap;

  AppButton({this.colors, this.text, this.textColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Set default color if none is set
    var _colors = colors ?? [Theme.of(context).backgroundColor];

    // Make sure there are at least two colours for the gradient
    if (_colors.length < 2) {
      _colors.length = 2;
      _colors[1] = _colors[0];
    }

    return InkWell(
      child: Container(
        width: ScreenUtil().setWidth(300),
        height: ScreenUtil().setHeight(90),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: _colors),
            borderRadius: BorderRadius.circular(6.0),
            boxShadow: [
              BoxShadow(
                  color: Color.lerp(_colors[0], _colors[_colors.length - 1], 0.5)
                      .withOpacity(.1),
                  offset: Offset(0.0, 8.0),
                  blurRadius: 8.0)
            ]),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: AutoSizeText(text ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: textColor ??
                            Theme.of(context).textTheme.button.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 1.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
