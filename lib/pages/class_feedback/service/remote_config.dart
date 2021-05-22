import 'package:firebase_remote_config/firebase_remote_config.dart';

const String _feedbackEnabled = 'feedback_enabled';

class RemoteConfigService {
  RemoteConfigService({RemoteConfig remoteConfig})
      : _remoteConfig = remoteConfig;
  final RemoteConfig _remoteConfig;
  final defaults = <String, dynamic>{_feedbackEnabled: false};
  static RemoteConfigService _instance;

  static Future<RemoteConfigService> getInstance() async {
    return _instance ??= RemoteConfigService(
      remoteConfig: await RemoteConfig.instance,
    );
  }

  bool get feedbackEnabled => _remoteConfig.getBool(_feedbackEnabled);

  Future<dynamic> initialise() async {
    try {
      await _remoteConfig.setDefaults(defaults);
      await _fetchAndActivate();
    } on FetchThrottledException catch (e) {
      print('Remote config fetch throttled: $e');
    } catch (e) {
      print(
          'Unable to fetch remote config. Cached or default values will be used.');
    }
  }

  Future<dynamic> _fetchAndActivate() async {
    await _remoteConfig.fetch();
    await _remoteConfig.activateFetched();
  }
}
