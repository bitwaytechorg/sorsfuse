import 'dart:convert';
import 'dart:io';
import 'dart:js' as js;
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sorsfuse/components/app_bar.dart';
import 'package:sorsfuse/components/bottom-bar.dart';
import 'package:sorsfuse/components/drawer.dart';
import 'package:sorsfuse/components/map.dart';
import 'package:sorsfuse/components/time_ag0_format.dart';
import 'package:sorsfuse/config/config.dart' as CONFIG;
import 'package:sorsfuse/global/session.dart' as SESSION;
import 'package:sorsfuse/global/global.dart' as GLOBAL;
import 'package:sorsfuse/models/audience.dart';
import 'package:sorsfuse/repositories/audienceRepository.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_time_ago/get_time_ago.dart';

class AudienceScreen extends StatefulWidget {
  final String audience_id;
  AudienceScreen({required this.audience_id});

  @override
  AudienceState createState() => AudienceState();
}

class AudienceState extends State<AudienceScreen> {
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  final sourceLinkCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final sourceLinkFocusNode = FocusNode();
  //repo
  AudienceRepository _audienceRepository = new AudienceRepository();

  @override
  void initState(){
    GetTimeAgo.setCustomLocaleMessages('en', CustomMessages());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldkey,
        appBar: BWTAppBar(
          scaffoldKey: scaffoldkey,
          context: context,
        ),
        endDrawer: BWTDrawer(),
        body: Stack(children: [SingleChildScrollView(
            child: Center(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: AudienceWidget()))),
          Align(
            alignment: Alignment.bottomLeft,
            child: BottomWidget(),
          )
    ]));
  }

  Widget AudienceWidget() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(GLOBAL.audienceCollection)
            .doc(widget.audience_id)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              Map<String, dynamic> data = {};
              snapshot.data!.data()?.forEach((key, value) {
                data[key] = value;
              });
              Audience _audience = Audience.fromMap(data);
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 10, bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _audience.name.capitalize(),
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              Text(
                                _audience.source_type.capitalize(),
                              ),
                            ],
                          )),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 10, bottom: 10, left: 20, right: 20),
                          child: Text("Back to List"),
                        ),
                      ),
                    ],
                  ),
                  //Detail section
                  Container(
                      child: Wrap(
                    runSpacing: 10,
                    spacing: 10,
                    children: [
                      //sources
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey[300]!)),
                        width: MediaQuery.of(context).size.width < 900
                            ? MediaQuery.of(context).size.width
                            : 400,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 10, top: 15),
                              child: Text(
                                "Sources",
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                            Divider(
                              height: 30,
                            ),
                            //button section
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () =>
                                        _audience.source_type == "custom"
                                            ? importCSVFile(_audience)
                                            : showAddSourceDialog(_audience),
                                    child: Text(
                                        _audience.source_type == "custom"
                                            ? "Import CSV File"
                                            : "Add Source"),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            _audience.source_type == "custom"
                                                ? CONFIG.secondaryColor
                                                : CONFIG.primaryColor,
                                        foregroundColor:
                                            _audience.source_type == "custom"
                                                ? CONFIG.primaryColor
                                                : Colors.white,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 20),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8))),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  ElevatedButton(
                                    onPressed: () => startSharingOnFB(),
                                    child: Text("Share with Facebook"),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: CONFIG.facebookColor,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 20),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8))),
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              height: 30,
                            ),
                            //stats
                            Container(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      child: CircularProgressIndicator(
                                        semanticsValue: "FB",
                                        value: 0.0,
                                        backgroundColor: Colors.grey[300],
                                        color: CONFIG.facebookColor,
                                        strokeWidth: 6,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 7),
                                      child: Text("Sources"),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      child: CircularProgressIndicator(
                                        semanticsLabel: "78",
                                        value: 0.0,
                                        backgroundColor: Colors.grey[300],
                                        color: CONFIG.instagramColor,
                                        strokeWidth: 6,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 7),
                                      child: Text("Users"),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      child: CircularProgressIndicator(
                                        value: 0.0,
                                        backgroundColor: Colors.grey[300],
                                        color: CONFIG.linkedinColor,
                                        strokeWidth: 6,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 7),
                                      child: Text("Coverage"),
                                    )
                                  ],
                                ),
                              ],
                            )),
                            Divider(
                              height: 30,
                            ),
                            //source table
                            Container(
                                width: 400,
                                child: DataTable(
                                  sortAscending: true,
                                  sortColumnIndex: 0,
                                  headingRowColor:
                                      MaterialStateColor.resolveWith(
                                          (states) => Colors.grey[300]!),
                                  columns: [
                                    DataColumn(label: Text("Source")),
                                    DataColumn(label: Text("Coverage")),
                                    DataColumn(label: Text("Date")),
                                  ],
                                  rows: _audience.source_list.length > 0
                                      ? _audience.source_list
                                          .map(
                                            (e) => DataRow(
                                              cells: [
                                                DataCell(Container(
                                                  padding:
                                                      EdgeInsets.only(top: 8),
                                                  width: 150,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        e['title'].toString(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 12,
                                                            color: CONFIG
                                                                .primaryColor),
                                                      ),
                                                      Text(
                                                        e['member_count']
                                                                .toString() +
                                                            " members",
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            color:
                                                                Colors.black87),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                                DataCell(
                                                  Text(
                                                    e['coverage'],
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.black87),
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(
                                                    GetTimeAgo.parse(DateTime.parse(e['created_at'])),
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.black54),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                          .toList()
                                      : [],
                                ))
                          ],
                        ),
                      ),
                      //Map
                      Container(
                          width: MediaQuery.of(context).size.width < 900
                              ? MediaQuery.of(context).size.width
                              : MediaQuery.of(context).size.width - 460,
                          height: 600,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey[300]!)),
                          margin: EdgeInsets.only(bottom: 20),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: WorldMap(
                            data: [
                              {"country": "India", "density": 0}
                            ],
                            title: "User Density Map",
                          ))
                    ],
                  ))
                ],
              );
            } else {
              return Center(
                  child: Container(
                margin: EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  "No Audience details available. Please check .",
                  style: TextStyle(fontSize: 20),
                ),
              ));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  //add Audience
  void showAddSourceDialog(Audience _data) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          String source_type = "";
          bool is_finding = false;
          bool is_ready_for_analysis = false;
          List<Map<String,dynamic>> line_status = [];
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                backgroundColor: Colors.white,
                titlePadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                title: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey[300]!))),
                    child: Text(
                      "Add Source",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    )),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                actions: [
                  ElevatedButton(
                    child: Text(is_ready_for_analysis?"Proceed to Analyse":"Add Source"),
                    onPressed: () async {
                      if(is_ready_for_analysis){
                        _data.status = "analysing";
                         _audienceRepository.save(_data);
                         Navigator.of(context).pop();
                      } else if(is_finding){

                      } else {
                        if (formKey.currentState!.validate()) {
                          List lines = sourceLinkCtrl.text.split("\n");
                          List<Map<String, dynamic>> l = [];
                          lines.forEach((element) {
                            l.add({"link": element, "status": "searching..."});
                          });

                          //print(lines);
                          setState(() {
                            is_finding = true;
                            line_status = l;
                          });

                          await Future.forEach(lines, (element) async {
                            int index = lines.indexOf(element);
                            if (element != "") {
                              print(element);
                              //get details from facebook
                              //get id
                              //remove last /
                              if (element.indexOf("facebook.com") > -1) {
                                //check if direct ID
                                String identifier = "";
                                String id = "";
                                bool is_group = (element.indexOf("groups") >
                                    -1);
                                bool element_has_id = false;
                                Map<String, dynamic> element_data = {};
                                if (element.indexOf("?id=") > -1) {
                                  id = element.substring(
                                      element.indexOf("?id=") + 4);
                                  element_has_id = true;
                                } else {
                                  List link_parts = element.split("/");
                                  identifier =
                                  link_parts[link_parts.length - 1] != ""
                                      ? link_parts[link_parts.length - 1]
                                      : link_parts[link_parts.length - 2];
                                  //get details form API
                                  //String API_URL = "https://api.sniperrleads.com/fbIDFetcher.php?i=${identifier}&type=" +
                                  String API_URL = "http://209.38.227.227/fbInfoFetcher.php?i=${identifier}&type=" +
                                      (is_group ? "group" : "page");
                                  print(API_URL);
                                  var api_response = await http.get(
                                      Uri.parse(API_URL), headers: {
                                    'Access-Control-Allow-Origin': '*',
                                    "Accept": "application/json"
                                  });
                                  if (api_response.statusCode == 200) {
                                    if (api_response.body != "[]") {
                                      Map<String,
                                          dynamic> api_data = jsonDecode(
                                          api_response.body);
                                      element_data = api_data;
                                      print(api_data);
                                      l[index]["status"] = "found";
                                      id = api_data["id"].toString();
                                      _data.source_list.add({
                                      "link": element,
                                      "status": "in queue",
                                      "created_at": DateTime.now().toString(),
                                      "member_count":  randomNumber(),//member_count,
                                      "title": api_data["id"].toString(),
                                      "id": api_data["id"].toString(),
                                      "source": "Facebook",
                                      "type": is_group ? "group" : "page",
                                      "privacy": "",
                                      "coverage": ""
                                      });
                                    } else {
                                      l[index]["status"] = "not found";
                                    }
                                  } else {
                                    print("Error is getting API Response - " +
                                        api_response.statusCode.toString());
                                    l[index]["status"] = "not found";
                                  }
                                }
                                setState(() {
                                  line_status = l;
                                });

                                //get data from facebook graph api
                                /*
                                if (id != "") {
                                  String fields = is_group
                                      ? "id,member_count,name,privacy"
                                      : "id,name,followers_count";
                                  String graphUrl = "https://graph.facebook.com/v16.0/${id}?fields=${fields}&access_token=" +
                                      SESSION.fb_access_token;
                                  http.Response response = await http.get(
                                      Uri.parse(graphUrl));
                                  Map<String,
                                      dynamic> responseData = jsonDecode(
                                      response.body);
                                  print(responseData);
                                  int member_count = responseData.containsKey(
                                      "followers_count")
                                      ? responseData["followers_count"]
                                      : 0; //responseData["member_count"];
                                  _data.source_list.add({
                                    "link": element,
                                    "status": "in queue",
                                    "created_at": DateTime.now().toString(),
                                    "member_count":  //randomNumber(),//member_count,
                                    "title": element_has_id
                                        ? responseData["name"]
                                        : element_data["title"],
                                    "id": element_has_id
                                        ? responseData["id"]
                                        : element_data["id"],
                                    "source": "Facebook",
                                    "type": is_group ? "group" : "page",
                                    "privacy": "",
                                    "coverage": ""
                                  });
                                }
                                */
                              }
                              //end facebook

                            }
                          });
                          setState((){
                            //is_finding = false;
                            is_ready_for_analysis=true;
                          });
                          _data.status = "analysing";
                          print(_data.source_list);
                        }
                      }
                    },
                  ),
                  TextButton(
                    child: Text("Close"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
                content: Container(
                  width: MediaQuery.of(context).size.width < 600
                      ? MediaQuery.of(context).size.width
                      : 800,
                  color: Colors.white,
                  child: Form(
                      key: formKey,
                      child: Wrap(
                        //direction: Axis.vertical,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 7),
                            child: Text("Links:"),
                          ),
                          is_finding?Container(
                            child: ListView.builder(itemBuilder: (context,index){
                              Color statusColor = Colors.orange;
                              if(line_status[index]["status"]=="found"){
                                statusColor = Colors.green;
                              } else if(line_status[index]=="not found"){
                                statusColor = Colors.red;
                              }
                              return ListTile(
                                title: Text(line_status[index]["link"]),
                                subtitle: Text(line_status[index]["status"].toString().toUpperCase(), style: TextStyle(color: statusColor, fontSize: 12),),
                              );
                            },
                            itemCount: line_status.length, shrinkWrap: true,),
                          ):Container(
                            child: TextFormField(
                              autofocus: true,
                              focusNode: sourceLinkFocusNode,
                              maxLines: 6,
                              minLines: 6,
                              controller: sourceLinkCtrl,
                              decoration: InputDecoration(
                                  //labelText: "First Name",
                                  ),
                              validator: (value) =>
                                  value!.isEmpty ? "Please add links" : null,
                              onFieldSubmitted: (v) {
                                formKey.currentState?.validate();
                              },
                              keyboardType: TextInputType.multiline,
                            ),
                          )
                        ],
                      )),
                ));
          });
        });
  }

  void importCSVFile(Audience _audience) {
    List<TextEditingController>? _controllers = [];
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          List<PlatformFile> CSVFiles = [];
          bool is_uploaded = false;
          String msg = "";
          String error = "";
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                backgroundColor: Colors.white,
                titlePadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                title: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey[300]!))),
                    child: Text(
                      "Import CSV Files",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    )),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                actions: [
                  ElevatedButton(
                    child: Text(is_uploaded?"Done":"Import"),
                    onPressed: () async {
                      if(is_uploaded){
                        Navigator.pop(context);
                      } else {
                        if (CSVFiles.length > 0) {
                          await Future.forEach(CSVFiles, (file) async {
                            //upload file
                            setState(() {
                              msg = "Uploading CSV...";
                            });
                            Reference ref = FirebaseStorage.instance
                                .ref('custom-csv/' + file.name);

                            final metadata = SettableMetadata(
                              contentType: "text/csv",
                              //customMetadata: {'picked-file-path': file.path},
                            );
                            Uint8List bytes = await file.bytes!;
                            try {
                              final uploadTask = ref.putData(bytes, metadata);

                              uploadTask.snapshotEvents.listen((event) async {
                                double progress =
                                    (event.bytesTransferred.toDouble() /
                                        event.totalBytes.toDouble()) *
                                        100;

                                setState(() {
                                  msg =
                                  "Uploading ${file.name}...${progress.floor()
                                      .toString()}%";
                                });
                                if (event.state == TaskState.success) {
                                  String tmp_path = await ref.getDownloadURL();
                                  List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(utf8.decode(file.bytes as List<int>));
                                  Map<String, dynamic> _source={
                                    "link": tmp_path,
                                    "status": "in queue",
                                    "member_count": randomNumber(),//rowsAsListOfValues[0].length,
                                    "title": file.name,
                                    "id": DateTime.now().toUtc().millisecondsSinceEpoch,
                                    "type": "custom csv",
                                    "privacy": "",
                                    "coverage": ""
                                  };
                                  _audience.source_list.add(_source);
                                }
                              });
                              var res = await uploadTask.whenComplete(() {
                                return true;
                              });
                            } on FirebaseException catch (e) {
                              setState(() {
                                error = "Error: " + e.toString();
                              });
                              print(e.message);
                            }
                          });
                          _audience.status="analysing";
                          _audienceRepository.save(_audience);
                          setState(() {
                            is_uploaded = true;
                          });
                          //Navigator.of(context).pop();
                        } else {
                          setState(() {
                            error = "Please selct CSV File(s) to import";
                          });
                        }
                      }
                    },
                  ),
                  TextButton(
                    child: Text("Close"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
                content: Wrap(
                  children: [
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        width: MediaQuery.of(context).size.width < 600
                            ? MediaQuery.of(context).size.width
                            : 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Supported Columns:"),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "1. Name",
                              style: TextStyle(fontSize: 13),
                            ),
                            Text(
                              "2. Email",
                              style: TextStyle(fontSize: 13),
                            ),
                            Text(
                              "3. Phone",
                              style: TextStyle(fontSize: 13),
                            ),
                            Text(
                              "4. Profile URL",
                              style: TextStyle(fontSize: 13),
                            ),
                            Text(
                              "5. Profile ID",
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width < 600
                            ? MediaQuery.of(context).size.width
                            : 600,
                        color: Colors.white,
                        child: Column(
                          children: [
                            CSVFiles.length == 0
                                ? InkWell(
                                    onTap: () async {
                                      FilePickerResult? result =
                                          await FilePicker.platform.pickFiles(
                                        type: FileType.custom,
                                        allowMultiple: true,
                                        allowedExtensions: ['csv'],
                                      );
                                      print(result?.files.length);
                                      if (result != null) {
                                        List<PlatformFile> files = result.files;
                                        setState(() {
                                          CSVFiles = files;
                                        });
                                      }
                                      setState(() {
                                        error = "";
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                          border: Border.all(
                                              color: Colors.grey[300]!)),
                                      width: MediaQuery.of(context).size.width <
                                              600
                                          ? MediaQuery.of(context).size.width
                                          : 800,
                                      height: 200,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 50, horizontal: 100),
                                      margin:
                                          EdgeInsets.symmetric(vertical: 20),
                                      child: Column(children: [
                                        Icon(
                                          FontAwesomeIcons.fileCsv,
                                          color: Colors.grey[400],
                                          size: 40,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "Click to select multiple CSV files",
                                          style: TextStyle(
                                              color: Colors.grey[500]),
                                        )
                                      ]),
                                    ))
                                : Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        border: Border.all(
                                            color: Colors.grey[300]!)),
                                    width:
                                        MediaQuery.of(context).size.width < 600
                                            ? MediaQuery.of(context).size.width
                                            : 800,
                                    height: 200,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    margin: EdgeInsets.symmetric(vertical: 20),
                                    child: SingleChildScrollView(
                                        child: ListView.builder(
                                      itemBuilder: (context, index) {
                                        _controllers.add(TextEditingController(
                                            text: CSVFiles[index]
                                                .name
                                                .replaceAll(".csv", "")));
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              (index + 1).toString() +
                                                  ". " +
                                                  CSVFiles[index].name,
                                              style: TextStyle(fontSize: 13),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                List<PlatformFile> _f =
                                                    CSVFiles;
                                                _f.removeAt(index);
                                                setState(() {
                                                  CSVFiles = _f;
                                                });
                                              },
                                              child: Icon(
                                                FontAwesomeIcons.xmark,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                      itemCount: CSVFiles.length,
                                      shrinkWrap: true,
                                    )),
                                  ),
                            Container(
                              child: Text(error,
                                  style: TextStyle(
                                      color: Colors.red,fontSize: 12)),
                            ),
                            Container(
                              child: Text(msg,
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 12)),
                            ),
                          ],
                        ))
                  ],
                ));
          });
        });
  }

  void startSharingOnFB() {
    // show all accounts to select
    List<Map<String, dynamic>> ad_accounts = [];
    SESSION.ad_accounts.forEach((key, value) {
      ad_accounts.add(value);
    });
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          Map<String, dynamic> selected_account = ad_accounts[0];
          String state = "select_account";
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                backgroundColor: Colors.white,
                titlePadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                title: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey[300]!))),
                    child: Text(
                      "Select Ad Account",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    )),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                actions: [
                  ElevatedButton(
                    child: Text(state == "check_tos"
                        ? "Re-check Terms of Service"
                        : "Proceed"),
                    onPressed: () async {
                      if (state == "select_account" || state == "check_tos") {
                        bool tos = await checkTOS(selected_account);
                        setState(() {
                          state = (tos == false) ? "check_tos" : "share";
                        });
                      } else {
                        //share audience
                        // TODO: call function to share audience
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  TextButton(
                    child: Text("Close"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
                content: Container(
                  width: MediaQuery.of(context).size.width < 600
                      ? MediaQuery.of(context).size.width
                      : 800,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: state == "select_account"
                        ? ListView.builder(
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () => setState(() {
                                        selected_account = ad_accounts[index];
                                      }),
                                  child: Container(
                                      margin: EdgeInsets.only(bottom: 7),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 7),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: selected_account[
                                                          "account_id"] ==
                                                      ad_accounts[index]
                                                          ["account_id"]
                                                  ? CONFIG.primaryColor
                                                  : Colors.grey[300]!)),
                                      child: ListTile(
                                        title: Text(ad_accounts[index]["name"]),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                ad_accounts[index]
                                                    ["account_id"],
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color:
                                                        CONFIG.primaryColor)),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            if (ad_accounts[index]
                                                .containsKey("business"))
                                              Text(
                                                  ad_accounts[index]["business"]
                                                      ["name"],
                                                  style:
                                                      TextStyle(fontSize: 12))
                                          ],
                                        ),
                                      )));
                            },
                            itemCount: ad_accounts.length,
                            shrinkWrap: true,
                          )
                        : state == "check_tos"
                            ? Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "You need to accept Facebook's Terms of Service to share Audience with Facebook. Click the button below and Accept the terms of Service. Once you complete the step, click the button to recheck the status to proceed"),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    InkWell(
                                      onTap: () => openPopUp(selected_account),
                                      child: Text(
                                        "Open Facebook's Terms of Seervice Page",
                                        style: TextStyle(
                                            color: CONFIG.linkedinColor),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Container(
                                child: Text(
                                    "You are all set to share Audience. Please tap button below to share Audience."),
                              ),
                  ),
                ));
          });
        });
  }

  Future<bool> checkTOS(Map<String, dynamic> selected_account) async {
    bool accepted_tos = false;
    String graphUrl =
        'https://graph.facebook.com/v16.0/${selected_account["id"]}?fields=tos_accepted,account_id,account_status&access_token=' +
            SESSION.fb_access_token;
    http.Response response = await http.get(Uri.parse(graphUrl));
    Map<String, dynamic> responseData = jsonDecode(response.body);
    print(responseData);
    if (responseData.containsKey("tos_accepted") &&
        responseData["tos_accepted"]['custom_audience_tos'] == 1) {
      //invoke pop up and check for TOS accepted
      accepted_tos = true;
    } else {
      openPopUp(selected_account);
    }
    return accepted_tos;
  }

  void openPopUp(Map<String, dynamic> selected_account) {
    var popup = js.context.callMethod('open', [
      "https://business.facebook.com/ads/manage/customaudiences/tos/?act=" +
          selected_account["account_id"],
      '_blank',
      'width=800,height=700'
    ]);
  }

  int randomNumber(){
      var random = Random();
      return random.nextInt(100000);
  }

}
