import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sorsfuse/components/avatar.dart';
import 'package:sorsfuse/components/route_builder.dart';
import 'package:sorsfuse/config/config.dart' as CONFIG;
import 'package:sorsfuse/global/global.dart' as GLOBAL;
import 'package:sorsfuse/global/session.dart' as SESSION;
import 'package:sorsfuse/screens/dashboard.dart';

class BWTAppBar extends AppBar{
  final GlobalKey<ScaffoldState> scaffoldKey;
  final BuildContext context;
  BWTAppBar({required this.scaffoldKey, required this.context}):super(
    title: InkWell(
      onTap: ()=>Navigator.pushReplacement(context, scaleIn(Dashboard())),
        child:Image.asset("assets/images/logo_sm_white.png", height:50,)),
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