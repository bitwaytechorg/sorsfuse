import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sorsfuse/components/app_bar.dart';
import 'package:sorsfuse/components/bottom-bar.dart';
import 'package:sorsfuse/components/drawer.dart';
import 'package:sorsfuse/components/map.dart';
import 'package:sorsfuse/config/config.dart' as CONFIG;
import 'package:sorsfuse/global/session.dart' as SESSION;
import 'package:sorsfuse/global/global.dart' as GLOBAL;
import 'package:sorsfuse/components/route_builder.dart';
import 'package:sorsfuse/screens/audience_list.dart';
import 'package:sorsfuse/screens/facebook_connect.dart';

import '../components/audience_chart.dart';

class Dashboard extends StatefulWidget{
  @override
  DashboardState createState()=> DashboardState();
}

class DashboardState extends State<Dashboard>{
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void initState(){
   // checkAccessToken();
  }

  Future<void> checkAccessToken() async {
    try {
      await FacebookAuth.instance.webAndDesktopInitialize(
        appId: CONFIG.facebook_app_id,
        cookie: true,
        xfbml: true,
        version: "v16.0",
      );

      final result = await FacebookAuth.instance.accessToken
          .then((accessToken)=>FacebookAuth.instance.getUserData());
      print(result);
      if(result.containsKey("error")){
        print(FacebookAuth.i.isWebSdkInitialized);
        final LoginResult result = await FacebookAuth.instance.login();

        // Check if login was successful
        if (result.status == LoginStatus.success) {
          final AccessToken accessToken = result.accessToken!;
          SESSION.fb_access_token = accessToken.token;
          FirebaseFirestore.instance.collection(GLOBAL.userCollection).doc(SESSION.uid).update({"fb_access_token":SESSION.fb_access_token});
        } else {
          print(result.status);
          print(result.message);
          print('Facebook login failed.');
        }
      }
    } catch (e) {
      print('Error logging in with Facebook: $e');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      //backgroundColor: Color(0XFF18193d),
      appBar: BWTAppBar(scaffoldKey: scaffoldkey, context: context,),
      endDrawer: BWTDrawer(),
      body: Stack(children: [
        SingleChildScrollView(
          child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 50, horizontal: 0),
              child:Column(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Expanded(child: InkWell(
                            onTap: ()=>Navigator.pushReplacement(context, scaleIn(AudienceList())),
                            child: Container(
                                child:ListTile(
                                  dense: true,
                                  leading: Icon(FontAwesomeIcons.peopleGroup),
                                  title: Text("Audience", style: TextStyle(color: Colors.black87, fontSize: 14),),
                                  subtitle: Text("Manage & Share audience"),
                                )
                            ),
                          ),),
                          Expanded(child: InkWell(
                            onTap: ()=>Navigator.pushReplacement(context, scaleIn(FacebookConnect())),
                            child: Container(child:ListTile(
                              dense: true,
                              leading: Icon(FontAwesomeIcons.facebook),
                              title: Text("Facebook Connect", style: TextStyle(color: Colors.black87, fontSize: 14)),
                              subtitle: Text("Manage Facebook Ad Profiles"),
                            )
                            ),
                          ),),
                        ],
                      )
                  ),
                  //charts
                  Row(
                    children: [
                    ],
                  ),
                  //Map
                  Container(
                      width:MediaQuery.of(context).size.width,
                      height: 600,
                      decoration: BoxDecoration(
                          color: Color(0XFF18193d),
                          border: Border.all(color: Color(0xFFfa3d4a), width:0)),
                      margin: EdgeInsets.only(top:40,bottom: 20),
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: WorldMap(
                        data: [
                          {"country": "India", "density": 0}
                        ],
                       title: "Audience Map",
                      ))
                ],
              )),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: BottomWidget(),
        )
      ],
      )
    );
  }
}