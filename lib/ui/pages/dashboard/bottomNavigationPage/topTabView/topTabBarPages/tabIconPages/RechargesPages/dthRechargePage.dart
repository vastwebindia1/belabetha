import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_auth/local_auth.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/IntroSliderPages/AppSignUpButton.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/HistoryPage/Rechargehistorypage.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/ui/pages/locations/IpHelper.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import 'mobileRecharge.dart';

class DthRechargePage extends StatefulWidget {
  const DthRechargePage({Key key}) : super(key: key);
  @override
  _DthRechargePageState createState() => _DthRechargePageState();
}

class _DthRechargePageState extends State<DthRechargePage> {

  bool textButton1 = false;
  bool _isvisible3 = false;
  bool nodatalay = false;
  bool customerInf1 = false;
  bool _isloading = false;

  bool recentHistoryVisible = true;
  bool recentPlanVisible = false;

  ScrollController _controllerList = new ScrollController();

  DateTime selectedDate = DateTime.now();
  DateTime selectedDate2 = DateTime.now();


  List rechhislist = [];
  List<int> list = [];

  int present = 0;
  int perPage;
  int pageIndex = 1;
  List originalItems = [];
  List items = [];

  String frmDate = "";
  String toDate = "";
  var userid;
  bool isExpand=false;



  void retid() async{

    final storage = new FlutterSecureStorage();
    userid = await storage.read(key: "userId");
    rechargehistory(pageIndex.toString(),userid, frmDate, toDate, "Retailer", "ALL", "ALL", "ALL");
  }

  Future<void> rechargehistory(String pgrind ,String retailerid, String fromdate, String todate, String role, String rechargenum,String status, String optname) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    try{

      var uri =
      new Uri.http("api.vastwebindia.com", "/Recharge/api/data/rem_rch_report", {
        "pageindex": pgrind,
        "pagesize": "500",
        "retailerid": retailerid,
        "fromdate": fromdate,
        "todate": todate,
        "role": role,
        "rechargeNo": rechargenum,
        "status": status,
        "OperatorName": optname,
        "portno":"ALL",
      });
      final http.Response response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // ignore: missing_return
      ).timeout(Duration(seconds: 15), onTimeout: (){
        setState(() {
          _isloading = false;

        });
      });

      print(response);

