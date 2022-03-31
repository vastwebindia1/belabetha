import 'dart:convert';
import 'package:cool_alert/cool_alert.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/DealerMainPage.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class RetailerList extends StatefulWidget {
  const RetailerList({Key key}) : super(key: key);

  @override
  _RetailerListState createState() => _RetailerListState();
}

ScrollController tabScroll = ScrollController();

class _RetailerListState extends State<RetailerList> {
  List retailerlist = [];

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
  String Retailerid = "";
  String Retailerstatus = "";

  Future<void> retailerList() async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url =
    new Uri.http("api.vastwebindia.com", "/api/data/retailer_list", {});
    final http.Response response = await http.post(
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
        retailerlist = data;
      });
    } else {
      throw Exception('Failed to load themes');
    }
  }

  Future<void> retailerActiveDeactive(String userid , String userStatus) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url =
    new Uri.http("api.vastwebindia.com", "/api/data/SetRetailerStatus", {
      "RetailerID" : userid,
      "Status" : userStatus,
    });
    final http.Response response = await http.post(
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
      var message = data["Message"].toString();
      if(message == "Success"){

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: message,
          title: "Change Status",
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => DealermaninDashboard()));
          },
        );


      }else{

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: message,
          title: "Change Status",
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => DealermaninDashboard()));
          },
        );





      }


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

  TextEditingController _textController = TextEditingController();
  TextEditingController _textController1 = TextEditingController();

  String retailerName = "";
  bool status = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retailerList();
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
          if (retailerlist.length == 0) Container(height: 50,
              child: DoteLoader()) else SingleChildScrollView(
            child: ListView.builder(
                shrinkWrap: true,
                controller: tabScroll,
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                itemCount: retailerlist.length,
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
                        margin: EdgeInsets.only(left: 8, right: 10, top: 5, bottom: 0),
                        child: Column(
                          children: [
                            Container(
                              height: 40,
                              margin: EdgeInsets.only(bottom: 10,top: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(width: 1,
                                      color: retailerlist[index]["Status"] == "Y" ? Colors.green:Colors.red)
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Stack(
                                        fit: StackFit.loose,
                                        alignment: Alignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(left: 5,top: 4, right: 0, bottom: 0),
                                                child: Container(
                                                  child: Stack(
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
                                                            image: retailerlist[index]["Photo"] == "" ? NetworkImage("https://upload.wikimedia.org/wikipedia/commons/e/e0/Userimage.png",scale: 0.5)
                                                                : NetworkImage("https://test.vastwebindia.com/" + retailerlist[index]["Photo"]),
                                                            width: 20,
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 1,
                                                        right: 0,
                                                        child: GestureDetector(
                                                          onTap: (){
                                                            CoolAlert.show(
                                                              backgroundColor: PrimaryColor.withOpacity(0.7),
                                                              context: context,
                                                              type: CoolAlertType.success,
                                                              text: "Retailer Current Status : " + retailerlist[index]["Status"],
                                                              title: "Change Retailer Status",
                                                              confirmBtnText: 'OK',
                                                              confirmBtnColor: Colors.green,
                                                              onConfirmBtnTap: (){
                                                                Navigator.pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => Dashboard()));
                                                              },
                                                            );
                                                          },
                                                          child: Container(
                                                              decoration:BoxDecoration(
                                                                borderRadius: BorderRadius.all(Radius.circular(100),),
                                                                color: TextColor,
                                                              ),
                                                              child: retailerlist[index]["Status"] == "Y" ? Icon(
                                                                Icons.check_circle,
                                                                color: Colors.green,
                                                                size: 10,
                                                              )
                                                                  : Icon(Icons.cancel, color: Colors.red, size: 10,)
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  retailerlist[index]["Status"] == "Y" ?
                                                  Container(
                                                    padding: EdgeInsets.only(top: 5),
                                                    width: 250,
                                                    alignment: Alignment.center,
                                                    child: Text(retailerlist[index]["firmName"].toString(),
                                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  )
                                                      : Container(
                                                    width: 290,
                                                    alignment: Alignment.center,
                                                    child: Text(retailerlist[index]["firmName"].toString(),
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          retailerlist[index]["Status"] == "Y" ?
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
                                          ) : Container(
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
                                      ),),
                                    ],
                                  )

                                ],
                              ),
                            ),
                            Container(
                              transform: Matrix4.translationValues(
                                  0.0, -2.0, 0.0),
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                    PrimaryColor.withOpacity(0.06),
                                  )),
                              child: Padding(
                                padding:
                                const EdgeInsets.only(top: 0.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
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
                                                  retailerlist[
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
                                              retailerlist[index][
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
                                              retailerlist[index][
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
                                              getTranslated(context, 'Outstanding'),
                                              style: TextStyle(
                                                  fontSize: 8),
                                            ),
                                            Text(
                                              retailerlist[index]
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
                                    retailerlist[index]["Name"]
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
                                    retailerlist[index]["Mobile"]
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
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text("Retailer Status"),
                                ),
                                Container(
                                  height: 25,
                                  child:  CustomSwitch(
                                    activeColor: Colors.green,
                                    value: retailerlist[index]["Status"] == "Y" ? true : false,
                                    onChanged: (value) {
                                      print("VALUE : $value");
                                      setState(() {
                                        CoolAlert.show(
                                          backgroundColor: PrimaryColor.withOpacity(0.7),
                                          context: context,
                                          type: CoolAlertType.success,
                                          text: "Retailer Current Status : " + retailerlist[index]["Status"],
                                          title: "Change Retailer Status",
                                          confirmBtnText: 'OK',
                                          confirmBtnColor: Colors.green,
                                          onConfirmBtnTap: (){
                                            Retailerstatus = retailerlist[index]["Status"];
                                            Retailerid = retailerlist[index]["UserID"].toString();
                                            retailerActiveDeactive(Retailerid, Retailerstatus);
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      });
                                    },
                                  ),
                                ),
                              ],
                            )
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
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(context, 'Email'),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Expanded(
                                      child: Text(
                                        retailerlist[index]["Email"]
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
                                    Expanded(
                                      child: Text(
                                        retailerlist[index]["JoinDate"]
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
                                      getTranslated(context, 'State'),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Expanded(
                                      child: Text(
                                        retailerlist[index]["State"]
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
                                        retailerlist[index]["District"]
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
                                    Container(
                                      width: 225,
                                      child:Text(
                                        retailerlist[index]["Address"]
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
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
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
                                                  String sms = retailerlist[index]
                                                  ["Mobile"];

                                                  _launched =
                                                      _openUrl('sms:$sms}');
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
                                                  String call =
                                                  retailerlist[index]
                                                  ["Mobile"];
                                                  _launched =
                                                      _openUrl('tel:$call}');
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
                                                  String address =
                                                  retailerlist[index]
                                                  ["Address"];

                                                  setState(() {
                                                    _launched = _openUrl(
                                                        'google.navigation:q=$address&mode=d');
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
                                                    String email =
                                                    retailerlist[index]
                                                    ["Email"];

                                                    setState(() {
                                                      _launched = _openUrl(
                                                          'mailto:$email}');
                                                    });
                                                  }),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  }else if (retailerlist[index]["Name"]
                      .toLowerCase()
                      .contains(_textController.text) || retailerlist[index]["Name"]
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
                                  border: Border.all(width: 1,
                                      color: retailerlist[index]["Status"] == "Y" ? Colors.green:Colors.red)
                              ),
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
                                                        image: retailerlist[index]["Photo"] == "" ? NetworkImage("https://upload.wikimedia.org/wikipedia/commons/e/e0/Userimage.png",scale: 0.5)
                                                            : NetworkImage("https://test.vastwebindia.com/" + retailerlist[index]["Photo"]),
                                                        width: 20,
                                                      ),
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
                                                        child: retailerlist[index]["Status"] == "Y" ? Icon(
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
                                              retailerlist[index]["Status"] == "Y" ?
                                              Container(
                                                padding: EdgeInsets.only(top: 5),
                                                width: 300,
                                                alignment: Alignment.center,
                                                child: Text(retailerlist[index]["firmName"].toString(),
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                                  : Container(
                                                width: 290,
                                                alignment: Alignment.center,
                                                child: Text(retailerlist[index]["firmName"].toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      retailerlist[index]["Status"] == "Y" ?
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
                              transform: Matrix4.translationValues(
                                  0.0, -2.0, 0.0),
                              padding:
                              EdgeInsets.fromLTRB(0, 0, 0, 0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                    PrimaryColor.withOpacity(0.06),
                                  )),
                              child: Padding(
                                padding:
                                const EdgeInsets.only(top: 0.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
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
                                                  retailerlist[
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
                                              retailerlist[index][
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
                                              retailerlist[index][
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
                                              getTranslated(context, 'Outstanding'),
                                              style: TextStyle(
                                                  fontSize: 8),
                                            ),
                                            Text(
                                              retailerlist[index]
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
                                    retailerlist[index]["Name"]
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
                                    retailerlist[index]["Mobile"]
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
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(context, 'Email'),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Expanded(
                                      child: Text(
                                        retailerlist[index]["Email"]
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
                                    Expanded(
                                      child: Text(
                                        retailerlist[index]["JoinDate"]
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
                                      getTranslated(context, 'State'),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Expanded(
                                      child: Text(
                                        retailerlist[index]["State"]
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
                                        retailerlist[index]["District"]
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
                                    Container(
                                      width: 225,
                                      child:Text(
                                        retailerlist[index]["Address"]
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
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
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
                                                  String sms = retailerlist[index]
                                                  ["Mobile"];

                                                  _launched =
                                                      _openUrl('sms:$sms}');
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
                                                  String call =
                                                  retailerlist[index]
                                                  ["Mobile"];
                                                  _launched =
                                                      _openUrl('tel:$call}');
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
                                                  String address =
                                                  retailerlist[index]
                                                  ["Address"];

                                                  setState(() {
                                                    _launched = _openUrl(
                                                        'google.navigation:q=$address&mode=d');
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
                                                    String email =
                                                    retailerlist[index]
                                                    ["Email"];

                                                    setState(() {
                                                      _launched = _openUrl(
                                                          'mailto:$email}');
                                                    });
                                                  }),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
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
