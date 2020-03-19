import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/authentication/view/recover_password_dialog.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/routes.dart';
import 'package:acs_upb_mobile/resources/banner.dart';
import 'package:acs_upb_mobile/widgets/button.dart';
import 'package:acs_upb_mobile/widgets/form/form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    formItems = <FormItem>[
      FormItem(
        label: S.of(context).labelEmail,
        hint: S.of(context).hintEmail,
        suffix: S.of(context).stringEmailDomain,
        controller: emailController,
        check: (email) => authProvider.canSignInWithPassword(
            email: email + S.of(context).stringEmailDomain),
      ),
      FormItem(
        label: S.of(context).labelPassword,
        hint: S.of(context).hintPassword,
        obscureText: true,
      ),
    ];
    return formItems;
  }

  AppForm _buildForm(BuildContext context) {
    AuthProvider authProvider = Provider.of(context);

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
          height: ScreenUtil().setHeight(35),
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
                  ResetPassword.show(
                      context: context, email: emailController.text);
                  // Remove text field from focus if necessary
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
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    AppForm loginForm = _buildForm(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Align(
            alignment: FractionalOffset.topRight,
            child: Padding(
              padding: EdgeInsets.only(top: 5.0, right: 10.0),
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 1.4,
                    maxHeight: MediaQuery.of(context).size.height -
                        ScreenUtil().setHeight(380),
                  ),
                  child: Image.asset(
                      "assets/illustrations/undraw_digital_nomad.png")),
            ),
          ),
          Align(
            alignment: FractionalOffset.bottomRight,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 4),
              child: Image.asset("assets/images/city_doodle.png",
                  color: Theme.of(context).accentColor.withOpacity(0.4)),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 28.0, right: 28.0, bottom: 8.0),
              child: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: ScreenUtil.screenWidth > ScreenUtil.screenHeight
                          ? MediaQuery.of(context).size.height / 2
                          : MediaQuery.of(context).size.width / 1.62,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          UniBanner(),
                        ],
                      ),
                    ),
                    Expanded(child: loginForm),
                    SizedBox(height: ScreenUtil().setHeight(40)),
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
                        SizedBox(width: ScreenUtil().setWidth(30)),
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
                      height: ScreenUtil().setHeight(50),
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
