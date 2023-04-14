import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import '../../components/auth_builder.dart';


class ForgetPassword extends StatelessWidget {
  final String? email;
  ForgetPassword({required this.email});


  @override
  Widget build(BuildContext context) {
    return ForgotPasswordScreen(
      email:email,
      headerMaxExtent:200,
      headerBuilder:headerBuilder(),
     // sideBuilder:sideBuilder(),
    ) ;
  }
}
