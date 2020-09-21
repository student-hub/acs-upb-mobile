import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/routes.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

class Utils {
  Utils._();

  static launchURL(String url, {BuildContext context}) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      if (context != null) {
        AppToast.show(S.of(context).errorCouldNotLaunchURL(url));
      }
    }
  }

  static Future<void> signOut(BuildContext context) async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    authProvider.signOut(context);
    Navigator.pushNamedAndRemoveUntil(context, Routes.login, (route) => false);
  }
}
