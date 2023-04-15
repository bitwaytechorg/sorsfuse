import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sorsfuse/components/app_bar.dart';
import 'package:sorsfuse/components/drawer.dart';
import 'package:sorsfuse/global/global.dart' as GLOBAL;

class UpdateProfile extends StatefulWidget{

  @override
  UpdateProfileState createState()=>UpdateProfileState();

}

class UpdateProfileState extends State<UpdateProfile>{
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     key: scaffoldkey,
     appBar: BWTAppBar(scaffoldKey: scaffoldkey,),
     endDrawer: BWTDrawer(),
   );
  }

}