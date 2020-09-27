import 'package:acs_upb_mobile/resources/custom_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

class FormCardField {
  FormCardField({
    this.label,
    this.additionalHint,
    this.hint,
    TextEditingController controller,
    FocusNode focusNode,
    void Function(String) onSubmitted,
    this.onChanged,
    this.check,
    this.obscureText = false,
    this.suffix,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.keyboardType = TextInputType.text,
    this.autofillHints,
  })  : onSubmitted = onSubmitted ?? ((_) {}),
        controller = controller ?? TextEditingController(),
        focusNode = focusNode ?? FocusNode(),
        valid = Future<bool>(() => null);

  final String label;
  final String additionalHint;
  final String hint;
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String) onSubmitted;
  final void Function(String) onChanged;
  final Future<bool> Function(String, {BuildContext context}) check;
  final bool obscureText;
  final String suffix;
  Future<bool> valid;
  final bool autocorrect;
  final bool enableSuggestions;
  final TextInputType keyboardType;
  final List<String> autofillHints;
}

class FormCard extends StatefulWidget {
  FormCard(
      {this.title,
      this.fields,
      this.onSubmitted,
      List<Widget> trailing,
      this.submitOnEnter = true})
      : trailing = trailing ?? <Widget>[];

  final String title;
  final List<FormCardField> fields;
  final bool submitOnEnter;

  /// Map from [FormCardField.label] to corresponding input
  final dynamic Function(Map<String, dynamic>) onSubmitted;

  /// Widgets to be added at the end of the form
  final List<Widget> trailing;

  @override
  _FormCardState createState() => _FormCardState();

  dynamic submit() {
    return onSubmitted(
        {for (var field in fields) field.label: field.controller.text});
  }
}

class _FormCardState extends State<FormCard> {
  Widget buildSuffixIcon(FormCardField field) => field.check == null
      ? null
      : IntrinsicWidth(
          child: FutureBuilder(
            future: field.valid,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.data == null) {
                // No icon
                return Container();
              } else {
                return GestureDetector(
                  onTap: () {
                    field.check(field.controller.text, context: context);
                  },
                  child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: snapshot.data
                          ? CustomIcons.valid
                          : CustomIcons.invalid),
                );
              }
            },
          ),
        );

  Widget buildTextField(int index, FormCardField field) {
    final Widget suffixIcon = buildSuffixIcon(field);

    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(field.label,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .apply(fontSizeFactor: 1.1)),
          ),
          if (field.additionalHint != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                field.additionalHint,
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
            ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    key: ValueKey('${field.label.snakeCase}_text_field'),
                    keyboardType: field.keyboardType,
                    autocorrect: field.autocorrect,
                    enableSuggestions: field.enableSuggestions,
                    obscureText: field.obscureText,
                    controller: field.controller,
                    focusNode: field.focusNode,
                    onChanged: (text) => setState(() {
                      field.onChanged(text);
                      if (text == null || text == '') {
                        field.valid = Future<bool>(() => null);
                      } else {
                        field.valid = field.check(text);
                      }
                    }),
                    onSubmitted: (input) {
                      if (index < widget.fields.length - 1) {
                        FocusScope.of(context)
                            .requestFocus(widget.fields[index + 1].focusNode);
                        field.onSubmitted(input);
                      } else {
                        if (widget.submitOnEnter) {
                          widget.submit();
                        } else {
                          // Just remove focus
                          final currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                        }
                      }
                    },
                    autofillHints: field.autofillHints,
                    // Only show verification icon within text field if it exists
                    // and there no suffix text set
                    decoration: field.suffix == null && suffixIcon != null
                        ? InputDecoration(
                            hintText: field.hint ?? field.label.toLowerCase(),
                            suffixIcon: suffixIcon,
                          )
                        : InputDecoration(
                            hintText: field.hint ?? field.label.toLowerCase(),
                          ),
                  ),
                ),
                if (field.suffix != null)
                  Row(
                    children: <Widget>[
                      const SizedBox(width: 4),
                      Text(field.suffix,
                          style: Theme.of(context)
                              .inputDecorationTheme
                              .suffixStyle),
                      suffixIcon,
                    ],
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final children = widget.fields
        .asMap()
        .map((index, field) => MapEntry(index, buildTextField(index, field)))
        .values
        .toList();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          const BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 15),
            blurRadius: 15,
          ),
          const BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -10),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(widget.title,
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(fontWeight: FontWeight.w600)),
                  )
                ] +
                children +
                widget.trailing,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (final field in widget.fields) {
      field.controller.dispose();
      field.focusNode.dispose();
    }
    super.dispose();
  }
}
