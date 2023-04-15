import 'package:countries_world_map/countries_world_map.dart';
import 'package:countries_world_map/data/maps/world_map.dart';
import 'package:flutter/material.dart';
import 'package:sorsfuse/components/app_bar.dart';
import 'package:sorsfuse/components/drawer.dart';
import 'package:sorsfuse/global/global.dart' as GLOBAL;

class Dashboard extends StatefulWidget{
  @override
  DashboardState createState()=> DashboardState();
}

class DashboardState extends State<Dashboard>{
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: BWTAppBar(scaffoldKey: scaffoldkey,),
      endDrawer: BWTDrawer(),
      body: Center(
        child: Container(
          width: 1000,
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 100),
            child:SimpleMap(
          // String of instructions to draw the map.
          instructions: SMapWorld.instructions,
          // Default color for all countries.
          defaultColor: Colors.grey[200],
          // Matching class to specify custom colors for each area.
          colors: SMapWorldColors(
            uS: Colors.purple,   // This makes USA green
            cN: Colors.yellow,   // This makes China green
            iN: Colors.green,
            iL:Colors.orange,
            pK: Colors.red// This makes Russia green
          ).toMap(),
          // Details of what area is being touched, giving you the ID, name and tapdetails
          callback: (id, name, tapdetails) {
            print(id);
          },
        )),
      ),
    );
  }
}