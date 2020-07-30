import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class AppDialog extends StatelessWidget {
  /// Icon to show to the left of the dialog title
  final Icon icon;

  /// Title of dialog
  final String title;

  /// Dialog message
  final String message;

  /// Additional information
  final String info;

  /// Content to be shown under dialog message
  final List<Widget> content;

  /// Action buttons (note: a cancel button is displayed by default, there is no
  /// need to include it here)
  final List<AppButton> actions;

  /// Whether to display a cancel button or not
  final bool enableCancelButton;

  const AppDialog(
      {Key key,
      this.icon,
      @required this.title,
      @required this.message,
      this.info,
      this.content,
      this.actions,
      this.enableCancelButton = true})
      : super(key: key);

  @override
  AlertDialog build(BuildContext context) => AlertDialog(
        title: icon == null
            ? Text(title)
            : Row(
                children: <Widget>[
                  icon,
                  SizedBox(width: 4),
                  Text(title),
                ],
              ),
        content: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                  Expanded(child: Container(height: 8)),
                  Text(message),
                  if (info != null)
                    Column(children: [
                      SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyText2,
                          children: [
                            WidgetSpan(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: Icon(
                                  Icons.info,
                                  color: Theme.of(context).hintColor,
                                  size: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .fontSize,
                                ),
                              ),
                            ),
                            TextSpan(
                              text: info,
                              style:
                                  TextStyle(color: Theme.of(context).hintColor),
                            ),
                          ],
                        ),
                      )
                    ])
                ] +
                (content ?? <Widget>[]),
          ),
        ),
        actions: <Widget>[
              FlatButton(
                key: ValueKey('cancel_button'),
                child: Text(
                  S.of(context).buttonCancel.toUpperCase(),
                  style: Theme.of(context).textTheme.button,
                ),
                onPressed: () => Navigator.pop(context),
              )
            ] +
            (actions ?? <Widget>[]),
      );
}
