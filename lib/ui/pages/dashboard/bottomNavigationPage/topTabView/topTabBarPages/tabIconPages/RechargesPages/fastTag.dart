import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/HistoryPage/Rechargehistorypage.dart';
import 'package:myapp/ui/pages/locations/IpHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../../../dashboard.dart';
import 'dthRechargePage.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;

class FASTag extends StatefulWidget {
  const FASTag({Key key}) : super(key: key);

  @override
  _FASTagState createState() => _FASTagState();
}

class _FASTagState extends State<FASTag> {

  bool fasttextButton = false;
  bool fasttextButton2 = false;
  bool btndisable = false;
  bool connectionerror = false;

  bool fastcustominfolay1 = false;
  bool fastnodatalay = false;
  bool loader = false;
  bool accntvisivility = false;
  bool duedatee = false;


  bool amntvisivle = true;

  bool textButton = false;


  bool numberenable = false;
  bool axiseditman = false;
  bool amonuntenable = false;

  int maxlength;
  int accmaxlength;

  bool _isloading = false;
  bool _isloading2 = false;


  bool _isloading3 = false;

  List fastoperatorlist = [];
  List custparam = [];
  String fastcode,billamnt,billduedate,customername;
  String msz ="";
  String fastopt = "Select Operator";
  String firsttexthint = "Number";
  String accnumhint = "Amount";
  var status;
  String netname, ipadd, modelname, androidid, lat, long, city, address, postcode;

  final TextEditingController fastconsumernumber = TextEditingController();
  final TextEditingController fastamount = TextEditingController();
  final TextEditingController accno = TextEditingController();

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
      var datalist = data["myprop2Items"];

