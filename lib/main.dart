import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide PhoneAuthProvider, EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sorsfuse/components/auth_builder.dart';
import 'package:sorsfuse/config/firebase_config.dart';
import 'package:sorsfuse/screens/auth/forget_password.dart';
import 'package:sorsfuse/screens/auth/phone.dart';
import 'package:sorsfuse/screens/auth/verify_email.dart';
import 'package:sorsfuse/screens/dashboard.dart';
import 'package:sorsfuse/screens/privacy-policy.dart';
import 'package:sorsfuse/screens/splash.dart';
import 'package:sorsfuse/screens/update_profile.dart';
import 'package:sorsfuse/theme/theme.dart';
import 'config/firebase_remote_config.dart';
import 'package:sorsfuse/global/session.dart' as SESSION;
import 'package:sorsfuse/global/global.dart' as GLOBAL;

final emailLinkProviderConfig=EmailLinkAuthProvider(
  actionCodeSettings: GLOBAL.actionCodeSettings,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    //PhoneAuthProvider(),
    //GoogleProvider(clientId: ),
  ]);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MaterialApp(
    title: "SorsFuse",
     theme: lightTheme,
    // darkTheme: darkTheme,
    routes:  <String, WidgetBuilder>{
      '/privacy-policy': (BuildContext context) => PrivacyPolicy(),
    },
    home: FutureBuilder<FirebaseRemoteConfig>(
      future: setupRemoteConfig(),
      builder: (BuildContext context,
          AsyncSnapshot<FirebaseRemoteConfig> snapshot) {
        return snapshot.hasData
            ? AuthGate(remoteConfig: snapshot.requireData)
            : Splash();
      },
    ),
    debugShowCheckedModeBanner: false,
    locale: const Locale('en', 'US'),
    supportedLocales: const [Locale('en', 'US'),Locale('en', 'IN'),Locale('en', 'GB')],
    localizationsDelegates: [
       FirebaseUILocalizations.withDefaultOverrides(const LabelOverrides()),
       GlobalMaterialLocalizations.delegate,
       GlobalWidgetsLocalizations.delegate,
       GlobalCupertinoLocalizations.delegate,
       FirebaseUILocalizations.delegate,
    ],
  )));
}
class LabelOverrides extends DefaultLocalizations{
  const LabelOverrides();

  @override
  String get emailInputLabel=>'Enter your email';

}
class AuthGate extends StatelessWidget {
  AuthGate({
    required this.remoteConfig,
  });

  final FirebaseRemoteConfig remoteConfig;
  Map<String, dynamic> userData = {};

  @override
  Widget build(BuildContext context) {
    final mfaAction = AuthStateChangeAction<MFARequired>(
          (context, state) async {
        await startMFAVerification(
          context: context,
          resolver: state.resolver,
        );
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      },
    );
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        // if user is already signed-in use it as initial data

        initialData: FirebaseAuth.instance.currentUser,
        builder: (context, snapshot) {
          // waiting for data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Splash();
          } else {
            // user not signed in
            if (snapshot.data == null) {
              return SignInScreen(
                actions: [
                  ForgotPasswordAction((context, email) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ForgetPassword(email: email)));
                  }),
                  VerifyPhoneAction((context, _) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => PhoneLogin()));
                  }),
                  AuthStateChangeAction<SignedIn>((context, state) async {
                    //set session
                    print("login done");

                    if (!state.user!.emailVerified) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VerifyEmail()));
                    } else {
                      await setSession(state.user!.uid);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Dashboard()));
                    }
                  }),
                  AuthStateChangeAction<UserCreated>((context, state) {
                    String email = state.credential.user!.email.toString();
                    FirebaseFirestore.instance
                        .collection(GLOBAL.userCollection)
                        .doc(state.credential.user!.uid)
                        .set({
                      "uid": state.credential.user!.uid,
                      "email":state.credential.user!.email,
                      "displayName":email.substring(0,email.indexOf("@")),
                      "subscription_ends_at":DateTime.now().toUtc(),
                      "audience_limit":3
                    });
                    if (!state.credential.user!.emailVerified) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VerifyEmail()));
                    } else {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => (FirebaseAuth.instance.currentUser!.displayName=="" || FirebaseAuth.instance.currentUser?.displayName==null)?UpdateProfile():Dashboard()));
                    }
                  }),
                  mfaAction,
                ],
                styles: const {
                  EmailFormStyle(signInButtonVariant: ButtonVariant.filled),
                },
                headerBuilder: headerBuilder(),
                sideBuilder: sideBuilder(),
                subtitleBuilder: (context, action) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      action == AuthAction.signIn
                          ? 'Welcome to ${GLOBAL.APP_TITLE}! Please sign in to continue.'
                          : 'Welcome to ${GLOBAL.APP_TITLE}! please create a account to continue',
                    ),
                  );
                },
                footerBuilder: (context, action) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        action == AuthAction.signIn
                            ? 'Welcome to ${GLOBAL.APP_TITLE}! please sign in to continue.'
                            : 'Welcome to ${GLOBAL.APP_TITLE} ! please create an account to continue',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                },
              );
            } else {
              //Render Your applicatiom if authenticated
              //and local session
              return FutureBuilder<bool>(
                future: setSession(
                    FirebaseAuth.instance.currentUser!.uid), // async work
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Splash();
                    default:
                      if (snapshot.hasError) {
                        print("ERROR");
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if(FirebaseAuth.instance.currentUser!.displayName=="" || FirebaseAuth.instance.currentUser!.displayName==null){
                        return UpdateProfile();
                      } else {
                        return Dashboard();
                      }
                  }
                },
              );
            }
          }
        },
      ),
    );
  }

  Future<bool> setSession(String uid) async {
    //print(uid);
    var result =
    await FirebaseFirestore.instance.collection(GLOBAL.userCollection).doc(uid).get();
    userData = result.data() as Map<String, dynamic>;
    //print("set user data");
    // print(userData["subscription_started"]);
    SESSION.uid = uid;
    SESSION.email = userData.containsKey("email")
        ? userData['email']
        : FirebaseAuth.instance.currentUser!.email;
    SESSION.firstName = userData["firstName"] ?? "";
    SESSION.lastName = userData["lastName"] ?? "";
    SESSION.displayName = userData["displayName"] ?? "";
    SESSION.phoneNumber = userData["phoneNumber"] ?? "";
    SESSION.audience_limit = userData["audience_limit"] ?? 3;
    SESSION.source_limit = userData["source_limit"] ?? 5;
    SESSION.subscription = userData['subscription']??"trail";
    SESSION.subscription_ends_at = userData["subscription_ends_at"].toDate();
    SESSION.ad_accounts = userData['ad_accounts']!=null && userData['ad_accounts']!=""?jsonDecode(userData['ad_accounts']):{};

    return true;
  }
}