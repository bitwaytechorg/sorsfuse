import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sorsfuse/components/app_bar.dart';
import 'package:sorsfuse/components/drawer.dart';

class UpdateProfile extends StatefulWidget{

  @override
  UpdateProfileState createState()=>UpdateProfileState();

}

class UpdateProfileState extends State<UpdateProfile>{
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     key: _scaffoldkey,
     appBar: BWTAppBar(appBarTitle: "Update Profile", scaffoldKey: _scaffoldkey,),
     endDrawer: BWTDrawer(),
   );
  }

}