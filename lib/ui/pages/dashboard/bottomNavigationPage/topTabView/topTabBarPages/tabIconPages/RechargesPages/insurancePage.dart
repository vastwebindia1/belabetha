 import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/IntroSliderPages/AppSignUpButton.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/ui/pages/locations/IpHelper.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import 'dthRechargePage.dart';
import 'mobileRecharge.dart';

class insurancePage extends StatefulWidget {
  const insurancePage({Key key}) : super(key: key);

  @override
  insurancestate createState() => insurancestate();
}

class insurancestate extends State<insurancePage> {

  bool textButton1 = false;
  bool custominfolay1 = false;
  bool nodatalay = false;
  bool customerInf1 = false;
  bool _isloading = false;

  bool btnvisible = false;
  bool loader = false;
  bool connectionerror = false;

  bool accntvisivility = false;
  bool accntvisivility2 = false;
  int maxlength;
  int minlength;
  int accmaxlength;
  int accmaxlength2;
  bool numberenable = false;

  bool textButton = false;
  bool amontvisi = false;


  var maxlen;
  String fastcode;
  String  billamnt="";
  String  billduedate = "";
  String customername = "";
  String msz ="";
  List operatorlisr = [];
  List custparam = [];
  String insuranceoperator = "Select Operator";
  String firsttexthint = "Consumer No";
  String accnumhint = "Agency Code";
  String accnumhint2 = "Agency Code";
  String insuranceoptcode,duedate,rechargeamnt,customerstatus,balance;
  String netname, ipadd, modelname, androidid, lat, long, city, address, postcode,status;

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
    ).timeout(const Duration(seconds: 10), onTimeout: () {});

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

  final TextEditingController consumernumber = TextEditingController();

  final TextEditingController amount = TextEditingController();
  final TextEditingController agencycode = TextEditingController();
  final TextEditingController agencycode2= TextEditingController();

  Future<void> insurancerechtask(String id, String num, String opt, String amnt, String lat,String long, String city,String address, String pin,String intype,String ipadd,String model,String key, String iv) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    try{

      var uri =
      new Uri.http("api.vastwebindia.com", "/Recharge/api/data/hkhk2", {
        "rd": id,
        "n": num,
        "ok": opt,
        "amn": amnt,
        "pc": agencycode.text,
        "bu": agencycode2.text,
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
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));},

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
              Navigator.of(context).pop();},
          );
        }



      } else {
        _isloading = false;
        throw Exception('Failed');
      }


    }catch(e){

    }

  }

  Future<void> viewbill(String billnum, String optcode, String acno) async {


    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var uri = new Uri.http("api.vastwebindia.com", "/Recharge/api/data/viewbill", {
      "billnumber": billnum,
      "Operator": optcode,
      "billunit": acno,
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
    ).timeout(Duration(seconds: 12), onTimeout: (){
      setState(() {
        loader = false;
        connectionerror = true;
      });

    });

    print(response);

    if (response.statusCode == 200) {

      var data = json.decode(response.body);
      var resp = data["ADDINFO"];
      String status = resp["IsSuccess"].toString();
      msz = resp["Message"];

      if(status.contains("true")){

        var billinfo = resp["BillInfo"];

        billamnt = billinfo["billAmount"];
        billduedate = billinfo["billDueDate"];
        customername = billinfo["customerName"];

        setState(() {
          connectionerror = false;
          loader = false;
          customername;
          btnvisible = true;
          amontvisi = true;
          amount.text = billamnt;
          nodatalay = false;
          custominfolay1 = true;
        });

      }else{


        setState(() {
          connectionerror = false;
          loader = false;
          msz;
          nodatalay = true;
          custominfolay1 = false;
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
    ).timeout(const Duration(seconds: 10), onTimeout: () {});

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

  String key1,key2,key3;
  var keytyp,keytyp2,keytyp3;

  void insuranceoperatordialog(){
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
                                              amount.clear();
                                              consumernumber.clear();
                                              nodatalay = false;
                                              numberenable = true;
                                              custominfolay1 = false;
                                              insuranceoperator = operatorlisr[index]["Operatorname"];
                                              insuranceoptcode  = operatorlisr[index]["OPtCode"];


                                              custparam = operatorlisr[index]["customerparams"];


                                              if(custparam == null){

                                                setState(() {
                                                  accntvisivility = false;
                                                  accntvisivility2 = false;
                                                });

                                              } else{

                                                setState(() {
                                                  firsttexthint = custparam[0]["paramName"];
                                                  maxlength = custparam[0]["maxLength"];
                                                  minlength = custparam[0]["minLength"];
                                                });

                                                if(custparam.length == 2){

                                                  setState(() {
                                                    accnumhint = custparam[1]["paramName"];
                                                    accmaxlength = custparam[1]["maxLength"];
                                                    accntvisivility = true;
                                                  });

                                                }else if (custparam.length == 3){

                                                  setState(() {
                                                    accnumhint = custparam[1]["paramName"];
                                                    accmaxlength = custparam[1]["maxLength"];
                                                    accntvisivility = true;
                                                    accnumhint2 = custparam[2]["paramName"];
                                                    accmaxlength2 = custparam[2]["maxLength"];
                                                    accntvisivility2 = true;
                                                  });

                                                }

                                              }

                                              viewbillstatuscheck(insuranceoptcode);
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
                                .contains(_textController.text) || operatorlisr[index]["Operatorname"]
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
                                              amount.clear();
                                              consumernumber.clear();
                                              nodatalay = false;
                                              numberenable = true;
                                              custominfolay1 = false;
                                              insuranceoperator = operatorlisr[index]["Operatorname"];
                                              insuranceoptcode  = operatorlisr[index]["OPtCode"];


                                              custparam = operatorlisr[index]["customerparams"];


                                              if(custparam == null){

                                                setState(() {
                                                  accntvisivility = false;
                                                  accntvisivility2 = false;
                                                });

                                              } else{

                                                setState(() {
                                                  firsttexthint = custparam[0]["paramName"];
                                                  maxlength = custparam[0]["maxLength"];
                                                  minlength = custparam[0]["minLength"];
                                                });

                                                if(custparam.length == 2){

                                                  setState(() {
                                                    accnumhint = custparam[1]["paramName"];
                                                    accmaxlength = custparam[1]["maxLength"];
                                                    accntvisivility = true;
                                                  });

                                                }else if (custparam.length == 3){

                                                  setState(() {
                                                    accnumhint = custparam[1]["paramName"];
                                                    accmaxlength = custparam[1]["maxLength"];
                                                    accntvisivility = true;
                                                    accnumhint2 = custparam[2]["paramName"];
                                                    accmaxlength2 = custparam[2]["maxLength"];
                                                    accntvisivility2 = true;
                                                  });

                                                }

                                              }

                                              _textController.clear();
                                              viewbillstatuscheck(insuranceoptcode);
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
    operatorlist("Insurance");
  }

  @override
  Widget build(BuildContext context) {
    return AppBarWidget(
        title: CenterAppbarTitle(
          svgImage: 'assets/pngImages/BBPS.png',
          topText: getTranslated(context, 'Selected Info'),
          selectedItemName:getTranslated(context, 'Insurance'),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  /*============select Option=============*/
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10,right: 10),
                    child: OutlineButton(
                      onPressed:insuranceoperatordialog,
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
                            Expanded(child: Text(insuranceoperator,style: TextStyle(color: PrimaryColor,fontWeight: FontWeight.normal,fontSize: 18,),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                            SizedBox(width: 20,child: Icon(Icons.arrow_drop_down,color: PrimaryColor,),)
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: accntvisivility,
                    child:  Container(
                      child: InputTextField(
                        inputFormatter: [ FilteringTextInputFormatter.allow(RegExp("[0-9/]")),],
                        controller: agencycode,
                        keyBordType: TextInputType.datetime,
                        label: accnumhint,
                        maxLength: accmaxlength,
                        obscureText: false,
                        labelStyle: TextStyle(
                          color: PrimaryColor,
                        ),
                        borderSide: BorderSide(width: 2, style: BorderStyle.solid),

                      ),
                    ),),
                  Visibility(
                    visible:accntvisivility ,
                    child: SizedBox(
                    ),),
                  Visibility(
                    visible: accntvisivility2,
                    child:  Container(
                      child: InputTextField(
                        controller: agencycode2,
                        keyBordType: TextInputType.number,
                        label: accnumhint2,
                        maxLength: accmaxlength2,
                        obscureText: false,
                        labelStyle: TextStyle(
                          color: PrimaryColor,
                        ),
                        borderSide: BorderSide(width: 2, style: BorderStyle.solid),

                      ),
                    ),
                  ),
                  Visibility(
                    visible:accntvisivility2 ,
                    child: SizedBox(
                    ),),
                  Container(
                    child: InputTextField(
                        controller: consumernumber,
                        checkenable: numberenable,
                        keyBordType: TextInputType.number,
                        maxLength: maxlen,
                        label: firsttexthint,
                        iButton: Visibility(
                          visible: textButton,
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

                                      FocusScopeNode currentFocus = FocusScope.of(context);
                                      currentFocus.unfocus();
                                      setState(() {
                                        connectionerror = false;
                                        loader = true;
                                        custominfolay1 = false;
                                        nodatalay = false;

                                      });
                                      viewbill(consumernumber.text,insuranceoptcode,agencycode.text);
                                    },
                                  ))
                          ),
                        ),
                        obscureText: false,
                        labelStyle: TextStyle(
                          color: PrimaryColor,
                        ),
                        borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                        onChange: (String value) {

                          if(status == "Y") {
                            if (value.length > 4) {
                              setState(() {
                                textButton = true;
                                amontvisi = true;
                              });
                            } else {
                              setState(() {
                                textButton = false;
                                custominfolay1 = false;
                                amontvisi = false;
                                amount.clear();
                              });
                            }
                          }else{

                            setState(() {
                              textButton = false;
                              amontvisi = true;
                            });

                          }

                        }),
                  ),
                  InputTextField(
                    controller: amount,
                    label: getTranslated(context, 'Enter Amount'),
                    checkenable: amontvisi,
                    keyBordType: TextInputType.number,
                    obscureText: false,
                    labelStyle: TextStyle(
                      color: PrimaryColor,
                    ),
                    borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                    onChange:(String val) {

                      if(val.length > 0){

                        setState(() {
                          btnvisible = true;
                        });

                      }else{

                        setState(() {
                          btnvisible = false;
                        });

                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "null";
                      }
                      return null;
                    },
                  ),
                  MainButtonSecodn(
                      onPressed: btnvisible == false ? null :() async{

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

                        lat = prefs.getString('lat2');
                        long = prefs.getString('long2');
                        city = prefs.getString('city2');
                        address = prefs.getString('add2');
                        postcode = prefs.getString('post2');
                        netname = prefs.getString('conntype');
                        ipadd = prefs.getString('ipaddress');

                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext
                            context) {
                              return CustomDialogWidget(
                                buttonText: getTranslated(context, 'Pay Now'),
                                description:getTranslated(context, 'Consumer Number'),
                                description0: consumernumber.text ,
                                description1: getTranslated(context, 'Operator Name'),
                                description01: insuranceoperator ,textStyle: TextStyle(fontSize: 32.0,fontWeight: FontWeight.w800,),
                                description2:getTranslated(context, 'Recharge Amount'),
                                description02: amount.text,
                                title: getTranslated(context, 'Please Verify Below Details'),
                                icon: Icons.help,
                                buttonText1:getTranslated(context, 'Cancel'),
                                buttonColor1: PrimaryColor,
                                buttonColor: SecondaryColor,
                                onpress2: (){
                                  Navigator.of(context).pop();
                                  insurancerechdetails(consumernumber.text,insuranceoptcode,amount.text,lat,long,city,address,postcode,netname,ipadd,androidid);
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
                              ),) : Text(getTranslated(context, 'Pay'),textAlign: TextAlign.center,style: TextStyle(color: TextColor),)
                          ),
                        ],
                      )
                  ),
                  Visibility(
                    visible: custominfolay1,
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
                                firstText: getTranslated(context, 'Recharge Amount'),
                                secondText: "\u{20B9}$billamnt",
                              ),
                              CustomerInfo(
                                firstText:getTranslated(context, 'Due Date'),
                                secondText: billduedate,
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

  void insurancerechdetails(String number, String operator, String amnt, String lat,String long, String city, String address,String pascode, String contype, String ipadd, String andid) async{


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


    insurancerechtask(useridd,numberr,opert,amnt,lat1,long1,city1,addre1,pascode1,cont1,ipd1,andiddd,keyencoded,viencoded);

  }


}
