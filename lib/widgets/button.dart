import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatefulWidget {
  final Color color;
  final String text;
  final Color textColor;
  final Future<dynamic> Function() onTap;

  AppButton({this.color, this.text, this.textColor, this.onTap});

  @override
  _AppButtonState createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  Future<dynamic> future;

  @override
  void initState() {
    super.initState();
    future = Future(() => null);
  }

  Widget _getTextWidget() {
    return AutoSizeText(widget.text ?? "",
        textAlign: TextAlign.center,
        minFontSize: 0,
        style: TextStyle(
          color: widget.textColor ?? Theme.of(context).textTheme.button.color,
          fontWeight: FontWeight.bold,
          fontSize: ScreenUtil().setSp(26),
          letterSpacing: 1.0,
        ));
  }

  @override
  Widget build(BuildContext context) {
    // Set default color if none is set
    var _color = widget.color ?? Theme.of(context).backgroundColor;

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
          onTap: () => setState(() {
            future = widget.onTap();
          }),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: FutureBuilder(
                future: future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return SizedBox(
                        height: ScreenUtil().setSp(28),
                        width: ScreenUtil().setSp(28),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              widget.textColor ??
                                  Theme.of(context).textTheme.button.color),
                        ));
                  } else {
                    return _getTextWidget();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
