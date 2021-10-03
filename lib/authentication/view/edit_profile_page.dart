import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pref/pref.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../pages/filter/view/filter_dropdown.dart';
import '../../resources/utils.dart';
import '../../resources/validator.dart';
import '../../widgets/button.dart';
import '../../widgets/circle_image.dart';
import '../../widgets/dialog.dart';
import '../../widgets/icon_text.dart';
import '../../widgets/scaffold.dart';
import '../../widgets/toast.dart';
import '../../widgets/upload_button.dart';
import '../model/user.dart';
import '../service/auth_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final dropdownController = FilterDropdownController();

  final formKey = GlobalKey<FormState>();

  ImageProvider imageWidget;

  UploadButtonController uploadButtonController;

  // Whether the user verified their email; this can be true, false or null if
  // the async check hasn't completed yet.
  bool isVerified;
  bool correctPassword;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.isVerified.then((value) => setState(() => isVerified = value));
    authProvider.getProfilePictureURL().then((value) => setState(() => {
          imageWidget = value != null
              ? NetworkImage(value)
              : const AssetImage('assets/illustrations/undraw_profile_pic.png'),
        }));
    uploadButtonController =
        UploadButtonController(onUpdate: () => setState(() => {}));
  }

  AppDialog _changePasswordDialog(BuildContext context) {
    final newPasswordController = TextEditingController();
    final oldPasswordController = TextEditingController();
    final changePasswordKey = GlobalKey<FormState>();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return AppDialog(
      title: S.current.actionChangePassword,
      content: [
        Form(
          key: changePasswordKey,
          child: Column(
            children: [
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: S.current.labelOldPassword,
                  hintText: S.current.hintPassword,
                  errorMaxLines: 2,
                ),
                controller: oldPasswordController,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return S.current.errorNoPassword;
                  }
                  if (!correctPassword) {
                    return S.current.errorIncorrectPassword;
                  }
                  return null;
                },
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: S.current.labelNewPassword,
                  hintText: S.current.hintPassword,
                  errorMaxLines: 2,
                ),
                controller: newPasswordController,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return S.current.errorNoPassword;
                  }
                  if (value == oldPasswordController.text) {
                    return S.current.warningSamePassword;
                  }
                  final result = AppValidator.isStrongPassword(value);
                  if (result != null) {
                    return result;
                  }
                  return null;
                },
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: S.current.labelConfirmNewPassword,
                  hintText: S.current.hintPassword,
                  errorMaxLines: 2,
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return S.current.errorNoPassword;
                  }
                  if (value != newPasswordController.text) {
                    return S.current.errorPasswordsDiffer;
                  }
                  return null;
                },
              ),
            ],
          ),
        )
      ],
      actions: [
        AppButton(
          key: const ValueKey('change_password_button'),
          text: S.current.actionChangePassword.toUpperCase(),
          color: Theme.of(context).primaryColor,
          width: 130,
          onTap: () async {
            correctPassword =
                await authProvider.verifyPassword(oldPasswordController.text);
            if (changePasswordKey.currentState.validate()) {
              if (correctPassword) {
                if (await authProvider
                    .changePassword(newPasswordController.text)) {
                  AppToast.show(S.current.messageChangePasswordSuccess);
                  if (!mounted) return;
                  Navigator.pop(context);
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
    return AppDialog(
      icon: const Icon(Icons.warning_amber_outlined, color: Colors.red),
      title: S.current.actionDeleteAccount,
      message:
          '${S.current.messageDeleteAccount} ${S.current.messageCannotBeUndone}',
      content: [
        TextFormField(
          decoration: InputDecoration(
            labelText: S.current.labelConfirmPassword,
            hintText: S.current.hintPassword,
          ),
          obscureText: true,
          controller: passwordController,
        )
      ],
      actions: [
        AppButton(
          key: const ValueKey('delete_account_button'),
          text: S.current.actionDeleteAccount.toUpperCase(),
          color: Colors.red,
          width: 130,
          onTap: () async {
            final authProvider =
                Provider.of<AuthProvider>(context, listen: false);
            if (await authProvider.verifyPassword(passwordController.text)) {
              if (await authProvider.delete()) {
                await Utils.signOut(context);
              }
            }
          },
        )
      ],
    );
  }

  AppDialog _changeEmailConfirmationDialog(BuildContext context) {
    final passwordController = TextEditingController();
    return AppDialog(
      title: S.current.actionChangeEmail,
      message: S.current.messageChangeEmail(
          emailController.text + S.current.stringEmailDomain),
      content: [
        TextFormField(
          decoration: InputDecoration(
            labelText: S.current.labelConfirmPassword,
            hintText: S.current.hintPassword,
          ),
          obscureText: true,
          controller: passwordController,
        ),
      ],
      actions: [
        AppButton(
          key: const ValueKey('change_email_button'),
          text: S.current.actionChangeEmail,
          color: Theme.of(context).primaryColor,
          width: 130,
          onTap: () async {
            final authProvider =
                Provider.of<AuthProvider>(context, listen: false);
            if (await authProvider.verifyPassword(passwordController.text)) {
              if (await authProvider.changeEmail(
                  emailController.text + S.current.stringEmailDomain)) {
                AppToast.show(S.current.messageChangeEmailSuccess);
                Navigator.pop(context, true);
              } else {
                Navigator.pop(context, false);
              }
            }
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final emailDomain = S.current.stringEmailDomain;
    final User user = authProvider.currentUserFromCache;

    if (user == null) {
      // TODO(AdrianMargineanu): Show error page if user is not authenticated
      return Container();
    }

    lastNameController.text = user.lastName;
    firstNameController.text = user.firstName;
    Uint8List imageAsPNG;
    if (isVerified == false) {
      emailController.text = authProvider.email.split('@')[0];
    }
    final path = user.classes;

    return AppScaffold(
      title: Text(S.current.actionEditProfile),
      needsToBeAuthenticated: true,
      actions: [
        AppScaffoldAction(
            text: S.current.buttonSave,
            onPressed: () async {
              final Map<String, dynamic> info = {
                S.current.labelFirstName: firstNameController.text,
                S.current.labelLastName: lastNameController.text,
              };
              if (dropdownController.path != null) {
                info['class'] = dropdownController.path;
              }

              if (formKey.currentState.validate()) {
                bool result = true;
                if (isVerified == false &&
                    emailController.text + emailDomain != authProvider.email) {
                  await showDialog<bool>(
                    context: context,
                    builder: _changeEmailConfirmationDialog,
                  ).then((value) => result = value ?? false);
                }
                if (uploadButtonController.newUploadedImageBytes != null) {
                  imageAsPNG = await Utils.convertToPNG(
                      uploadButtonController.newUploadedImageBytes);
                  result = await authProvider.uploadProfilePicture(imageAsPNG);
                }
                if (result) {
                  if (await authProvider.updateProfile(info)) {
                    AppToast.show(S.current.messageEditProfileSuccess);
                    if (!mounted) return;
                    Navigator.pop(context);
                  }
                }
              }
            }),
        AppScaffoldAction(
          icon: Icons.more_vert_outlined,
          items: {
            S.current.actionChangePassword: () => showDialog<dynamic>(
                context: context, builder: _changePasswordDialog),
            S.current.actionDeleteAccount: () => showDialog<dynamic>(
                context: context, builder: _deletionConfirmationDialog)
          },
        )
      ],
      body: Container(
        child: ListView(padding: const EdgeInsets.all(12), children: [
          AccountNotVerifiedWarning(),
          Padding(
            padding: const EdgeInsets.all(10),
            child: CircleImage(
              circleSize: 150,
              image: uploadButtonController.uploadImageBytes != null
                  ? MemoryImage(uploadButtonController.newUploadedImageBytes)
                  : imageWidget,
            ),
          ),
          const SizedBox(height: 10),
          UploadButton(pageType: true, controller: uploadButtonController),
          PrefTitle(
            title: Text(S.current.labelPersonalInformation),
            padding: const EdgeInsets.only(left: 0, bottom: 0, top: 20),
          ),
          const SizedBox(height: 10),
          Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outlined),
                    labelText: S.current.labelFirstName,
                    hintText: S.current.hintFirstName,
                  ),
                  controller: firstNameController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return S.current.errorMissingFirstName;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outlined),
                    labelText: S.current.labelLastName,
                    hintText: S.current.hintLastName,
                  ),
                  controller: lastNameController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return S.current.errorMissingLastName;
                    }
                    return null;
                  },
                ),
                if (isVerified == false)
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.alternate_email_outlined),
                      labelText: S.current.labelEmail,
                      hintText: S.current.hintEmail,
                      suffix: Text(emailDomain),
                    ),
                    controller: emailController,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return S.current.errorMissingLastName;
                      }
                      return null;
                    },
                  )
              ],
            ),
          ),
          const SizedBox(height: 10),
          PrefTitle(
            title: Text(S.current.labelClass),
            padding: const EdgeInsets.only(left: 0, bottom: 0, top: 20),
          ),
          FilterDropdown(
            initialPath: path,
            controller: dropdownController,
            leftPadding: 10,
            textStyle: Theme.of(context)
                .textTheme
                .caption
                .apply(color: Theme.of(context).hintColor),
          ),
        ]),
      ),
    );
  }
}

class AccountNotVerifiedWarning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (!authProvider.isAuthenticated || authProvider.isAnonymous) {
      return Container();
    }

    return FutureBuilder(
      future: authProvider.isVerified,
      builder: (context, snap) {
        if (!snap.hasData || snap.data) {
          return Container();
        }
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconText(
                align: TextAlign.center,
                icon: Icons.error_outlined,
                text: S.current.messageEmailNotVerified,
                actionText: S.current.actionSendVerificationAgain,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: Theme.of(context).hintColor),
                onTap: authProvider.sendEmailVerification,
              ),
            ],
          ),
        );
      },
    );
  }
}
