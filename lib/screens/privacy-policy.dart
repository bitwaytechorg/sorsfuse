import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sorsfuse/components/BulletList.dart';

class PrivacyPolicy extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child:Container(
          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 50),
                child: Text("Privacy Policy", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black87),),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text("Thank you for using SorsFuse! We take privacy very seriously, and we want to make sure that you understand how we collect, use, and protect your personal information.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54)),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text("This privacy policy applies to SorsFuse and any information that we collect from you through the app.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54)),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 30),
                      child: Text("Information We Collect", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black87),),
                    ),

                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text("When you use SorsFuse, we may collect the following information from you:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54),),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: BulletedList(
                          listItems:[
                            "Your Facebook profile information (such as your name, profile picture, and other information you have made publicly available on your Facebook account)",
                            "Information about your device (such as your device ID, operating system, and browser type).","Usage information (such as the pages you visit within the app, the time you spend on the app, and other usage statistics).",
                            "Information you provide to us directly (such as when you contact our customer support team or provide feedback on the app).",
                          ]
                      )
                    ),


                    Container(
                      margin: EdgeInsets.symmetric(vertical: 30),
                      child: Text("How We Use Your Information", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black87),),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text("We use the information we collect from you in the following ways:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54),),
                    ),
                    Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: BulletedList(
                            listItems:[
                              "To provide you with SorsFuse and its features.",
                              "To personalize your experience on our app.",
                              "To communicate with you about our app and any updates or changes.",
                              "To improve our app and its features.",
                              "To respond to your inquiries and customer service requests.",
                              "We may also use your information for other purposes that are disclosed to you at the time we collect the information or that are otherwise permitted by law."
                            ]
                        )
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(vertical: 30),
                      child: Text("How We Share Your Information", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black87),),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text("We may share your information with third-party service providers who help us operate and improve SorsFuse. These service providers may have access to your information only to perform services on our behalf, and they are not authorized to use your information for any other purpose.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54),),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text("We may also share your information if we are required to do so by law or if we believe that such disclosure is necessary to protect our rights or the rights of others, to prevent fraud or other illegal activity, or to comply with a court order or other legal process.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54),),
                    ),


                    Container(
                      margin: EdgeInsets.symmetric(vertical: 30),
                      child: Text("Your Choices", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black87),),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text("You can control the information that we collect from you through SorsFuse by adjusting your Facebook privacy settings. You can also choose not to provide certain information to us, although this may limit your ability to use certain features of our app.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54),),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text("You can also opt-out of receiving promotional emails from us by following the instructions in those emails.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54),),
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(vertical: 30),
                      child: Text("Data Security", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black87),),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text("We take appropriate measures to protect your personal information from unauthorized access, disclosure, alteration, or destruction. However, no data transmission over the internet can be guaranteed to be 100% secure, and we cannot guarantee the security of any information that you transmit to us.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54),),
                    ),


                    Container(
                      margin: EdgeInsets.symmetric(vertical: 30),
                      child: Text("Changes to This Privacy Policy", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black87),),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text("We may update this privacy policy from time to time by posting a new version on our website. We will notify you of any material changes to this policy by posting a notice on our website or by sending you an email.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54),),
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(vertical: 30),
                      child: Text("Contact Us", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black87),),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text("If you have any questions about this privacy policy or SorsFuse, please contact us at support@bitwaytech.com.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54),),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),)
    );
  }
}