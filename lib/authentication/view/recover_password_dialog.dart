import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ResetPassword {
  ResetPassword._();

  static show({BuildContext context, String email}) {
    AuthProvider authProvider = Provider.of(context, listen: false);
    // Set the given email as the starting text, if provided
    TextEditingController emailController =
        TextEditingController(text: email ?? "");

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(S.of(context).actionResetPassword),
              content: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    Expanded(child: Container(height: 6)),
                    Text(S.of(context).messageResetPassword),
                    TextField(
                      controller: emailController,
                      decoration:
                          InputDecoration(hintText: S.of(context).hintEmail),
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    S.of(context).buttonCancel.toUpperCase(),
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                AppButton(
                  text: S.of(context).actionSendEmail.toUpperCase(),
                  width: ScreenUtil().setWidth(200),
                  onTap: () async {
                    bool success = await authProvider.sendPasswordResetEmail(
                        email: emailController.text, context: context);
                    if (success) {
                      Navigator.pop(context);
                    }
                    return;
                  },
                ),
              ],
            ));
  }
}
