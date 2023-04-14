import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sorsfuse/components/avatar.dart';
import 'package:sorsfuse/components/route_builder.dart';
import 'package:sorsfuse/screens/audience.dart';
import 'package:sorsfuse/screens/dashboard.dart';
import 'package:sorsfuse/config/config.dart' as CONFIG;
import 'package:sorsfuse/global/session.dart' as SESSION;
import 'package:sorsfuse/screens/facebook_connect.dart';
import 'package:sorsfuse/screens/payment_history.dart';
import 'package:sorsfuse/screens/subscription.dart';
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
                              color: CONFIG.primaryColor,
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
                      child: Text(FirebaseAuth.instance.currentUser?.displayName??"Hello!"),
                    ),
                    InkWell(
                      onTap: ()=>Navigator.push(context, scaleIn(UpdateProfile())),
                      child: Container(
                        child:Text("Update Profile", style: TextStyle(color:CONFIG.primaryColor, fontSize: 12),),
                      ),
                    ),
                    //menu
                    Divider(
                      thickness: 20,
                      color: Colors.transparent,
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                        //height:500,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                                onTap: ()=>Navigator.push(context,scaleIn(Dashboard())),
                                child: ListTile(
                                  leading: Icon(Icons.dashboard),
                                  title: Text("Dashboard", style: TextStyle(color: Colors.black87, fontSize: 14)),
                                  subtitle: Text("Summary & Stats"),
                                )

                            ),

                            InkWell(
                              onTap: ()=>Navigator.push(context, scaleIn(Audience())),
                              child: Container(
                                  child:ListTile(
                                    leading: Icon(FontAwesomeIcons.peopleGroup),
                                    title: Text("Audience", style: TextStyle(color: Colors.black87, fontSize: 14),),
                                    subtitle: Text("Manage & Share audience"),
                                  )
                              ),
                            ),

                            Divider(
                              thickness: 1,
                              color: CONFIG.secondaryColor,
                            ),
                            InkWell(
                              onTap: ()=>Navigator.push(context, scaleIn(FacebookConnect())),
                              child: ListTile(
                                leading: Icon(FontAwesomeIcons.facebook),
                                title: Text("Facebook Connect", style: TextStyle(color: Colors.black87, fontSize: 14)),
                                subtitle: Text("Your subscription & other plans"),
                              ),
                            ),

                            Divider(
                              thickness: 1,
                              color: CONFIG.secondaryColor,
                            ),

                            InkWell(
                              onTap: ()=>Navigator.push(context,scaleIn(Subscription())),
                              child: ListTile(
                                leading: Icon(FontAwesomeIcons.sackDollar),
                                title: Text("Subscription", style: TextStyle(color: Colors.black87, fontSize: 14)),
                                subtitle: Text("Your subscription & other plans"),
                              ),
                            ),
                            InkWell(
                              onTap: ()=>Navigator.push(context,scaleIn(PaymentHistory())),
                              child: ListTile(
                                leading: Icon(FontAwesomeIcons.piggyBank),
                                title: Text("Payment History", style: TextStyle(color: Colors.black87, fontSize: 14)),
                                subtitle: Text("see all your invoices"),
                              ),
                            ),
                          ],
                        )
                    ),
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