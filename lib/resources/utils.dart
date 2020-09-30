import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/routes.dart';
import 'package:acs_upb_mobile/pages/filter/service/filter_provider.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:pedantic/pedantic.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  Utils._();

  static Future<void> launchURL(String url, {BuildContext context}) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      if (context != null) {
        AppToast.show(S.of(context).errorCouldNotLaunchURL(url));
      }
    }
  }

  static Future<void> signOut(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final filterProvider = Provider.of<FilterProvider>(context, listen: false);
    unawaited(Navigator.pushNamedAndRemoveUntil(
        context, Routes.login, (route) => false));
    unawaited(authProvider.signOut());
    filterProvider.resetFilter();
  }
}
