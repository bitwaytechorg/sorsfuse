import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sorsfuse/components/app_bar.dart';
import 'package:sorsfuse/components/bottom-bar.dart';
import 'package:sorsfuse/components/drawer.dart';
import 'package:sorsfuse/config/config.dart' as CONFIG;
import 'package:sorsfuse/global/session.dart' as SESSION;
import 'package:sorsfuse/global/global.dart' as GLOBAL;
import 'package:sorsfuse/models/audience.dart';
import 'package:sorsfuse/repositories/audienceRepository.dart';
import 'package:sorsfuse/screens/audience.dart';

import '../components/route_builder.dart';


class AudienceList extends StatefulWidget{

  @override
  AudienceListState createState()=>AudienceListState();

}

class AudienceListState extends State<AudienceList>{
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  final audienceNameCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final audienceNameFocusNode = FocusNode();
  List<Audience> audience_list =[];

  int current_page = 1;
  int records_per_page = 10;
  int startAt = 1;
  late int endingAt;
  int total_records = 0;
  int pageCount = 1;

  bool dataLoaded = false;

  //repo
  AudienceRepository _audienceRepository = new AudienceRepository();

  @override
  void initState(){
    
  }

  void prepareData(List<Audience> rec){
    //set variables to fetch data
    int startFrom = (current_page - 1)*records_per_page;
    int endAt = (startFrom+records_per_page)>rec.length?rec.length:startFrom+records_per_page;
    List<Audience> recordsToShow = rec.sublist(startFrom,endAt);
    //set page data
    setState(() {
      startAt = startFrom==0?1:startFrom;
      endingAt = endAt;
      pageCount = (audience_list.length/records_per_page).ceil();
      total_records = audience_list.length;
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
                    "My Audience",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),

                //list of added accounts
                AudienceList()
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

  Widget AudienceList(){
    return Container(
      decoration: BoxDecoration(
        //borderRadius: BorderRadius.all(Radius.circular(5)),
        // border: Border.all(color: Colors.grey[200]!)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //datatable
          Container(
              child:dataList()
          )
        ],
      ),
    );
  }
  Widget dataList(){
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection(GLOBAL.audienceCollection).where("created_by", isEqualTo: SESSION.uid).snapshots(),
        builder:  (context, snapshot){
      if (snapshot.connectionState == ConnectionState.active) {
        if(snapshot.hasData){
        List raw_docs = snapshot.data!.docs;
        audience_list=[];
        raw_docs.forEach((element) {
            audience_list.add(Audience.fromMap(element.data()));
        });
          return SingleChildScrollView(
            child: Column(
              children: [
                //header
                dataTableHeader(audience_list),
                ListView.builder(itemBuilder: (context, index) {
                  IconData recordIcon = FontAwesomeIcons.squareFacebook;
                  Color recordTypeBg = CONFIG.facebookColor;

                  if (audience_list[index].source_type == "instagram") {
                    recordIcon = FontAwesomeIcons.instagram;
                    recordTypeBg = CONFIG.instagramColor;
                  } else if (audience_list[index].source_type == "linkedin") {
                    recordIcon = FontAwesomeIcons.linkedin;
                    recordTypeBg = CONFIG.linkedinColor;
                  } else if (audience_list[index].source_type == "custom") {
                    recordIcon = FontAwesomeIcons.fileCsv;
                    recordTypeBg = CONFIG.secondaryColor;
                  }

                  IconData statusIcon = FontAwesomeIcons.clock;
                  Color statusColor = Colors.black87;
                  if (audience_list[index].status == "analysing") {
                    statusIcon = FontAwesomeIcons.gears;
                    statusColor = Colors.orange;
                  } else if (audience_list[index].status == "completed") {
                    statusIcon = FontAwesomeIcons.check;
                    statusColor = Colors.green;
                  }
                  return InkWell(
                    hoverColor: Colors.transparent,
                      onTap: ()=>Navigator.pushReplacement(context, scaleIn(AudienceScreen(audience_id: audience_list[index].audience_id))),
                      child:Container(
                    height: 80,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300]!)
                    ),
                    margin: EdgeInsets.symmetric(vertical: 7),
                    child: Row(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          alignment: Alignment.center,
                          color: recordTypeBg,
                          child: Icon(recordIcon, size: 50, color: Colors.white,),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(audience_list[index].name,
                                    style: TextStyle(
                                        fontSize: 16, color: CONFIG.primaryColor),),
                                ),
                                Container(
                                  child: Text("Sources: " +
                                      audience_list[index].source_list.length
                                          .toString(), style: TextStyle(
                                      fontSize: 11, color: CONFIG.primaryColor)),
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Icon(statusIcon, color: statusColor, size: 10,),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 5),
                                      child: Text(audience_list[index].status.capitalize(),
                                        style: TextStyle(
                                            fontSize: 12, color: statusColor),),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                hoverColor: Colors.transparent,
                                onTap: () async {
                                  if (await confirm(
                                    context,
                                    title: const Text('Please Confirm deletion'),
                                    content: Container( width: 300,child:Text(
                                        "Would you like to delete audience permanently? Audience once removed can't be recovered. You will loose all of your source and lead data.")),
                                    textOK: const Text('Yes Delete'),
                                    textCancel: const Text('No, Cancel'),
                                  )) {
                                    _audienceRepository.delete(
                                        audience_list[index].audience_id);
                                  }
                                },
                                child: Container(
                                    margin: EdgeInsets.only(left:8, right: 14),
                                    child:Icon(
                                    FontAwesomeIcons.trashCan, color: Colors.red,
                                    size: 17)),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ));
                }, shrinkWrap: true, itemCount: audience_list.length,)
              ],
            )
          );
        } else {
          return Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 40),
                child: Text("No Audience yet. Click the button above to create your first Audience.", style: TextStyle(fontSize: 20),),
              )
          );
        }
      } else {
        return Center(child:CircularProgressIndicator());
      }
    });
  }

  Widget dataTableHeader(List<Audience> _audiences){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              if(audience_list.length<SESSION.audience_limit)
              Container(
                //margin: EdgeInsets.only(top: 10, bottom: 10, left:10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor:CONFIG.primaryColor,padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  onPressed: ()=>showAddAudienceDialog(),
                  child: Wrap(
                    runAlignment: WrapAlignment.center,
                    alignment: WrapAlignment.center,
                    children: [
                      Icon(FontAwesomeIcons.plus, color: Colors.white,size: 16,),
                      SizedBox(width: 10,),
                      Text("Create Audience", style: TextStyle(color:Colors.white),)
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5),
                child: Text("Added ${_audiences.length}/${SESSION.audience_limit} audience")
              )
            ],
          ),

          Container(
            child: makePagination(_audiences),
          )
        ],
      ),
    );
  }

  Widget makePagination(List<Audience> _audiences){
    if(_audiences.length<10) return Container();
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
            prepareData(_audiences);
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
            prepareData(audience_list);
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
              prepareData(audience_list);
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
              prepareData(audience_list);
            }
          },
        ),),
        Container(child: InkWell(
          child: Icon(Icons.last_page, size:22),
          onTap: (){
            setState(() {
              current_page = pageCount;
            });
            prepareData(audience_list);
          },
        ),),
      ],
    );
  }

  //add Audience
