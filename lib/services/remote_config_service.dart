import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  Future<String> getString({required String key}) async {
    FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    return remoteConfig.getString(key);
  }
}
