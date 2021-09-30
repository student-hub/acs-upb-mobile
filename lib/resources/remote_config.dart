import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

const String _feedbackEnabled = 'feedback_enabled';
const String _chatEnabled = 'chat_enabled';

class RemoteConfigService {
  RemoteConfigService._();

  static RemoteConfig _remoteConfig;
  static final defaults = <String, dynamic>{
    _feedbackEnabled: false,
    _chatEnabled: false
  };
  static Map<String, dynamic> overrides;

  static bool get feedbackEnabled => overrides != null
      ? true
      : _remoteConfig?.getBool(_feedbackEnabled) ?? defaults[_feedbackEnabled];

  static bool get chatEnabled => overrides != null
      ? true
      : _remoteConfig?.getBool(_chatEnabled) ?? defaults[_chatEnabled];

  static Future<dynamic> initialize() async {
    if (kIsWeb) return; // Remote config is not yet supported on web.
    try {
      _remoteConfig = RemoteConfig.instance;
      await _remoteConfig.setDefaults(defaults);
      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      print(
          'Unable to fetch remote config. Cached or default values will be used.');
    }
    // Does not work on web
  }
}
