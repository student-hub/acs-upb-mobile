import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';

import '../../generated/l10n.dart';
import '../../navigation/routes.dart';
import '../../pages/filter/view/filter_dropdown.dart';
import '../../resources/banner.dart';
import '../../resources/theme.dart';
import '../../resources/utils.dart';
import '../../resources/validator.dart';
import '../../widgets/button.dart';
import '../../widgets/form_card.dart';
import '../../widgets/toast.dart';
import '../service/auth_provider.dart';

class SignUpView extends StatefulWidget {
  static const String routeName = '/signup';

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  List<FormCardField> formItems;

  bool agreedToPolicy = false;

  final dropdownController = FilterDropdownController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  /// Attempt to guess the user's first and last name from the email, since
  /// university e-mail addresses are standardized.
  ///
  /// Special characters such as ".", "_" are used to separate the names,
  /// numbers are removed and names are capitalized.
  /// *Format example:* firstnameone_firstnametwo.lastname123@stud.acs.pub.ro
  void parseNameFromEmail(TextEditingController email,
      TextEditingController firstName, TextEditingController lastName) {
    final emailWithoutNumbers =
        email.text.replaceAll(RegExp('[^a-zA-Z._]'), '');
    final names = emailWithoutNumbers.split('.');

    if (names.isNotEmpty) {
      if (!names[0].contains('_')) {
        firstName.text = names[0].titleCase;
      } else {
        final firstNames = names[0].split('_');
        firstName.text = firstNames.map((s) => s.titleCase).join(' ');
      }

      if (names.length > 1) {
        lastName.text = names[1].titleCase;
      }
    }
  }

  List<FormCardField> _buildFormItems() {
    // Only build them once to avoid the cursor staying everywhere
    if (formItems != null) {
      return formItems;
    }
    final emailDomain = S.current.stringEmailDomain;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return formItems = <FormCardField>[
      FormCardField(
        label: S.current.labelEmail,
        hint: S.current.hintEmail,
        additionalHint: S.current.infoEmail(S.current.stringForum),
        controller: emailController,
        suffix: emailDomain,
        autocorrect: false,
        autofillHints: [AutofillHints.newUsername],
        check: (email, {showToast}) => authProvider
            .canSignUpWithEmail(email + emailDomain, showToast: showToast),
        onChanged: (_) => parseNameFromEmail(
            emailController, firstNameController, lastNameController),
      ),
      FormCardField(
          label: S.current.labelPassword,
          hint: S.current.hintPassword,
          additionalHint: S.current.infoPassword,
          controller: passwordController,
          obscureText: true,
          autofillHints: [AutofillHints.newPassword],
          check: (password, {showToast}) async {
            final errorString = AppValidator.isStrongPassword(password);
            if (showToast && errorString != null) {
              AppToast.show(errorString);
            }
            return errorString == null;
          }),
      FormCardField(
        label: S.current.labelConfirmPassword,
        hint: S.current.hintPassword,
        obscureText: true,
        check: (password, {showToast}) async {
          final bool ok = password == passwordController.text;
          if (!ok && showToast) {
            AppToast.show(S.current.errorPasswordsDiffer);
          }
          return ok;
        },
      ),
      FormCardField(
          label: S.current.labelFirstName,
          hint: S.current.hintFirstName,
          controller: firstNameController,
          autofillHints: [AutofillHints.givenName]),
      FormCardField(
          label: S.current.labelLastName,
          hint: S.current.hintLastName,
          controller: lastNameController,
          autofillHints: [AutofillHints.familyName]),
    ];
  }

  Widget _privacyPolicy() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Checkbox(
            value: agreedToPolicy,
            visualDensity: VisualDensity.compact,
            onChanged: (value) => setState(() => agreedToPolicy = value),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                  style: Theme.of(context).textTheme.subtitle1,
                  children: [
                    TextSpan(text: S.current.messageIAgreeToThe),
                    TextSpan(
                        text: S.current.labelPrivacyPolicy,
                        style: Theme.of(context)
                            .coloredTextTheme
                            .subtitle1
                            .apply(fontWeightDelta: 2),
                        recognizer: TapGestureRecognizer()
                          ..onTap =
                              () => Utils.launchURL(Utils.privacyPolicyURL)),
                    const TextSpan(text: '.'),
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  FormCard _buildForm(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return FormCard(
      title: S.current.actionSignUp,
      fields: _buildFormItems(),
      trailing: <Widget>[
        FilterDropdown(controller: dropdownController),
        _privacyPolicy()
      ],
      submitOnEnter: false,
      onSubmitted: (fields) async {
        if (!agreedToPolicy) {
          AppToast.show(
              '${S.current.warningAgreeTo}${S.current.labelPrivacyPolicy}.');
          return;
        }

        fields[S.current.labelEmail] += S.current.stringEmailDomain;

        if (dropdownController.path != null &&
            dropdownController.path.length > 1) {
          fields['class'] = dropdownController.path;
        }

        final result = await authProvider.signUp(fields);

        if (result) {
          if (!mounted) {
            return;
          }
          // Remove all routes below and push home page
          await Navigator.pushNamedAndRemoveUntil(
              context, Routes.home, (route) => false);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final signUpForm = _buildForm(context);

    return GestureDetector(
      onTap: () {
        // Remove current focus on tap
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Align(
              alignment: FractionalOffset.topRight,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                    height: MediaQuery.of(context).size.height / 3 - 20,
                    child: Image.asset(
                        'assets/illustrations/undraw_personal_information.png')),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 28, right: 28, bottom: 10),
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
                      Expanded(child: signUpForm),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: AppButton(
                              key: const ValueKey('cancel_button'),
                              text: S.current.buttonCancel,
                              onTap: () async {
                                return Navigator.pop(context);
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: AppButton(
                              key: const ValueKey('sign_up_button'),
                              color: Theme.of(context).primaryColor,
                              text: S.current.actionSignUp,
                              onTap: () => signUpForm.submit(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
