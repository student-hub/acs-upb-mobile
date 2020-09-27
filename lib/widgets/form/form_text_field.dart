import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormTextField extends StatefulWidget {
  final String label;
  final String additionalHint;
  final String hint;
  final String suffix;
  final bool obscureText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final Widget suffixIcon;
  final bool autocorrect;
  final bool enableSuggestions;
  final TextInputType keyboardType;
  final List<String> autofillHints;

  FormTextField({
    Key key,
    this.label,
    this.additionalHint,
    this.hint,
    this.suffix,
    this.obscureText = false,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.suffixIcon,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.keyboardType = TextInputType.text,
    this.autofillHints,
  }) : super(key: key);

  @override
  _FormTextFieldState createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(widget.label,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .apply(fontSizeFactor: 1.1)),
          ),
          widget.additionalHint != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    widget.additionalHint,
                    style: TextStyle(color: Theme.of(context).hintColor),
                  ),
                )
              : Container(height: 0),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    keyboardType: widget.keyboardType,
                    autocorrect: widget.autocorrect,
                    enableSuggestions: widget.enableSuggestions,
                    obscureText: widget.obscureText,
                    controller: widget.controller,
                    focusNode: widget.focusNode,
                    onChanged: widget.onChanged,
                    onSubmitted: widget.onSubmitted,
                    autofillHints: widget.autofillHints,
                    // Only show verification icon within text field if it exists
                    // and there no suffix text set
                    decoration: widget.suffix == null &&
                            widget.suffixIcon != null
                        ? InputDecoration(
                            hintText: widget.hint ?? widget.label.toLowerCase(),
                            suffixIcon: widget.suffixIcon,
                          )
                        : InputDecoration(
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
                          widget.suffixIcon,
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
