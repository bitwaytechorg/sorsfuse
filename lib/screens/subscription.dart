import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sorsfuse/components/app_bar.dart';
import 'package:sorsfuse/components/drawer.dart';

class Subscription extends StatefulWidget{

  @override
  SubscriptionState createState()=>SubscriptionState();

}

class SubscriptionState extends State<Subscription>{
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: BWTAppBar(scaffoldKey: scaffoldkey,context: context,),
      endDrawer: BWTDrawer(),
    );
  }

}