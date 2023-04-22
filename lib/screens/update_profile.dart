import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sorsfuse/components/app_bar.dart';
import 'package:sorsfuse/components/avatar.dart';
import 'package:sorsfuse/components/drawer.dart';
import 'package:sorsfuse/config/config.dart' as CONFIG;
import 'package:sorsfuse/global/session.dart' as SESSION;

class UpdateProfile extends StatefulWidget{

  @override
  UpdateProfileState createState()=>UpdateProfileState();

}

class UpdateProfileState extends State<UpdateProfile>{
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  final dislayNameCtrl = TextEditingController(text: SESSION.displayName);
  final firstNameCtrl = TextEditingController(text: SESSION.firstName);
  final lastNameCtrl = TextEditingController(text: SESSION.lastName);
  final emailCtrl = TextEditingController(text: SESSION.email);
  final formKey = GlobalKey<FormState>();
  final displayNameFocusNode = FocusNode();
  final firstNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();

  final passwordFormKey = GlobalKey<FormState>();
  final passwordCtrl = TextEditingController();
  final newPasswordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();
  final passwordFocusNode = FocusNode();
  final newPasswordFocusNode = FocusNode();
  final confirmPassowrdFocusNode = FocusNode();
  String? _errorMsg;

  String mode = "profile";



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
       child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 30),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Profile",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                  child:Wrap(
                    children: [
                      InkWell(
                        onTap: ()=>setState(() {
                          mode="profile";
                        }),
                          hoverColor: Colors.transparent,
                        child: Container(
                          margin: EdgeInsets.only(right: 8),
                          padding: EdgeInsets.symmetric(horizontal: 30,vertical: 8),
                          decoration: BoxDecoration(
                            color: mode=="profile"?CONFIG.primaryColor:Colors.white,
                            border: Border.all(color: CONFIG.primaryColor),
                            borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          child: Text("Profile", style: TextStyle(color: mode=="profile"?Colors.white:CONFIG.primaryColor),),
                        )
                      ),
                      InkWell(
                          onTap: ()=>setState(() {
                            mode="security";
                          }),
                          hoverColor: Colors.transparent,
                          child: Container(
                            margin: EdgeInsets.only(right: 8),
                            padding: EdgeInsets.symmetric(horizontal: 30,vertical: 8),
                            decoration: BoxDecoration(
                                color: mode=="security"?CONFIG.primaryColor:Colors.white,
                                border: Border.all(color: CONFIG.primaryColor),
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: Text("Change Password", style: TextStyle(color: mode=="security"?Colors.white:CONFIG.primaryColor),),
                          )
                      ),
                    ],
                  )
                ),
                mode=="profile"?ProfileView():PasswordView(),
              ],
            )
     ))
   ));
  }

  Widget ProfileView(){
    return SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey))
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              margin: EdgeInsets.symmetric(vertical: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Avatar(size: 70, ImageURL: SESSION.profileImage),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(SESSION.displayName, style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),),
                            Text(SESSION.email)
                          ],
                        ),
                      )
                    ],
                  ),
                  OutlinedButton(onPressed: ()=>null, child: Text("Update Avatar"))
                ],
              ),
            ),
            //Form
            Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
                    child: Wrap(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width<800?MediaQuery.of(context).size.width:400,
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                          child: TextFormField(
                            autofocus: true,
                            focusNode: firstNameFocusNode,
                            controller: firstNameCtrl,
                            decoration: InputDecoration(
                              labelText: "First Name",
                            ),
                            validator: (value) =>
                            value!.isEmpty ? "First Name can't be blank" : null,
                            onFieldSubmitted: (v) {
                              formKey.currentState?.validate();
                              FocusScope.of(context).requestFocus(lastNameFocusNode);
                            },
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width<800?MediaQuery.of(context).size.width:400,
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                          child: TextFormField(
                            autofocus: true,
                            focusNode: lastNameFocusNode,
                            controller: lastNameCtrl,
                            decoration: InputDecoration(
                              labelText: "Last Name",
                            ),
                            validator: (value) =>
                            value!.isEmpty ? "Last Name can't be blank" : null,
                            onFieldSubmitted: (v) {
                              formKey.currentState?.validate();
                              FocusScope.of(context).requestFocus(displayNameFocusNode);
                            },
                            keyboardType: TextInputType.text,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Wrap(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width<800?MediaQuery.of(context).size.width:400,
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                          child: TextFormField(
                            autofocus: true,
                            focusNode: displayNameFocusNode,
                            controller: dislayNameCtrl,
                            decoration: InputDecoration(
                              labelText: "Display Name",
                            ),
                            validator: (value) =>
                            value!.isEmpty ? "Display Name can't be blank" : null,
                            onFieldSubmitted: (v) {
                              formKey.currentState?.validate();
                              FocusScope.of(context).requestFocus(emailFocusNode);
                            },
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width<800?MediaQuery.of(context).size.width:400,
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                          child: TextFormField(
                            autofocus: true,
                            readOnly: true,
                            focusNode: emailFocusNode,
                            controller: emailCtrl,
                            decoration: InputDecoration(
                              labelText: "Email",
                            ),
                            validator: (value) =>
                            value!.isEmpty ? "Email can't be blank" : null,
                            onFieldSubmitted: (v) {
                              formKey.currentState?.validate();
                            },
                            keyboardType: TextInputType.text,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 40),
                    child: ElevatedButton(
                      onPressed: (){
                        if (formKey.currentState!.validate()) {
                          SESSION.displayName = dislayNameCtrl.text;
                          SESSION.firstName = firstNameCtrl.text;
                          SESSION.lastName = lastNameCtrl.text;
                          FirebaseFirestore.instance.collection("users").doc(SESSION.uid).update({
                            "firstName": SESSION.firstName,
                            "lastName": SESSION.lastName,
                            "displayName": SESSION.displayName
                          });
                          FirebaseAuth.instance.currentUser!.updateDisplayName(SESSION.displayName);
                          setState(() {

                          });
                        }
                      },
                      child: Text("Update Profile"),
                    ),
                  )
                ],
              ),
            ),
          ],
        )
    );
  }

  Widget PasswordView(){
    return SingleChildScrollView(
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 35),
          child:Wrap(
        children: [
          Container(
            width: MediaQuery.of(context).size.width<800?MediaQuery.of(context).size.width:400,
            padding: EdgeInsets.symmetric(horizontal: 10,),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text("Change Password", style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),)
                ),
                Container(
                  child:Text("You can always change your password for security reasons or reset your password in case you forgot it.", style: TextStyle(color: Colors.grey),)
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width<800?MediaQuery.of(context).size.width:400,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child:Form(
              key: passwordFormKey,
            child: Column(
              children: [
              Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child:TextFormField(
                  autofocus: true,
                  focusNode: passwordFocusNode,
                  controller: passwordCtrl,
                  decoration: InputDecoration(
                    labelText: "Current Password",
                    errorText: _errorMsg
                  ),
                  validator: (value) =>
                  value!.isEmpty ? "Current Password can't be blank" : null,
                  onFieldSubmitted: (v) {
                    passwordFormKey.currentState?.validate();
                    FocusScope.of(context).requestFocus(newPasswordFocusNode);
                  },
                  obscureText: true,
                  keyboardType: TextInputType.text,
                )),
                Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child:TextFormField(
                  autofocus: true,
                  focusNode: newPasswordFocusNode,
                  controller: newPasswordCtrl,
                  decoration: InputDecoration(
                    labelText: "New Password",
                  ),
                  validator: (value) =>
                  value!.isEmpty ? "Password can't be blank" : null,
                  onFieldSubmitted: (v) {
                    passwordFormKey.currentState?.validate();
                    FocusScope.of(context).requestFocus(confirmPassowrdFocusNode);
                  },
                  obscureText: true,
                  keyboardType: TextInputType.text,
                )),
                Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child:TextFormField(
                  autofocus: true,
                  focusNode: confirmPassowrdFocusNode,
                  controller: confirmPasswordCtrl,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                  ),
                  validator: (value) {
                    return value!.isEmpty || value != newPasswordCtrl.text? "Please Confirm Password" : null;
                  },
                  onFieldSubmitted: (v) {
                    passwordFormKey.currentState?.validate();
                  },
                  obscureText: true,
                  keyboardType: TextInputType.text,
                )),
                Container(
                  margin: EdgeInsets.only(top: 40),
                  child: ElevatedButton(
                    onPressed: (){
                      if (passwordFormKey.currentState!.validate()) {
                        final cred = EmailAuthProvider.credential(
                            email: SESSION.email, password: passwordCtrl.text);

                        FirebaseAuth.instance.currentUser?.reauthenticateWithCredential(cred).then((value) {
                          FirebaseAuth.instance.currentUser?.updatePassword(newPasswordCtrl.text).then((_) {
                            passwordFormKey.currentState?.reset();
                            ScaffoldMessenger.of(scaffoldkey.currentContext!).showSnackBar(SnackBar(backgroundColor: Colors.green,content: Container(child: Text("You have successfully reset your password", style: TextStyle(color: Colors.white),),),showCloseIcon: true, elevation: 5,));
                          }).catchError((error) {
                            setState(() {
                              _errorMsg = error;
                            });
                          });
                        }).catchError((err) {
                          //wrong password entered
                          setState(() {
                            _errorMsg = "You have entered wrong password";
                          });
                        });
                      }
                    },
                    child: Text("Update Password"),
                  ),
                ),
              ],
            ),
            )
          )
        ],
      )),
    );
  }

}