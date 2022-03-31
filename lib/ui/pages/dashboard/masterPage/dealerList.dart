import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/delerpages/delerHomeTopPages/retailerList.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart'as http;

import '../dashboard.dart';


class DealerList extends StatefulWidget {
  const DealerList({Key key}) : super(key: key);

  @override
  _DealerListState createState() => _DealerListState();
}

class _DealerListState extends State<DealerList> {



  List retailer = [];
  List dealerlist = [];

  String firmName = "";
  String Name = "";
  String Mobile = "";
  String Email = "";
  String JoinDate = "";
  String State = "";
  String District = "";
  String Address = "";
  String RemainAmt = "";
  String totalholdamount = "";
  String currentPosamount = "";
  String currentcr = "";
  String Photo = "";
  String Status = "ALL";
  String retailerName = "";
  String userid = "";
  String retailerId = "";
  String retailerFirm = "";
  String retailerAmount = "";
  String trasactionId = "";
  String retailerCredit = "";
  String newAmount = "";
  String retailerMobile = "";

  String dealerUser = "";





  Future<void> dealerList(String master) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url =
    new Uri.http("api.vastwebindia.com", "/api/master/distibutorlist", {
      "masterid" :master,

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

      setState(() {
        dealerlist = data;
      });
    } else {
      throw Exception('Failed to load themes');
    }
  }


  Future<void> dealeInRetailerList(String dealer1) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url =
    new Uri.http("api.vastwebindia.com", "/api/master/distibutorofremlist", {
      "dlmid" :dealer1,
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

      setState(() {
        retailer = data;
        retailerListdialog();

      });
    } else {
      throw Exception('Failed to load themes');
    }
  }

  Future<void> _launched;
  bool notLaunchUrl = false;

