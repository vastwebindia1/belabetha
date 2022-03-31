import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/IntroSliderPages/AppSignUpButton.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:http/http.dart' as http;

import 'login.dart';

class LoginPagetoOtp extends StatefulWidget {
  const LoginPagetoOtp({Key key}) : super(key: key);

  @override
  _LoginPagetoOtpState createState() => _LoginPagetoOtpState();
}

class _LoginPagetoOtpState extends State<LoginPagetoOtp> {

  Future<void> verifyotp(String mobileotp, String emailotp) async {


    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/Common/api/data/VeryfyUserEmailOTP", {
      "hdmobileotp": mobileotp,
      "hdemailotp	": emailotp,
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
      _isloading = false;
      var dataa = json.decode(response.body);
      var status = dataa["Status"];
      var msz = dataa["msg"];



      if(status == "Success"){

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: msz,
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));},

        );


      }else{


        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: msz,
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
      var dataa = json.decode(response.body);
      var status = dataa["status"];


    } else {
      throw Exception('Failed');
    }


  }

  TextEditingController mobileee = TextEditingController();

  TextEditingController emailotp1 = TextEditingController();
  TextEditingController emailotp2 = TextEditingController();
  TextEditingController emailotp3 = TextEditingController();
  TextEditingController emailotp4 = TextEditingController();

  String mobileotp;

  bool _isloading = false;
  String mobileottp;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listenotp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              height: MediaQuery.of(context).size.width * .30,
              decoration: BoxDecoration(color: PrimaryColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Note:- ",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.red),),
                            Text(
                              "Mobile OTP Auto Receive from Message Inbox.\n Registered Mobile SIM must be required in the slot",
                              style: TextStyle(
                                  height: 1.5,
                                  color: SecondaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12),
                            ),

                          ],
                        ),
                        Text(
                          'Email OTP received on your Registered Email Id.',
                          style: TextStyle(
                              height: 1.5,
                              color: TextColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Card(
                      elevation: 5,
                      semanticContainer: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 5, right: 5, top: 8, bottom: 8),
                        child: Column(
                          children: [
                            Container(
                              child: Center(
                                child: Text(
                                  "Mobile OTP Auto Receive from Message Inbox",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Center(
                                child: Text(
                                  "Mobile SIM must be required in the slot.",
                                  style: TextStyle(
                                      fontSize: 14, color: SecondaryColor),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 10, right: 10,),
                              child:PinFieldAutoFill(
                                codeLength: 4,
                                decoration: UnderlineDecoration(
                                  textStyle: TextStyle(fontSize: 20, color: Colors.black),
                                  colorBuilder: FixedColorBuilder(PrimaryColor.withOpacity(0.4)),
                                  bgColorBuilder: FixedColorBuilder(PrimaryColor.withOpacity(0.1)),

                                ),

                                onCodeChanged: (code) {
                                  if (code.length == 4) {
                                    setState(() {
                                      mobileottp = code;
                                    });
                                    FocusScope.of(context).requestFocus(FocusNode());
                                  }

                                },
                              ),
                              /*Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: OTPWidget(

                                  )),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: OTPWidget(

                                  )),
                                  SizedBox(width: 10),
                                  Expanded(
                                      child: OTPWidget(

                                  )),
                                  SizedBox(width: 10),
                                  Expanded(
                                      child: OTPWidget(

                                  )),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),*/
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
                    padding: EdgeInsets.all(5),
                    child: Card(
                      elevation: 5,
                      semanticContainer: false,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 5, right: 5, top: 8, bottom: 8),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                Expanded(
                                    child: Center(
                                      child: Text(
                                        "Email OTP received on your Registered Email Id.",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
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
                    )
                  ),

                  Container(
                    child: MainButtonSecodn(
                        color: SecondaryColor,
                        onPressed: () {


                          setState(() {
                            _isloading = true;
                          });
                          String emailotp = emailotp1.text+emailotp2.text+emailotp3.text+emailotp4.text;

                          verifyotp(mobileottp, emailotp);
                        },
                    btnText: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: _isloading ? Center(child: SizedBox(
                              height: 20,
                              child: LinearProgressIndicator(backgroundColor: PrimaryColor,valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
                            ),) :
                            Text("Verify OTP",style: TextStyle(color: TextColor),textAlign: TextAlign.center,)
                        )
                      ],
                    )
                    ),
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
    );
  }

  void _listenotp() async {

    await SmsAutoFill().listenForCode;
  }
}

class OTPWidget extends StatefulWidget {
  const OTPWidget({Key key}) : super(key: key);

  @override
  _OTPWidgetState createState() => _OTPWidgetState();
}

class _OTPWidgetState extends State<OTPWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
            child: TextEditorForPhoneVerify()
        )
    );
  }
}
class TextEditorForPhoneVerify extends StatelessWidget {


  TextEditorForPhoneVerify();

  @override
  Widget build(BuildContext context) {
    return TextField(
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
    );
  }
}