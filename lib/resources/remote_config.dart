import 'package:firebase_remote_config/firebase_remote_config.dart';

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
    try {
      _remoteConfig = await RemoteConfig.instance;
      await _remoteConfig.setDefaults(defaults);
      await _remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await _remoteConfig.activateFetched();
    } on FetchThrottledException catch (e) {
      print('Remote config fetch throttled: $e');
    } catch (e) {
      print(
          'Unable to fetch remote config. Cached or default values will be used.');
    }
  }
}
