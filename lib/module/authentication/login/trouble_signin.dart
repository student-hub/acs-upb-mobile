import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

class TroubleSignIn extends StatefulWidget {
  final String email;
  final FirebaseAuth auth;

  TroubleSignIn(this.email, this.auth, {Key key}) : super(key: key);

  @override
  _TroubleSignInState createState() => new _TroubleSignInState();
}

class _TroubleSignInState extends State<TroubleSignIn> {
  TextEditingController _controllerEmail;

  @override
  initState() {
    super.initState();
    _controllerEmail = new TextEditingController(text: widget.email);
  }

  @override
  Widget build(BuildContext context) {
    _controllerEmail.text = widget.email;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(S.of(context).recoverPassword),
        elevation: 4.0,
      ),
      body: new Builder(
        builder: (BuildContext context) {
          return new Padding(
            padding: const EdgeInsets.all(16.0),
            child: new Column(
              children: <Widget>[
                new TextField(
                  controller: _controllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: new InputDecoration(
                      labelText: S.of(context).emailLabel),
                ),
                new SizedBox(height: 16.0),
                new Container(
                    alignment: Alignment.centerLeft,
                    child: new Text(
                      S.of(context).recoverPasswordInstructions,
                      style: Theme.of(context).textTheme.caption,
                    )),
                //const SizedBox(height: 5.0),
              ],
            ),
          );
        },
      ),
      persistentFooterButtons: <Widget>[
        new ButtonBar(
          alignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new FlatButton(
                onPressed: () => _send(context),
                child: new Row(
                  children: <Widget>[
                    new Text(S.of(context).sendLabel),
                  ],
                )),
          ],
        )
      ],
    );
  }

  _send(BuildContext context) async {
    FirebaseAuth _auth = widget.auth;
    try {
      await _auth.sendPasswordResetEmail(email: _controllerEmail.text);
      Navigator.of(context).pop();
    } catch (exception) {
      showErrorDialog(context, exception);
    }

    showErrorDialog(context,
        S.of(context).recoverPasswordDialog(_controllerEmail.text));
  }
}