      if (response.statusCode == 200) {

        setState(() {
          /* loadersho = false;*/
          _isloading = false;
        });

        var data = json.decode(response.body);

        for(int i=0;i<data.length; i++){

          if(i > 4){
            break;
          }else{

            items.add(data[i]);

          }

        }

      } else {
        _isloading = false;
        throw Exception('Failed');
      }


    }catch(e){

      print(e);
    }

  }




  var maxlen = 8;
  Position _currentPosition;
  List operatorlisr = [];
  String dthoperator = "Select DTH Operator";
  String dthoptcode,duedate,rechargeamnt,customername,customerstatus,balance;
  String netname, ipadd, modelname, androidid, lat, long, city, address, postcode;

  Future<void> operatorlist(String name) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/Recharge/api/data/Optcodelist", {
      "opttype": name,
    });
    final http.Response response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 15), onTimeout: () {});

    print(response);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var datalist = data["myprop2Items"];

      setState(() {
        operatorlisr = datalist;
      });
    } else {
      throw Exception('Failed');
    }
  }

  Future<void> bestplan(String operator, String number) async {


    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var uri = new Uri.http("api.vastwebindia.com", "/Recharge/api/Data/BestOfferPlan", {
      "optname": operator,
      "mobileno": number,

    });
    final http.Response response = await http.post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response);

    if (response.statusCode == 200) {

      var data = json.decode(response.body);
      var status = data["status"];

      if(status == "SUCCESS"){

        duedate = data["rechargedueDate"].toString();
        rechargeamnt = data["monthlyRecharge"].toString();
        customername = data["customerName"].toString();
        customerstatus = data["customerStatus"].toString();
        balance = data["balance"].toString();

        setState(() {
          duedate;
          nodatalay = false;
          _isvisible3 = true;
          recentHistoryVisible = false;
        });

      }else{


        setState(() {
          nodatalay = true;
          _isvisible3 = false;
          recentHistoryVisible = false;

        });

      }


    } else {


      throw Exception('Failed to load data from internet');
    }
  }

  final TextEditingController consumernumber = TextEditingController();

  final TextEditingController amount = TextEditingController();

  Future<void> dthrechtask(String id, String num, String opt, String amnt, String lat,String long, String city,String address, String pin,String intype,String ipadd,String model,String key, String iv) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    try{

      var uri =
      new Uri.http("api.vastwebindia.com", "/Recharge/api/data/hkhk2", {
        "rd": id,
        "n": num,
        "ok": opt,
        "amn": amnt,
        "pc": "",
        "bu": "",
        "acno": "",
        "lt": "",
        "ip": ipadd,
        "mc":"",
        "em": "",
        "offerprice": "",
        "commAmount": "",
        "Devicetoken": city,
        "Latitude": lat,
        "Longitude": long,
        "ModelNo": model,
        "City": city,
        "PostalCode": pin,
        "InternetTYPE":intype,
        "Addresss":address,
        "value1":key,
        "value2":iv
      });
      final http.Response response = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // ignore: missing_return
      ).timeout(Duration(seconds: 15), onTimeout: (){
        setState(() {
          _isloading = false;
        });

        final snackBar2 = SnackBar(
          backgroundColor: PrimaryColor,
          content: Container(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Text("Request Submit Successfully. Please Check Your History.",style: TextStyle(color: TextColor,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.start)),
                Container(
                    width: MediaQuery.of(context).size.width,
                    color: SecondaryColor,
                    child: FlatButton(
                        onPressed: (){

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Rechargehistory()));

                        }, child: Text("History",style: TextStyle(color: TextColor),)))
              ],
            ),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar2);
      });

      print(response);

      if (response.statusCode == 200) {
        _isloading = false;
        var data = json.decode(response.body);
        var status = data["Response"];
        var msz = data["Message"];

        if(status == "Success"){

          CoolAlert.show(
            backgroundColor: PrimaryColor.withOpacity(0.7),
            context: context,
            type: CoolAlertType.success,
            text: msz,
            title: status,
            confirmBtnText: 'OK',
            confirmBtnColor: Colors.green,
            onConfirmBtnTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));
            },
          );

        }else{

          CoolAlert.show(
            backgroundColor: PrimaryColor.withOpacity(0.6),
            context: context,
            type: CoolAlertType.error,
            text: msz,
            title: status,
            confirmBtnText: 'OK',
            confirmBtnColor: Colors.red,
            onConfirmBtnTap: (){
              Navigator.of(context).pop();
            },
          );
        }



      } else {
        _isloading = false;
        throw Exception('Failed');
      }


    }catch(e){

    }

  }

  TextEditingController _textController = TextEditingController();
  ScrollController listSlide = ScrollController();

   void dthoperatordialog(){
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
                                child: Text(getTranslated(context, 'Select Your Operator'),
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
                          itemCount: operatorlisr.length,
                          itemBuilder: (context,  index) {
                            if (_textController.text.isEmpty) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
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
                                              dthoperator = operatorlisr[index]["Operatorname"];
                                              dthoptcode  = operatorlisr[index]["OPtCode"];

                                              Navigator.of(context).pop();
                                            });


                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(operatorlisr[index]["Operatorname"],textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(height: 1,color: PrimaryColor,margin: EdgeInsets.only(top: 0,bottom: 0),)
                                ],
                              );
                            } else if (operatorlisr[index]["Operatorname"]
                                .toLowerCase()
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
                                              dthoperator = operatorlisr[index]["Operatorname"];
                                              dthoptcode  = operatorlisr[index]["OPtCode"];
                                              _textController.clear();
                                              Navigator.of(context).pop();
                                            });


                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(operatorlisr[index]["Operatorname"],textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
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

   @override
   void initState() {
    // TODO: implement initState
    super.initState();
    frmDate = "${selectedDate2.toLocal()}".split(' ')[0];
    toDate = "${selectedDate.toLocal()}".split(' ')[0];
    retid();
    getCurrentLocation();
    operatorlist("DTH");
  }

   @override
   Widget build(BuildContext context) {
    return AppBarWidget(
        title: CenterAppbarTitleImage(
          svgImage: 'assets/pngImages/DTH.png',
          topText: getTranslated(context, 'Selected Info'),
          selectedItemName:getTranslated(context, 'DTH Recharge'),
        ),
        body: Material(
          child: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /*select Option=============*/
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10,right: 10),
                      child: OutlineButton(
                        onPressed:(){
                          dthoperatordialog();
                        },
                        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(4) ),
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        clipBehavior: Clip.none,
                        autofocus: false,
                        color:Colors.transparent ,
                        highlightColor:Colors.transparent ,
                        highlightedBorderColor: PrimaryColor,
                        focusColor:PrimaryColor ,
                        disabledBorderColor: PrimaryColor,
                        padding: EdgeInsets.only(top: 16,bottom: 16,left: 10,right: 10),
                        borderSide: BorderSide(width: 1,color: PrimaryColor),
                        child: Container(
                          child: Row(
                            children: [
                              Expanded(child: Text(dthoperator,style: TextStyle(color: PrimaryColor,fontWeight: FontWeight.normal,fontSize: 18),overflow: TextOverflow.ellipsis,)),
                              SizedBox(width: 20,child: Icon(Icons.arrow_drop_down,color: PrimaryColor,),)
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: InputTextField(
                          controller: consumernumber,
                          keyBordType: TextInputType.number,
                          maxLength: maxlen,
                          label:getTranslated(context, 'Customer ID'),
                          obscureText: false,
                          iButton: Visibility(
                            visible: textButton1,
                            child: SizedBox(
                                height: 10,
                                width: 79,
                                child: Container(
                                    margin: EdgeInsets.only(
                                        top: 10, left: 10, right: 10, bottom: 10),
                                    /* color: SecondaryColor,*/
                                    child: TextButton(

                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4.0),
                                            side: BorderSide(color: SecondaryColor),

                                          ),
                                        ),
                                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                                        backgroundColor:MaterialStateProperty.all(SecondaryColor) ,
                                      ),
                                      child: Text(getTranslated(context, 'Info'),style: TextStyle(color: TextColor),),
                                      onPressed: () {

                                        FocusScopeNode currentFocus = FocusScope.of(context);
                                        currentFocus.unfocus();
                                        bestplan(dthoperator,consumernumber.text);

                                      },
                                    ))
                            ),
                          ),
                          labelStyle: TextStyle(
                            color: PrimaryColor,
                          ),
                          borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                          onChange: (String value) {
                            if (value.length > 4) {
                              setState(() {
                                textButton1 = true;
                              });
                            } else {
                              setState(() {
                                textButton1 = false;
                                _isvisible3 =false;
                                amount.clear();
                              });

                            }

                            if(dthoperator == "Tata Sky"){
                              setState(() {
                                maxlen = 10;
                              });
                            }else if(dthoperator == "Dish TV"){
                              setState(() {
                                maxlen = 11;
                              });
                            }else if(dthoperator == "Videocon D2H"){
                              setState(() {
                                maxlen = 11;
                              });

                            }else if(dthoperator == "Airtel Digital TV"){
                              setState(() {
                                maxlen = 10;
                              });
                            }else if(dthoperator == "Sun Direct"){
                              setState(() {
                                maxlen = 11;
                              });
                            }else if(dthoperator == "Independent TV"){
                              setState(() {
                                maxlen = 12;
                              });
                            }else{
                              setState(() {
                                maxlen = 12;
                              });

                            }
                          }),
                    ),
                    InputTextField(
                      controller: amount,
                      label:getTranslated(context, 'Amount'),
                      keyBordType: TextInputType.number,
                      obscureText: false,
                      labelStyle: TextStyle(
                        color: PrimaryColor,
                      ),
                      borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "null";
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Container(
                            child: MainButtonTh(
                                onPressed: () async{


                                  final prefs = await SharedPreferences.getInstance();
                                  var dd= IpHelper().getCurrentLocation();
                                  var hu= IpHelper().getconnectivity();
                                  var hdddu= IpHelper().getLocalIpAddress();

                                  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                                  AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;

                                  modelname = androidDeviceInfo.model;
                                  androidid = androidDeviceInfo.androidId;

                                  netname = prefs.getString('conntype');
                                  ipadd = prefs.getString('ipaddress');

                                  if(_currentPosition == null){

                                    setState(() {
                                      lat = "null";
                                      long = "null";
                                      city = "null";
                                      address = "null";
                                      postcode = "null";
                                    });

                                  }

                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext
                                      context) {
                                        return CustomDialogWidget(
                                          buttonText:getTranslated(context, 'Pay Now'),
                                          description:getTranslated(context, 'Consumer Number'),
                                          description0: consumernumber.text ,
                                          description1:getTranslated(context, 'Operator Name') ,
                                          description01: dthoperator ,textStyle: TextStyle(fontSize: 32.0,fontWeight: FontWeight.w800),
                                          description2:getTranslated(context, 'Recharge Amount'),
                                          description02: amount.text,
                                          title: getTranslated(context, 'Please Verify Below Details'),
                                          icon: Icons.help,
                                          buttonText1:getTranslated(context, 'Cancel'),
                                          buttonColor1: PrimaryColor,
                                          buttonColor: SecondaryColor,
                                          onpress2: (){

                                            Navigator.of(context).pop();
                                            setState(() {
                                              _isloading = true;
                                            });
                                            dthrechdetails(consumernumber.text,dthoptcode,amount.text,"lat","long","city","address","postcode",netname,ipadd,androidid);
                                          },
                                          onpress: (){

                                            setState(() {

                                              _isloading = false;
                                            });

                                            Navigator.of(context).pop();
                                          },


                                        );
                                      });

                                },
                                color: SecondaryColor,
                                btnText:Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        child: _isloading ? Center(child: SizedBox(
                                          height: 20,
                                          child: LinearProgressIndicator(backgroundColor: PrimaryColor,valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
                                        ),) : Text(getTranslated(context, 'Pay'),style: TextStyle(color: TextColor,),textAlign: TextAlign.center,)
                                    ),
                                  ],
                                )
                            ),
                          ),
                        ),

                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: recentHistoryVisible,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text("Recent 5 Transaction", style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  height:2,
                                  width: 135,
                                  color: Colors.black,
                                  margin: EdgeInsets.only(left:8,),
                                )
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),


                    Visibility(
                      visible: _isvisible3,
                      replacement: SingleChildScrollView(
                        child: Container(
                          color: TextColor,
                          child: Container(
                            margin: EdgeInsets.only(left: 8,right: 8),
                            child: ListView.builder(
                              controller: _controllerList,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              itemCount: (present <= originalItems.length) ? items.length + 1 : items.length,
                              itemBuilder: (BuildContext context, int index) {
                                if ((index == items.length )) {
                                  return originalItems.length > 20 ? Container(
                                    margin: EdgeInsets.only(left: 0,right: 0,top: 20),
                                    color: SecondaryColor,
                                  ) :Container(
                                    child: Text(""),
                                  );
                                } else {
                                  return Container(
                                    margin: EdgeInsets.only(top: 10),
                                    padding: EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1,color: PrimaryColor.withOpacity(0.4),),
                                      boxShadow: [
                                        BoxShadow(
                                          color: PrimaryColor.withOpacity(0.08),
                                          blurRadius: 0.5,
                                          spreadRadius: 0,
                                          offset: Offset(0.0, .0), // shadow direction: bottom right
                                        )
                                      ],
                                    ),
                                    child: Container(
                                      color:Colors.white,
                                      child:Container(
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          alignment: Alignment.centerRight,
                                                          color: items[index]["Status"] == "SUCCESS" ? Colors.green
                                                              : items[index]["Status"] == "Pending" ? Colors.yellow[800]
                                                              : items[index]["Status"] == "FAILED" ? Colors.red
                                                              : Colors.deepPurple,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  items[index]["Status"] == "SUCCESS" ? Icon(Icons.check_circle,color: Colors.white,size: 32,) : items[index]["Status"] == "Pending" ? Icon(Icons.watch_later,color: Colors.white,size: 32,) :items[index]["Status"] == "FAILED" ?Icon(Icons.cancel,color: Colors.white,size: 32,) : Container(child: Icon(Icons.replay_circle_filled,color: Colors.white,size: 32,)),

                                                                ],
                                                              ),

                                                            ],
                                                          ),
                                                        ),

                                                        Container(
                                                          padding: EdgeInsets.only(left: 5,),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Text(items[index]["Reqesttime"].toString(),overflow: TextOverflow.ellipsis,textAlign: TextAlign.right,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                              SizedBox(height: 4,),

                                                              Row(
                                                                children: [
                                                                  Text(items[index]["Recharge_number"].toString(),overflow: TextOverflow.ellipsis,textAlign: TextAlign.right,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)
                                                                ],
                                                              )

                                                            ],
                                                          ),
                                                        ),


                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(right:5,),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Text(" \u{20B9} " + items[index]["Recharge_amount"].toString(),textAlign: TextAlign.right,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold)),
                                                          SizedBox(height: 3,),
                                                          Row(
                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: [
                                                              Flexible(child: Text(items[index]["Operator_name"].toString().toLowerCase(),overflow: TextOverflow.clip,textAlign: TextAlign.right,style: TextStyle(fontSize: 12 ,fontWeight: FontWeight.bold),)),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),


                                                ],
                                              ),
                                              /*Visibility(
                                              visible: items[index]["Operator_name"] == "Sun Direct" && items[index]["Status"] == "SUCCESS"?true:false,
                                              child: Row(
                                                crossAxisAlignment:CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                  child: Container(
                                                    child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Heavy Request",textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                                      SizedBox(height: 2,),
                                                      IconButton(
                                                        onPressed: (){
                                                          String opeStatus = items[index]["Status"];
                                                          if(opeStatus == "SUCCESS"){

                                                            String opeConsumer = items[index]["Operator_name"];
                                                            String opeNumber = items[index]["Recharge_number"];
                                                            heavyRequest(opeConsumer, opeNumber);

                                                          }

                                                        },
                                                        icon: Icon(Icons.refresh,color: SecondaryColor,),
                                                      ),

                                                    ],
                                                    ),
                                                  ),
                                                  ),


                                                ],
                                              ),
                                            ),*/
                                            ],
                                          ),
                                        ),
                                      ),

                                      /*children: [
                                                                      Column(
                                                                        children: [
                                                                          Container(
                                                                            margin: EdgeInsets.only(top: 0,bottom: 8),
                                                                            height: 1,
                                                                            color: PrimaryColor.withOpacity(0.1),
                                                                          ),
                                                                          Container(
                                                                            child: Container(
                                                                              child: Container(
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Container(
                                                                                      child:Column(
                                                                                        children: [
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            children: [
                                                                                              Expanded(
                                                                                                child: Container(
                                                                                                  alignment: Alignment.centerLeft,
                                                                                                  child: Column(
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    children: [
                                                                                                      Text(
                                                                                                        getTranslated(context, 'Requst ID'),
                                                                                                        style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),
                                                                                                        overflow: TextOverflow.ellipsis,softWrap: true,textAlign: TextAlign.left,),
                                                                                                      SizedBox(height: 2,),
                                                                                                      SelectableText(
                                                                                                        items[index]["Request_ID"].toString(),textAlign: TextAlign.right,
                                                                                                      )
                                                                                                      //Text(items[index]["Request_ID"].toString(),textAlign: TextAlign.right,)
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              Expanded(
                                                                                                child: Container(
                                                                                                  alignment: Alignment.centerRight,
                                                                                                  child: Column(
                                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                                                    children: [
                                                                                                      Text(
                                                                                                        getTranslated(context, 'Operator ID'),
                                                                                                        style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),
                                                                                                        overflow: TextOverflow.ellipsis,softWrap: true,textAlign: TextAlign.right,),
                                                                                                      SizedBox(height: 2,),
                                                                                                      SelectableText(items[index]["Operatorid"].toString(),textAlign: TextAlign.right,)
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          Container(
                                                                                            margin: EdgeInsets.only(top: 5,bottom: 8),
                                                                                            height: 1,
                                                                                            color: PrimaryColor.withOpacity(0.1),
                                                                                          ),
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            children: [
                                                                                              Expanded(
                                                                                                child: Container(
                                                                                                  alignment: Alignment.centerLeft,
                                                                                                  child: Column(
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    children: [
                                                                                                      Text(getTranslated(context, 'Pre Balance'),textAlign: TextAlign.left,style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                                                                      SizedBox(height: 1,),
                                                                                                      Text("\u{20B9} " + items[index]["RemainPre"].toString(),textAlign: TextAlign.right,)
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                width: 1,
                                                                                                height: 28,
                                                                                                child: Container(
                                                                                                  width: 2,
                                                                                                  color: Colors.black12,
                                                                                                ),
                                                                                              ),
                                                                                              Expanded(
                                                                                                child: Container(
                                                                                                  alignment: Alignment.center,
                                                                                                  child: Column(
                                                                                                    children: [
                                                                                                      items[index]["Creditamount"] == 0.0 ? Text(getTranslated(context, 'Debit') + "\u{20B9}",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,softWrap: true,) : Text("Credit \u{20B9}".toUpperCase(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                                                                      SizedBox(height: 2,),
                                                                                                      items[index]["Creditamount"] == 0.0 ? Text("\u{20B9} "+items[index]["Debitamount"].toString(),textAlign: TextAlign.right,) : Text("\u{20B9} "+items[index]["Creditamount"].toString(),textAlign: TextAlign.right,)
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                width: 1,
                                                                                                height: 28,
                                                                                                child: Container(
                                                                                                  width: 2,
                                                                                                  color: Colors.black12,
                                                                                                ),
                                                                                              ),
                                                                                              Expanded(
                                                                                                child: Container(
                                                                                                  alignment: Alignment.centerRight,
                                                                                                  child: Column(
                                                                                                    children: [
                                                                                                      Text(getTranslated(context, 'Post Balance') ,style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                                                                      SizedBox(height: 1,),
                                                                                                      Text("\u{20B9} " + items[index]["RemainPost"].toString(),textAlign: TextAlign.center,)
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              // items[index]["Status"] == "SUCCESS" ? Expanded(
                                                                                              //   child: Container(
                                                                                              //     alignment: Alignment.centerRight,
                                                                                              //     child: Column(
                                                                                              //       children: [
                                                                                              //         Container(
                                                                                              //
                                                                                              //           height: 32,
                                                                                              //           child: TextButton(
                                                                                              //               onPressed: (){
                                                                                              //
                                                                                              //                 idno = items[index]["Idno"].toString();
                                                                                              //                 disputeresiondialog();
                                                                                              //               },
                                                                                              //               style: ButtonStyle(backgroundColor: MaterialStateProperty.all(SecondaryColor)),
                                                                                              //               child: Text("Complain", style: TextStyle(fontSize: 12,color: TextColor),)),
                                                                                              //         )
                                                                                              //       ],
                                                                                              //     ),
                                                                                              //   ),
                                                                                              // ) : Text(""),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 5,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],*/

                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0XFFe8e8e8),
                                blurRadius: .5,
                                spreadRadius: 1,
                                offset:
                                Offset(.0, .0), // shadow direction: bottom right
                              )
                            ],
                          ),
                          child: Container(
                            color: PrimaryColor.withOpacity(0.08),
                            padding: EdgeInsets.only(
                                top: 10, bottom: 10, left: 5, right: 5),
                            child: Column(
                              children: [
                                CustomerInfo(
                                  firstText:getTranslated(context, 'Customer  Name'),
                                  secondText: customername,
                                ),
                                CustomerInfo(
                                  firstText:getTranslated(context, 'Balance'),
                                  secondText: "\u{20B9}$balance",
                                ),
                                CustomerInfo(
                                  firstText:getTranslated(context, 'Bill Amount'),
                                  secondText: "\u{20B9}$rechargeamnt",
                                ),
                                CustomerInfo(
                                  firstText:getTranslated(context, 'Due Date'),
                                  secondText: duedate,
                                ),
                                CustomerInfo(
                                  firstText:getTranslated(context, 'Customer Status'),
                                  secondText: customerstatus,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: nodatalay,
                      child: Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 20),
                        child: Center(
                          child: Text(getTranslated(context, 'No Data Found'),style: TextStyle(fontWeight: FontWeight.bold),),

                        ),
                      ),
                    )

                  ],
                ),
              ),
            ),
          ),
        )
    );
  }

   void dthrechdetails(String number, String operator, String amnt, String lat,String long, String city, String address,String pascode, String contype, String ipadd, String andid) async{

    final storage = new FlutterSecureStorage();
    var userid = await storage.read(key: "userId");

    var uuid = Uuid();
    var keyst = uuid.v1().substring(0,16);
    var ivstr = uuid.v4().substring(0,16);

    String keySTR = keyst.toString(); //16 byte
    String ivSTR =  ivstr.toString(); //16 byte

    String keyencoded = base64.encode(utf8.encode(keySTR));
    String viencoded = base64.encode(utf8.encode(ivSTR));


    final key = encrypt.Key.fromUtf8(keySTR);
    final iv = encrypt.IV.fromUtf8(ivSTR);

    final encrypter = encrypt.Encrypter(encrypt.AES(key,mode: encrypt.AESMode.cbc,padding: 'PKCS7'));

    final encrypted1 =encrypter.encrypt(userid, iv: iv);
    final encrypted2 =encrypter.encrypt(number, iv: iv);
    final encrypted3 =encrypter.encrypt(operator, iv: iv);
    final encrypted4 =encrypter.encrypt(amnt, iv: iv);
    final encrypted5 =encrypter.encrypt(lat, iv: iv);
    final encrypted6 =encrypter.encrypt(long, iv: iv);
    final encrypted7 =encrypter.encrypt(city, iv: iv);
    final encrypted8 =encrypter.encrypt(address, iv: iv);
    final encrypted9 =encrypter.encrypt(pascode, iv: iv);
    final encrypted10 =encrypter.encrypt(contype, iv: iv);
    final encrypted11 =encrypter.encrypt(ipadd, iv: iv);
    final encrypted12 =encrypter.encrypt(andid, iv: iv);


    String useridd = encrypted1.base64;
    String numberr = encrypted2.base64;
    String opert = encrypted3.base64;
    String amnt1 = encrypted4.base64;
    String lat1 = encrypted5.base64;
    String long1 = encrypted6.base64;
    String city1 = encrypted7.base64;
    String addre1 = encrypted8.base64;
    String pascode1 = encrypted9.base64;
    String cont1 = encrypted10.base64;
    String ipd1 = encrypted11.base64;
    String andiddd = encrypted12.base64;


    dthrechtask(useridd,numberr,opert,amnt,lat1,long1,city1,addre1,pascode1,cont1,ipd1,andiddd,keyencoded,viencoded);

  }

   getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium)
        .then((Position position) {

      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();

    }).catchError((e) {
      print(e);
    });
  }
  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        lat = _currentPosition.latitude.toString();
        long = _currentPosition.longitude.toString();
        address = place.street;
        city = place.locality;
        postcode = place.postalCode;
      });


    } catch (e) {
      print(e);
    }
  }

}

