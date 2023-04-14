import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sorsfuse/components/avatar.dart';
import 'package:sorsfuse/config/config.dart' as CONFIG;
import 'package:sorsfuse/global/session.dart' as SESSION;

class BWTAppBar extends AppBar{
  final String appBarTitle;
  final GlobalKey<ScaffoldState> scaffoldKey;
  BWTAppBar({required this.appBarTitle, required this.scaffoldKey}):super(
    title: Text(appBarTitle),
    leading: AspectRatio(aspectRatio: 1, child:Image.asset("assets/images/logo_low_white.png", height: 50,)),
    centerTitle: false,
    foregroundColor: Colors.white,
    backgroundColor:CONFIG.primaryColor,
    actions: [
      InkWell(
      onTap: () => scaffoldKey.currentState?.openEndDrawer(),
        child: Container(padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10), margin: EdgeInsets.symmetric(horizontal: 10),child:Avatar(size: 35, ImageURL: SESSION.profileImage,)),
      )
    ]
  );
}