import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
}
