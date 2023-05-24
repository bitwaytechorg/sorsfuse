import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:js' as js;
import 'package:sorsfuse/config/config.dart' as CONFIG;

class BottomWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: CONFIG.primaryColor,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 20),
            child: Text("Copyright \u00a9 2023 SNIPERR LEADS",style: TextStyle(color: Colors.white),),
          ),
          InkWell(
            onTap: (){
                js.context.callMethod('open', ['https://sniperrleads.com/privacy-policy']);
              },
            child: Container(
              margin: EdgeInsets.only(right: 20),
              child: Text("Privacy Policy",style: TextStyle(color: Colors.white),),
            ),
          ),
          InkWell(
            onTap: (){
                js.context.callMethod('open', ['https://sniperrleads.com/terms']);
              },
            child: Container(
              margin: EdgeInsets.only(right: 20),
              child: Text("Terms of use",style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }
}
