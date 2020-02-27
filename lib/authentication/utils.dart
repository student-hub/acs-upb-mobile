import 'dart:async';

import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

enum ProvidersTypes { email, google, facebook }

extension on ProvidersTypes {
  String toShortString() {
    return this.toString().split('.').last;
  }

  String toCapitalizedShortString() {
    return StringUtils.capitalize(this.toString().split('.').last);
  }
}

ProvidersTypes stringToProvidersType(String value) {
  if (value.toLowerCase().contains('facebook')) return ProvidersTypes.facebook;
  if (value.toLowerCase().contains('google')) return ProvidersTypes.google;
  if (value.toLowerCase().contains('password')) return ProvidersTypes.email;
  return null;
}

// Description button
class ButtonDescription extends StatelessWidget {
  final String label;
  final Color labelColor;
  final Color color;
  final String logo;
  final String name;
  final VoidCallback onSelected;

  const ButtonDescription(
      {@required this.logo,
      @required this.label,
      @required this.name,
      this.onSelected,
      this.labelColor = Colors.grey,
      this.color = Colors.white});

  ButtonDescription copyWith({
    String label,
    Color labelColor,
    Color color,
    String logo,
    String name,
    VoidCallback onSelected,
  }) {
    return new ButtonDescription(
        label: label ?? this.label,
        labelColor: labelColor ?? this.labelColor,
        color: color ?? this.color,
        logo: logo ?? this.logo,
        name: name ?? this.name,
        onSelected: onSelected ?? this.onSelected);
  }

  @override
  Widget build(BuildContext context) {
    VoidCallback _onSelected = onSelected ?? () => {};
    return new Padding(
      padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
      child: new RaisedButton(
          color: color,
          child: new Row(
            children: <Widget>[
              new Container(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 32.0, 16.0),
                  child: new Image.asset('assets/icons/$logo')),
              new Expanded(
                child: new Text(
                  label,
                  style: new TextStyle(color: labelColor),
                ),
              )
            ],
          ),
          onPressed: _onSelected),
    );
  }
}

ButtonDescription _providerButton(
    ProvidersTypes provider, Color color, BuildContext context) {
  return ButtonDescription(
      color: const Color.fromRGBO(59, 87, 157, 1.0),
      logo: "${provider.toShortString()}-logo.png",
      label: S.of(context).actionSignInWith(provider.toCapitalizedShortString()),
      name: provider.toCapitalizedShortString(),
      labelColor: Colors.white);
}

Map<ProvidersTypes, ButtonDescription> providersDefinitions(
        BuildContext context) =>
    {
      ProvidersTypes.facebook: _providerButton(ProvidersTypes.facebook,
          const Color.fromRGBO(59, 87, 157, 1.0), context),
      ProvidersTypes.google:
          _providerButton(ProvidersTypes.google, Colors.grey, context),
      ProvidersTypes.email: _providerButton(
          ProvidersTypes.email, const Color.fromRGBO(219, 68, 55, 1.0), context)
    };

Future<Null> showErrorDialog(BuildContext context, String message,
    {String title}) {
  return showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) => new AlertDialog(
      title: title != null ? new Text(title) : null,
      content: new SingleChildScrollView(
        child: new ListBody(
          children: <Widget>[
            new Text(message ?? S.of(context).errorSomethingWentWrong),
          ],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Row(
            children: <Widget>[
              new Text(S.of(context).buttonCancel),
            ],
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}
