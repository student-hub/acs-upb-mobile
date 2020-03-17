import 'package:flutter/material.dart';

class FormTextField extends StatefulWidget {
  final String label;
  final String hint;
  final String suffix;
  final bool obscureText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final Widget suffixIcon;

  FormTextField({
    Key key,
    this.label,
    this.hint,
    this.suffix,
    this.obscureText = false,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.suffixIcon,
  }) : super(key: key);

  @override
  _FormTextFieldState createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // The following prevents the text field from overflowing
          Expanded(
              child: SizedBox(
            height: 8,
          )),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(widget.label,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .apply(fontSizeFactor: 1.1)),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  obscureText: widget.obscureText,
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  decoration: InputDecoration(
                    hintText: widget.hint ?? widget.label.toLowerCase(),
                  ),
                ),
              ),
              widget.suffix != null
                  ? Row(
                      children: <Widget>[
                        SizedBox(
                          width: 4,
                        ),
                        Text(widget.suffix,
                            style: Theme.of(context)
                                .inputDecorationTheme
                                .suffixStyle),
                        IntrinsicWidth(child: widget.suffixIcon),
                      ],
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }
}