class CenterAppbarTitle extends StatelessWidget {
  final String topText, selectedItemName;
  final svgImage;
  const CenterAppbarTitle({
    Key key, this.topText, this.selectedItemName, this.svgImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 25,
              width: 25,
              child: Image.asset(
                svgImage,
                width:20,
                color: TextColor,
              )
            ),
            SizedBox(width: 3,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topText,
                  style: TextStyle(
                      color: TextColor,
                      fontSize: 8,
                      fontWeight: FontWeight.bold
                  ),),
                SizedBox(height: 1,),
                Text(selectedItemName,
                  style: TextStyle(color: TextColor,fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),

          ],
        ));
  }
}

class CenterAppbarTitleImage extends StatelessWidget {
  final String topText, selectedItemName;
  final svgImage;
  final Color color;
  const CenterAppbarTitleImage({
    Key key, this.topText, this.selectedItemName, this.svgImage, this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 25,
                width: 25,
                child: Image.asset(
                  svgImage,
                  width:20,
                  color: color,
                )
            ),
            SizedBox(width: 3,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topText,
                  style: TextStyle(
                      color: TextColor,
                      fontSize: 8,
                      fontWeight: FontWeight.bold
                  ),),
                SizedBox(height: 1,),
                Text(selectedItemName,
                  style: TextStyle(color: TextColor,fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),

          ],
        ));
  }
}

