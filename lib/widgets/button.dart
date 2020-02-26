import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  final Color color;
  final String text;
  final Color textColor;
  final void Function() onTap;

  AppButton({this.color, this.text, this.textColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Set default color if none is set
    var _color = color ?? Theme.of(context).backgroundColor;

    return InkWell(
      child: Container(
        width: ScreenUtil().setWidth(300),
        height: ScreenUtil().setSp(70),
        decoration: BoxDecoration(
            color: _color,
            borderRadius: BorderRadius.circular(6.0),
            boxShadow: [
              BoxShadow(
                  color: _color.withOpacity(.1),
                  offset: Offset(0.0, 8.0),
                  blurRadius: 8.0)
            ]),
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: AutoSizeText(text ?? "",
                  textAlign: TextAlign.center,
                  minFontSize: 0,
                  style: TextStyle(
                    color:
                        textColor ?? Theme.of(context).textTheme.button.color,
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(26),
                    letterSpacing: 1.0,
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
