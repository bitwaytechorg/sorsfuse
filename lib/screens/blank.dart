import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sorsfuse/components/app_bar.dart';
import 'package:sorsfuse/components/drawer.dart';

class Blank extends StatefulWidget{

  @override
  BlankState createState()=>BlankState();

}

class BlankState extends State<Blank>{
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: BWTAppBar(scaffoldKey: scaffoldkey,),
      endDrawer: BWTDrawer(),
        body: SingleChildScrollView(
            child:Center(child:Container(
              width: MediaQuery.of(context).size.width<600?MediaQuery.of(context).size.width:800,
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [],
              ),
            ))
        )
    );
  }

}