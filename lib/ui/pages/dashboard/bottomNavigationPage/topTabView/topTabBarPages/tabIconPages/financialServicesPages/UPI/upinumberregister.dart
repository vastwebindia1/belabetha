import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/IntroSliderPages/AppSignUpButton.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/homeTopPages/paymentOptions.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/BroadbandPage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/dmtPages/moneyTransfer.dart';
import 'package:myapp/ui/pages/login/otpPage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../dashboard.dart';

class Upinumberregister extends StatefulWidget {
  const Upinumberregister({Key key}) : super(key: key);

  @override
  _UpinumberregisterState createState() => _UpinumberregisterState();
}

class _UpinumberregisterState extends State<Upinumberregister> {

  bool remitterOtp = false;
  bool remitterName = false;
  bool _isloading = false;
  bool remitterNameBox = true;
  String sendnum = "";
  var id;

  void getnum()async{
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      sendnum = prefs.getString("sendnum");
    });

  }

  Future<void> sendotp(String num, String name) async {


    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var uri = new Uri.http("api.vastwebindia.com", "/Money/api/Money/RegisterMobileForIMPS", {
      "Mobile": num,
      "Name": name,
      "surname": "tte",
      "pincode": "123456",

    });
    final http.Response response = await http.post(
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
      var addinfo = data["ADDINFO"];
      var status = addinfo["statuscode"];
      var msz = addinfo["status"];
      id = addinfo["data"]["remitter"]["id"];



      if(status == "TXN"){


      }else{


        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: msz.toUpperCase(),
          title: getTranslated(context, 'Warning'),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.red,
          onConfirmBtnTap: (){
            Navigator.of(context).pop();
          },
        );

      }




    } else {


      throw Exception('Failed to load data from internet');
    }
  }

  Future<void> verifyotp(String num, String otp, String id) async {


    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var uri = new Uri.http("api.vastwebindia.com", "/Money/api/Money/VerifiyOTP_ToAddNewMobile", {
      "Mobile": num,
      "OTP": otp,
      "RequestId": "",
      "remitterid": id,
      "beneficiaryid": "",
      "Action": "add",

    });
    final http.Response response = await http.post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 12), onTimeout: (){

      setState(() {
        _isloading = false;
      });
    });

    print(response);

    if (response.statusCode == 200) {

      _isloading = false;
      var data = json.decode(response.body);
      var result = data["RESULT"];



      if(result == 0){

        var status = data["ADDINFO"]["statuscode"];

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: "Register Successfully!!",
          title: getTranslated(context, 'Success'),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => MoneyTransferPage(),
                transitionDuration: Duration(seconds: 0),
              ),
            );
          },
        );

      }else{

        var msz = data["ADDINFO"];

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: msz.toUpperCase(),
          title: getTranslated(context, 'Warning'),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.red,
          onConfirmBtnTap: (){
            Navigator.of(context).pop();
          },
        );

      }




    } else {


      throw Exception('Failed to load data from internet');
    }
  }



  TextEditingController remname = TextEditingController();

  TextEditingController ot1 = TextEditingController();
  TextEditingController ot2 = TextEditingController();
  TextEditingController ot3 = TextEditingController();
  TextEditingController ot4 = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getnum();
  }

  @override
  Widget build(BuildContext context) {

    TextStyle style = TextStyle(color: TextColor, fontSize: 16);
    TextStyle labelStyle = TextStyle(
      color: PrimaryColor,
      fontSize: 14,
    );
    Color color = PrimaryColor;

    return Material(
      child: Container(
        child:Container(
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 20),
                    color: PrimaryColor.withOpacity(0.8),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Center(
                            child: SizedBox(
                              height: 60,
                              width: 60,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: TextColor,
                                ),
                                child: Icon(
                                  Icons.person_add_alt_1,
                                  size: 40,
                                  color: SecondaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Center(
                              child: Text(
                                getTranslated(context, 'Register New Remitter'),
                                style: TextStyle(fontSize: 16,color: TextColor),
                              )),
                        ),

                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 10,right: 10,top: 15),
                          padding: EdgeInsets.only(top: 8,bottom: 0,right: 10,left: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1,color: PrimaryColor),
                            borderRadius: BorderRadius.circular(5),
                            color: TextColor.withOpacity(0.8),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(bottom: 2),
                                      child: Icon(Icons.check_circle,color: SecondaryColor,size: 14,)),
                                  Text(getTranslated(context, 'Remitter Mobile Number'),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 12,color: PrimaryColor),),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(sendnum,textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                        color: PrimaryColor
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          maintainSize: false,
                          visible: remitterName,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(left: 10,right: 10,top: 15),
                            padding: EdgeInsets.only(top: 8,bottom: 0,right: 10,left: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: TextColor.withOpacity(0.8),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(bottom: 2),
                                        child: Icon(Icons.check_circle,color:SecondaryColor,size: 14,)),
                                    Flexible(
                                      child: Text(getTranslated(context, 'Remitter Name'),
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 12,color: PrimaryColor),),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(remname.text,textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 35,
                                            fontWeight: FontWeight.bold,
                                            color: PrimaryColor
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    maintainSize: false,
                    visible: remitterNameBox,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 10,right: 10,top: 12),
                          child: Text(getTranslated(context, 'Enter Remitter Name')),
                        ),
                        Container(
                          clipBehavior: Clip.none,
                          margin: EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  maxLength: 22,
                                  buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
                                  textCapitalization: TextCapitalization.words,
                                  controller:remname ,
                                  decoration: InputDecoration(
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(width: 1, color: color),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(width: 1, color: color),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(width: 1, color: color),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide:
                                      BorderSide(width: 1, color: color),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    contentPadding: EdgeInsets.only(
                                        left: 10,
                                        right: 16,
                                        top: 14.5,
                                        bottom: 14.5),
                                    hintText: getTranslated(context, 'Enter Remitter Name'),
                                    labelStyle: labelStyle,
                                    fillColor:TextColor,
                                    hintStyle: labelStyle,
                                    suffixIcon: Container(
                                      margin: EdgeInsets.only(right: 3,top: 3,bottom: 3),
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 1, color: SecondaryColor),
                                        borderRadius: BorderRadius.circular(2),
                                        color: SecondaryColor,
                                      ),
                                      child: TextButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.zero,
                                                side: BorderSide(
                                                    width: 0,
                                                    color: Colors.transparent)),
                                          ),
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.zero),
                                        ),
                                        child: Text(
                                          getTranslated(context, 'Next'),
                                          style: TextStyle(color: TextColor),
                                        ),
                                        onPressed: (){
                                          if(remname.text.isNotEmpty){

                                            FocusScopeNode focus = FocusScope.of(context);
                                            focus.unfocus();
                                            setState(() {
                                              remitterOtp=true;
                                              remitterName = true;
                                            });
                                            sendotp(sendnum,remname.text);
                                          }
                                          remitterNameBox = false;
                                        },
                                      ),
                                    ),
                                  ),
                                  style: TextStyle(
                                    color: PrimaryColor,
                                    fontSize: 18,
                                  ),
                                  onChanged: (value){
                                    remname.text;
                                    if(value.isEmpty){
                                      setState(() {
                                        remitterOtp = false;
                                        remitterName = false;
                                      });
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

                  Visibility(
                    visible: remitterOtp,
                    maintainSize: false,
                    child: Container(
                      margin: EdgeInsets.only(top: 20),
                      height: 50,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: TextField(
                                inputFormatters: [ FilteringTextInputFormatter.allow(RegExp("[0-9]")),],
                                textAlign: TextAlign.center,
                                controller: ot1,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                cursorColor: PrimaryColor,
                                cursorHeight: 20,
                                decoration: InputDecoration(
                                  hintText: "-",
                                  counterText: '',
                                  hintStyle: TextStyle(color: PrimaryColor, fontSize: 20.0),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: PrimaryColor),
                                      borderRadius: BorderRadius.circular(2)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: PrimaryColor,width: 1),
                                    borderRadius: BorderRadius.circular(3),

                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: PrimaryColor,width: 1),
                                    borderRadius: BorderRadius.circular(3),
                                  ),

                                ),
                                style: TextStyle(color: PrimaryColor),
                                onChanged: (value){
                                  if(value.length == 1){
                                    FocusScope.of(context).nextFocus();
                                  }
                                  else if(value.length == 0){
                                    FocusScope.of(context).previousFocus();
                                  }
                                },
                              )
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(child: TextField(
                            inputFormatters: [ FilteringTextInputFormatter.allow(RegExp("[0-9]")),],
                            textAlign: TextAlign.center,
                            controller: ot2,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            cursorColor: PrimaryColor,
                            cursorHeight: 20,
                            decoration: InputDecoration(
                              hintText: "-",
                              counterText: '',
                              hintStyle: TextStyle(color: PrimaryColor, fontSize: 20.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: PrimaryColor),
                                  borderRadius: BorderRadius.circular(2)
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: PrimaryColor,width: 1),
                                borderRadius: BorderRadius.circular(3),

                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: PrimaryColor,width: 1),
                                borderRadius: BorderRadius.circular(3),
                              ),

                            ),
                            style: TextStyle(color: PrimaryColor),
                            onChanged: (value){
                              if(value.length == 1){
                                FocusScope.of(context).nextFocus();
                              }
                              else if(value.length == 0){
                                FocusScope.of(context).previousFocus();
                              }
                            },
                          ),),
                          SizedBox(width: 15),
                          Expanded(child: TextField(
                            inputFormatters: [ FilteringTextInputFormatter.allow(RegExp("[0-9]")),],
                            textAlign: TextAlign.center,
                            controller: ot3,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            cursorColor: PrimaryColor,
                            cursorHeight: 20,
                            decoration: InputDecoration(
                              hintText: "-",
                              counterText: '',
                              hintStyle: TextStyle(color: PrimaryColor, fontSize: 20.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: PrimaryColor),
                                  borderRadius: BorderRadius.circular(2)
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: PrimaryColor,width: 1),
                                borderRadius: BorderRadius.circular(3),

                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: PrimaryColor,width: 1),
                                borderRadius: BorderRadius.circular(3),
                              ),

                            ),
                            style: TextStyle(color: PrimaryColor),
                            onChanged: (value){
                              if(value.length == 1){
                                FocusScope.of(context).nextFocus();
                              }
                              else if(value.length == 0){
                                FocusScope.of(context).previousFocus();
                              }
                            },
                          ),),
                          SizedBox(width: 15),
                          Expanded(child: TextField(
                            inputFormatters: [ FilteringTextInputFormatter.allow(RegExp("[0-9]")),],
                            textAlign: TextAlign.center,
                            controller: ot4,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            cursorColor: PrimaryColor,
                            cursorHeight: 20,
                            decoration: InputDecoration(
                              hintText: "-",
                              counterText: '',
                              hintStyle: TextStyle(color: PrimaryColor, fontSize: 20.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: PrimaryColor),
                                  borderRadius: BorderRadius.circular(2)
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: PrimaryColor,width: 1),
                                borderRadius: BorderRadius.circular(3),

                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: PrimaryColor,width: 1),
                                borderRadius: BorderRadius.circular(3),
                              ),

                            ),
                            style: TextStyle(color: PrimaryColor),
                            onChanged: (value){
                              if(value.length == 1){
                                FocusScope.of(context).nextFocus();
                              }
                              else if(value.length == 0){
                                FocusScope.of(context).previousFocus();
                              }
                            },
                          ),),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                  ),

                  Visibility(
                    visible: remitterOtp,
                    child: Container(
                      child: MainButtonSecodn(
                        color: SecondaryColor,
                        btnText: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: _isloading ? Center(child: SizedBox(
                                  height: 20,
                                  child: LinearProgressIndicator(backgroundColor: PrimaryColor,valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
                                ),) : Text(getTranslated(context, 'Submit'),textAlign: TextAlign.center,style: TextStyle(color: TextColor),)
                            ),
                          ],
                        ),
                        onPressed: (){

                          setState(() {
                            _isloading = true;
                          });
                          String otp = ot1.text+ot2.text+ot3.text+ot4.text;
                          verifyotp(sendnum, otp, id);

                        },
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Visibility(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              child: BackButtons(
                                btnText: getTranslated(context, 'back'),
                              )
                          ),
                          Visibility(
                            visible: remitterOtp,
                            child: Container(
                              margin: EdgeInsets.only(left: 15),
                              child: TextButtons(
                                buttonText: getTranslated(context, 'Resend OTP'),
                                textButtonText: "",
                                onPressed: () {},
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


