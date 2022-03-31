import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class LoginInformation extends StatefulWidget {
  const LoginInformation({Key key}) : super(key: key);

  @override
  _LoginInformationState createState() => _LoginInformationState();
}

class _LoginInformationState extends State<LoginInformation> {
  String userroll = "";

  Future<void> userRoll() async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "role");

    String rollUser = a;
    setState(() {
      userroll = rollUser;

      spStatus = "100";
      frmDate = "${selectedDate2.toLocal()}".split(' ')[0];
      toDate = "${selectedDate.toLocal()}".split(' ')[0];

      if (userroll == "Dealer") {
        dealerLoginInfo(frmDate, toDate, spStatus);
      } else if(userroll == "master") {
        masterLoginInfo(frmDate, toDate, spStatus);
      }else {
        loginInfoReport(frmDate, toDate, spStatus);
      }
    });
  }

  List inforeport = [];

  String frmDate = "";
  String toDate = "";
  String spStatus = "100";

  DateTime selectedDate = DateTime.now();
  DateTime selectedDate2 = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        helpText: getTranslated(context, 'To Date'),
        initialDate: selectedDate,
        builder: (context, child) {
          return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: SecondaryColor,
                accentColor: SecondaryColor,
                colorScheme: ColorScheme.light(
                  primary: SecondaryColor,
                  onSurface: Colors.white,
                  surface: Colors.white,
                ),
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: TextColor)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: TextColor)),
                  hintStyle: TextStyle(
                    color: TextColor,
                  ),
                ),
                textTheme: TextTheme(),
                hintColor: SecondaryColor,
                buttonTheme: ButtonThemeData(
                  textTheme: ButtonTextTheme.primary,
                ),
                dialogBackgroundColor: PrimaryColor,
              ),
              // This will change to dark theme.
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Container(
                    child: child,
                  ),
                ),
              ));
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
        helpText: getTranslated(context, 'From Date'),
        initialDate: selectedDate2,
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: SecondaryColor,
              accentColor: SecondaryColor,
              colorScheme: ColorScheme.light(
                primary: SecondaryColor,
                onSurface: Colors.white,
                surface: Colors.white,
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: TextColor)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: TextColor)),
                hintStyle: TextStyle(
                  color: TextColor,
                ),
              ),
              textTheme: TextTheme(),
              hintColor: SecondaryColor,
              buttonTheme: ButtonThemeData(
                textTheme: ButtonTextTheme.primary,
              ),
              dialogBackgroundColor: PrimaryColor,
            ),
            // This will change to dark theme.
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Container(
                  child: child,
                ),
              ),
            ),
          );
        },
        firstDate: DateTime(1980),
        lastDate: DateTime(2050));
    if (picked != null && picked != selectedDate2)
      setState(() {
        selectedDate2 = picked;
      });
  }

  Future<void> dealerLoginInfo(String frmDate, String toDate,
      String spStatus) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url = new Uri.http("api.vastwebindia.com", "/api/data/LoginDetails", {
      "txt_frm_date": frmDate,
      "txt_to_date": toDate,
      "ddltop": spStatus,
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
      var report = data["Report"];

      setState(() {
        inforeport = report;
      });
    } else {
      throw Exception('Failed to load themes');
    }
  }

  Future<void> loginInfoReport(String frmDate, String toDate,
      String spStatus) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url = new Uri.http(
        "api.vastwebindia.com", "/Retailer/api/data/LoginDetailsRetailer", {
      "txt_frm_date": frmDate,
      "txt_to_date": toDate,
      "ddltop": spStatus,
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
      var report = data["Report"];

      setState(() {
        inforeport = report;
      });
    } else {
      throw Exception('Failed to load themes');
    }
  }



  Future<void> masterLoginInfo(String frmDate, String toDate,
      String spStatus) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url = new Uri.http("api.vastwebindia.com", "/api/data/LoginDetailsMaster", {
      "txt_frm_date": frmDate,
      "txt_to_date": toDate,
      "ddltop": spStatus,
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
      var report = data["Report"];

      setState(() {
        inforeport = report;
      });
    } else {
      throw Exception('Failed to load themes');
    }
  }

  bool dataload = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userRoll();
  }

  bool notLaunchUrl = false;

  Future<void> _launched;

  Future<void> _openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      notLaunchUrl = true;
      throw 'Could not launch $url';
    }
  }



  ScrollController _controllerList = new ScrollController();




  final df = new DateFormat('dd-MM-yyyy hh:mm a');



  @override
  Widget build(BuildContext context) {
    setState(() {
      loginInfoReport(frmDate, toDate, spStatus);
    });
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: TextColor,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.arrow_back,
                color: TextColor,
              ),
            ),
            title: Align(
                alignment: Alignment(-.4, 0),
                child: Text(
                  getTranslated(context, 'Login History'),
                  style: TextStyle(color: TextColor),
                  textAlign: TextAlign.center,
                )),
            elevation: 0,
            toolbarHeight: 39,
            leadingWidth: 60,
            backgroundColor: PrimaryColor.withOpacity(0.8),
          ),
          body: SingleChildScrollView(
            child: Container(
              child: Container(
                color: TextColor,
                child: StickyHeader(
                  header: Container(
                    color: TextColor,
                    margin: EdgeInsets.only(bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                color: PrimaryColor.withOpacity(0.8),
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(3),
                                          border: Border.all(
                                            color: TextColor,
                                          )),
                                      margin:
                                      EdgeInsets.only(left: 10, right: 2),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 2,
                                            left: 10,
                                            right: 17,
                                            bottom: 2),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(4.0),
                                              child: Icon(
                                                Icons.calendar_today_outlined,
                                                size: 25,
                                                color: TextColor,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                _selectDate2(context);
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    getTranslated(context, 'From Date'),
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: TextColor),
                                                  ),
                                                  Text(
                                                    "${selectedDate2.toLocal()}"
                                                        .split(' ')[0],
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: TextColor),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                      EdgeInsets.only(left: 2, right: 3),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(3),
                                          border: Border.all(
                                            color: TextColor,
                                          )),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 2,
                                            left: 10,
                                            right: 17,
                                            bottom: 2),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(4.0),
                                              child: Icon(
                                                Icons.calendar_today_outlined,
                                                size: 25,
                                                color: TextColor,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                _selectDate(context);
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    getTranslated(context, 'To Date'),
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: TextColor),
                                                  ),
                                                  Text(
                                                    "${selectedDate.toLocal()}"
                                                        .split(' ')[0],
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: TextColor),
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
                                          borderRadius:
                                          BorderRadius.circular(3),
                                          border: Border.all(
                                            color: SecondaryColor,
                                          ),
                                          color: SecondaryColor),
                                      alignment: Alignment.center,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.search,
                                        ),
                                        iconSize: 25,
                                        color: TextColor,
                                        splashColor: Colors.purple,
                                        onPressed: () {
                                          spStatus = "100";
                                          frmDate = "${selectedDate2.toLocal()}"
                                              .split(' ')[0];
                                          toDate = "${selectedDate.toLocal()}"
                                              .split(' ')[0];

                                          if (userroll == "Dealer") {
                                            dealerLoginInfo(frmDate, toDate, spStatus);
                                          }else if(userroll == "master"){
                                            masterLoginInfo(frmDate, toDate, spStatus);
                                          }
                                          else {
                                            loginInfoReport(
                                                frmDate, toDate, spStatus);
                                          }
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
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [inforeport.length == 0 ? Container(
                  margin: EdgeInsets.only(top: 20,left: 10,right: 10),
                  child: Center(
                    child: Text(getTranslated(context, 'No Data') ,style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),),
                  ),
                ) : ListView.builder(
                          controller: _controllerList,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: inforeport.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                        PrimaryColor.withOpacity(0.08),
                                        blurRadius: .5,
                                        spreadRadius: 1,
                                        offset: Offset(.0,
                                            .0), // shadow direction: bottom right
                                      )
                                    ],
                                  ),
                                  margin: EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                      top: 0,
                                      bottom: 10),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 0.5,
                                        right: 0.5,
                                        top: 0.5,
                                        bottom: 0.5),
                                    child: Container(
                                      child: TextButton(
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.zero),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _launched = _openUrl(
                                                'google.navigation:q=' +
                                                    inforeport[index]["City1"]);
                                          });
                                        },
                                        child: Container(
                                          color:
                                          Colors.white.withOpacity(0.5),
                                          padding: EdgeInsets.only(
                                              top: 5,
                                              bottom: 5,
                                              left: 0,
                                              right: 5),
                                          child: Column(
                                            children: [
                                              Container(
                                                child: Row(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .center,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .location_on_outlined,
                                                              size: 35,
                                                              color:
                                                              SecondaryColor,
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                Text(
                                                                  getTranslated(context, 'Location/City'),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      11,
                                                                      color:
                                                                      PrimaryColor),
                                                                  textAlign:
                                                                  TextAlign
                                                                      .left,
                                                                ),
                                                                dataload
                                                                    ? DoteLoader()
                                                                    : inforeport[index]["City1"] ==
                                                                    null
                                                                    ? Text(
                                                                  getTranslated(context, 'Unknown location'),
                                                                  style: TextStyle(
                                                                      color: PrimaryColor),)
                                                                    : Text(
                                                                  inforeport[index]["City1"],
                                                                  style:
                                                                  TextStyle(
                                                                      fontSize: 18,
                                                                      color: SecondaryColor),
                                                                  textAlign:
                                                                  TextAlign
                                                                      .left,
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        Text(
                                                          getTranslated(context, 'Login By'),
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              color:
                                                              PrimaryColor),
                                                          textAlign:
                                                          TextAlign
                                                              .left,
                                                        ),
                                                        inforeport[index][
                                                        "Logintype"] ==
                                                            null
                                                            ? DoteLoader()
                                                            : Text(
                                                          inforeport[
                                                          index]
                                                          [
                                                          "Logintype"],
                                                          style: TextStyle(
                                                              fontSize:
                                                              18,
                                                              color:
                                                              SecondaryColor),
                                                          textAlign:
                                                          TextAlign
                                                              .left,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 8, top: 3),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(getTranslated(context, 'Login Time'),
                                                      style: TextStyle(
                                                          color: PrimaryColor),),
                                                    inforeport[index]["Currentlogin"] ==
                                                        null
                                                        ? DoteLoader()
                                                        : Text(inforeport[index]["Currentlogin"],
                                                      style: TextStyle(
                                                          color:
                                                          PrimaryColor),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
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
      ),
    );
  }
}