  Future<void> _openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      notLaunchUrl = true;
      throw 'Could not launch $url';
    }
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

  Future<void> generateUniqueId() async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var url = new Uri.http("api.vastwebindia.com", "/api/data/dlm_to_Rem_Generate_Unique_ID");
    final http.Response response = await http.get(
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
      var result = dataa1["Response"];
      trasactionId = dataa1["Message"];

      setState(() {

        trasactionId;

      });


    } else {
      throw Exception('Failed to load themes');
    }


  }

  TextEditingController _textController = TextEditingController();
  TextEditingController _textController1 = TextEditingController();
  ScrollController listSlide = ScrollController();




  _sendingMails() async {
    const url = 'mailto:feedback@geeksforgeeks.org';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _sendingSMS() async {
    const url = 'sms:9887990750';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  void masterid() async{

    final storage = new FlutterSecureStorage();
    var b = await storage.read(key: "userId");
    userid = b;

    dealerList(userid);


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    masterid();



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
                            border: OutlineInputBorder(gapPadding: 1, borderRadius: BorderRadius.circular(50), borderSide: BorderSide(width: 1,color: TextColor)),
                            enabledBorder: OutlineInputBorder(gapPadding: 1, borderRadius: BorderRadius.circular(50), borderSide: BorderSide(width: 1,color: TextColor)),
                            focusedBorder:  OutlineInputBorder(gapPadding: 1, borderRadius: BorderRadius.circular(50), borderSide: BorderSide(width: 1,color: TextColor)),
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
                        child: retailer.length == 0?
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text(getTranslated(context, 'No Retailer'),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                )
                              ],
                            )
                        :Column(
                          children: [
                            ListView.builder(
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
                                              retailerAmount = retailer[index]["RemainAmt"].toString();
                                              retailerCredit = retailer[index]["currentcr"].toString();
                                              retailerMobile = retailer[index]["Mobile"].toString();

                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            padding: EdgeInsets.only(top: 5),
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text( getTranslated(context, 'Name') +" :" +retailer[index]["Name"].toString().toUpperCase(),textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                                Text( getTranslated(context, 'FirmName') +" : " +retailer[index]["firmName"].toString().toUpperCase(),textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                                Text(getTranslated(context, 'Current Amount') +" : " +retailer[index]["RemainAmt"].toString(),textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                                Text(getTranslated(context, 'Mobile No') +" : " +retailer[index]["Mobile"].toString(),textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
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
                                                  retailerAmount = retailer[index]["RemainAmt"].toString();
                                                  retailerCredit = retailer[index]["currentcr"].toString();
                                                  retailerMobile = retailer[index]["Mobile"].toString();

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
                                                    Text( getTranslated(context, 'FirmName') +retailer[index]["firmName"].toString().toUpperCase() ,textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                                    Text(getTranslated(context, 'Current Amount')+retailer[index]["RemainAmt"].toString(),textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                                    Text(getTranslated(context, 'Mobile No')+retailer[index]["Mobile"].toString(),textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
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
                            ),
                          ],
                        ),),
                    )
                ),
              ),
            );
          });
        });

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TextColor,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 45,
            color: TextColor.withOpacity(0.1),
            padding: EdgeInsets.only(top: 6, left: 10, right: 10),
            child: TextField(
              onChanged: (value) {
                setState(() {});
              },
              controller: _textController,
              decoration: InputDecoration(
                labelText:getTranslated(context, 'Search'),
                hintText:getTranslated(context, 'Search'),
                labelStyle: TextStyle(color: PrimaryColor),
                contentPadding: EdgeInsets.only(left: 25),
                suffixIcon: Icon(
                  Icons.search,
                  color: PrimaryColor,
                ),
                border: OutlineInputBorder(
                    gapPadding: 1,
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(width: 1)),
                enabledBorder: OutlineInputBorder(
                    gapPadding: 1,
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(width: 1)),
                focusedBorder: OutlineInputBorder(
                    gapPadding: 1,
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(width: 1)),
              ),
            ),
          ),
          if (dealerlist.length == 0) Container(height: 50,
              child: DoteLoader()) else SingleChildScrollView(
            child: ListView.builder(
                shrinkWrap: true,
                controller: tabScroll,
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                itemCount: dealerlist.length,
                itemBuilder: (BuildContext context, int index) {
                  if (_textController.text.isEmpty) {
                    return ExpansionTile(
                      childrenPadding: EdgeInsets.all(10),
                      textColor: Colors.black,
                      title: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          boxShadow: [BoxShadow(
                            color: PrimaryColor.withOpacity(0.08),
                            blurRadius: .5,
                            spreadRadius: 1,
                            offset: Offset(.0,.0),)
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(width: 1, color: Colors.green)),
                              child: Column(
                                children: [
                                  Stack(
                                    fit: StackFit.loose,
                                    alignment: Alignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 5,top: 4, right: 0, bottom: 0),
                                            child: Container(
                                              child: Stack(
                                                fit: StackFit.loose,
                                                alignment: Alignment.center,
                                                children: [
                                                  Container(
                                                    height: 30,
                                                    width: 30,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                      BorderRadius.circular(50),
                                                      child: Image(
                                                          fit: BoxFit.cover,
                                                          image: dealerlist[index]["Photo"] == null ? NetworkImage("https://upload.wikimedia.org/wikipedia/commons/e/e0/Userimage.png")
                                                              : NetworkImage("https://test.vastwebindia.com/" + dealerlist[index]["Photo"])),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 1,
                                                    right: 0,
                                                    child: Container(
                                                        decoration:BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(100),),
                                                          color: TextColor,
                                                        ),
                                                        child: dealerlist[index]["Status"] == "Y" ? Icon(
                                                          Icons.check_circle,
                                                          color: Colors.green,
                                                          size: 10,
                                                        )
                                                            : Icon(Icons.cancel, color: Colors.red, size: 10,)
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              dealerlist[index]["Status"] == "Y" ?
                                              Container(
                                                padding: EdgeInsets.only(top: 5),
                                                width: 245,
                                                alignment: Alignment.center,
                                                child: Text(dealerlist[index]["firmName"].toString(),
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                                  : Container(
                                                width: 245,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(50),
                                                    border: Border.all(width: 1, color: Colors.red)),
                                                child: Text(dealerlist[index]["firmName"].toString(),
                                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,),
                                                ),
                                              ),
                                            ],
                                          ),


                                        ],
                                      ),
                                      dealerlist[index]["Status"] == "Y" ?
                                      Container(
                                        transform: Matrix4.translationValues(0.0, -18, 0.0),
                                        alignment: Alignment.center,
                                        width: 80,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            border: Border.all(width: 1, color: TextColor),
                                            color: Colors.green),
                                        child: Text(getTranslated(context, 'Firm Name'), style: TextStyle(fontSize: 8, color: TextColor),
                                        ),
                                      )
                                          : Container(
                                        transform: Matrix4.translationValues(0.0, -18, 0.0),
                                        alignment: Alignment.center,
                                        width: 80,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            border: Border.all(width: 1, color: TextColor),
                                            color: Colors.red),
                                        child: Text(getTranslated(context, 'Firm Name'), style: TextStyle(fontSize: 8, color: TextColor),
                                        ),
                                      ),

                                      Container(
                                        width: 10,
                                        height: 10,
                                        child : MainButtonSecodn(
                                            onPressed: () {

                                              setState(() {

                                                dealerUser = dealerlist[index]["UserID"].toString();

                                                dealeInRetailerList(dealerUser);
                                              });


                                            },
                                            color: SecondaryColor,
                                            btnText:Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                    child:
                                                    Text("Show Retailers",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: TextColor),)
                                                ),
                                              ],
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child : MainButtonSecodn(
                                  onPressed: () {

                                    setState(() {

                                      dealerUser = dealerlist[index]["UserID"].toString();

                                      dealeInRetailerList(dealerUser);
                                    });

                                  },
                                  btnText:Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child:
                                          Text("Show Retailers",textAlign: TextAlign.center,style: TextStyle(fontSize: 12,color: Colors.black),)
                                      ),
                                    ],
                                  )
                              ),
                            ),
                            Container(
                              transform: Matrix4.translationValues(0.0, -2.0, 0.0),
                              padding:EdgeInsets.fromLTRB(0, 0, 0, 0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color:PrimaryColor.withOpacity(0.06),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 0, right: 0, top: 2, bottom: 0),
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: [
                                            Text(
                                              getTranslated(context, 'Main Wallet'),
                                              style: TextStyle(
                                                  fontSize: 8),
                                            ),
                                            Text(
                                              "\u{20B9} " +
                                                  dealerlist[
                                                  index]
                                                  [
                                                  "RemainAmt"]
                                                      .toString(),
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight
                                                      .bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 0,
                                            right: 0,
                                            top: 2,
                                            bottom: 0),
                                        decoration: BoxDecoration(
                                          color: PrimaryColor
                                              .withOpacity(0.06),
                                        ),
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: [
                                            Text(
                                              getTranslated(context, 'Pos Wallet'),
                                              style: TextStyle(
                                                  fontSize: 8),
                                            ),
                                            Text(
                                              dealerlist[index][
                                              "currentPosamount"]
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight
                                                      .bold),
                                              textAlign:
                                              TextAlign.left,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 0,
                                            right: 0,
                                            top: 2,
                                            bottom: 0),
                                        decoration: BoxDecoration(),
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: [
                                            Text(
                                              getTranslated(context, 'Hold Amount'),
                                              style: TextStyle(
                                                  fontSize: 8),
                                            ),
                                            Text(
                                              dealerlist[index][
                                              "totalholdamount"]
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight
                                                      .bold),
                                              textAlign:
                                              TextAlign.right,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 0,right: 0,top: 2,bottom: 0),
                                        decoration: BoxDecoration(
                                          color: PrimaryColor.withOpacity(0.06),
                                        ),
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: [
                                            Text(
                                              getTranslated(context, 'Outstanding'),
                                              style: TextStyle(
                                                  fontSize: 8),
                                            ),
                                            Text(
                                              dealerlist[index]
                                              ["currentcr"]
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight
                                                      .bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(top: 4.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width:120,
                                    child: Text(
                                      getTranslated(context, 'Retailer Name'),
                                      style: TextStyle(fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    dealerlist[index]["Name"]
                                        .toString(),
                                    style: TextStyle(fontSize: 14),
                                    textAlign: TextAlign.end,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 4),
                              height: 1,
                              color: PrimaryColor.withOpacity(0.1),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(top: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getTranslated(context, 'Registered Mobile'),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    dealerlist[index]["Mobile"]
                                        .toString(),
                                    style: TextStyle(fontSize: 14),
                                    textAlign: TextAlign.end,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      children: [
                        Container(
                          transform: Matrix4.translationValues(0.0, -10, 0.0),
                          margin: EdgeInsets.only(left: 7,right: 7),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            boxShadow: [BoxShadow(
                              color: PrimaryColor.withOpacity(0.08),
                              blurRadius: .5,
                              spreadRadius: 1,
                              offset: Offset(.0,.0),)
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1),)),
                                ),
                                padding: const EdgeInsets.only(top: 5, bottom: 5),
                                child:Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(context, 'Email'),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Expanded(
                                      child: Text(
                                        dealerlist[index]["Email"]
                                            .toString()
                                            .toLowerCase(),
                                        style: TextStyle(fontSize: 14),
                                        textAlign: TextAlign.end,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1),)),
                                ),
                                padding: const EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(context, 'Join Date'),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      dealerlist[index]["JoinDate"]
                                          .toString(),
                                      style: TextStyle(fontSize: 14),
                                      textAlign: TextAlign.end,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1),)),
                                ),
                                padding: const EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(context, 'State'),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Expanded(
                                      child: Text(
                                        dealerlist[index]["State"]
                                            .toString(),
                                        style: TextStyle(fontSize: 14),
                                        textAlign: TextAlign.end,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1),)),
                                ),
                                padding: const EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(context, 'District'),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Expanded(
                                      child: Text(
                                        dealerlist[index]["District"]
                                            .toString(),
                                        style: TextStyle(fontSize: 14),
                                        textAlign: TextAlign.end,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1),)),
                                ),
                                padding: const EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(context, 'Full Address'),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Expanded(
                                      child: Text(
                                        dealerlist[index]["Address"]
                                            .toString(),
                                        style: TextStyle(fontSize: 14),
                                        textAlign: TextAlign.end,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 24,
                                transform: Matrix4.translationValues(0.0, -0, 0.0),
                                child:Container(
                                  transform: Matrix4.translationValues(
                                      0.0, -4.0, 0.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.add_comment,
                                          ),
                                          iconSize: 24,
                                          color: PrimaryColor,
                                          splashColor: Colors.purple,
                                          onPressed: () {

                                            String sms = dealerlist[index]["Mobile"];
                                            _launched = _openUrl('sms:$sms}');

                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.add_call,
                                          ),
                                          iconSize: 24,
                                          color: PrimaryColor,
                                          splashColor: Colors.purple,
                                          onPressed: () {

                                            String call = dealerlist[index]["Mobile"];
                                            _launched = _openUrl('tel:$call}');

                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.maps_ugc,
                                            color: PrimaryColor,
                                          ),
                                          iconSize: 24,
                                          splashColor: Colors.green,
                                          onPressed: () {

                                            String address = dealerlist[index]["Address"];
                                            setState(() {
                                              _launched = _openUrl('google.navigation:q=$address&mode=d');
                                            });

                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.attach_email,
                                            ),
                                            iconSize: 24,
                                            color: PrimaryColor,
                                            splashColor: Colors.purple,
                                            onPressed: () {

                                              String email = dealerlist[index]["Email"];
                                              setState(() {
                                                _launched = _openUrl('mailto:$email}');
                                              });

                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  }else if (dealerlist[index]["Name"]
                      .toLowerCase()
                      .contains(_textController.text) || dealerlist[index]["Name"]
                      .toUpperCase()
                      .contains(_textController.text)) {
                    return ExpansionTile(
                      childrenPadding: EdgeInsets.all(10),
                      textColor: Colors.black,
                      title: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          boxShadow: [BoxShadow(
                            color: PrimaryColor.withOpacity(0.08),
                            blurRadius: .5,
                            spreadRadius: 1,
                            offset: Offset(.0,.0),)
                          ],
                        ),
                        margin: EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 0),
                        child: Column(
                          children: [
                            Container(
                              height: 40,
                              margin: EdgeInsets.only(bottom: 10,top: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(width: 1, color: Colors.green)),
                              child: Column(
                                children: [
                                  Stack(
                                    fit: StackFit.loose,
                                    alignment: Alignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 5,top: 4, right: 0, bottom: 0),
                                            child: Container(
                                              child: Stack(
                                                fit: StackFit.loose,
                                                alignment: Alignment.center,
                                                children: [
                                                  Container(
                                                    height: 30,
                                                    width: 30,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                      BorderRadius.circular(50),
                                                      child: Image(
                                                          fit: BoxFit.cover,
                                                          image: dealerlist[index]["Photo"] == null ? NetworkImage("https://upload.wikimedia.org/wikipedia/commons/e/e0/Userimage.png")
                                                              : NetworkImage("https://test.vastwebindia.com/" + dealerlist[index]["Photo"])),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 1,
                                                    right: 0,
                                                    child: Container(
                                                        decoration:BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(100),),
                                                          color: TextColor,
                                                        ),
                                                        child: dealerlist[index]["Status"] == "Y" ? Icon(
                                                          Icons.check_circle,
                                                          color: Colors.green,
                                                          size: 10,
                                                        )
                                                            : Icon(Icons.cancel, color: Colors.red, size: 10,)
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              dealerlist[index]["Status"] == "Y" ?
                                              Container(
                                                padding: EdgeInsets.only(top: 5),
                                                width: 245,
                                                alignment: Alignment.center,
                                                child: Text(dealerlist[index]["firmName"].toString(),
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                                  : Container(
                                                width: 245,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(50),
                                                    border: Border.all(width: 1, color: Colors.red)),
                                                child: Text(dealerlist[index]["firmName"].toString(),
                                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      dealerlist[index]["Status"] == "Y" ?
                                      Container(
                                        transform: Matrix4.translationValues(0.0, -18, 0.0),
                                        alignment: Alignment.center,
                                        width: 80,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            border: Border.all(width: 1, color: TextColor),
                                            color: Colors.green),
                                        child: Text(getTranslated(context, 'Firm Name'), style: TextStyle(fontSize: 8, color: TextColor),
                                        ),
                                      )
                                          : Container(
                                        transform: Matrix4.translationValues(0.0, -18, 0.0),
                                        alignment: Alignment.center,
                                        width: 80,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            border: Border.all(width: 1, color: TextColor),
                                            color: Colors.red),
                                        child: Text(getTranslated(context, 'Firm Name'), style: TextStyle(fontSize: 8, color: TextColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              transform: Matrix4.translationValues(0.0, -2.0, 0.0),
                              padding:EdgeInsets.fromLTRB(0, 0, 0, 0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color:PrimaryColor.withOpacity(0.06),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 0, right: 0, top: 2, bottom: 0),
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: [
                                            Text(
                                              getTranslated(context, 'Main Wallet'),
                                              style: TextStyle(
                                                  fontSize: 8),
                                            ),
                                            Text(
                                              "\u{20B9} " +
                                                  dealerlist[
                                                  index]
                                                  [
                                                  "RemainAmt"]
                                                      .toString(),
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight
                                                      .bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 0,
                                            right: 0,
                                            top: 2,
                                            bottom: 0),
                                        decoration: BoxDecoration(
                                          color: PrimaryColor
                                              .withOpacity(0.06),
                                        ),
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: [
                                            Text(
                                              getTranslated(context, 'Pos Wallet'),
                                              style: TextStyle(
                                                  fontSize: 8),
                                            ),
                                            Text(
                                              dealerlist[index][
                                              "currentPosamount"]
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight
                                                      .bold),
                                              textAlign:
                                              TextAlign.left,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 0,
                                            right: 0,
                                            top: 2,
                                            bottom: 0),
                                        decoration: BoxDecoration(),
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: [
                                            Text(
                                              getTranslated(context, 'Hold Amount'),
                                              style: TextStyle(
                                                  fontSize: 8),
                                            ),
                                            Text(
                                              dealerlist[index][
                                              "totalholdamount"]
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight
                                                      .bold),
                                              textAlign:
                                              TextAlign.right,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 0,right: 0,top: 2,bottom: 0),
                                        decoration: BoxDecoration(
                                          color: PrimaryColor.withOpacity(0.06),
                                        ),
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: [
                                            Text(
                                              getTranslated(context, 'Outstanding'),
                                              style: TextStyle(
                                                  fontSize: 8),
                                            ),
                                            Text(
                                              dealerlist[index]
                                              ["currentcr"]
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight
                                                      .bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(top: 4.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getTranslated(context, 'Retailer Name'),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    dealerlist[index]["Name"]
                                        .toString(),
                                    style: TextStyle(fontSize: 14),
                                    textAlign: TextAlign.end,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 4),
                              height: 1,
                              color: PrimaryColor.withOpacity(0.1),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(top: 5.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getTranslated(context, 'Registered Mobile'),
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    dealerlist[index]["Mobile"]
                                        .toString(),
                                    style: TextStyle(fontSize: 14),
                                    textAlign: TextAlign.end,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      children: [
                        Container(
                          transform: Matrix4.translationValues(0.0, -10, 0.0),
                          margin: EdgeInsets.only(left: 7,right: 7),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            boxShadow: [BoxShadow(
                              color: PrimaryColor.withOpacity(0.08),
                              blurRadius: .5,
                              spreadRadius: 1,
                              offset: Offset(.0,.0),)
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1),)),
                                ),
                                padding: const EdgeInsets.only(top: 5, bottom: 5),
                                child:Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(context, 'Email'),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Expanded(
                                      child: Text(
                                        dealerlist[index]["Email"]
                                            .toString()
                                            .toLowerCase(),
                                        style: TextStyle(fontSize: 14),
                                        textAlign: TextAlign.end,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1),)),
                                ),
                                padding: const EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(context, 'Join Date'),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      dealerlist[index]["JoinDate"]
                                          .toString(),
                                      style: TextStyle(fontSize: 14),
                                      textAlign: TextAlign.end,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1),)),
                                ),
                                padding: const EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(context, 'State'),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Expanded(
                                      child: Text(
                                        dealerlist[index]["State"]
                                            .toString(),
                                        style: TextStyle(fontSize: 14),
                                        textAlign: TextAlign.end,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1),)),
                                ),
                                padding: const EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(context, 'District'),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Expanded(
                                      child: Text(
                                        dealerlist[index]["District"]
                                            .toString(),
                                        style: TextStyle(fontSize: 14),
                                        textAlign: TextAlign.end,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1),)),
                                ),
                                padding: const EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(context, 'Full Address'),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Expanded(
                                      child: Text(
                                        dealerlist[index]["Address"]
                                            .toString(),
                                        style: TextStyle(fontSize: 14),
                                        textAlign: TextAlign.end,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 24,
                                transform: Matrix4.translationValues(0.0, -0, 0.0),
                                child:Container(
                                  transform: Matrix4.translationValues(
                                      0.0, -4.0, 0.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.add_comment,
                                          ),
                                          iconSize: 24,
                                          color: PrimaryColor,
                                          splashColor: Colors.purple,
                                          onPressed: () {

                                            String sms = dealerlist[index]["Mobile"];
                                            _launched = _openUrl('sms:$sms}');

                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.add_call,
                                          ),
                                          iconSize: 24,
                                          color: PrimaryColor,
                                          splashColor: Colors.purple,
                                          onPressed: () {

                                            String call = dealerlist[index]["Mobile"];
                                            _launched = _openUrl('tel:$call}');

                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.maps_ugc,
                                            color: PrimaryColor,
                                          ),
                                          iconSize: 24,
                                          splashColor: Colors.green,
                                          onPressed: () {

                                            String address = dealerlist[index]["Address"];
                                            setState(() {
                                              _launched = _openUrl('google.navigation:q=$address&mode=d');
                                            });

                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.attach_email,
                                            ),
                                            iconSize: 24,
                                            color: PrimaryColor,
                                            splashColor: Colors.purple,
                                            onPressed: () {

                                              String email = dealerlist[index]["Email"];
                                              setState(() {
                                                _launched = _openUrl('mailto:$email}');
                                              });

                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  } else {
                    return Container(
                    );
                  }
                }
            ),
          ),

        ],
      ),
    );
  }
}
