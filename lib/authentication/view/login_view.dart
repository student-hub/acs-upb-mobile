import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/routes.dart';
import 'package:acs_upb_mobile/resources/banner.dart';
import 'package:acs_upb_mobile/widgets/button.dart';
import 'package:acs_upb_mobile/widgets/dialog.dart';
import 'package:acs_upb_mobile/widgets/form/form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  static const String routeName = '/login';

  LoginView();

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  var emailController = TextEditingController();
  List<FormItem> formItems;

  List<FormItem> _buildFormItems() {
    // Only build them once to avoid the cursor staying everywhere
    if (formItems != null) {
      return formItems;
    }
    String emailDomain = S.of(context).stringEmailDomain;

    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    formItems = <FormItem>[
      FormItem(
        label: S.of(context).labelEmail,
        hint: S.of(context).hintEmail,
        suffix: emailDomain,
        controller: emailController,
        check: (email, {BuildContext context}) =>
            authProvider.canSignInWithPassword(
                email: email + emailDomain, context: context),
      ),
      FormItem(
        label: S.of(context).labelPassword,
        hint: S.of(context).hintPassword,
        obscureText: true,
      ),
    ];
    return formItems;
  }

  AppDialog _resetPasswordDialog(BuildContext context) => AppDialog(
        title: S.of(context).actionResetPassword,
        message: S.of(context).messageResetPassword,
        content: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  key: ValueKey('reset_password_email_text_field'),
                  controller: emailController,
                  decoration:
                      InputDecoration(hintText: S.of(context).hintEmail),
                ),
              ),
              SizedBox(
                width: 4,
              ),
              Text(S.of(context).stringEmailDomain,
                  style: Theme.of(context).inputDecorationTheme.suffixStyle),
            ],
          )
        ],
        actions: [
          AppButton(
            key: ValueKey('send_email_button'),
            text: S.of(context).actionSendEmail.toUpperCase(),
            width: 130,
            onTap: () async {
              bool success =
                  await Provider.of<AuthProvider>(context, listen: false)
                      .sendPasswordResetEmail(
                          email: emailController.text +
                              S.of(context).stringEmailDomain,
                          context: context);
              if (success) {
                Navigator.pop(context);
              }
              return;
            },
          ),
        ],
      );

  AppForm _buildForm(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return AppForm(
      title: S.of(context).actionLogIn,
      items: _buildFormItems(),
      onSubmitted: (Map<String, String> fields) async {
        var result = await authProvider.signIn(
          email: fields[S.of(context).labelEmail] +
              S.of(context).stringEmailDomain,
          password: fields[S.of(context).labelPassword],
          context: context,
        );
        if (result) {
          Navigator.pushReplacementNamed(context, Routes.home);
        }
      },
      trailing: <Widget>[
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            InkWell(
                child: Text(
                  S.of(context).actionResetPassword,
                  style: Theme.of(context)
                      .accentTextTheme
                      .subtitle1
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  showDialog(context: context, builder: _resetPasswordDialog);
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                })
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    AppForm loginForm = _buildForm(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Align(
            alignment: FractionalOffset.topRight,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Container(
                  height: MediaQuery.of(context).size.height / 3,
                  child: Image.asset(
                      "assets/illustrations/undraw_digital_nomad.png")),
            ),
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height / 4,
              maxWidth: MediaQuery.of(context).size.width,
              ),
              child: FittedBox(
                fit:BoxFit.contain,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 1,
                    minHeight: 1,
                  ),
                  child: Image.asset("assets/images/city_doodle.png",
                      color: Theme.of(context).accentColor.withOpacity(0.4)),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 28.0, right: 28.0, bottom: 8.0),
              child: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          UniBanner(),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(child: loginForm),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: AppButton(
                            key: ValueKey('log_in_anonymously_button'),
                            text: S.of(context).actionLogInAnonymously,
                            onTap: () async {
                              var result = await authProvider.signInAnonymously(
                                  context: context);
                              if (result) {
                                Navigator.pushReplacementNamed(
                                    context, Routes.home);
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: AppButton(
                            key: ValueKey('log_in_button'),
                            color: Theme.of(context).accentColor,
                            text: S.of(context).actionLogIn,
                            onTap: () => loginForm.submit(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          S.of(context).messageNewUser + " ",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, Routes.signUp);
                          },
                          child: Text(S.of(context).actionSignUp,
                              style: Theme.of(context)
                                  .accentTextTheme
                                  .subtitle1
                                  .copyWith(fontWeight: FontWeight.w500)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
