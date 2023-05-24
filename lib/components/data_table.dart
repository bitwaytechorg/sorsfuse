import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:sorsfuse/components/search_bar.dart';
import 'package:sorsfuse/config/config.dart' as CONFIG;
import 'package:sorsfuse/global/global.dart' as GLOBAL;
import 'package:sorsfuse/screens/dashboard.dart';
import 'package:confirm_dialog/confirm_dialog.dart';

class BWTDataTable extends StatefulWidget{
  final String screen;
  final List<Map<String, dynamic>> collection;
  final List<String> headers;
  final List<String> dataElements;
  final String uniqueKey;
  bool showView;
  bool inlineUpdate;
  final Function(Map<String, dynamic>)? inlineUpdateFunction;
  BWTDataTable({required this.screen, required this.uniqueKey,required this.collection, required this.headers, required this.dataElements, this.showView=true, this.inlineUpdate=false, this.inlineUpdateFunction});

  @override
  BWTDataTableState createState()=> new BWTDataTableState();
}

class BWTDataTableState extends State<BWTDataTable>{
  //variables to hold data
  List<Map<String, dynamic>> records =[];
  List<Map<String, dynamic>> filtered_data =[];
  //data table components
  bool checkAll = false;
  List<DataColumn> columns=[];
  List<DataRow> rows=[];
  //variables to hold data fetching controls
  int current_page = 1;
  int records_per_page = 25;
  int startAt = 1;
  late int endingAt;
  bool data_loaded = false;
  int total_records = 0;
  int pageCount = 1;
  //for sorting
  bool _sortAsc = true;
  int _sortColumnIndex = 0;
// other variables
  String? message;


  @override
  void initState(){
    //add columns
    widget.headers.forEach((element) {
      columns.add(DataColumn(
        label: Text(element),
      ));
    });
    columns.add(DataColumn(
        label: Text("Action")
    ));
    records = widget.collection;
    filtered_data = records;
    data_loaded=true;
    prepareData(records);
  }

