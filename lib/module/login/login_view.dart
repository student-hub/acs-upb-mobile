import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'email_view.dart';
import 'utils.dart';

class LoginView extends StatefulWidget {
  final List<ProvidersTypes> providers;
  final bool passwordCheck;
  final FirebaseAuth auth;

  LoginView({
    Key key,
    @required this.providers,
    this.passwordCheck,
    this.auth,
  }) : super(key: key);

  @override
  _LoginViewState createState() => new _LoginViewState(auth);
}

class _LoginViewState extends State<LoginView> {
  final FirebaseAuth _auth;

  _LoginViewState(this._auth) : super();

  Map<ProvidersTypes, ButtonDescription> _buttons;

  _handleEmailSignIn() async {
    String value = await Navigator.of(context)
        .push(new MaterialPageRoute<String>(builder: (BuildContext context) {
      return new EmailView(widget.passwordCheck, _auth);
    }));

    if (value != null) {
      _followProvider(value);
    }
  }

  _handleGoogleSignIn() async {
    // TODO
  }

  _handleFacebookSignin() async {
    // TODO
  }

  @override
  Widget build(BuildContext context) {
    _buttons = {
      ProvidersTypes.facebook:
          providersDefinitions(context)[ProvidersTypes.facebook]
              .copyWith(onSelected: _handleFacebookSignin),
      ProvidersTypes.google:
          providersDefinitions(context)[ProvidersTypes.google]
              .copyWith(onSelected: _handleGoogleSignIn),
      ProvidersTypes.email: providersDefinitions(context)[ProvidersTypes.email]
          .copyWith(onSelected: _handleEmailSignIn),
    };

    return new Container(
        child: new ListView(
            children: widget.providers.map((p) {
      return new Container(
          padding: const EdgeInsets.symmetric(vertical: 0.0),
          child: _buttons[p] ?? new Container());
    }).toList()));
  }

  void _followProvider(String value) {
    ProvidersTypes provider = stringToProvidersType(value);
    if (provider == ProvidersTypes.facebook) {
      _handleFacebookSignin();
    } else if (provider == ProvidersTypes.google) {
      _handleGoogleSignIn();
    }
  }
}
