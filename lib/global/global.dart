import 'package:firebase_auth/firebase_auth.dart';

Map<String, dynamic> lang ={};

final actionCodeSettings = ActionCodeSettings(
  url: 'https://mrs-jacked.firebaseapp.com',
  handleCodeInApp: true,
  androidMinimumVersion: '1',
  // androidPackageName: 'io.flutter.plugins.firebase_ui.firebase_ui_example',
  // iOSBundleId: 'io.flutter.plugins.fireabaseUiExample',
);