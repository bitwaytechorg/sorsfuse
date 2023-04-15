import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'firebase_config.dart';
import 'package:sorsfuse/global/global.dart' as GLOBAL;

Future<FirebaseRemoteConfig> setupRemoteConfig() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseConfig.platformOptions,
  );
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 3),
    minimumFetchInterval: const Duration(seconds: 1),
  ));

  print(remoteConfig.getString("en"));
  GLOBAL.APP_TITLE = remoteConfig.getString("app_title");

  RemoteConfigValue(null, ValueSource.valueStatic);
  return remoteConfig;

}