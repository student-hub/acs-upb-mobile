import 'package:acs_upb_mobile/authentication/login/trouble_signin.dart';
import 'package:acs_upb_mobile/authentication/utils.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordView extends StatefulWidget {
  final String email;
  final FirebaseAuth auth;

  PasswordView(this.email, this.auth, {Key key}) : super(key: key);

  @override
  _PasswordViewState createState() => new _PasswordViewState();
}

class _PasswordViewState extends State<PasswordView> {
  TextEditingController _controllerEmail;
  TextEditingController _controllerPassword;

  @override
  initState() {
    super.initState();
    _controllerEmail = new TextEditingController(text: widget.email);
    _controllerPassword = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    _controllerEmail.text = widget.email;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(S.of(context).actionLogIn),
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
                      labelText: S.of(context).labelEmail),
                ),
                //const SizedBox(height: 5.0),
                new TextField(
                  controller: _controllerPassword,
                  autofocus: true,
                  onSubmitted: _submit,
                  obscureText: true,
                  autocorrect: false,
                  decoration: new InputDecoration(
                      labelText: S.of(context).labelPassword),
                ),
                new SizedBox(height: 16.0),
                new Container(
                    alignment: Alignment.centerLeft,
                    child: new InkWell(
                        child: new Text(
                          S.of(context).actionResetPassword,
                          style: Theme.of(context).textTheme.caption,
                        ),
                        onTap: _handleLostPassword)),
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
                onPressed: () => _connect(context),
                child: new Row(
                  children: <Widget>[
                    new Text(S.of(context).actionLogIn),
                  ],
                )),
          ],
        )
      ],
    );
  }

  _submit(String submitted) {
    _connect(context);
  }

  _handleLostPassword() {
    Navigator.of(context)
        .push(new MaterialPageRoute<Null>(builder: (BuildContext context) {
      return new TroubleSignIn(_controllerEmail.text, widget.auth);
    }));
  }

  _connect(BuildContext context) async {
    FirebaseAuth _auth = widget.auth;
    FirebaseUser user;
    try {
      var result = await _auth.signInWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
      user = result.user;
      print(user);
    } catch (exception) {
      //TODO improve errors catching
      String msg = S.of(context).errorIncorrectPassword;
      showErrorDialog(context, msg);
    }

    if (user != null) {
      Navigator.of(context).pop(true);
    }
  }
}
