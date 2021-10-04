import 'package:flutter/foundation.dart';

/// This is a stub implementation of the `Platform` class in dart:io, for use
/// when dart:io is not available (e.g. on web).
class Platform {
  static Map<String, String> environment = {};

  static bool isAndroid = false, isIOS = false;
  static bool isWeb = kIsWeb &&
      defaultTargetPlatform != TargetPlatform.iOS &&
      defaultTargetPlatform != TargetPlatform.android;
}
