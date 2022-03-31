import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/masterPage/masterMainPage.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:http/http.dart'as http;

class DealerCreditReport extends StatefulWidget {
  const DealerCreditReport({Key key}) : super(key: key);

  @override
  _DealerCreditReportState createState() => _DealerCreditReportState();
}

class _DealerCreditReportState extends State<DealerCreditReport> {

  List dealerInfoReport = [];

  List retailer = [];

  String retailerCredit = "";
  String masterCredit = "";
  String adminCredit = "";
  String creditValue = "";
  bool retailerVisible = true;
  bool listVisible = true;
  bool textVisible = false;



  String retailerName = "Select Retailer Name";
  String retailerId = "";

  List creditList = ["Retailer's Outstanding","My Credit From Master","My Credit From Admin"];

  String frmDate = "";
  String toDate = "";

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

  Future<void> dealerOutstandingReport() async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url =
    new Uri.http("api.vastwebindia.com", "/api/Dealer/ChkbalanceRetailerOutstandingAndMyCredit");
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
      retailerCredit = data["RetailerCreditbal"].toString();
      masterCredit = data["MasterCreditbal"].toString();
      adminCredit = data["AdminCreditbal"].toString();



      setState(() {

        retailerCredit;
        masterCredit;
        adminCredit;

        retailerList();



      });

    } else {
      throw Exception('Failed to load themes');
    }
  }

  Future<void> dealerCreditReport(String userid) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url =
    new Uri.http("api.vastwebindia.com", "/api/Dealer/Show_Retailer_outstandingreport",{
      "RetailerId":userid,

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

      if(daata2 == "0"){

        setState(() {

          listVisible = false;
          textVisible = true;

        });



      }else{

        setState(() {

          listVisible = true;
          textVisible = false;

          dealerInfoReport = daata2;


        });


      }



    } else {
      throw Exception('Failed to load themes');
    }
  }


  Future<void> masterCreditReport() async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url =
    new Uri.http("api.vastwebindia.com", "/api/Dealer/CreditReportByMaster");
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

        dealerInfoReport = daata2;


      });

    } else {
      throw Exception('Failed to load themes');
    }
  }

  Future<void> adminCreditReport() async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url =
    new Uri.http("api.vastwebindia.com", "/api/Dealer/ShowCreditReportByAdmin");
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

        dealerInfoReport = daata2;


      });

    } else {
      throw Exception('Failed to load themes');
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    dealerOutstandingReport();


    retailerId = "All";
    dealerCreditReport(retailerId);



  }


  String receive = "Retailer's Outstanding";


  void creditListdialog(){
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
                                child: Text('Credit From'.toUpperCase(),
                                  style: TextStyle(color: TextColor,fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),

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
                        itemCount: creditList.length,
                        itemBuilder: (context,  index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 35,
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(top: 8,left: 10,right: 10),
                                  decoration: BoxDecoration(border: Border(bottom: (BorderSide(width: 1,color: PrimaryColor.withOpacity(0.5))))),
                                  child: TextButton(
                                    style: ButtonStyle(
                                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                                      shadowColor: MaterialStateProperty.all(Colors.transparent),
                                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                      padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        receive = creditList[index] == null ?"":creditList[index];
                                        if(receive == "My Credit From Master"){
                                          creditValue = masterCredit;
                                          retailerVisible = false;
                                          masterCreditReport();
                                        }else if (receive == "My Credit From Admin"){
                                          creditValue = adminCredit;
                                          retailerVisible = false;
                                          adminCreditReport();
                                        }else{
                                          retailerVisible = true;
                                          creditValue = retailerCredit;
                                          retailerList();
                                        }
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(creditList[index]== null ? "":creditList[index],
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
                        height: 45,
                        margin: EdgeInsets.only(top: 5,bottom: 5,),
                        padding: EdgeInsets.only(top: 0,bottom: 0,left: 10,right: 10),
                        child: TextField(
                          onChanged: (value) {
                            setStatee(() {
                            });
                          },
                          controller: _textController,
                          decoration: InputDecoration(
                            labelText:getTranslated(context, 'Search'),
                            hintText:getTranslated(context, 'Search'),
                            labelStyle: TextStyle(color: PrimaryColor),
                            hintStyle: TextStyle(color: PrimaryColor),
                            contentPadding: EdgeInsets.only(left: 15),
                            suffixIcon:Icon(Icons.search,color: PrimaryColor,) ,
                            border: OutlineInputBorder(
                                gapPadding: 1,
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(width: 1,color: PrimaryColor)
                            ),
                            enabledBorder: OutlineInputBorder(
                                gapPadding: 1,
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(width: 1,color: PrimaryColor)
                            ),
                            focusedBorder:  OutlineInputBorder(
                                gapPadding: 1,
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(width: 1,color: PrimaryColor)
                            ),
                          ),
                          style: TextStyle(color: PrimaryColor,fontSize: 20),
                          cursorColor: PrimaryColor,
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
                                    child: Container(
                                      height: 35,
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(top: 8,left: 10,right: 10),
                                      decoration: BoxDecoration(border: Border(bottom: (BorderSide(width: 1,color: PrimaryColor.withOpacity(0.5))))),
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
                                            dealerCreditReport(retailerId);
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(retailer[index]["Name"].toString().toUpperCase(),textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                            ],
                                          ),
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
                                              dealerCreditReport(retailerId);
                                            });
                                            _textController.clear();
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text( getTranslated(context, 'Name') +retailer[index]["Name"].toString().toUpperCase(),textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
      var dataa1 = json.decode(response.body);


      setState(() {
        retailer = dataa1;

      });


    } else {
      throw Exception('Failed to load themes');
    }


  }


  TextEditingController _textController = TextEditingController();
  ScrollController _controllerList = new ScrollController();
  ScrollController listSlide = ScrollController();


  @override
  Widget build(BuildContext context) {
    return SimpleAppBarWidget(
      title: Align(
          alignment:  Alignment(-.4, 0),
          child: Text("Credit History",style: TextStyle(color: TextColor),textAlign: TextAlign.center,)),
      body: SingleChildScrollView(
        child: Container(
          child: Container(
            color: TextColor,
            child: StickyHeader(
                header: Container(
                  color: PrimaryColor.withOpacity(0.8),
                  margin: EdgeInsets.only(bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 45,
                        margin: EdgeInsets.only(left: 10,right: 10,top: 20,),
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
                          padding: EdgeInsets.only(top: 0,bottom: 0,left: 10,right: 10),
                          borderSide: BorderSide(width: 1,color: TextColor),
                          onPressed: creditListdialog,
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

                      Visibility(
                        visible: retailerVisible,
                        child: Container(
                          height: 45,
                          margin: EdgeInsets.only(left: 10,right: 10,top: 20,),
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
                            padding: EdgeInsets.only(top: 0,bottom: 0,left: 10,right: 10),
                            borderSide: BorderSide(width: 1,color: TextColor),
                            onPressed: retailerListdialog,
                            child: Container(
                              child: Row(
                                children: [
                                  Expanded(child: Text(retailerName,style: TextStyle(color: TextColor,fontWeight: FontWeight.normal,fontSize: 16),)),
                                  SizedBox(width: 20,child: Icon(Icons.arrow_drop_down,color: TextColor,),)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 15,)

                    ],
                  ),
                ),
                content: Column(
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
                        margin: EdgeInsets.only(left: 0.5,right: 0.5, top: 0.5,bottom: 0.5),
                        child: Container(
                          color:Colors.white.withOpacity(0.5),
                          padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(receive.toString(),
                                style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),),
                              Text("\u{20B9} " + creditValue.toString(),
                                style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),)
                            ],
                          ),
                        ),
                      ),
                    ),
                     Visibility(
                      visible: listVisible,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          dealerInfoReport.length == 0 ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(getTranslated(context, 'No Data') ,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                            ],
                          ): ListView.builder(
                              controller: _controllerList,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount:dealerInfoReport.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    receive == "Retailer's Outstanding" ?Container(
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
                                                padding: EdgeInsets.only(bottom: 5),
                                                child:Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(getTranslated(context, 'Name'),style: TextStyle(fontSize: 10,),),
                                                          Text (dealerInfoReport[index]["RetailerName"] == null ? "....." :dealerInfoReport[index]["RetailerName"],style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                        ]),
                                                    Column(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Text (getTranslated(context, 'Date'),style: TextStyle(fontSize: 10,),),
                                                          Text (dealerInfoReport[index]["RechargeDate"] == null ? "0 0 0" :dealerInfoReport[index]["RechargeDate"],style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,),),
                                                        ]),

                                                  ],
                                                ),
                                              ),
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
                                                            "Remain Balance",
                                                            softWrap: true,
                                                            style: TextStyle(fontSize: 10),
                                                            textAlign: TextAlign.left,
                                                          ),
                                                          Text(
                                                            "\u{20B9} " + dealerInfoReport[index]["remain_amount"].toString() == null ? "":"\u{20B9} " + dealerInfoReport[index]["remain_amount"].toString(),
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
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(getTranslated(context, 'Credit'),style: TextStyle(fontSize: 10),),
                                                          Text("\u{20B9} " + dealerInfoReport[index]["cr"].toString() == null ? "": "\u{20B9} " + dealerInfoReport[index]["cr"].toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
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
                                                          Text(dealerInfoReport[index]["bal_type"].toString() == null ? "":  dealerInfoReport[index]["bal_type"].toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
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
                                    ):
                                    Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: PrimaryColor.withOpacity(0.08),
                                            blurRadius: .5,
                                            spreadRadius: 1,
                                            offset: Offset(.0, .0), // shadow direction: bottom right
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
                                                padding: EdgeInsets.only(bottom: 5),
                                                child:Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(getTranslated(context, 'Name'),style: TextStyle(fontSize: 10,),),
                                                          receive == "My Credit From Master"?Text (dealerInfoReport[index]["SuperstokistName"] == null ? "....." :dealerInfoReport[index]["SuperstokistName"],style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),):
                                                          Text (dealerInfoReport[index]["Name"] == null ? "....." :dealerInfoReport[index]["Name"],style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                        ]),
                                                    Column(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Text (getTranslated(context, 'Date'),style: TextStyle(fontSize: 10,),),
                                                          Text (dealerInfoReport[index]["date_dlm"] == null ? "0 0 0" :dealerInfoReport[index]["date_dlm"],style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,),),
                                                        ]),

                                                  ],
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            getTranslated(context, 'Pre Balance'),
                                                            softWrap: true,
                                                            style: TextStyle(fontSize: 10),
                                                            textAlign: TextAlign.left,
                                                          ),
                                                          Text(
                                                            "\u{20B9} " + dealerInfoReport[index]["dealer_prebal"].toString() == null ? "":"\u{20B9} " + dealerInfoReport[index]["dealer_prebal"].toString(),
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
                                                      decoration: BoxDecoration(
                                                        border: Border(left: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1)),),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(getTranslated(context, 'Post Balance') ,style: TextStyle(fontSize: 10),),
                                                          Text("\u{20B9} " + dealerInfoReport[index]["dealer_postbal"].toString() == null ? "": "\u{20B9} " + dealerInfoReport[index]["dealer_postbal"].toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border(left: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1)),),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(getTranslated(context, 'Amount'),style: TextStyle(fontSize: 10),),
                                                          Text("\u{20B9} " + dealerInfoReport[index]["balance"].toString() == null ? "": "\u{20B9} " + dealerInfoReport[index]["balance"].toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border(left: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1)),),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Text(getTranslated(context, 'Type') ,style: TextStyle(fontSize: 10),),
                                                          Text(dealerInfoReport[index]["bal_type"].toString() == null ? "":  dealerInfoReport[index]["bal_type"].toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
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
                      visible: textVisible,
                      child: Container(
                          alignment: Alignment.center,
                        child: Text(getTranslated(context, 'No Data') ,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                      ),
                    )

                  ],

                ),
            ),
          ),
        ),
      ),
    );
  }
}
