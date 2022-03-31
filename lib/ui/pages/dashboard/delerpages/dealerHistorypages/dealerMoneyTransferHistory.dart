import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:http/http.dart'as http;

class DealerMoneyTransferReport extends StatefulWidget {
  const DealerMoneyTransferReport({Key key}) : super(key: key);

  @override
  _DealerMoneyTransferReportState createState() => _DealerMoneyTransferReportState();
}

class _DealerMoneyTransferReportState extends State<DealerMoneyTransferReport> {


  String dropdownValue = 'ALL';
  ScrollController _controllerList = ScrollController();

  String frmDate = "";
  String toDate = "";
  String userId2 = "";
  List delHistory = [];


  DateTime selectedDate = DateTime.now();
 DateTime selectedDate2 = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        builder: (context, child) {
          return Theme(
              data: ThemeData.light().copyWith(
                primaryColor:SecondaryColor,
                accentColor: SecondaryColor,
                colorScheme: ColorScheme.light(
                  primary:SecondaryColor,
                  onSurface: Colors.white,
                  surface: Colors.white,

                ),
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                      borderSide:BorderSide(width: 1,color: TextColor)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide:BorderSide(width: 1,color: TextColor)
                  ),
                  hintStyle: TextStyle(
                    color: TextColor,
                  ),
                ),
                textTheme: TextTheme(

                ),
                hintColor:SecondaryColor ,
                buttonTheme: ButtonThemeData(
                  textTheme: ButtonTextTheme.primary,
                ),
                dialogBackgroundColor:PrimaryColor,
              ),
              // This will change to dark theme.
              child:Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Container(
                    child: child,
                  ),
                ),
              )
          );
        },
        firstDate: DateTime(1980),
        lastDate: DateTime(2050));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> _selectDate2(BuildContext context) async {

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate2,
        builder: (context, child) {
          return Theme(
              data: ThemeData.light().copyWith(
                primaryColor:SecondaryColor,
                accentColor: SecondaryColor,
                colorScheme: ColorScheme.light(
                  primary:SecondaryColor,
                  onSurface: Colors.white,
                  surface: Colors.white,

                ),
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                      borderSide:BorderSide(width: 1,color: TextColor)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide:BorderSide(width: 1,color: TextColor)
                  ),
                  hintStyle: TextStyle(
                    color: TextColor,
                  ),
                ),
                textTheme: TextTheme(

                ),
                hintColor:SecondaryColor ,
                buttonTheme: ButtonThemeData(
                  textTheme: ButtonTextTheme.primary,
                ),
                dialogBackgroundColor:PrimaryColor,
              ),
              // This will change to dark theme.
              child:Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Container(
                    child: child,
                  ),
                ),
              )
          );
        },
        firstDate: DateTime(1980),
        lastDate: DateTime(2050));
    if (picked != null && picked != selectedDate2)
      setState(() {
        selectedDate2 = picked;

      });
  }




  List retailer = [];
  TextEditingController _textController = TextEditingController();
  ScrollController listSlide = ScrollController();


  String retailerName = "Select Retailer Name";
  String retailerId = "";
  String retailerFirm = "";
  String retailerAmount = "";
  String trasactionId = "";
  String retailerCredit = "";

  int pageIndex = 1;

  Future<void> retailerList() async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var url = new Uri.http("api.vastwebindia.com", "/api/data/retailer_list");
    final http.Response response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response);

    if (response.statusCode == 200) {
      var dataa1 = json.decode(response.body);


      setState(() {
        retailer = dataa1;

      });


    } else {
      throw Exception('Failed to load themes');
    }

  }


  void retailerListdialog(){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setStatee){
            return Container(
              color: Colors.black.withOpacity(0.8),
              child: AlertDialog(
                buttonPadding: EdgeInsets.all(0),
                titlePadding: EdgeInsets.all(0),
                contentPadding: EdgeInsets.only(left: 10,right: 10),
                title: Container(
                  child: Column(
                    children: [
                      Container(
                        color:PrimaryColor,
                        padding: EdgeInsets.only(top: 8,),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 8,left: 8,right: 8),
                          color: PrimaryColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(getTranslated(context, 'Select Retailer'),
                                  style: TextStyle(color: TextColor,fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),

                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 8,bottom: 8,left: 10,right: 10),
                        color: PrimaryColor.withOpacity(0.9),
                        child: TextField(
                          onChanged: (value) {
                            setStatee(() {

                            });
                          },
                          controller: _textController,
                          decoration: InputDecoration(
                            labelText:getTranslated(context, 'Search'),
                            hintText:getTranslated(context, 'Search'),
                            labelStyle: TextStyle(color: TextColor),
                            hintStyle: TextStyle(color: TextColor),
                            contentPadding: EdgeInsets.only(left: 25),
                            suffixIcon:Icon(Icons.search,color: TextColor,) ,
                            border: OutlineInputBorder(
                                gapPadding: 1,
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(width: 1,color: TextColor)
                            ),
                            enabledBorder: OutlineInputBorder(
                                gapPadding: 1,
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(width: 1,color: TextColor)
                            ),
                            focusedBorder:  OutlineInputBorder(
                                gapPadding: 1,
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(width: 1,color: TextColor)
                            ),
                          ),
                          style: TextStyle(color: TextColor,fontSize: 20),
                          cursorColor: TextColor,
                          cursorHeight: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                content: Container(// Change as per your requirement
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Container(
                        child: ListView.builder(
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          controller: listSlide,
                          itemCount: retailer.length,
                          itemBuilder: (context,  index) {
                            if (_textController.text.isEmpty) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      style: ButtonStyle(
                                        overlayColor: MaterialStateProperty.all(Colors.transparent) ,
                                        shadowColor: MaterialStateProperty.all(Colors.transparent),
                                        backgroundColor:MaterialStateProperty.all(Colors.transparent) ,
                                        padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                                      ),
                                      onPressed: (){

                                        setState(() {

                                          retailerName = retailer[index]["Name"];
                                          retailerId  =  retailer[index]["UserID"];
                                          retailerFirm = retailer[index]["firmName"];


                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(top: 5),
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text( getTranslated(context, 'Name') + " :" + retailer[index]["Name"].toString().toUpperCase(),textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                            Text( getTranslated(context, 'FirmName') +" : " +retailer[index]["firmName"].toString().toUpperCase(),textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                            Container(margin: EdgeInsets.only(top: 5),height: 1,color: PrimaryColor,)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else if (retailer[index]["Name"]
                                .toLowerCase()
                                .contains(_textController.text) || retailer[index]["Name"]
                                .toUpperCase()
                                .contains(_textController.text)) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          style: ButtonStyle(
                                            padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                                          ),
                                          onPressed: (){

                                            setState(() {

                                              retailerName = retailer[index]["Name"];
                                              retailerId  =  retailer[index]["UserID"];
                                              retailerFirm = retailer[index]["firmName"];


                                            });
                                            _textController.clear();
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(getTranslated(context, 'Name') +retailer[index]["Name"].toString().toUpperCase(),textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                                Text(getTranslated(context, 'FirmName') +retailer[index]["firmName"].toString().toUpperCase() ,textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),

                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(height: 1,color: PrimaryColor,margin: EdgeInsets.only(top: 0,bottom: 0),)
                                ],
                              );
                            } else {
                              return Container(
                              );
                            }

                          },
                        ),),
                    )
                ),
              ),
            );
          });
        });

  }

  Future<void> dealerMoneyTransferReport( String page ,String from1 ,String to1,String retailer1,String all1,String all2,String all3 ) async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var url = new Uri.http("api.vastwebindia.com", "/api/data/dealer_rem_MoneyTransferReport",
        {
          "pageindex" : page,
          "txt_frm_date" : from1,
          "txt_to_date" :to1,
          "allretailer" : retailer1,
          "allapiuser": all1,
          "ddl_status":all2,
          "ddl_Type":all3,
        });
    final http.Response response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response);

    if (response.statusCode == 200) {
      var dataa1 = json.decode(response.body);

      setState(() {
        delHistory = dataa1;
      });



    } else {
      throw Exception('Failed to load themes');
    }


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retailerList();

    frmDate = "${selectedDate2.toLocal()}".split(' ')[0];
    toDate = "${selectedDate.toLocal()}".split(' ')[0];


    dealerMoneyTransferReport(pageIndex.toString(),frmDate,toDate,retailerId,"","ALL","ALL");

  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: SimpleAppBarWidget(
          title: Align(
              alignment:  Alignment(-.4, 0),
              child: Text(getTranslated(context, 'money Transfer Report'),style: TextStyle(color: TextColor),textAlign: TextAlign.center,)),
          body: SingleChildScrollView(
            child: StickyHeader(
              header: Container(
                color: TextColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      color: PrimaryColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: TextColor.withOpacity(0.1),
                            padding: EdgeInsets.only(top: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3),
                                          border: Border.all(
                                            color: PrimaryColor,
                                          )
                                      ),
                                      margin: EdgeInsets.only(left: 10,right: 2),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 2,left: 10,right: 17,bottom: 2),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child: Icon(Icons.calendar_today_outlined,size: 25,color: TextColor,),
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                _selectDate2(context);
                                              },
                                              child:Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    getTranslated(context, 'From Date'),
                                                    style: TextStyle(
                                                        fontSize: 10, color: TextColor),
                                                  ),
                                                  Text(
                                                    "${selectedDate2.toLocal()}".split(' ')[0],
                                                    style: TextStyle(
                                                        fontSize: 14, color: TextColor),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 2,right: 3),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3),
                                          border: Border.all(
                                            color: PrimaryColor,
                                          )
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 2,left: 10,right: 17,bottom: 2),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child: Icon(Icons.calendar_today_outlined,size: 25,color: TextColor,),
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                _selectDate(context);
                                              },
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    getTranslated(context, 'To Date'),
                                                    style: TextStyle(
                                                        fontSize: 10, color: TextColor),
                                                  ),
                                                  Text(
                                                    "${selectedDate.toLocal()}".split(' ')[0],
                                                    style: TextStyle(
                                                        fontSize: 14, color: TextColor),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 10),
                                      height: 40,
                                      width: 55,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3),
                                          border: Border.all(
                                            color: PrimaryColor,
                                          ),
                                          color: SecondaryColor
                                      ),
                                      alignment: Alignment.center,
                                      child:IconButton(
                                        icon: Icon(
                                          Icons.search,
                                        ),
                                        iconSize: 25,
                                        color: TextColor,
                                        splashColor: Colors.purple,
                                        onPressed: () {

                                          frmDate = "${selectedDate2.toLocal()}".split(' ')[0];
                                          toDate = "${selectedDate.toLocal()}".split(' ')[0];
                                          dealerMoneyTransferReport(pageIndex.toString(),frmDate,toDate,retailerId,"","ALL","ALL");


                                        },
                                      ),

                                    ),
                                  ],
                                ),
                                Container(
                                  height: 45,
                                  color: Colors.transparent,
                                  margin: EdgeInsets.all(10),
                                  child: OutlineButton(
                                    shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(4) ),
                                    splashColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    clipBehavior: Clip.none,
                                    autofocus: false,
                                    color:Colors.transparent ,
                                    highlightColor:Colors.transparent ,
                                    highlightedBorderColor: TextColor,
                                    focusColor: TextColor,
                                    borderSide: BorderSide(width: 1,color: TextColor,),
                                    onPressed: retailerListdialog,
                                    child: Container(
                                      width: 320,
                                      child: Row(
                                        children: [
                                          Expanded(child: Text(retailerName,style: TextStyle(color: TextColor,fontWeight: FontWeight.normal,fontSize: 16),)),
                                          SizedBox(width: 20,child: Icon(Icons.arrow_drop_down,color: TextColor,),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              content: Container(
                margin: EdgeInsets.only(top: 15),
                alignment: Alignment.center,
                color: TextColor,
                child: delHistory.length == 0 ? Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(getTranslated(context, 'No Data') ,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)
                    ],
                  ),

                ):
                Column(
                  children: [
                    ListView.builder(
                        controller: _controllerList,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount:delHistory.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: PrimaryColor.withOpacity(0.08),
                                      blurRadius: .5,
                                      spreadRadius: 1,
                                      offset:
                                      Offset(.0, .0), // shadow direction: bottom right
                                    )
                                  ],
                                ),
                                margin: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 10),
                                child: Container(
                                  margin: EdgeInsets.only(left: 0.5,right: 0.5,
                                      top: 0.5,bottom: 0.5),
                                  child: Container(
                                    color:Colors.white.withOpacity(0.5),
                                    padding: EdgeInsets.only(top: 5, bottom: 0, left: 5, right: 5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child:Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  delHistory[index]["status"] == "Pending"?
                                                  Icon(Icons.watch_later,color: Colors.yellow[800],):
                                                  delHistory[index]["status"] == "SUCCESS"?
                                                  Icon(Icons.check_circle,color: Colors.green,):Icon(Icons.cancel,color: Colors.red,),
                                                  SizedBox(width: 5,),
                                                  Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(getTranslated(context, 'Name'),style: TextStyle(fontSize: 10,),),
                                                        Text (delHistory[index]["retailername"] == "" ? "....." :delHistory[index]["retailername"],style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                      ]),
                                                ],
                                              ),
                                              Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Text (getTranslated(context, 'Date'),style: TextStyle(fontSize: 10,),),
                                                    Text (delHistory[index]["trans_time"] == null ? "0 0 0" :delHistory[index]["trans_time"],style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,),),
                                                  ]),

                                            ],
                                          ),
                                        ),
                                        Container(padding: EdgeInsets.only(top: 0.5,bottom: 0.5,),margin: EdgeInsets.only(top: 2,bottom: 2,),),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                      right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1))),

                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      getTranslated(context, 'Sender No'),
                                                      softWrap: true,
                                                      style: TextStyle(fontSize: 10),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Text(delHistory[index]["senderno"].toString(),
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                      right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1))),

                                                ),
                                                child: Column(
                                                  children: [
                                                    Text(getTranslated(context, 'Amount'),style: TextStyle(fontSize: 10),),
                                                    Text("\u{20B9} " + delHistory[index]["amount"].toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                      right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1))),

                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(getTranslated(context, 'Charge'),style: TextStyle(fontSize: 10),),
                                                    Text("\u{20B9} " + delHistory[index]["charge"].toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Text(getTranslated(context, 'Net Amount'),style: TextStyle(fontSize: 10),),
                                                    Text("\u{20B9} " + delHistory[index]["totalamount"].toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
                                                  ],
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        )
                                      ],

                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              )
                            ],
                          );

                        }
                    ),
                  ],
                ),
              ),
            ),

          ),
        ),
      ),
    );
  }
}
