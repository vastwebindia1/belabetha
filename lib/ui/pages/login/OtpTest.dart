import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/CommanWidget/app_logo.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/IntroSliderPages/AppSignUpButton.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:myapp/ui/pages/login/login.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:http/http.dart' as http;

import 'otpPage.dart';

class OTPTEST extends StatefulWidget {
  const OTPTEST({Key key}) : super(key: key);

  @override
  _OTPTESTState createState() => _OTPTESTState();
}

class _OTPTESTState extends State<OTPTEST> {



  TextEditingController emailotp1 = TextEditingController();
  TextEditingController emailotp2 = TextEditingController();
  TextEditingController emailotp3 = TextEditingController();
  TextEditingController emailotp4 = TextEditingController();

  TextEditingController emailotp5 = TextEditingController();
  TextEditingController emailotp6 = TextEditingController();
  TextEditingController emailotp7 = TextEditingController();
  TextEditingController emailotp8 = TextEditingController();

  Future<void> verifyotp(String mobileotp, String emailotp) async {

    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/Common/api/data/VeryfyUserMobileEmailOTP", {
      "hdmobileotp": mobileotp,
      "hdemailotp": emailotp,
    });
    final http.Response response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response);

    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      var status = dataa["Status"];
      var msz = dataa["msg"];


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
      throw Exception('Failed');
    }


  }

  Future<void> verifyusers() async {


    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/Common/api/data/VeryFY_Profiles_users");
    final http.Response response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response);

    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      var status = dataa["status"];


    } else {
      throw Exception('Failed');
    }


  }

  String mobileottp ;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listenotp();
  }

  DateTime backbuttonpressedTime;
  final snackBar2 = SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Double Click to exit app',textAlign: TextAlign.center,style: TextStyle(color: Colors.yellowAccent),),
      ],
    ),
  );
  Future<bool> _onbackpress() async {

    DateTime currentTime = DateTime.now();

    //Statement 1 Or statement2
    bool backButton = backbuttonpressedTime == null ||
        currentTime.difference(backbuttonpressedTime) > Duration(seconds: 3);

    if (backButton) {
      backbuttonpressedTime = currentTime;
      // ignore: unnecessary_statements
      SnackBar;ScaffoldMessenger.of(context).showSnackBar(snackBar2);
      return Future.value(false);
    }
    SystemNavigator.pop();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    final storage = new FlutterSecureStorage();
    storage.deleteAll();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
        appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            final storage = new FlutterSecureStorage();
            storage.deleteAll();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start, children: [
            /*APP LOGO==========*/
            Container(
                margin: EdgeInsets.only(top: 20),
                height: 90,
                child: Image.asset('assets/aashalogo.png')
            ),
            SizedBox(
              height: 20,
            ),

            /*MOBILE & EMAIL OTP CARD=================*/
            Container(
              child: Column(
                children: [
                  /*Mobile otp =========*/
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Card(
                      elevation: 5,
                      semanticContainer: false,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 5, right: 6, top: 8, bottom: 8),
                        child: Column(
                          children: [
                            Container(
                              child: Center(
                                child: Text(
                                  "Mobile OTP received on your Registered Mobile No.",
                                  style: TextStyle(
                                      fontSize: 11,color:PrimaryColor,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                child:Container(
                                  height: 60,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(child: TextField(
                                        controller: emailotp5,
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        maxLength: 1,
                                        cursorColor: PrimaryColor,
                                        cursorHeight: 20,
                                        decoration: InputDecoration(
                                          hintText: "-",
                                          counterText: '',
                                          hintStyle: TextStyle(color: Colors.black, fontSize: 20.0),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),),
                                              borderRadius: BorderRadius.circular(2)
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),width: 2),
                                            borderRadius: BorderRadius.circular(3),

                                          ),

                                        ),
                                        onChanged: (value){
                                          if(value.length == 1){
                                            FocusScope.of(context).nextFocus();
                                          }
                                          else if(value.length == 0){
                                            FocusScope.of(context).previousFocus();
                                          }
                                        },
                                      )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(child: TextField(
                                        textAlign: TextAlign.center,
                                        controller: emailotp6,
                                        keyboardType: TextInputType.number,
                                        maxLength: 1,
                                        cursorColor: PrimaryColor,
                                        cursorHeight: 20,
                                        decoration: InputDecoration(
                                          hintText: "-",
                                          counterText: '',
                                          hintStyle: TextStyle(color: Colors.black, fontSize: 20.0),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),),
                                              borderRadius: BorderRadius.circular(2)
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),width: 2),
                                            borderRadius: BorderRadius.circular(3),

                                          ),

                                        ),
                                        onChanged: (value){
                                          if(value.length == 1){
                                            FocusScope.of(context).nextFocus();
                                          }
                                          else if(value.length == 0){
                                            FocusScope.of(context).previousFocus();
                                          }
                                        },
                                      )),
                                      SizedBox(width: 10),
                                      Expanded(child: TextField(
                                        textAlign: TextAlign.center,
                                        controller: emailotp7,
                                        keyboardType: TextInputType.number,
                                        maxLength: 1,
                                        cursorColor: PrimaryColor,
                                        cursorHeight: 20,
                                        decoration: InputDecoration(
                                          hintText: "-",
                                          counterText: '',
                                          hintStyle: TextStyle(color: Colors.black, fontSize: 20.0),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),),
                                              borderRadius: BorderRadius.circular(2)
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),width: 2),
                                            borderRadius: BorderRadius.circular(3),

                                          ),

                                        ),
                                        onChanged: (value){
                                          if(value.length == 1){
                                            FocusScope.of(context).nextFocus();
                                          }
                                          else if(value.length == 0){
                                            FocusScope.of(context).previousFocus();
                                          }
                                        },
                                      )),
                                      SizedBox(width: 10),
                                      Expanded(child: TextField(
                                        textAlign: TextAlign.center,
                                        controller: emailotp8,
                                        keyboardType: TextInputType.number,
                                        maxLength: 1,
                                        cursorColor: PrimaryColor,
                                        cursorHeight: 20,
                                        decoration: InputDecoration(
                                          hintText: "-",
                                          counterText: '',
                                          hintStyle: TextStyle(color: Colors.black, fontSize: 20.0),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),),
                                              borderRadius: BorderRadius.circular(2)
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),width: 2),
                                            borderRadius: BorderRadius.circular(3),

                                          ),

                                        ),
                                        onChanged: (value){
                                          if(value.length == 1){
                                            FocusScope.of(context).nextFocus();
                                          }
                                          else if(value.length == 0){
                                            FocusScope.of(context).previousFocus();
                                          }
                                        },
                                      )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                )
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 15),
                                  child: TextButtons(
                                    buttonText: getTranslated(context, 'Resend OTP'),
                                    textButtonText: "",
                                    onPressed: () {

                                      verifyusers();
                                    },
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /*Email Otp card==========*/
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Card(
                      elevation: 5,
                      semanticContainer: false,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 5, right: 6, top: 8, bottom: 8),
                        child: Column(
                          children: [
                            Container(
                              child: Center(
                                child: Text(
                                  "Email OTP received on your Registered Email Id.",
                                  style: TextStyle(
                                      fontSize: 11,color:PrimaryColor,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                child:Container(
                                  height: 60,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(child: TextField(
                                        controller: emailotp1,
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        maxLength: 1,
                                        cursorColor: PrimaryColor,
                                        cursorHeight: 20,
                                        decoration: InputDecoration(
                                          hintText: "-",
                                          counterText: '',
                                          hintStyle: TextStyle(color: Colors.black, fontSize: 20.0),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),),
                                              borderRadius: BorderRadius.circular(2)
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),width: 2),
                                            borderRadius: BorderRadius.circular(3),

                                          ),

                                        ),
                                        onChanged: (value){
                                          if(value.length == 1){
                                            FocusScope.of(context).nextFocus();
                                          }
                                          else if(value.length == 0){
                                            FocusScope.of(context).previousFocus();
                                          }
                                        },
                                      )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(child: TextField(
                                        textAlign: TextAlign.center,
                                        controller: emailotp2,
                                        keyboardType: TextInputType.number,
                                        maxLength: 1,
                                        cursorColor: PrimaryColor,
                                        cursorHeight: 20,
                                        decoration: InputDecoration(
                                          hintText: "-",
                                          counterText: '',
                                          hintStyle: TextStyle(color: Colors.black, fontSize: 20.0),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),),
                                              borderRadius: BorderRadius.circular(2)
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),width: 2),
                                            borderRadius: BorderRadius.circular(3),

                                          ),

                                        ),
                                        onChanged: (value){
                                          if(value.length == 1){
                                            FocusScope.of(context).nextFocus();
                                          }
                                          else if(value.length == 0){
                                            FocusScope.of(context).previousFocus();
                                          }
                                        },
                                      )),
                                      SizedBox(width: 10),
                                      Expanded(child: TextField(
                                        textAlign: TextAlign.center,
                                        controller: emailotp3,
                                        keyboardType: TextInputType.number,
                                        maxLength: 1,
                                        cursorColor: PrimaryColor,
                                        cursorHeight: 20,
                                        decoration: InputDecoration(
                                          hintText: "-",
                                          counterText: '',
                                          hintStyle: TextStyle(color: Colors.black, fontSize: 20.0),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),),
                                              borderRadius: BorderRadius.circular(2)
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),width: 2),
                                            borderRadius: BorderRadius.circular(3),

                                          ),

                                        ),
                                        onChanged: (value){
                                          if(value.length == 1){
                                            FocusScope.of(context).nextFocus();
                                          }
                                          else if(value.length == 0){
                                            FocusScope.of(context).previousFocus();
                                          }
                                        },
                                      )),
                                      SizedBox(width: 10),
                                      Expanded(child: TextField(
                                        textAlign: TextAlign.center,
                                        controller: emailotp4,
                                        keyboardType: TextInputType.number,
                                        maxLength: 1,
                                        cursorColor: PrimaryColor,
                                        cursorHeight: 20,
                                        decoration: InputDecoration(
                                          hintText: "-",
                                          counterText: '',
                                          hintStyle: TextStyle(color: Colors.black, fontSize: 20.0),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),),
                                              borderRadius: BorderRadius.circular(2)
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),width: 2),
                                            borderRadius: BorderRadius.circular(3),

                                          ),

                                        ),
                                        onChanged: (value){
                                          if(value.length == 1){
                                            FocusScope.of(context).nextFocus();
                                          }
                                          else if(value.length == 0){
                                            FocusScope.of(context).previousFocus();
                                          }
                                        },
                                      )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                )
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 15),
                                  child: TextButtons(
                                    buttonText: getTranslated(context, 'Resend OTP'),
                                    textButtonText: "",
                                    onPressed: () {

                                      verifyusers();
                                    },
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Container(
                    child: MainButton(
                        color: SecondaryColor,
                        btnText: "VERIFY OTP",
                        onPressed: () {

                          String emailotp = emailotp1.text+emailotp2.text+emailotp3.text+emailotp4.text;
                          String mobileottp = emailotp5.text+emailotp6.text+emailotp7.text+emailotp8.text;

                          verifyotp(mobileottp, emailotp);
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            )
          ]),
        ),
      ),

    ),
        onWillPop: _onbackpress);
  }


  void _listenotp() async {

    await SmsAutoFill().listenForCode;
  }
}
