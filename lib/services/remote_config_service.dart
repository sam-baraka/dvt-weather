import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  Future<String> getString({required String key}) async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(seconds: 1),
      ));
      await remoteConfig.fetchAndActivate();
      var apiKey = remoteConfig.getString(key);
      return apiKey;
    } catch (e) {
      rethrow;
    }
  }
}
