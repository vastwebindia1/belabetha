import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:http/http.dart'as http;

class DealerFundReceive extends StatefulWidget {
  const DealerFundReceive({Key key}) : super(key: key);

  @override
  _DealerFundReceiveState createState() => _DealerFundReceiveState();
}

class _DealerFundReceiveState extends State<DealerFundReceive> {


  List masterInfoReport = [];
  List adminInfoReport = [];

  List fundList = ["Receive From Master","Receive From Admin"];

  String frmDate = "";
  String toDate = "";
  String retailerId = "ALL";
  bool masterVisible = true;
  bool adminVisible = false;

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
              child:Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Container(
                      child: child,
                    ),
                  ),
                ],
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
              child:Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Container(
                      child: child,
                    ),
                  ),
                ],
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


  Future<void> dealerFundReceiveMaster( String frmDate, String toDate) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url =
    new Uri.http("api.vastwebindia.com", "/api/Dealer/ReceiveFund_by_master",{
      "txt_frm_date":frmDate,
      "txt_to_date":toDate,
    });
    final http.Response response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 15), onTimeout: (){
      setState(() {

        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(getTranslated(context, 'Data Not Found'),style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);

      });
    });

    print(response);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var daata2 = data["Report"];


      setState(() {

        masterInfoReport = daata2;


      });

    } else {
      throw Exception('Failed to load themes');
    }
  }

  Future<void> dealerFundReceiveAdmin( String frmDate, String toDate,) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url =
    new Uri.http("api.vastwebindia.com", "/api/Dealer/ReceiveFund_by_admin",{
      "txt_frm_date":frmDate,
      "txt_to_date":toDate,
    });
    final http.Response response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 15), onTimeout: (){
      setState(() {

        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(getTranslated(context, 'Data Not Found'),style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);

      });
    });

    print(response);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var data3 = data["Report"];
      print(data3);


      setState(() {

        adminInfoReport = data3;


      });

    } else {
      throw Exception('Failed to load themes');
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    frmDate = "${selectedDate2.toLocal()}".split(' ')[0];
    toDate = "${selectedDate.toLocal()}".split(' ')[0];

    dealerFundReceiveMaster(frmDate,toDate);


  }


  TextEditingController _textController = TextEditingController();
  ScrollController listSlide = ScrollController();

  String receive = "Receive From";



  void fundReciveListdialog(){
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
                contentPadding: EdgeInsets.only(left: 0,right: 0),
                title: Container(
                  color:PrimaryColor.withOpacity(0.8),
                  padding: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text('Receive From'.toUpperCase(),
                          style: TextStyle(color: TextColor,fontSize: 20),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 25,
                        width: 25,
                        child: FlatButton(
                          color: PrimaryColor.withOpacity(0.5),
                          shape:RoundedRectangleBorder(side: BorderSide(color: PrimaryColor, width: 1, style: BorderStyle.solid),
                            borderRadius: new BorderRadius.circular(100),),
                          padding: EdgeInsets.all(0),
                          onPressed: () => Navigator.of(context).pop(),
                          child:Icon(Icons.clear,color: TextColor,size: 22,),
                        ),
                      ),
                    ],
                  ),
                ),
                content: Container(
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Container(
                        child: ListView.builder(
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          controller: listSlide,
                          itemCount: fundList.length,
                          itemBuilder: (context,  index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(top: 0,bottom: 0,left: 10,right: 10,),
                                    decoration: BoxDecoration(border: Border(top: BorderSide(color: PrimaryColor.withOpacity(0.8),width: 1))),
                                    child: TextButton(
                                      style: ButtonStyle(
                                        overlayColor: MaterialStateProperty.all(
                                            Colors.transparent),
                                        shadowColor: MaterialStateProperty.all(
                                            Colors.transparent),
                                        backgroundColor: MaterialStateProperty
                                            .all(Colors.transparent),
                                        padding: MaterialStateProperty.all(
                                            EdgeInsets.all(0)),
                                      ),
                                      onPressed: () {
                                        setState(() {

                                          receive = fundList[index] == null ?"":fundList[index];

                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(fundList[index]== null ? "":fundList[index],
                                              style: TextStyle(color: PrimaryColor),),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),),
                    ),
                ),
              ),
            );
          });
        });

  }

  ScrollController _controllerList = new ScrollController();


  @override
  Widget build(BuildContext context) {
    return SimpleAppBarWidget(
      title: Align(
          alignment:  Alignment(-.4, 0),
          child: Text(getTranslated(context, 'Fund Receive History'),style: TextStyle(color: TextColor),textAlign: TextAlign.center,)),
      body: SingleChildScrollView(
        child: Container(
            child: Container(
              color: TextColor,
            child: StickyHeader(
              header: Container(
                margin: EdgeInsets.only(bottom: 10),
                color: PrimaryColor.withOpacity(0.8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                      height: 45,
                      child: OutlineButton(
                        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(4) ),
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        clipBehavior: Clip.none,
                        autofocus: false,
                        color:Colors.transparent ,
                        highlightColor:Colors.transparent ,
                        highlightedBorderColor: PrimaryColor,
                        focusColor:PrimaryColor ,
                        padding: EdgeInsets.only(left: 10,right: 10),
                        borderSide: BorderSide(width: 1,color: TextColor),
                        onPressed: fundReciveListdialog,
                        child: Container(
                          child: Row(
                            children: [
                              Expanded(child: Text(receive,style: TextStyle(color: TextColor,fontWeight: FontWeight.normal,fontSize: 16),)),
                              SizedBox(width: 20,child: Icon(Icons.arrow_drop_down,color: TextColor,),)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 5,bottom: 10),
                            child: Row(
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

                                      setState(() {



                                        if(receive == "Receive From Master"){

                                          adminVisible = false;
                                          masterVisible = true;

                                          frmDate = "${selectedDate2.toLocal()}".split(' ')[0];
                                          toDate = "${selectedDate.toLocal()}".split(' ')[0];

                                          dealerFundReceiveMaster(frmDate,toDate);


                                        }else if(receive == "Receive From Admin"){

                                          adminVisible = true;
                                          masterVisible = false;

                                          frmDate = "${selectedDate2.toLocal()}".split(' ')[0];
                                          toDate = "${selectedDate.toLocal()}".split(' ')[0];

                                          dealerFundReceiveAdmin(frmDate,toDate);

                                        }else{

                                          frmDate = "${selectedDate2.toLocal()}".split(' ')[0];
                                          toDate = "${selectedDate.toLocal()}".split(' ')[0];

                                          dealerFundReceiveMaster(frmDate,toDate);


                                        }




                                      });




                                    },
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
              content: Column(
                children: [
                  Visibility(
                    visible: masterVisible,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        masterInfoReport.length == 0 ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(getTranslated(context, 'No Data') ,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                          ],
                        ): ListView.builder(
                            controller: _controllerList,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount:masterInfoReport.length,
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
                                                  Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(getTranslated(context, 'Name') ,style: TextStyle(fontSize: 10,),),
                                                        Text (masterInfoReport[index]["SuperstokistName"] == null ? "....." :masterInfoReport[index]["SuperstokistName"],style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                      ]),
                                                  Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text (getTranslated(context, 'Date'),style: TextStyle(fontSize: 10,),),
                                                        Text (masterInfoReport[index]["date_dlm"] == null ? "0 0 0" :masterInfoReport[index]["date_dlm"],style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,),),
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
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          getTranslated(context, 'Pre Balance'),
                                                          softWrap: true,
                                                          style: TextStyle(fontSize: 10),
                                                          textAlign: TextAlign.left,
                                                        ),
                                                        Text(
                                                          "\u{20B9} " + masterInfoReport[index]["dealer_prebal"].toString() == null ? "":"\u{20B9} " + masterInfoReport[index]["dealer_prebal"].toString(),
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
                                                      border: Border(left: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1)),
                                                      right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1))),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Text(getTranslated(context, 'Post Balance') ,style: TextStyle(fontSize: 10),),
                                                        Text("\u{20B9} " + masterInfoReport[index]["dealer_postbal"].toString() == null ? "": "\u{20B9} " + masterInfoReport[index]["dealer_postbal"].toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text(getTranslated(context, 'Amount'),style: TextStyle(fontSize: 10),),
                                                        Text("\u{20B9}" + masterInfoReport[index]["balance"].toString() == null ? "": "\u{20B9} " + masterInfoReport[index]["balance"].toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text("Transfer",style: TextStyle(fontSize: 10),),
                                                        Text("\u{20B9}" + masterInfoReport[index]["Newbalance"].toString() == null ? "": "\u{20B9} " + masterInfoReport[index]["Newbalance"].toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text(getTranslated(context, 'Type') ,style: TextStyle(fontSize: 10),),
                                                        Text(masterInfoReport[index]["bal_type"].toString() == null ? "":  masterInfoReport[index]["bal_type"].toString(),
                                                        style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
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
                  Visibility(
                    visible: adminVisible,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        adminInfoReport.length == 0 ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(getTranslated(context, 'No Data') ,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                          ],
                        ): ListView.builder(
                            controller: _controllerList,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount:adminInfoReport.length,
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
                                                  Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(getTranslated(context, 'Name') ,style: TextStyle(fontSize: 10,),),
                                                        Text (adminInfoReport[index]["Name"] == null ? "....." :adminInfoReport[index]["Name"],style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                      ]),
                                                  Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text (getTranslated(context, 'Date'),style: TextStyle(fontSize: 10,),),
                                                        Text (adminInfoReport[index]["date_dlm"] == null ? "0 0 0" :adminInfoReport[index]["date_dlm"],style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,),),
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
                                                          right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.5))),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          getTranslated(context, 'Pre Balance'),
                                                          softWrap: true,
                                                          style: TextStyle(fontSize: 10),
                                                          textAlign: TextAlign.left,
                                                        ),
                                                        Text(
                                                          "\u{20B9} " + adminInfoReport[index]["dealer_prebal"].toString() == null ? "":"\u{20B9} " + adminInfoReport[index]["dealer_prebal"].toString(),
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
                                                          right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.5))),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Text(getTranslated(context, 'Post Balance') ,style: TextStyle(fontSize: 10),),
                                                        Text("\u{20B9} " + adminInfoReport[index]["dealer_postbal"].toString() == null ? "": "\u{20B9} " + adminInfoReport[index]["dealer_postbal"].toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                          right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.5))),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text(getTranslated(context, 'Amount'),style: TextStyle(fontSize: 10),),
                                                        Text("\u{20B9} " + adminInfoReport[index]["balance"].toString() == null ? "": "\u{20B9} " + adminInfoReport[index]["balance"].toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text(getTranslated(context, 'Type') ,style: TextStyle(fontSize: 10),),
                                                        Text(adminInfoReport[index]["bal_type"].toString() == null ? "":  adminInfoReport[index]["bal_type"].toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)
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
                ],
              )


            ),
          ),
        ),
      ),
    );
  }
}
