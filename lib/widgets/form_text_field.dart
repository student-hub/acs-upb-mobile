import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FormTextField extends StatefulWidget {
  final String label;
  final bool obscureText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final Widget suffixIcon;

  FormTextField(
      {this.label,
      this.obscureText = false,
      this.controller,
      this.focusNode,
      this.onChanged,
      this.onSubmitted,
      this.suffixIcon});

  @override
  _FormTextFieldState createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: ScreenUtil().setHeight(30),
        ),
        Text(widget.label,
            style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(26))),
        TextField(
          obscureText: widget.obscureText,
          controller: widget.controller,
          focusNode: widget.focusNode,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          decoration: InputDecoration(
            hintText: widget.label.toLowerCase(),
            hintStyle: TextStyle(fontSize: ScreenUtil().setSp(22)),
            suffixIcon: widget.suffixIcon,
          ),
        )
      ],
    );
  }
}
