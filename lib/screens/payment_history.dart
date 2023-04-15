import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sorsfuse/components/app_bar.dart';
import 'package:sorsfuse/components/drawer.dart';
import 'package:sorsfuse/global/global.dart' as GLOBAL;

class PaymentHistory extends StatefulWidget{

  @override
  PaymentHistoryState createState()=>PaymentHistoryState();

}

class PaymentHistoryState extends State<PaymentHistory>{
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