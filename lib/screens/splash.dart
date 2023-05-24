import 'package:flutter/material.dart';
import 'package:sorsfuse/config/config.dart' as CONFIG;

class Splash extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: CONFIG.bgColor,
      body: Center(
        child:Image.asset("assets/images/logo_high_white.png", width: MediaQuery.of(context).size.width/2,),
      ),
    );
  }

}