import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as im;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pedantic/pedantic.dart';
import 'package:pref/pref.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../authentication/service/auth_provider.dart';
import '../generated/l10n.dart';
import '../navigation/routes.dart';
import '../widgets/toast.dart';

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

PrefServiceShared prefService;

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
    unawaited(Navigator.pushNamedAndRemoveUntil(
        context, Routes.login, (route) => false));
    unawaited(authProvider.signOut());
  }

  static String wrapUrlWithCORS(String url) {
    return '${Utils.corsProxyUrl}/$url';
  }

  static PackageInfo packageInfo = PackageInfo(
    version: '\$version',
    buildNumber: '\$buildNumber',
    appName: '\$appName',
    packageName: '\$packageName',
  );

  static Future<Uint8List> convertToPNG(Uint8List image) async {
    final decodedImage = im.decodeImage(image);
    return im.encodePng(im.copyResizeCropSquare(decodedImage, 500));
  }
}
