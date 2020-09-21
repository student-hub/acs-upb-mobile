import 'package:acs_upb_mobile/resources/custom_icons.dart';
import 'package:acs_upb_mobile/widgets/form/form_card.dart';
import 'package:acs_upb_mobile/widgets/form/form_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:recase/recase.dart';

class FormItem {
  final String label;
  final String additionalHint;
  final String hint;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onSubmitted;
  final Function(String) onChanged;
  final Future<bool> Function(String, {BuildContext context}) check;
  final bool obscureText;
  final String suffix;
  Future<bool> valid;
  final bool autocorrect;
  final bool enableSuggestions;
  final TextInputType keyboardType;
  final List<String> autofillHints;

  FormItem({
    this.label,
    this.additionalHint,
    this.hint,
    TextEditingController controller,
    FocusNode focusNode,
    Function(String) onSubmitted,
    this.onChanged,
    this.check,
    this.obscureText = false,
    this.suffix,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.keyboardType = TextInputType.text,
    this.autofillHints,
  })  : this.onSubmitted = onSubmitted ?? ((_) {}),
        this.controller = controller ?? TextEditingController(),
        this.focusNode = focusNode ?? FocusNode(),
        this.valid = Future<bool>(() => null);
}

class AppForm extends StatefulWidget {
  final String title;
  final List<FormItem> items;
  final bool submitOnEnter;

  /// Map from [FormItem.label] to corresponding input
  final dynamic Function(Map<String, dynamic>) onSubmitted;

  /// Widgets to be added at the end of the form
  final List<Widget> trailing;

  AppForm(
      {this.title,
      this.items,
      this.onSubmitted,
      List<Widget> trailing,
      this.submitOnEnter = true})
      : this.trailing = trailing ?? <Widget>[];

  @override
  _AppFormState createState() => _AppFormState();

  dynamic submit() {
    return onSubmitted(
        {for (var field in items) field.label: field.controller.text});
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
                    key:
                        ValueKey(ReCase(field.label).snakeCase + '_text_field'),
                    label: field.label,
                    additionalHint: field.additionalHint,
                    hint: field.hint,
                    suffix: field.suffix,
                    obscureText: field.obscureText,
                    controller: field.controller,
                    focusNode: field.focusNode,
                    autocorrect: field.autocorrect,
                    enableSuggestions: field.enableSuggestions,
                    keyboardType: field.keyboardType,
                    autofillHints: field.autofillHints,
                    onChanged: (text) => setState(() {
                      field.onChanged(text);
                      if (text == null || text == "") {
                        field.valid = Future<bool>(() => null);
                      } else {
                        field.valid = field.check(text);
                      }
                    }),
                    suffixIcon: field.check == null
                        ? null
                        : IntrinsicWidth(
                            child: FutureBuilder(
                              future: field.valid,
                              builder: (BuildContext context,
                                  AsyncSnapshot<bool> snapshot) {
                                if (snapshot.data == null) {
                                  // No icon
                                  return Container();
                                } else {
                                  return GestureDetector(
                                    onTap: () {
                                      field.check(field.controller.text,
                                          context: context);
                                    },
                                    child: Padding(
                                        padding: EdgeInsets.only(left: 4.0),
                                        child: snapshot.data
                                            ? CustomIcons.valid
                                            : CustomIcons.invalid),
                                  );
                                }
                              },
                            ),
                          ),
                    onSubmitted: (input) {
                      if (i < widget.items.length - 1) {
                        FocusScope.of(context)
                            .requestFocus(widget.items[i + 1].focusNode);
                        field.onSubmitted(input);
                      } else {
                        if (widget.submitOnEnter) {
                          widget.submit();
                        } else {
                          // Just remove focus
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                        }
                      }
                    },
                  );
                }).toList() +
                widget.trailing ??
            <Widget>[]);
  }

  @override
  void dispose() {
    widget.items.forEach((field) {
      field.controller.dispose();
      field.focusNode.dispose();
    });
    super.dispose();
  }
}
