import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

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
    return AutoSizeText(widget.text.toUpperCase() ?? "",
        textAlign: TextAlign.center,
        minFontSize: 0,
        style: Theme.of(context)
            .textTheme
            .button
            .copyWith(fontWeight: FontWeight.w600));
  }

  @override
  Widget build(BuildContext context) {
    // Set default color if none is set
    var _color = widget.color ?? Theme.of(context).backgroundColor;

    return Expanded(
      child: InkWell(
        child: Container(
          width: double.infinity,
          height: 36,
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
                          height: 20,
                          width: 20,
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
      ),
    );
  }
}
