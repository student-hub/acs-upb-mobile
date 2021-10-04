import 'dart:typed_data';

import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/model/routes.dart';
import 'package:acs_upb_mobile/navigation/service/navigator.dart';
import 'package:acs_upb_mobile/resources/platform.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as im;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pedantic/pedantic.dart';
import 'package:provider/provider.dart';
import 'package:time_machine/time_machine.dart';
import 'package:url_launcher/url_launcher.dart';

export 'package:acs_upb_mobile/resources/platform.dart'
    if (dart.library.io) 'dart:io';

Iterable<int> range(int low, int high) sync* {
  for (int i = low; i < high; ++i) {
    yield i;
  }
}

extension IterableUtils<E> on Iterable<E> {
  Iterable<E> whereIndex(bool Function(int index) test) sync* {
    int i = 0;
    for (final e in this) {
      if (test(i++)) yield e;
    }
  }
}

extension EnumUtils on Object {
  String toShortString() {
    return toString().split('.').last;
  }
}

class Utils {
  Utils._();

  static String privacyPolicyURL =
      'https://www.websitepolicies.com/policies/view/IIUFv381';
  static String repoURL = 'https://github.com/student-hub/acs-upb-mobile';
  static const String corsProxyUrl = 'https://cors-anywhere.herokuapp.com';

  static Future<void> launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      AppToast.show(S.current.errorCouldNotLaunchURL(url));
    }
  }

  static Future<void> signOut(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // TODO(IoanaAlexandru): Might actually be better to use the same login on mobile?
    if (Platform.isWeb) {
      await authProvider.signOut();
      unawaited(AppNavigator.pushNamedAndRemoveUntil(
          context, Routes.login, (route) => false));
    } else {
      unawaited(AppNavigator.pushNamedAndRemoveUntil(
          context, Routes.login, (route) => false));
      unawaited(authProvider.signOut());
    }
  }

  static String wrapUrlWithCORS(String url) {
    return '${Utils.corsProxyUrl}/$url';
  }

  static PackageInfo packageInfo = PackageInfo(
      version: 'Unknown', buildNumber: 'Unknown', appName: 'Unknown');

  static Future<Uint8List> convertToPNG(Uint8List image) async {
    final decodedImage = im.decodeImage(image);
    return im.encodePng(im.copyResizeCropSquare(decodedImage, 500));
  }
}

extension PeriodExtension on Period {
  Duration toDuration() {
    return Duration(hours: hours, minutes: minutes);
  }
}
