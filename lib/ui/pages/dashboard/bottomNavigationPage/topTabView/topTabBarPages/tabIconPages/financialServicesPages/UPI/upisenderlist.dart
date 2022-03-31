import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/dmtPages/AddnewBeneficary.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/dmtPages/numberRegister.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/dmtPages/payDmt.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sticky_headers/sticky_headers.dart';

import 'Addupiid.dart';
import 'Upimoneytransfer.dart';

class Upisenderlist extends StatefulWidget {
  const Upisenderlist({Key key}) : super(key: key);

  @override
  _UpisenderlistState createState() => _UpisenderlistState();
}

class _UpisenderlistState extends State<Upisenderlist> {
  bool editText = false;
  bool loader = false;


  String sendnum = "";
  String sendname = "";
  String consumelimit = "";
  String remainlimit = "";
  List benificiarylist = [];
  var benelist,mode;
  var remid, benefid;

  TextEditingController editsennumber = TextEditingController();
  ScrollController scollable = new ScrollController();

  Future<void> remeterdetails(String number) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");
    final prefs = await SharedPreferences.getInstance();

    var url1 = new Uri.http(
        "api.vastwebindia.com", "/UPI/api/UPI/GetBeneficiaryList", {
      "sender_number": number,
    });

    final http.Response response = await http.get(
      url1,
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
      var data = json.decode(response.body);
      var status = data["RESULT"];
      var addinfo = data["ADDINFO"];


      if (status == "0") {
        benelist = addinfo["Response"];
        //remid = addinfo["data"]["remitter"]["id"];

        if(benelist == "Firstlly Purchase this Service."){

          final snackBar2 = SnackBar(
            backgroundColor: Colors.red[900],
            content: Text(benelist,style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar2);
        }else {
          setState(() {
            benificiarylist = benelist;
          });
        }

      } else if (status == "RNF") {
        prefs.setString('sendnum', number);

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => NumberRegister(),
            transitionDuration: Duration(seconds: 0),
          ),);

      }else{

        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(addinfo,style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);
      }


    } else {



    }
  }

  void getnum() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      sendnum = prefs.getString("sendnum");
      sendname = prefs.getString("sendname");
      //remid  = prefs.getString("remidd");
      consumelimit = prefs.getString("consumelim");
      remainlimit = prefs.getString("remainlim");


      remeterdetails(sendnum);
    });
  }

  Future<void> checksendernumber(String number) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");
    final prefs = await SharedPreferences.getInstance();

    var url1 = new Uri.http(
        "api.vastwebindia.com", "/Money/api/Money/GetBeneficiaryList", {
      "sender_number": number,
    });

    final http.Response response = await http.get(
      url1,
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
      loader = false;
      var data = json.decode(response.body);
      var addinfo = data["ADDINFO"];
      var status = addinfo["statuscode"];

      if (status == "TXN") {
        var remmname = addinfo["data"]["remitter"]["name"];
        var consumelimit =
        addinfo["data"]["remitter"]["consumedlimit"].toString();
        var remainlimit =
        addinfo["data"]["remitter"]["remaininglimit"].toString();
        prefs.setString('sendnum', number);
        prefs.setString('sendname', remmname);
        prefs.setString('consumelim', consumelimit);
        prefs.setString('remainlim', remainlimit);

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => Upisenderlist(),
            transitionDuration: Duration(seconds: 0),
          ),);

      } else if (status == "RNF") {
        prefs.setString('sendnum', number);
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => NumberRegister(),
            transitionDuration: Duration(seconds: 0),
          ),);

      }
    } else {
      throw Exception('Failed to load themes');
    }
  }

  Future<void> deletebeneficiary(String idno) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url1 = new Uri.http("api.vastwebindia.com", "/UPI/api/UPI/DeleteBeneficiary", {
      "idno": idno,
    });

    final http.Response response = await http.get(
      url1,
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
      var data = json.decode(response.body);
      var result = data["RESULT"];
      var status = data["ADDINFO"];

      if (result == "0") {

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => Upisenderlist(),
            transitionDuration: Duration(seconds: 0),
          ),);

      } else {


      }


    } else {
      throw Exception('Failed to load themes');
    }
  }

  Future<void> genuniqeid(String name, String accnum) async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var uri = new Uri.http("api.vastwebindia.com", "/Money/api/data/imps_Generate_Unique_ID");
    final http.Response response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 12), onTimeout: (){

    });

    print(response);

    if (response.statusCode == 200) {

      var data = json.decode(response.body);
      var unqid = data["Message"];

      Navigator.push(context, MaterialPageRoute(builder: (context) =>
          Upimoneytransfer(
            name: name,
            accnum:accnum,
            uniqidd: unqid,
          ),
      ),
      );

    } else {


      throw Exception('Failed to load data from internet');
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getnum();
  }
  bool buttonFirst = true;
  bool buttonSecond = false;

  @override
  Widget build(BuildContext context) {
    Color colorWhite = Colors.white;
    TextStyle labelStyle = TextStyle(
      color: TextColor,
      fontSize: 17,
    );
    Color color = PrimaryColor;
    return Material(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Container(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    StickyHeader(
                      header: Container(
                        color: TextColor,
                        child: Container(
                          color: PrimaryColor.withOpacity(0.9),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border:
                                  Border.all(width: 1, color: PrimaryColor),
                                  color: PrimaryColor.withOpacity(0.5),
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(2),
                                    bottomLeft: Radius.circular(2),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: TextButton(
                                          onPressed: (){
                                            Navigator.pushReplacement(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (context, animation1, animation2) => Dashboard(),
                                                transitionDuration: Duration(seconds: 0),
                                              ),);
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                      width: 16,
                                                      child: Image(image: AssetImage("assets/pngImages/back.png"))),
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  Text(getTranslated(context, 'Hi'),
                                                    style: TextStyle(
                                                        color: SecondaryColor,
                                                        fontSize: 14,fontWeight: FontWeight.bold),
                                                  )
                                                ],
                                              ),
                                              Container(
                                                width: 160,
                                                child: Text(
                                                  sendname,
                                                  style: TextStyle(
                                                      color: TextColor,
                                                      fontSize: 16),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 1,
                                            height: 48,
                                            color: color,
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                top: 10,
                                                bottom: 0,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                children: [
                                                  Text(getTranslated(context, 'Monthly Limit'),
                                                    style: TextStyle(
                                                        color: colorWhite,
                                                        fontSize: 9),
                                                  ),
                                                  Text(consumelimit,
                                                      style: TextStyle(
                                                          color: colorWhite,
                                                          fontSize: 18))
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 1,
                                            height: 48,
                                            color: color,
                                          ),
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              padding: EdgeInsets.only(
                                                top: 10,
                                                bottom: 0,
                                              ),
                                              margin: EdgeInsets.only(right: 10),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  Text(getTranslated(context, 'Remain Limit'),
                                                    style: TextStyle(
                                                        color: colorWhite,
                                                        fontSize: 9),
                                                  ),
                                                  Text(remainlimit,
                                                      style: TextStyle(
                                                          color: colorWhite,
                                                          fontSize: 18))
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              /*Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(top: 10,left: 10, right: 10),
                              child: Text(
                                "Hi " + "Ramniwas",
                                style: TextStyle(color: TextColor, fontSize: 16),
                              ),
                            ),*/
                              Container(
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 10, right: 10, top: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: editText
                                                ? Container(
                                              color: PrimaryColor,
                                              child: TextFormField(
                                                maxLength: 10,
                                                controller: editsennumber,
                                                cursorColor: TextColor,
                                                keyboardType:
                                                TextInputType.number,
                                                buildCounter: (BuildContext
                                                context,
                                                    {int currentLength,
                                                      int maxLength,
                                                      bool isFocused}) =>
                                                null,
                                                textCapitalization:
                                                TextCapitalization
                                                    .words,
                                                decoration: InputDecoration(
                                                  focusedBorder:
                                                  OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: color),
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(2),
                                                  ),
                                                  border:
                                                  OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: color),
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(2),
                                                  ),
                                                  enabledBorder:
                                                  OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: color),
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(2),
                                                  ),
                                                  disabledBorder:
                                                  OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: color),
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(2),
                                                  ),
                                                  contentPadding:
                                                  EdgeInsets.only(
                                                      left: 10,
                                                      right: 16,
                                                      top: 15,
                                                      bottom: 15),
                                                  hintText: getTranslated(context, 'Enter Mobile No'),
                                                  labelStyle: labelStyle,
                                                  fillColor:TextColor,
                                                  hintStyle: labelStyle,
                                                  suffixIcon: SizedBox(
                                                    height: 20,
                                                    width: 30,
                                                    child: Container(
                                                      margin:
                                                      EdgeInsets.only(
                                                          right: 10,
                                                          top: 10,
                                                          bottom: 10,
                                                          left: 5),
                                                      color: TextColor
                                                          .withOpacity(0.3),
                                                      child: TextButton(
                                                        style: ButtonStyle(
                                                          shape: MaterialStateProperty
                                                              .all<
                                                              RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  30),
                                                            ),
                                                          ),
                                                          padding:
                                                          MaterialStateProperty.all(
                                                              EdgeInsets
                                                                  .zero),
                                                        ),
                                                        child: loader
                                                            ? SizedBox(
                                                          width: 15,
                                                          height: 15,
                                                          child:
                                                          CircularProgressIndicator(
                                                            valueColor:
                                                            AlwaysStoppedAnimation<Color>(
                                                                SecondaryColor),
                                                            strokeWidth:
                                                            2,
                                                          ),
                                                        )
                                                            : Icon(
                                                          Icons
                                                              .swap_horiz_outlined,
                                                          color: Colors
                                                              .white,
                                                          size: 30,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            editText =
                                                            false;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                onChanged: (value) {
                                                  if (value.length == 10) {
                                                    setState(() {
                                                      loader = true;
                                                    });
                                                    checksendernumber(
                                                        editsennumber.text);
                                                  } else {
                                                    setState(() {
                                                      loader = false;
                                                    });
                                                  }
                                                },
                                                style: TextStyle(
                                                    color: TextColor,
                                                    fontSize: 16,
                                                    letterSpacing: 1),
                                              ),
                                            )
                                                : Container(
                                              padding: EdgeInsets.only(
                                                  left: 10,
                                                  right: 0,
                                                  top: 1,
                                                  bottom: 1),
                                              color: PrimaryColor,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Expanded(
                                                      child: Text(
                                                        sendnum,
                                                        style: TextStyle(
                                                            color: TextColor,
                                                            fontSize: 16,
                                                            letterSpacing: 1),
                                                      )),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10,
                                                        top: 10,
                                                        bottom: 10),
                                                    child: Container(
                                                      height: 28,
                                                      width: 33,
                                                      color: TextColor
                                                          .withOpacity(0.2),
                                                      child: TextButton(
                                                        style: ButtonStyle(
                                                          shape: MaterialStateProperty
                                                              .all<
                                                              RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  30),
                                                            ),
                                                          ),
                                                          padding:
                                                          MaterialStateProperty.all(
                                                              EdgeInsets
                                                                  .zero),
                                                        ),
                                                        child: Icon(
                                                          Icons
                                                              .swap_horiz_outlined,
                                                          color:
                                                          Colors.white,
                                                          size: 30,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            editText = true;
                                                            loader = false;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Container(
                                              color: SecondaryColor,
                                              child: TextButton(
                                                style: ButtonStyle(
                                                  shape:
                                                  MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.zero,
                                                        side: BorderSide(
                                                            width: 0,
                                                            color: Colors
                                                                .transparent)),
                                                  ),
                                                  padding:
                                                  MaterialStateProperty.all(
                                                      EdgeInsets.zero),
                                                ),
                                                child: Visibility(
                                                  maintainSize: false,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Icon(
                                                            Icons.add_box_sharp,
                                                            color: TextColor,
                                                            size: 14,
                                                          ),
                                                          SizedBox(
                                                            width: 1,
                                                          ),
                                                          Text(getTranslated(context, 'Add'),
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color:
                                                                Colors.white),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(getTranslated(context, 'Upi ID'),
                                                        style: TextStyle(
                                                            fontSize: 9,
                                                            color: TextColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Addnewupid()),
                                                  );
                                                },
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                      content: benificiarylist.length == 0 ? Container(
                        margin: EdgeInsets.only(top: 50),
                        child: Center(child: CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(
                              SecondaryColor),
                          strokeWidth: 2,
                        )),
                      ) :
                      Container(
                          margin:EdgeInsets.only(top: 10),
                          child: ListView.builder(
                              padding: EdgeInsets.all(0),
                              shrinkWrap: true,
                              controller: scollable,
                              itemCount: benificiarylist.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: PrimaryColor.withOpacity(0.08),
                                        blurRadius: .5,
                                        spreadRadius: 1,
                                        offset: Offset(.0,
                                            .0), // shadow direction: bottom right
                                      )
                                    ],
                                  ),
                                  margin: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 10),
                                  child: Container(
                                    margin: EdgeInsets.only(left: 0.5, right: 0.5, top: 0.5, bottom: 0.5),
                                    child: Container(
                                      color: TextColor.withOpacity(0.5),
                                      padding: EdgeInsets.only(top: 5, bottom: 0, left: 5, right: 5),
                                      child: Column(
                                        children: [

                                          SizedBox(
                                            height: 45,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        benificiarylist[index]["isverified"] == false ? Text(getTranslated(context, 'Name')
                                                          ,style: TextStyle(
                                                              fontWeight: FontWeight.bold),
                                                          textAlign: TextAlign.left,
                                                        )
                                                            :Row(
                                                          children: [
                                                            Icon(Icons.check_circle,color: Colors.green,size: 18,),
                                                            SizedBox(width: 5,),
                                                            Text(
                                                              getTranslated(context, 'Verified'),
                                                              style: TextStyle(
                                                                  color: Colors.green,
                                                                  fontSize: 14),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(benificiarylist[index]
                                                    ["BenName"]),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Text("VPA ID",
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight
                                                              .bold),textAlign: TextAlign.right,),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(benificiarylist[index]
                                                    ["UPIID"]),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 1,
                                            color:
                                            PrimaryColor.withOpacity(0.1),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                             Expanded(
                                               child:  TextButton(
                                               style: ButtonStyle(
                                                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                       RoundedRectangleBorder(
                                                           borderRadius: BorderRadius.zero,
                                                           side: BorderSide(color:PrimaryColor)
                                                       )
                                                   ),
                                                   padding: MaterialStateProperty.all(EdgeInsets.zero),
                                                   backgroundColor: MaterialStateProperty.all(Colors.white)
                                               ),
                                               onPressed: () {

                                                 String name = benificiarylist[index]["BenName"];
                                                 String upiid = benificiarylist[index]["UPIID"];

                                                 genuniqeid(name,upiid);


                                               },
                                               child: Column(
                                                 children: [
                                                   SizedBox(
                                                     width: 16,
                                                     child: Image(
                                                       image: AssetImage("assets/pngImages/UPI.png",),
                                                     ),
                                                   ),
                                                   Text("UPI Transfer",
                                                     style: TextStyle(
                                                         color: color,
                                                         fontSize: 12),
                                                   )
                                                 ],
                                               ),
                                             ),),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Visibility(
                                                replacement: Expanded(
                                                  child: TextButton(
                                                    style: ButtonStyle(
                                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.zero,
                                                                side: BorderSide(color:Colors.red)
                                                            )
                                                        ),
                                                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                                                        backgroundColor: MaterialStateProperty.all(Colors.red)
                                                    ),
                                                    onPressed: () {

                                                      benefid = benificiarylist[index]["idno"].toString();
                                                      deletebeneficiary(benefid);

                                                    },
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                            width: 16,
                                                            child: Icon(
                                                              Icons.delete_outline_outlined,
                                                              size: 16,
                                                              color: TextColor,
                                                            )),
                                                        Text(getTranslated(context, 'SURE'),
                                                          style: TextStyle(
                                                              color: TextColor,
                                                              fontSize: 12),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                maintainSize: false,
                                                visible: buttonFirst,
                                                child: Expanded(
                                                  child: TextButton(
                                                    style: ButtonStyle(
                                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.zero,
                                                                side: BorderSide(color:Colors.red)
                                                            )
                                                        ),
                                                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                                                        backgroundColor: MaterialStateProperty.all(Colors.white)
                                                    ),
                                                    onPressed: () {
                                                      setState(() {

                                                        String aa = index.toString();
                                                        buttonSecond = true;
                                                        buttonFirst = false;
                                                      });

                                                    },
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                            width: 16,
                                                            child: Icon(
                                                              Icons.delete,
                                                              size: 16,
                                                              color: Colors.red,
                                                            )),
                                                        Text(
                                                          getTranslated(context, 'DELETE success'),
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 12),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ),
                                              /*Visibility(
                                            maintainSize: false,
                                            visible: buttonSecond,
                                            child:
                                          )*/
                                            ],
                                          ),
                                          Container(
                                            height: 1,
                                            color:
                                            PrimaryColor.withOpacity(0.1),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              })
                      ),)



                  ],
                ),
              ),
            ),
          ),
        ),
      ),    );
  }
}
