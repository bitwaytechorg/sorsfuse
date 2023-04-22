import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sorsfuse/components/avatar.dart';
import 'package:sorsfuse/components/route_builder.dart';
import 'package:sorsfuse/screens/audience.dart';
import 'package:sorsfuse/screens/audience_list.dart';
import 'package:sorsfuse/screens/dashboard.dart';
import 'package:sorsfuse/config/config.dart' as CONFIG;
import 'package:sorsfuse/global/session.dart' as SESSION;
import 'package:sorsfuse/screens/facebook_connect.dart';
import 'package:sorsfuse/screens/settings.dart';
import 'package:sorsfuse/screens/subscription.dart';
import 'package:sorsfuse/screens/support.dart';
import 'package:sorsfuse/screens/update_profile.dart';

class BWTDrawer extends Drawer{
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
          // Set the transparency here
          canvasColor: Colors
              .transparent, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
        ),
        child:Drawer(
          child:
          Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(bottom: 10),
            color:Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(child:Column(
                  children: [
                    Container(
                        alignment: Alignment.topCenter,
                        child:Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                              color: CONFIG.secondaryColor,
                              width: double.maxFinite,
                              height: 70,
                            ),
                            Container(
                              margin: EdgeInsets.only(top:30),
                              child: Container(child:Avatar(size: 70, ImageURL: SESSION.profileImage,)),
                            ),
                          ],
                        )),
                    //container with name
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(SESSION.displayName, style: TextStyle(fontSize: 16),),
                    ),
                    InkWell(
                      onTap: ()=>Navigator.push(context, scaleIn(UpdateProfile())),
                      child: Container(
                        child:Text("Profile", style: TextStyle(color:CONFIG.primaryColor, fontSize: 12),),
                      ),
                    ),
                    //menu
                    Divider(
                      thickness: 20,
                      color: Colors.transparent,
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                        height:MediaQuery.of(context).size.height-200,
                        child: SingleChildScrollView(
                            child:Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                                onTap: ()=>Navigator.push(context,scaleIn(Dashboard())),
                                child: ListTile(
                                  dense: true,
                                  leading: Icon(Icons.dashboard),
                                  title: Text("Dashboard", style: TextStyle(color: Colors.black87, fontSize: 14)),
                                  subtitle: Text("Summary & Stats"),
                                )
                            ),

                            InkWell(
                              onTap: ()=>Navigator.push(context, scaleIn(AudienceList())),
                              child: Container(
                                  child:ListTile(
                                    dense: true,
                                    leading: Icon(FontAwesomeIcons.peopleGroup),
                                    title: Text("Audience", style: TextStyle(color: Colors.black87, fontSize: 14),),
                                    subtitle: Text("Manage & Share audience"),
                                  )
                              ),
                            ),
                            InkWell(
                              onTap: ()=>Navigator.push(context, scaleIn(FacebookConnect())),
                              child: ListTile(
                                dense: true,
                                leading: Icon(FontAwesomeIcons.facebook),
                                title: Text("Facebook Connect", style: TextStyle(color: Colors.black87, fontSize: 14)),
                                subtitle: Text("Manage Facebook Ad Profiles"),
                              ),
                            ),

                            Divider(
                              thickness: 1,
                              color: CONFIG.secondaryColor,
                            ),

                            InkWell(
                              onTap: ()=>Navigator.push(context,scaleIn(Subscription())),
                              child: ListTile(
                                dense: true,
                                leading: Icon(FontAwesomeIcons.sackDollar),
                                title: Text("Subscription", style: TextStyle(color: Colors.black87, fontSize: 14)),
                                subtitle: Text("Your subscription & Payment History"),
                              ),
                            ),
                            InkWell(
                              onTap: ()=>Navigator.push(context,scaleIn(Settings())),
                              child: ListTile(
                                dense: true,
                                leading: Icon(FontAwesomeIcons.sliders),
                                title: Text("Settings", style: TextStyle(color: Colors.black87, fontSize: 14)),
                                subtitle: Text("Finetune your expereince"),
                              ),
                            ),
                            InkWell(
                              onTap: ()=>Navigator.push(context,scaleIn(Support())),
                              child: ListTile(
                                dense: true,
                                leading: Icon(FontAwesomeIcons.circleQuestion),
                                title: Text("Support", style: TextStyle(color: Colors.black87, fontSize: 14)),
                                subtitle: Text("Reachout and get help"),
                              ),
                            ),
                          ],
                        )
                    )),
                  ],
                )
          ),



                Container(
                  child: InkWell(
                      onTap: () {
                        print("logout");
                        FirebaseAuth.instance.signOut();
                        Navigator.pushReplacementNamed(context, '/');
                      },
                      child: Text("Logout")),
                )
              ],
            ),
          ),
        ));
  }
}