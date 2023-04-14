import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sorsfuse/screens/auth/sms.dart';


class PhoneLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PhoneInputScreen(
      actions: [
        SMSCodeRequestedAction((context, action, flowKey, phone) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SMSVerify(flowKey:flowKey, action:action, phone: phone,)));
        })
      ],
    );
  }
}
