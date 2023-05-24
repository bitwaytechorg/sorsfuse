import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:sorsfuse/config/config.dart' as CONFIG;


SideBuilder sideBuilder(){
  return (context, constraints){
    return Container(
      color: CONFIG.bgColor,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(90),
      child: AspectRatio(
        aspectRatio: 1,
        child: Center(
          child: Image.asset("assets/images/logo_high_white.png", width: MediaQuery.of(context).size.width-180,),
        ),
      ),
    );
  };
}
HeaderBuilder headerBuilder(){
  return (context, constraints, _){
    return Container(
      color: CONFIG.bgColor,
      padding: EdgeInsets.all(20),
      child:  AspectRatio(
        aspectRatio: 1,
        child:  Center(
          child: Image.asset("assets/images/logo_low_white.png", width: MediaQuery.of(context).size.width-180,),
        ),
      ),
    );
  };
}