  bool isJSON(String str) {
    if(str.contains("[")) {
      try {
        var a = jsonDecode(str);
      } catch (e) {
        return false;
      }
      return true;
    } else {
      return false;
    }
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
    //hold all rows
    List<DataRow> tmp_rows = [];
    recordsToShow.forEach((element) {
      List<DataCell> cells = [];
      widget.dataElements.forEach((k) {
        Widget child = Container();
        if(k=="created"){
          child = RichText(text: TextSpan(
              text: DateFormat("MMM d, y HH:mm").format(DateTime.parse(element['created_at'].toString()).toLocal()).toString(),
              style: Theme.of(context).textTheme.bodySmall,
              children: [
                TextSpan(
                    text: "\nby ",
                    style: Theme.of(context).textTheme.caption
                ),
                TextSpan(
                    text: element['created_by_name'],
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(color: CONFIG.secondaryColor)
                )
              ]
          ));
        } else if(k=="updated"){
          child =element['updated_at']!=""?RichText(text: TextSpan(
              text: DateFormat("MMM d, y HH:mm").format(DateTime.parse(element['updated_at'].toString()).toLocal()).toString(),
              style: Theme.of(context).textTheme.bodySmall,
              children: [
                TextSpan(
                    text: "\nby ",
                    style: Theme.of(context).textTheme.caption
                ),
                TextSpan(
                    text: element['updated_by_name'],
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(color: CONFIG.secondaryColor)
                )
              ]
          )):Text("No Updates");
        } else {
          String text="";
          if(isJSON(element[k].toString())){
            List a = jsonDecode(element[k].toString());
            List t =[];
            a.forEach((element) {
              if(GLOBAL.lang.containsKey(element)){
                t.add(GLOBAL.lang[element]);
              } else {
                t.add(element);
              }
            });
            text = t.join(", ");
          } else {
            text = GLOBAL.lang.containsKey(element[k])?GLOBAL.lang[element[k]]:element[k].toString();
          }
          child = Wrap(children:[Text(text.toString())]);
        }
        cells.add(DataCell(
            Container(
                constraints: BoxConstraints(minWidth: 20, maxWidth: 220),
                child: child
            )
        ));
      });
      //for updating records
      Widget updatePage = Dashboard();
      Widget viewPage = Dashboard();
      switch(widget.screen){
       /* case widget.screen:
          updatePage = RecipeForm(recipe: Recipe.fromMap(element));
          viewPage = RecipeDetailPage(recipe: Recipe.fromMap(element));
          break;
        case CONFIG.workout_collection:
          updatePage = WorkoutForm(workout: Workout.fromMap(element));
          //viewPage = RecipeDetailPage(recipe: Recipe.fromMap(element));
          break;
        case CONFIG.meal_plan_collection:
          updatePage = MealPlanForm(mealPlan: MealPlan.fromMap(element));
          //viewPage = RecipeDetailPage(recipe: MealPlan.fromMap(element));
          break;
        case CONFIG.users_collection:
          updatePage = RecipeForm(recipe: Recipe.fromMap(element));
          viewPage = RecipeDetailPage(recipe: Recipe.fromMap(element));
          break;
        */
      };
      cells.add(DataCell(
          Container(
            child: Row(
              children: [
                Tooltip(
                  child: IconButton(splashRadius: 20,onPressed: (){
                    if(widget.inlineUpdate){
                      widget.inlineUpdateFunction?.call(element);
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (
                          context) => updatePage));
                    }
                  }, icon: Icon(FontAwesomeIcons.solidPenToSquare, size: 16,)),
                  message: "Update Record",
                ),
                widget.showView?Tooltip(
                  child: IconButton(splashRadius: 20,onPressed: ()=>showViewPage(context,viewPage), icon: Icon(FontAwesomeIcons.eye, size: 16)),
                  message: "View Details",
                ):Container(),
                Tooltip(
                  child: IconButton(
                      splashRadius: 20,
                      splashColor: Colors.red,
                      onPressed: () async {
                        if (await confirm(
                          context,
                          title: const Text('Please Confirm deletion'),
                          content: const Text("Would you like to remove place permanently? Place once removed can't be recovered."),
                          textOK: const Text('Yes Delete'),
                          textCancel: const Text('No, Cancel'),
                        )) {
                          //delete
                          //await FirebaseFirestore.instance.collection(widget.collection).doc(element[widget.uniqueKey]).delete();
                         // fetchData();
                        }
                      }, icon: Icon(FontAwesomeIcons.solidTrashCan, size: 16, color: Colors.redAccent,)),
                  message: "Delete Record",
                ),
              ],
            ),
          )
      ));
      DataRow tmp_row=DataRow(cells: cells, onSelectChanged: (bool? selected){});
      tmp_rows.add(tmp_row);
    });
    setState(() {
      filtered_data = rec;
      rows = tmp_rows;
      message = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //header
          dataTableHeader(),
          //datatable
          records.length>0?Container(
              child:dataTable(context)
          ):Center(
            child: data_loaded?Text("No Records to show"):CircularProgressIndicator(),
          ),
          //footer
          records.length>0?dataTableFooter():Container()
        ],
      ),
    );
  }

  Widget dataTableHeader(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //records per page selector
          Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Text("Records per Page: ", style: Theme.of(context).textTheme.labelSmall,),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButton<int>(items: [
                  DropdownMenuItem(child: Text("25"), value: 25,),
                  DropdownMenuItem(child: Text("50"), value: 50),
                  DropdownMenuItem(child: Text("75"), value: 75),
                  DropdownMenuItem(child: Text("100"), value: 100),
                ],
                  focusColor: Color(0xFFFAFAFA),
                  value: records_per_page,
                  onChanged: (value) { setState(() {
                    records_per_page = value!;
                  });
                  prepareData(filtered_data);
                  },),
              ),
            ],
          ),
          Text(message!),
          //search bar and refresh data
          Row(
            children: [
              Container(
               // child: SearchBar(width: 500, onSearch: onSearch, rtl: true,),
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget dataTable(context){
    return Expanded(child: ListView(
        shrinkWrap: true,
        children:[SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child:ConstrainedBox(
                  constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                  child:DataTable(
                  columnSpacing: 30.0,
                  headingRowColor: MaterialStateProperty.all(CONFIG.primaryColor),
                  headingTextStyle: TextStyle(color: Colors.white),
                  border: TableBorder(
                    left: BorderSide(color: Colors.grey[300]!),
                    right: BorderSide(color: Colors.grey[300]!),
                  ),
                  showCheckboxColumn: false,
                  showBottomBorder: true,
                  columns:columns,
                  rows:rows,
                  sortColumnIndex: _sortColumnIndex,
                  sortAscending: _sortAsc,
                )),
              )),
        )]
    ));
  }

  Widget dataTableFooter(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  child: Text("Showing ${startAt} - ${endingAt} of ${total_records}",style: Theme.of(context).textTheme.labelMedium,)
              ),
              Container(
                child: makePagination(),
              )
            ],
          ),
          Center(child:Text(message!))
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

  void showViewPage(BuildContext context, Widget viewPage){
    showDialog(context: context, builder: (context){
      return  Center(child:Container(
        width: MediaQuery.of(context).size.width-100,
        height: MediaQuery.of(context).size.height-100,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child:Scaffold(body:Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: ()=>Navigator.pop(context),
                child: Icon(FontAwesomeIcons.xmark),
              ),
            ),
            SingleChildScrollView(child:Container(
              height: MediaQuery.of(context).size.height-140,
              padding: EdgeInsets.symmetric(vertical: 30),
              child: viewPage,
            ))
          ],
        ),
        ),
      ));
    });
  }

  void onSearch(text){
    // print(text.toLowerCase());
    //print(widget.dataElements[0]);
    List<Map<String, dynamic>> temp_list = records;
    if(text!='') {
      temp_list = records.where((u) =>
      (u[widget.dataElements[0]]
          .toLowerCase()
          .contains(text.toLowerCase()) ||
          u[widget.dataElements[1]]
              .toLowerCase()
              .contains(text.toLowerCase()) ||
          u[widget.dataElements[2]]
              .toLowerCase()
              .contains(text.toLowerCase()) ||
          u[widget.dataElements[3]]
              .toLowerCase()
              .contains(text.toLowerCase()) ||
          u[widget.dataElements[4]]
              .toLowerCase()
              .contains(text.toLowerCase())
      )).toList();

    } else {
      temp_list = records;
    }
    setState(() {
      filtered_data = temp_list;
    });
    prepareData(temp_list);
  }

  exportData(){

  }

}