class CenterAppbarTitleWithIcon extends StatelessWidget {
  final String topText, selectedItemName;
  final icon;
  const CenterAppbarTitleWithIcon({
    Key key, this.topText, this.selectedItemName, this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 25,
                width: 25,
                child:icon
            ),
            SizedBox(width: 3,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topText,
                  style: TextStyle(
                      color: TextColor,
                      fontSize: 8,
                      fontWeight: FontWeight.bold
                  ),),
                SizedBox(height: 1,),
                Text(selectedItemName,
                  style: TextStyle(color: TextColor,fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),

          ],
        ));
  }
}

class AepsAppbarTitle extends StatelessWidget {
  final String topText, selectedItemName;
  final svgImage;
  const AepsAppbarTitle({
    Key key, this.topText, this.selectedItemName, this.svgImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 25,
                width: 25,
                child: Image.asset(
                  svgImage,
                  width:20,

                )
            ),
            SizedBox(width: 3,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topText,
                  style: TextStyle(
                      color: TextColor,
                      fontSize: 8,
                      fontWeight: FontWeight.bold
                  ),),
                SizedBox(height: 1,),
                Text(selectedItemName,
                  style: TextStyle(color: TextColor,fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),

          ],
        ));
  }
}

class CustomerInfo extends StatelessWidget {
  final String firstText, secondText;
  final Widget test;

  const CustomerInfo({
    Key key,
    this.firstText,
    this.secondText, this.test,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 3, bottom: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Text(firstText)),
              Expanded(
                  child: Text(secondText,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.right))
            ],
          ),
        ),
        Container(
          height: 1,
          color: PrimaryColor.withOpacity(0.1),
        )
      ],
    );
  }
}
