import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/model/routes.dart';
import 'package:acs_upb_mobile/navigation/service/app_navigator.dart';
import 'package:acs_upb_mobile/resources/banner.dart';
import 'package:acs_upb_mobile/widgets/button.dart';
import 'package:acs_upb_mobile/widgets/dialog.dart';
import 'package:acs_upb_mobile/widgets/form_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  static const String routeName = '/login';

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  var emailController = TextEditingController();
  List<FormCardField> formItems;

  List<FormCardField> _buildFormItems() {
    // Only build them once to avoid the cursor staying everywhere
    if (formItems != null) {
      return formItems;
    }
    final emailDomain = S.current.stringEmailDomain;

    final authProvider = Provider.of<AuthProvider>(context);
    return formItems = <FormCardField>[
      FormCardField(
        label: S.current.labelEmail,
        hint: S.current.hintEmail,
        suffix: emailDomain,
        controller: emailController,
        autocorrect: false,
        autofillHints: [AutofillHints.username],
        check: (email, {showToast}) => authProvider
            .canSignInWithPassword(email + emailDomain, showToast: showToast),
      ),
      FormCardField(
        label: S.current.labelPassword,
        hint: S.current.hintPassword,
        obscureText: true,
        autofillHints: [AutofillHints.password],
      ),
    ];
  }

  AppDialog _resetPasswordDialog(BuildContext context) => AppDialog(
        title: S.current.actionResetPassword,
        message: S.current.messageResetPassword,
        content: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  key: const ValueKey('reset_password_email_text_field'),
                  controller: emailController,
                  decoration: InputDecoration(hintText: S.current.hintEmail),
                ),
              ),
              const SizedBox(width: 4),
              Text(S.current.stringEmailDomain,
                  style: Theme.of(context).inputDecorationTheme.suffixStyle),
            ],
          )
        ],
        actions: [
          AppButton(
            key: const ValueKey('send_email_button'),
            text: S.current.actionSendEmail.toUpperCase(),
            width: 130,
            onTap: () async {
              final success =
                  await Provider.of<AuthProvider>(context, listen: false)
                      .sendPasswordResetEmail(
                          emailController.text + S.current.stringEmailDomain);
              if (success) {
                AppNavigator.pop(context);
              }
              return;
            },
          ),
        ],
      );

  FormCard _buildForm(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return FormCard(
      title: S.current.actionLogIn,
      fields: _buildFormItems(),
      onSubmitted: (fields) async {
        final result = await authProvider.signIn(
          fields[S.current.labelEmail] + S.current.stringEmailDomain,
          fields[S.current.labelPassword],
        );
        if (result) {
          await AppNavigator.pushReplacementNamed(context, Routes.home);
        }
      },
      trailing: <Widget>[
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            InkWell(
                child: Text(
                  S.current.actionResetPassword,
                  style: Theme.of(context)
                      .accentTextTheme
                      .subtitle1
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  showDialog(context: context, builder: _resetPasswordDialog);
                  final currentFocus = FocusScope.of(context);
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
    final authProvider = Provider.of<AuthProvider>(context);
    final loginForm = _buildForm(context);

    return GestureDetector(
      onTap: () {
        // Remove current focus on tap
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Align(
                  alignment: FractionalOffset.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                        height: MediaQuery.of(context).size.height / 3,
                        child: Image.asset(
                            'assets/illustrations/undraw_digital_nomad.png')),
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
                      fit: BoxFit.contain,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 1,
                          minHeight: 1,
                        ),
                        child: Image.asset('assets/images/city_doodle.png',
                            color:
                                Theme.of(context).accentColor.withOpacity(0.4)),
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 28, right: 28, bottom: 10),
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
                          const SizedBox(height: 10),
                          Expanded(child: loginForm),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: AppButton(
                                  key: const ValueKey(
                                      'log_in_anonymously_button'),
                                  text: S.current.actionLogInAnonymously,
                                  onTap: () async {
                                    final result =
                                        await authProvider.signInAnonymously();
                                    if (result) {
                                      await AppNavigator.pushReplacementNamed(
                                          context, Routes.home);
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: AppButton(
                                  key: const ValueKey('log_in_button'),
                                  color: Theme.of(context).accentColor,
                                  text: S.current.actionLogIn,
                                  onTap: () => loginForm.submit(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '${S.current.messageNewUser} ',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(fontWeight: FontWeight.w400),
                              ),
                              InkWell(
                                onTap: () {
                                  AppNavigator.pushNamed(context, Routes.signUp);
                                },
                                child: Text(S.current.actionSignUp,
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
          ),
        ),
      ),
    );
  }
}
