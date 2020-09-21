import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/authentication/view/dropdown_tree.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:acs_upb_mobile/resources/validator.dart';
import 'package:acs_upb_mobile/widgets/button.dart';
import 'package:acs_upb_mobile/widgets/dialog.dart';
import 'package:acs_upb_mobile/widgets/icon_text.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:preferences/preference_title.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final dropdownController = DropdownTreeController();

  final formKey = GlobalKey<FormState>();

  AppDialog _changePasswordDialog(BuildContext context) {
    final newPasswordController = TextEditingController();
    final oldPasswordController = TextEditingController();
    final changePasswordKey = GlobalKey<FormState>();
    return AppDialog(
      title: S
          .of(context)
          .actionChangePassword,
      content: [
        Form(
          key: changePasswordKey,
          child: Column(
            children: [
              TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: S
                        .of(context)
                        .labelOldPassword,
                    hintText: S
                        .of(context)
                        .hintPassword,
                  ),
                  controller: oldPasswordController,
                  validator: (value) {
                    if (value.isEmpty || value == null) {
                      return S
                          .of(context)
                          .errorNoPassword;
                    }
                    return null;
                  }),
              TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: S
                        .of(context)
                        .labelNewPassword,
                    hintText: S
                        .of(context)
                        .hintPassword,
                  ),
                  controller: newPasswordController,
                  validator: (value) {
                    if (value.isEmpty || value == null) {
                      return S
                          .of(context)
                          .errorNoPassword;
                    }
                    return null;
                  }),
              TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: S
                        .of(context)
                        .labelConfirmNewPassword,
                    hintText: S
                        .of(context)
                        .hintPassword,
                  ),
                  validator: (value) {
                    if (value.isEmpty || value == null) {
                      return S
                          .of(context)
                          .errorNoPassword;
                    }
                    if (value != newPasswordController.text) {
                      return S
                          .of(context)
                          .errorPasswordsDiffer;
                    }
                    return null;
                  }),
            ],
          ),
        )
      ],
      actions: [
        AppButton(
          key: ValueKey('change_password_button'),
          text: S
              .of(context)
              .actionChangePassword
              .toUpperCase(),
          color: Colors.lightBlue,
          width: 130,
          onTap: () async {
            if (changePasswordKey.currentState.validate()) {
              AuthProvider authProvider =
              Provider.of<AuthProvider>(context, listen: false);
              if (await authProvider.verifyPassword(
                  password: oldPasswordController.text, context: context)) {
                if (await AppValidator.isStrongPassword(
                    password: newPasswordController.text, context: context)) {
                  bool res = await authProvider.changePassword(
                      password: newPasswordController.text, context: context);
                  if (res) {
                    Navigator.pop(context);
                  }
                }
              }
            }
          },
        )
      ],
    );
  }

  AppDialog _deletionConfirmationDialog(BuildContext context) {
    final passwordController = TextEditingController();
    return
      AppDialog(
        icon: Icon(Icons.warning, color: Colors.red),
        title: S
            .of(context)
            .actionDeleteAccount,
        message: S
            .of(context)
            .messageDeleteAccount +
            ' ' +
            S
                .of(context)
                .messageCannotBeUndone,
      content: [
        TextFormField(
          decoration: InputDecoration(
            labelText: S.of(context).labelConfirmPassword,
            hintText: S.of(context).hintPassword,
          ),
          obscureText: true,
          controller: passwordController,
        )
      ],  actions: [
          AppButton(
            key: ValueKey('delete_account_button'),
            text: S
                .of(context)
                .actionDeleteAccount
                .toUpperCase(),
            color: Colors.red,
            width: 130,
            onTap: () async {
              AuthProvider authProvider =
              Provider.of<AuthProvider>(context, listen: false);
              if (await authProvider.verifyPassword(
                password: passwordController.text, context: context)) {
              if (await authProvider.delete(context: context)) {
                Utils.signOut(context);
              }
            }
          },
        )
      ],
    );
  }

  AppDialog _changeEmailConfirmationDialog(BuildContext context) =>
      AppDialog(title: 'Confirm Change Email',
        message: 'Are you sure you want to change your mail to' + emailController.text,
        content: [
          TextFormField(
            decoration: InputDecoration(
              labelText: S.of(context).labelConfirmPassword,
              hintText: S.of(context).hintPassword,
            ),
            obscureText: true,
          )
        ],
        actions: [
          AppButton(
            key: ValueKey('change_email_button'),
            text: 'Change email',
            color: Colors.lightBlue,
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    String emailDomain = S
        .of(context)
        .stringEmailDomain;
    return AppScaffold(
      title: S
          .of(context)
          .actionEditProfile,
      actions: [
        AppScaffoldAction(
            text: S
                .of(context)
                .buttonSave,
            onPressed: () async {
              Map<String, dynamic> info = {
                S
                    .of(context)
                    .labelFirstName: firstNameController.text,
                S
                    .of(context)
                    .labelLastName: lastNameController.text,
              };
              if (dropdownController.path != null) {
                info['class'] = dropdownController.path;
              }

              if (formKey.currentState.validate()) {
                bool result = await authProvider.updateProfile(
                  info: info,
                  context: context,
                );
                if (emailController.text != authProvider.email) {

                }

                if (result) {
                  AppToast.show(S
                      .of(context)
                      .messageEditProfileSuccess);
                  Navigator.pop(context);
                }
              }
            }),
        AppScaffoldAction(
          icon: Icons.more_vert,
          items: {
            S
                .of(context)
                .actionChangePassword: () =>
                showDialog(
                    context: context, child: _changePasswordDialog(context)),
            S
                .of(context)
                .actionDeleteAccount: () =>
                showDialog(
                    context: context,
                    child: _deletionConfirmationDialog(context))
          },
        )
      ],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: FutureBuilder(
            future: authProvider.currentUser,
            builder: (BuildContext context, AsyncSnapshot<User> snap) {
              List<String> path;
              if (snap.hasData) {
                User user = snap.data;
                lastNameController.text = user.lastName;
                firstNameController.text = user.firstName;
                if (!authProvider.isVerifiedFromCache) {
                  emailController.text = authProvider.email.substring(
                      0, authProvider.email.length - emailDomain.length);
                }
                path = user.classes;
                return Container(
                  child: ListView(children: [
                    PreferenceTitle(
                      S
                          .of(context)
                          .labelPersonalInformation,
                      leftPadding: 0,
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              labelText: S
                                  .of(context)
                                  .labelFirstName,
                              hintText: S
                                  .of(context)
                                  .hintFirstName,
                            ),
                            controller: firstNameController,
                            validator: (value) {
                              if (value.isEmpty || value == null) {
                                return S
                                    .of(context)
                                    .errorMissingFirstName;
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              labelText: S
                                  .of(context)
                                  .labelLastName,
                              hintText: S
                                  .of(context)
                                  .hintLastName,
                            ),
                            controller: lastNameController,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return S
                                    .of(context)
                                    .errorMissingLastName;
                              }
                              return null;
                            },
                          ),
                          if (!authProvider.isVerifiedFromCache)
                            TextFormField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.alternate_email),
                                labelText: S
                                    .of(context)
                                    .labelEmail,
                                hintText: S
                                    .of(context)
                                    .hintEmail,
                                suffix: Text(emailDomain),
                              ),
                              controller: emailController,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return S
                                      .of(context)
                                      .errorMissingLastName;
                                }
                                return null;
                              },
                            )
                        ],
                      ),
                    ),
                    PreferenceTitle(
                      S
                          .of(context)
                          .labelClass,
                      leftPadding: 0,
                    ),
                    DropdownTree(
                      initialPath: path,
                      controller: dropdownController,
                      leftPadding: 10.0,
                      textStyle: Theme.of(context)
                          .textTheme
                          .caption
                          .apply(color: Theme.of(context).hintColor),
                    )
                    ),
                  ]),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
