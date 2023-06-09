import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'firebase_config.dart';
import 'package:sorsfuse/global/global.dart' as GLOBAL;
import 'package:sorsfuse/config/config.dart' as CONFIG;

Future<FirebaseRemoteConfig> setupRemoteConfig() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseConfig.platformOptions,
  );
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 3),
    minimumFetchInterval: const Duration(seconds: 0),
  ));
  await remoteConfig.fetchAndActivate();
  GLOBAL.APP_TITLE = remoteConfig.getString("app_title");
  CONFIG.facebook_app_id = remoteConfig.getString("facebook_app_id");
  CONFIG.facebook_app_secret = remoteConfig.getString("facebook_app_secret");


  RemoteConfigValue(null, ValueSource.valueStatic);
  return remoteConfig;

}