import 'package:firebase_remote_config/firebase_remote_config.dart';

const String _feedbackEnabled = 'feedback_enabled';

class RemoteConfigService {
  static RemoteConfig _remoteConfig;
  static final defaults = <String, dynamic>{_feedbackEnabled: false};
  static RemoteConfigService _instance;
  static Map<String, dynamic> overrides;

  static bool get feedbackEnabled => overrides != null
      ? true
      : _remoteConfig?.getBool(_feedbackEnabled) ?? defaults[_feedbackEnabled];

  Future<dynamic> initialise() async {
    try {
      _instance ??= RemoteConfigService();
      _remoteConfig = await RemoteConfig.instance;
      await _remoteConfig.setDefaults(defaults);
      await _remoteConfig.fetch();
      await _remoteConfig.activateFetched();
    } on FetchThrottledException catch (e) {
      print('Remote config fetch throttled: $e');
    } catch (e) {
      print(
          'Unable to fetch remote config. Cached or default values will be used.');
    }
  }
}