void showAddAudienceDialog(){
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        String source_type ="";
        return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                  backgroundColor: Colors.white,
                  titlePadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  title: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey[300]!))
                      ),
                      child: Text("New Audience", style: TextStyle(fontWeight: FontWeight.w600),)),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  actions: [
                    ElevatedButton(
                      child: Text("Create Audience"),
                      onPressed:  () async {
                          if (formKey.currentState!.validate()) {
                            Audience data = Audience(
                                name: audienceNameCtrl.text, source_type: source_type);
                            audience_list.add(data);
                            audienceNameCtrl.text="";
                            _audienceRepository.save(data);
                            Navigator.of(context).pop();
                          }
                      },
                    ),
                    TextButton(
                      child: Text("Close"),
                      onPressed:  () =>Navigator.of(context).pop(),
                    ),
                  ],
                  content:Container(
                      width: MediaQuery.of(context).size.width<600?MediaQuery.of(context).size.width:800,
                      color: Colors.white,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //source name
                          Container(
                            child: Form(
                                key: formKey,
                                child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin:EdgeInsets.symmetric(vertical: 7),
                                      child: Text("Audience Name:"),
                                    ),
                                    Container(
                                      child: TextFormField(
                                        autofocus: true,
                                        focusNode: audienceNameFocusNode,
                                        controller: audienceNameCtrl,
                                        decoration: InputDecoration(
                                          //labelText: "First Name",
                                        ),
                                        validator: (value) =>
                                        value!.isEmpty ? "Audience Name can't be blank" : null,
                                        onFieldSubmitted: (v) {
                                          formKey.currentState?.validate();
                                        },
                                        keyboardType: TextInputType.text,
                                      ),
                                    )
                                  ],
                                )),
                          ),
                          Divider(height: 30, color: Colors.grey[200]!,),
                          //source type
                          Container(
                            height: MediaQuery.of(context).size.height>720?420:MediaQuery.of(context).size.height-300,
                            child: SingleChildScrollView(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin:EdgeInsets.symmetric(vertical: 7),
                                  child: Text("Source Type:"),
                                ),
                                InkWell(
                                    onTap: (){setState((){
                                      source_type = "facebook";
                                    });
                                    },
                                    child:Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: source_type=="facebook"?CONFIG.facebookColor:Colors.grey[300]!),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 0,vertical: 7),
                                      margin: EdgeInsets.symmetric(vertical: 7),
                                      child: ListTile(
                                        leading: Container(child: Icon(FontAwesomeIcons.squareFacebook, size: 40, color: source_type=="facebook"?CONFIG.facebookColor:Colors.grey,),),
                                        title: Text("Facebook"),
                                        subtitle: Text("Analyze Facebook groups and pages"),
                                      ),
                                    )),
                                InkWell(
                                    onTap: (){setState((){
                                      source_type = "instagram";
                                    });
                                      },
                                    child:Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: source_type=="instagram"?CONFIG.instagramColor:Colors.grey[300]!),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 0,vertical: 7),
                                      margin: EdgeInsets.symmetric(vertical: 7),
                                      child: ListTile(
                                        leading: Container(child: Icon(FontAwesomeIcons.instagram, size: 40, color: source_type=="instagram"?CONFIG.instagramColor:Colors.grey,),),
                                        title: Text("Instagram"),
                                        subtitle: Text("Target the right Instagram audience"),
                                      ),
                                    )),
                                InkWell(
                                    onTap: (){setState((){
                                      source_type = "linkedin";
                                    });
                                    },
                                    child:Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: source_type=="linkedin"?CONFIG.linkedinColor:Colors.grey[300]!),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 0,vertical: 7),
                                      margin: EdgeInsets.symmetric(vertical: 7),
                                      child: ListTile(
                                        leading: Container(child: Icon(FontAwesomeIcons.linkedin, size: 40, color: source_type=="linkedin"?CONFIG.linkedinColor:Colors.grey,),),
                                        title: Text("LinkedIn"),
                                        subtitle: Text("Find the right LinkedIn audience"),
                                      ),
                                    )),
                                InkWell(
                                    onTap: (){setState((){
                                      source_type = "custom";
                                    });
                                    },
                                    child:Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: source_type=="custom"?CONFIG.primaryColor:Colors.grey[300]!),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 0,vertical: 7),
                                      margin: EdgeInsets.symmetric(vertical: 7),
                                      child: ListTile(
                                        leading: Container(child: Icon(FontAwesomeIcons.fileCsv, size: 40, color: source_type=="custom"?CONFIG.primaryColor:Colors.grey,),),
                                        title: Text("Custom Source"),
                                        subtitle: Text("Upload your own list"),
                                      ),
                                    ))
                              ],
                            )),
                          ),
                        ],
                      ))
              );
            }
        );
  }
  );
}

}