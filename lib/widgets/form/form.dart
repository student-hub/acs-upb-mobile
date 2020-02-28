import 'package:acs_upb_mobile/resources/custom_icons.dart';
import 'package:acs_upb_mobile/widgets/form/form_card.dart';
import 'package:flutter/cupertino.dart';

import 'file:///C:/Users/sako_/StudioProjects/acs-upb-mobile/lib/widgets/form/form_text_field.dart';

class FormItem {
  final String label;
  final String hint;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Future<bool> Function(String) check;
  final bool obscureText;
  Future<bool> valid;

  FormItem(
      {this.label,
      this.hint,
      TextEditingController controller,
      FocusNode focusNode,
      this.check,
      this.obscureText = false})
      : this.controller = controller ?? TextEditingController(),
        this.focusNode = focusNode ?? FocusNode(),
        this.valid = Future<bool>(() => null);
}

class AppForm extends StatefulWidget {
  final String title;
  final List<FormItem> items;

  /// Map from [FormItem.label] to corresponding input
  final dynamic Function(Map<String, String>) onSubmitted;

  /// Widgets to be added at the end of the form
  final List<Widget> trailing;

  AppForm({this.title, this.items, this.onSubmitted, List<Widget> trailing})
      : this.trailing = trailing ?? <Widget>[];

  @override
  _AppFormState createState() => _AppFormState();

  dynamic submit() {
    onSubmitted({for (var field in items) field.label: field.controller.text});
  }
}

class _AppFormState extends State<AppForm> {
  @override
  Widget build(BuildContext context) {
    return FormCard(
        title: widget.title,
        children: widget.items.asMap().entries.map<Widget>((e) {
                  int i = e.key;
                  FormItem field = e.value;

                  return FormTextField(
                    label: field.label,
                    hint: field.hint,
                    obscureText: field.obscureText,
                    controller: field.controller,
                    focusNode: field.focusNode,
                    onChanged: (text) => setState(() {
                      if (text == null || text == "") {
                        field.valid = Future<bool>(() => null);
                      } else {
                        field.valid = field.check(text);
                      }
                    }),
                    suffixIcon: field.check == null
                        ? null
                        : FutureBuilder(
                            future: field.valid,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.data == null) {
                                  // Display transparent icon
                                  return CustomIcons.empty;
                                } else {
                                  return snapshot.data
                                      ? CustomIcons.valid
                                      : CustomIcons.invalid;
                                }
                              } else {
                                return CustomIcons.empty;
                              }
                            },
                          ),
                    onSubmitted: (_) {
                      if (i < widget.items.length - 1) {
                        FocusScope.of(context)
                            .requestFocus(widget.items[i + 1].focusNode);
                      } else {
                        widget.submit();
                      }
                    },
                  );
                }).toList() +
                widget.trailing ??
            <Widget>[]);
  }
}