      setState(() {
        fastoperatorlist = datalist;
      });
    } else {
      throw Exception('Failed');
    }
  }

  Future<void> fastrechtask(String id, String num, String opt, String amnt, String lat,String long, String city,String address, String pin,String intype,String ipadd,String model,String key, String iv) async {
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

  Future<void> viewbill(String billnum, String optcode) async {


    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var uri = new Uri.http("api.vastwebindia.com", "/Recharge/api/data/viewbill", {
      "billnumber": billnum,
      "Operator": optcode,
      "billunit": "",
      "ProcessingCycle": "",
      "acno": "",
      "lt": "",
      "ViewBill": "Y",

    });
    final http.Response response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 15), onTimeout: (){
      setState(() {
        loader = false;
        _isloading2 = false;
        connectionerror = true;
        textButton = true;

      });

    });

    print(response);

    if (response.statusCode == 200) {

      var data = json.decode(response.body);
      var result = data["RESULT"];
      var resp = data["ADDINFO"];

      if(result == 0){

        var billinfo = resp["BillInfo"];

        billamnt = billinfo["billAmount"];
        billduedate = billinfo["billDueDate"];
        customername = billinfo["customerName"];

        if(billduedate == ""){

          setState(() {
            duedatee = false;
          });
        }else{

          setState(() {
            duedatee = true;
          });

        }

        setState(() {
          connectionerror = false;
          loader = false;
          _isloading2 = false;
          customername;
          btndisable = true;
          fastamount.text = billamnt;
          fastnodatalay = false;
          fastcustominfolay1 = true;
        });

      }else{


        setState(() {
          _isloading2 = false;
          loader = false;
          msz = resp;
          fastnodatalay = true;
          fastcustominfolay1 = false;
          connectionerror = false;
        });

      }





    } else {


      throw Exception('Failed to load data from internet');
    }
  }

  Future<void> viewbillstatuscheck(String optcode) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

     var url = new Uri.http("api.vastwebindia.com", "/Recharge/api/data/viewbillstatuscheck", {
      "Operatorcode": optcode,
    });

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
      var data = json.decode(response.body);
      status = data["RESULT"];

      setState(() {
        status;
      });
    } else {
      throw Exception('Failed');
    }
  }

  TextEditingController _textController = TextEditingController();
  ScrollController listSlide = ScrollController();

  void fastoperatordialog(){
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
                          itemCount: fastoperatorlist.length,
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
                                              fastamount.clear();
                                              fastconsumernumber.clear();
                                              amntvisivle = true;
                                              fastnodatalay = false;
                                              numberenable = true;
                                              fastcustominfolay1 = false;
                                              fastopt = fastoperatorlist[index]["Operatorname"];
                                              fastcode  = fastoperatorlist[index]["OPtCode"];

                                              custparam = fastoperatorlist[index]["customerparams"];

                                            if(custparam != null){

                                              setState(() {
                                                firsttexthint = custparam[0]["paramName"];
                                                maxlength = custparam[0]["maxLength"];
                                              });

                                              if(custparam.length == 2){

                                                setState(() {
                                                  accnumhint = custparam[1]["paramName"];
                                                  accmaxlength = custparam[1]["maxLength"];
                                                  accntvisivility = true;
                                                  amntvisivle = false;
                                                });

                                              }else{

                                                setState(() {
                                                  accntvisivility = false;
                                                });

                                              }

                                            }


                                              viewbillstatuscheck(fastcode);
                                              Navigator.of(context).pop();
                                            });

                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(fastoperatorlist[index]["Operatorname"],textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(height: 1,color: PrimaryColor,margin: EdgeInsets.only(top: 0,bottom: 0),)
                                ],
                              );
                            } else if (fastoperatorlist[index]["Operatorname"]
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
                                              fastamount.clear();
                                              fastconsumernumber.clear();
                                              amntvisivle = true;
                                              fastnodatalay = false;
                                              numberenable = true;
                                              fastcustominfolay1 = false;
                                              fastopt = fastoperatorlist[index]["Operatorname"];
                                              fastcode  = fastoperatorlist[index]["OPtCode"];

                                              custparam = fastoperatorlist[index]["customerparams"];

                                              if(custparam != null){

                                                setState(() {
                                                  firsttexthint = custparam[0]["paramName"];
                                                  maxlength = custparam[0]["maxLength"];
                                                });

                                                if(custparam.length == 2){

                                                  setState(() {
                                                    accnumhint = custparam[1]["paramName"];
                                                    accmaxlength = custparam[1]["maxLength"];
                                                    accntvisivility = true;
                                                    amntvisivle = false;
                                                  });

                                                }else{

                                                  setState(() {
                                                    accntvisivility = false;
                                                  });

                                                }
                                              }


                                              viewbillstatuscheck(fastcode);
                                              Navigator.of(context).pop();
                                            });

                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(fastoperatorlist[index]["Operatorname"],textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
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
  Position _currentPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    operatorlist("Fastag");
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return AppBarWidget(
        title: CenterAppbarTitle(
          svgImage: 'assets/pngImages/BBPS.png',
          topText: getTranslated(context, 'Selected Info'),
          selectedItemName:getTranslated(context, 'FASTag'),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  /*select Option=============*/
                  SizedBox(
                    height: 20,
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 10,right: 10),
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

                      padding: EdgeInsets.only(top: 16,bottom: 16,left: 10,right: 10),
                      borderSide: BorderSide(width: 1,color: PrimaryColor),
                      onPressed: () {
                        fastoperatordialog();
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Expanded(child: Text(fastopt,style: TextStyle(color: PrimaryColor,fontWeight: FontWeight.normal,fontSize: 18),overflow: TextOverflow.ellipsis,)),
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
                      controller: fastconsumernumber,
                        maxLength: 10,
                        label: firsttexthint,
                        obscureText: false,
                        iButton: textButton == true ?Visibility(
                          child: SizedBox(
                              height: 10,
                              width: 75,
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

                                      setState(() {
                                        _isloading2 = true;
                                        textButton = false;
                                        connectionerror = false;
                                        loader = true;
                                        fastcustominfolay1 = false;
                                        fastnodatalay = false;
                                      });
                                      FocusScopeNode currentFocus = FocusScope.of(context);
                                      currentFocus.unfocus();

                                      viewbill(fastconsumernumber.text,fastcode);
                                    },
                                  ))
                          ),
                        ) :Visibility(
                          visible:_isloading2,
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: Center(
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                      valueColor:
                                      AlwaysStoppedAnimation<
                                          Color>(
                                          SecondaryColor)),
                                )),
                          ),
                        ),
                        labelStyle: TextStyle(
                          color: PrimaryColor,
                        ),
                        borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                        onChange: (String value) {


                        if(status == "Y") {
                          if (value.length == 10) {
                            setState(() {
                              amonuntenable = true;
                              _isloading2 = true;
                              textButton = false;
                              connectionerror = false;
                              loader = true;
                              fastcustominfolay1 = false;
                              fastnodatalay = false;
                            });
                            FocusScopeNode currentFocus = FocusScope.of(
                                context);
                            currentFocus.unfocus();

                            viewbill(fastconsumernumber.text, fastcode);
                          } else {
                            setState(() {
                              textButton = true;
                              amonuntenable = true;
                              _isloading2 = false;
                            });
                          }
                        }else{

                          if(value.length == 10){

                            setState(() {
                              axiseditman = true;
                            });
                          }
                        }
                    },
                  ),
                  ),


                  Visibility(
                    visible: accntvisivility,
                    child: Container(
                      child: InputTextField(
                        controller: fastamount,
                        maxLength: accmaxlength,
                        checkenable: axiseditman,
                        label: accnumhint,
                        obscureText: false,
                        labelStyle: TextStyle(
                          color: PrimaryColor,
                        ),
                        borderSide: BorderSide(width: 2, style: BorderStyle.solid),

                      ),
                    ),),

                  Visibility(
                    visible: amntvisivle,
                    child:  InputTextField(

                      controller: fastamount,
                    label: getTranslated(context, 'Enter Amount'),
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
                  ),),

                  MainButtonSecodn(
                    onPressed:()async{

                      setState(() {

                        _isloading = true;
                      });

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
                              buttonText: getTranslated(context, 'Pay Now'),
                              description: getTranslated(context, 'Number'),
                              description0: fastconsumernumber.text ,
                              description1: getTranslated(context, 'Operator Name'),
                              description01: fastopt ,textStyle: TextStyle(fontSize: 32.0,fontWeight: FontWeight.w800),
                              description2:getTranslated(context, 'Recharge Amount'),
                              description02: fastamount.text,
                              title:
                              getTranslated(context, 'Please Verify Below Details'),
                              icon: Icons.help,
                              buttonText1:getTranslated(context, 'Cancel'),
                              buttonColor1: PrimaryColor,
                              buttonColor: SecondaryColor,
                              onpress2: (){

                                Navigator.of(context).pop();
                                fastrechdetails(fastconsumernumber.text,fastcode,fastamount.text,lat,long,city,address,postcode,netname,ipadd,androidid);
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
                            ),) : Text(getTranslated(context, 'Pay'),style: TextStyle(color: TextColor),textAlign: TextAlign.center,)
                        ),
                      ],
                    ),
                  ),

                  Visibility(
                    visible: fastcustominfolay1,
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
                                firstText:getTranslated(context, 'Amount'),
                                secondText: "\u{20B9}$billamnt",
                              ),
                              Visibility(
                                visible: duedatee,
                                child: CustomerInfo(
                                firstText: getTranslated(context, 'Due Date'),
                                secondText: billduedate,
                              ),
                              )

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: fastnodatalay,
                    child: Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: Center(
                        child: Text(msz,style: TextStyle(fontWeight: FontWeight.bold),),

                      ),
                    ),
                  ),
                  Visibility(
                    visible: loader,
                    child:  Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: Center(
                        child: Text(getTranslated(context, 'Data fetching please wait'),style: TextStyle(fontWeight: FontWeight.bold),),

                      ),
                    ),
                  ),
                  Visibility(
                    visible: connectionerror,
                    child:  Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 20),
                      child: Center(
                        child: Text(getTranslated(context, 'Connection Problem!! Please try Again'),style: TextStyle(fontWeight: FontWeight.bold),),

                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
    );
  }

  void fastrechdetails(String number, String operator, String amnt, String lat,String long, String city, String address,String pascode, String contype, String ipadd, String andid) async{


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


    fastrechtask(useridd,numberr,opert,amnt,lat1,long1,city1,addre1,pascode1,cont1,ipd1,andiddd,keyencoded,viencoded);

  }

  getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        print(_currentPosition);
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
