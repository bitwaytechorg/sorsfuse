import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Map<String, dynamic> lang ={};
String APP_TITLE="";

// Collections
String userCollection="users";
String audienceCollection="audience";

final actionCodeSettings = ActionCodeSettings(
  url: 'https://mrs-jacked.firebaseapp.com',
  handleCodeInApp: true,
  androidMinimumVersion: '1',
  // androidPackageName: 'io.flutter.plugins.firebase_ui.firebase_ui_example',
  // iOSBundleId: 'io.flutter.plugins.fireabaseUiExample',
);