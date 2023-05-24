import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sorsfuse/components/app_bar.dart';
import 'package:sorsfuse/components/bottom-bar.dart';
import 'package:sorsfuse/components/drawer.dart';
import 'package:sorsfuse/config/config.dart' as CONFIG;
import 'package:sorsfuse/global/session.dart' as SESSION;
import 'package:sorsfuse/global/global.dart' as GLOBAL;
import 'package:http/http.dart' as http;

class FacebookConnect extends StatefulWidget{

  @override
  FacebookConnectState createState()=>FacebookConnectState();

}

class FacebookConnectState extends State<FacebookConnect>{
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> records =[];
  List<Map<String, dynamic>> filtered_data =[];

  int current_page = 1;
  int records_per_page = 10;
  int startAt = 1;
  late int endingAt;
  int total_records = SESSION.ad_accounts.length;
  int pageCount = 1;

  @override
  void initState(){
    setData();
  }

  void setData(){
    List<Map<String, dynamic>> _records = [];
    SESSION.ad_accounts.forEach((key, value) {
      _records.add(value);
    });
    setState(() {
      records = _records;
      filtered_data = _records;
    });
    prepareData(filtered_data);
  }

  void prepareData(List<Map<String, dynamic>> rec){
    //set variables to fetch data
    int startFrom = (current_page - 1)*records_per_page;
    int endAt = (startFrom+records_per_page)>rec.length?rec.length:startFrom+records_per_page;
    List<Map<String, dynamic>> recordsToShow = rec.sublist(startFrom,endAt);
    //set page data
    setState(() {
      startAt = startFrom==0?1:startFrom;
      endingAt = endAt;
      pageCount = (records.length/records_per_page).ceil();
      total_records = records.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: BWTAppBar(scaffoldKey: scaffoldkey,context: context,),
      endDrawer: BWTDrawer(),
      body: Stack(children: [
        Container(
          child:Center(child:Container(
      width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 20),
                  child: Text(
                    "Integration",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),

                //list of added accounts
                AdAccountList()
              ],
            ),
        ))
      ),
        Align(
          alignment: Alignment.bottomLeft,
          child: BottomWidget(),
        )
    ])
    );
  }

  Widget AdAccountList(){
    return Container(
        decoration: BoxDecoration(

            //borderRadius: BorderRadius.all(Radius.circular(5)),
           // border: Border.all(color: Colors.grey[200]!)
        ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //header
          dataTableHeader(),
          //datatable
          records.length>0?Container(
              color: Colors.white,
              child:dataList()
          ):Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 40),
            child: Text("You don't have any Ad Account connected. Click the button 'Add Facebook Ad Account' to connect Facebook Ad Account.", style: TextStyle(fontSize: 20),),
            )
          ),
        ],
      ),
    );
  }

  Widget dataList(){
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.grey[300]!)
        ),
        child:Column(
      children: [
        Container(
          color: CONFIG.secondaryColor,
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: ListTile(
            title: Text("Facebook Ad Account"),
          ),
        ),
        ListView.builder(itemBuilder: (context, index){
      return Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[300]!))
        ),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(filtered_data[index]["name"], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
                ),
                Container(
                  child: Text(filtered_data[index]["account_id"], style: TextStyle(fontSize: 12)),
                ),
                if(filtered_data[index].containsKey("business"))
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Text(filtered_data[index]["business"]["name"],style: TextStyle(fontSize: 14, color: CONFIG.primaryColor)),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: filtered_data[index]['account_status']==1?Colors.green:Colors.deepOrangeAccent,
                    borderRadius: BorderRadius.all(Radius.circular(2))
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  child: Text(filtered_data[index]['account_status']==1?"Active":"Inactive", style: TextStyle(color: Colors.white, fontSize: 10),),
                ),
                SizedBox(width: 10,),
                //delete Button
                InkWell(
                  onTap: (){
                    SESSION.ad_accounts.removeWhere((key, value) => key==filtered_data[index]['account_id']);
                    FirebaseFirestore.instance.collection(GLOBAL.userCollection).doc(SESSION.uid).update({"ad_accounts":jsonEncode(SESSION.ad_accounts)});
                    setData();
                  },
                  child: Icon(FontAwesomeIcons.trashCan, color: Colors.red, size:17),
                )
              ],
            )
          ],
        ),
      );
    },shrinkWrap: true, itemCount: filtered_data.length,)
      ],
    ));
  }

  Widget dataTableHeader(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            //margin: EdgeInsets.only(top: 10, bottom: 10, left:10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor:CONFIG.facebookColor,padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              onPressed: ()=>getAccessToken(),
              child: Wrap(
                runAlignment: WrapAlignment.center,
                alignment: WrapAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.squareFacebook, color: Colors.white,size: 16,),
                  SizedBox(width: 10,),
                  Text("Add Facebook Ad Account", style: TextStyle(color:Colors.white),)
                ],
              ),
            ),
          ),
          Container(
            child: makePagination(),
          )
        ],
      ),
    );
  }

  Widget makePagination(){
    int startingPage = current_page>3?current_page-2:1;
    int lastPage = pageCount>current_page+2?current_page+2:pageCount;
    String leading = current_page>3?"...":"";
    String trailing = pageCount>current_page+2?"...":"";
    List<Widget> pages=[];
    for(int i=startingPage;i<=lastPage;i++){
      pages.add(Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: InkWell(
          onTap: (){
            setState(() {
              current_page=i;
            });
            prepareData(filtered_data);
          },
          child: Text(i.toString(), style: TextStyle(fontWeight: i==current_page?FontWeight.bold:FontWeight.normal, color: i==current_page?CONFIG.primaryColor:Colors.black87,fontSize: 14),),
        ),
      ));
    }

    return Row(
      children: [
        Container(child: InkWell(
          child: Icon(Icons.first_page, size:22),
          onTap: (){
            setState(() {
              current_page = 1;
            });
            prepareData(filtered_data);
          },
        ),),
        Container(child: InkWell(
          child: Icon(Icons.arrow_back_ios, size:14),
          onTap: (){
            if(current_page>1) {
              int newpage = current_page-1;
              setState(() {
                current_page = newpage;
              });
              prepareData(filtered_data);
            }
          },
        ),),
        Container(margin:EdgeInsets.symmetric(horizontal: 3),child: Text(leading),),
        Row(
          children: pages,
        ),
        Container(margin:EdgeInsets.symmetric(horizontal: 3),child: Text(trailing),),
        Container(child: InkWell(
          child: Icon(Icons.arrow_forward_ios, size:14),
          onTap: (){
            if(current_page<pageCount) {
              int newpage = current_page+1;
              setState(() {
                current_page = newpage;
              });
              prepareData(filtered_data);
            }
          },
        ),),
        Container(child: InkWell(
          child: Icon(Icons.last_page, size:22),
          onTap: (){
            setState(() {
              current_page = pageCount;
            });
            prepareData(filtered_data);
          },
        ),),
      ],
    );
  }


  Future<void> getAccessToken() async {
    try {
      await FacebookAuth.instance.webAndDesktopInitialize(
        appId: "247745554393324",//CONFIG.facebook_app_id,
        cookie: true,
        xfbml: true,
        version: "v16.0",
      );
      print(FacebookAuth.i.isWebSdkInitialized);
      final LoginResult result = await FacebookAuth.instance.login();

      // Check if login was successful
      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        SESSION.fb_access_token = accessToken.token;
        print(SESSION.fb_access_token);
        fetchAdAccounts();
      } else {
        print(result.status);
        print(result.message);
        print('Facebook login failed.');
      }
    } catch (e) {
      print('Error logging in with Facebook: $e');
    }
  }
  Future<void> fetchAdAccounts() async {
    final String graphUrl = 'https://graph.facebook.com/v16.0/me?fields=id,name,adaccounts{business_name,name,business,account_id,account_status}&access_token='+SESSION.fb_access_token;
    final http.Response response = await http.get(Uri.parse(graphUrl));
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    print(responseData);
print("code---");
    print(response.statusCode);
    if (response.statusCode == 200) {
     responseData["adaccounts"]["data"].forEach((element){
       SESSION.ad_accounts[element["account_id"]]=element;
     });
     print(SESSION.ad_accounts.length);
     FirebaseFirestore.instance.collection("users").doc(SESSION.uid).update({"fb_access_token":SESSION.fb_access_token,"ad_accounts":jsonEncode(SESSION.ad_accounts)});
     setData();
    } else {
      // Handle error response
      print('Error: ${responseData['error']['message']}');
    }
  }

}