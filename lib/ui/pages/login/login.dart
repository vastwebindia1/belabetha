import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myapp/CommanWidget/app_logo.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/CommanWidget/otpPage.dart';
import 'package:myapp/CommanWidget/passcodePage.dart';
import 'package:myapp/IntroSliderPages/AppSignUpButton.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/data/localSecureStorage/flutterStorageHelper.dart';
import 'package:myapp/networkConfig/ApiBaseHelper.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/DealerMainPage.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:myapp/ui/pages/dashboard/masterPage/masterMainPage.dart';
import 'package:myapp/ui/pages/locations/IpHelper.dart';
import 'package:myapp/ui/pages/login/OtpTest.dart';
import 'package:myapp/ui/pages/login/join.dart';
import 'package:myapp/ui/pages/login/videoKyc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:device_info/device_info.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String netname, ipadd, modelname, androidid, lat, long, city, address, postcode;
  var role;

  String passType;

  // ignore: unused_element, non_constant_identifier_names

  Future<void> OTPCheck(String email, String pass) async {
    String token = "";

    var uri = new Uri.http("api.vastwebindia.com", "/api/Account/getOtp",
        {"userid": email, "pwd": pass});
    final http.Response response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      // ignore: missing_return
    ).timeout(Duration(seconds: 30), onTimeout: (){
      setState(() {
        _isloading = false;

      });
      // ignore: unnecessary_statements
      SnackBar;
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

    });

    print(response);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      String status = data["status"].toString();
      String message = data["Message"].toString();

      if (status == "FAILED") {
        if (message == "2FA is disabled") {
          _executeLogin(email, pass, context);
        } else {
          setState(() {
            _isloading = false;

          });


          ScaffoldMessenger.of(context).showSnackBar(wrongpass);
          /*showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomDialog(
                  buttonText:getTranslated(context, 'ok'),
                  color: Colors.red,
                  description: message.toUpperCase(),
                  title: getTranslated(context, 'Warning'),
                  icon: Icons.cancel,
                  onpress: (){ Navigator.of(context).pop();},
                );


              });*/
        }
      } else if(status == "SUCCESS"){

        _isloading = false;
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => VerifyPhone(
          email: email,pass: pass,)));
      }else{


        setState(() {
          _isloading = false;

        });

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: message.toUpperCase(),
          title: getTranslated(context, 'Warning'),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.red,
          onConfirmBtnTap: (){
            Navigator.of(context).pop();},
        );
      }


    } else {
      throw Exception('Service Failed');
    }
  }

  Future<void> _executeLogin(String username, String password, BuildContext ctx) async {


    Map body = {
      'UserName': username,
      'Password': password,
      'grant_type': 'password'
    };
    try {
      final Map response = await ApiBaseHelper().post('/token', {}, body);
      var flutterStorage = FlutterStorageHelper();
      flutterStorage.addNewItem('accessToken', response['access_token']);
      flutterStorage.addNewItem('userId', response['userId']);
      flutterStorage.addNewItem('role', response['role']);
      flutterStorage.addNewItem('tokendate', response['.expires']);


      authtask();
    } catch (e) {
      print(e);
      _isloading = false;

      CoolAlert.show(
        backgroundColor: PrimaryColor.withOpacity(0.6),
        context: context,
        type: CoolAlertType.error,
        text: "Service Error",
        title: getTranslated(context, 'Warning'),
        confirmBtnText: 'OK',
        confirmBtnColor: Colors.red,
        onConfirmBtnTap: (){
          Navigator.of(context).pop();},
      );
    }
  }

  Future<void> authtask() async {
    final storage = new FlutterSecureStorage();
    final prefs = await SharedPreferences.getInstance();
    var token = await storage.read(key: "accessToken");
    role = await storage.read(key: "role");

    try{

      var uri =
      new Uri.http("api.vastwebindia.com", "/Common/api/data/authenticate", {
        "Devicetoken": "fcmtoken",
        "ImeiNo": androidid,
        "Latitude": lat,
        "Longitude": long,
        "ModelNo": modelname,
        "IPAddress": ipadd,
        "Address": address,
        "City": city,
        "PostalCode": postcode,
        "InternetTYPE":netname
      });
      final http.Response response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // ignore: missing_return
      ).timeout(Duration(seconds: 30), onTimeout: (){
        setState(() {
          _isloading = false;
        });
        SnackBar;
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

      });

      print(response);

      if (response.statusCode == 200) {
        _isloading = false;
        var data = json.decode(response.body);
        String status = data["status"].toString();

        if (status == "SUCCESS") {

          var message = data["message"]["Status"];
          var loginsts = data["message"]["APPLOGINSTATUS"];
          passType = data["message"]["BOXTYPE"];
          var verifymailmob = data["message"]["VEREmailPhone"].toString();


          if(loginsts == "Y"){

            if(message == "BOXOPEN"){

              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => VerifyPassCode(typePasscode: passType,)));


            }

            if (message == "BOXNOTOPEN") {
              _isloading = false;

              if(role == "Retailer"){

                /*_firebaseMessaging.subscribeToTopic("vastweb-retailer").then((value) => Text("value"));*/

                if(verifymailmob == "true"){

                  verifyusers();

                }else{

                  var kycvideostatus = data["message"]["VIDEOKYC"];
                  var referalcode = data["message"]["SELFREFFERALCODE"];
                  prefs.setString('referlcode', referalcode);
                  prefs.setString('kyvvideostatus', kycvideostatus);

                  if(kycvideostatus =="VideoKYCNOTDONE"){

                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VideoKyc()));

                  } else {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Dashboard()));
                  }
                }

              }else if (role == "Dealer"){

                /*_firebaseMessaging.subscribeToTopic("vastweb-dealer").then((value) => Text("value"));*/

                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => DealermaninDashboard()));
              }else{

                /*_firebaseMessaging.subscribeToTopic("vastweb-master").then((value) => Text("value"));*/

                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => MasterManinDashboard()));

              }

            } else {

            }

          }else{

            final storage = new FlutterSecureStorage();
            storage.deleteAll();

            setState(() {
              _isloading = false;

            });


            CoolAlert.show(
              backgroundColor: PrimaryColor.withOpacity(0.6),
              context: context,
              type: CoolAlertType.error,
              text: "Please Check Your Login Status From Admin",
              title: getTranslated(context, 'Warning'),
              confirmBtnText: 'OK',
              confirmBtnColor: Colors.red,
              onConfirmBtnTap: (){
                Navigator.of(context).pop();},
            );
          }


        } else {

          authtask2();

        }
      } else {
        _isloading = false;
        throw Exception('Failed');
      }


    }catch(e){

      final storage = new FlutterSecureStorage();
      storage.deleteAll();
    }

  }

  Future<void> authtask2() async {
    final storage = new FlutterSecureStorage();
    final prefs = await SharedPreferences.getInstance();
    var token = await storage.read(key: "accessToken");
    role = await storage.read(key: "role");


    try{

      var uri =
      new Uri.http("api.vastwebindia.com", "/Common/api/data/authenticate", {
        "Devicetoken": "fcmtoken",
        "ImeiNo": androidid,
        "Latitude": "1234",
        "Longitude": "1234",
        "ModelNo": modelname,
        "IPAddress": ipadd,
        "Address": "Address",
        "City": "City",
        "PostalCode": "123456",
        "InternetTYPE":netname
      });
      final http.Response response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // ignore: missing_return
      ).timeout(Duration(seconds: 30), onTimeout: (){
        setState(() {
          _isloading = false;

        });
        // ignore: unnecessary_statements
        SnackBar;
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

      }).timeout(Duration(seconds: 15), onTimeout: (){
        setState(() {

          final snackBar2 = SnackBar(
            backgroundColor: Colors.greenAccent,
            content: Text(getTranslated(context, 'Data Not Found'),style: TextStyle(color: Colors.black),textAlign: TextAlign.center),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar2);

        });
      });

      print(response);

      if (response.statusCode == 200) {
        _isloading = false;
        var data = json.decode(response.body);
        String status = data["status"].toString();


        if (status == "SUCCESS") {


          var message = data["message"]["Status"];
          var loginsts = data["message"]["APPLOGINSTATUS"];
          passType = data["message"]["BOXTYPE"];
          var verifymailmob = data["message"]["VEREmailPhone"].toString();


          if(loginsts == "Y"){

            if(message == "BOXOPEN"){

              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => VerifyPassCode(typePasscode: passType,)));


            }

            if (message == "BOXNOTOPEN") {
              _isloading = false;

              if(role == "Retailer"){

                /*_firebaseMessaging.subscribeToTopic("vastweb-retailer").then((value) => Text("value"));*/

                if(verifymailmob == "true"){

                  verifyusers();

                }else{

                  var kycvideostatus = data["message"]["VIDEOKYC"];
                  var referalcode = data["message"]["SELFREFFERALCODE"];
                  prefs.setString('referlcode', referalcode);
                  prefs.setString('kyvvideostatus', kycvideostatus);

                  if(kycvideostatus =="VideoKYCNOTDONE"){

                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VideoKyc()));

                  } else if(kycvideostatus == "VideoKYCPENDING"){

                    CoolAlert.show(
                      backgroundColor: PrimaryColor.withOpacity(0.6),
                      context: context,
                      type: CoolAlertType.warning,
                      text: "Your Video Kyc is Pending. Contact to Admin.",
                      title: "Pending",
                      confirmBtnText: 'OK',
                      confirmBtnColor: Colors.yellow[700],
                      onConfirmBtnTap: (){
                        setState(() {
                          _isloading = false;
                        });
                        final storage = new FlutterSecureStorage();
                        storage.deleteAll();
                        Navigator.of(context).pop();

                      },
                    );


                  }else {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Dashboard()));
                  }


                }



              }else if (role == "Dealer"){

               /* _firebaseMessaging.subscribeToTopic("vastweb-dealer").then((value) => Text("value"));*/

                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => DealermaninDashboard()));
              }else{

               /* _firebaseMessaging.subscribeToTopic("vastweb-master").then((value) => Text("value"));*/

                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => MasterManinDashboard()));

              }

            } else {

            }

          }else{

            final storage = new FlutterSecureStorage();
            storage.deleteAll();

            setState(() {
              _isloading = false;

            });


            CoolAlert.show(
              backgroundColor: PrimaryColor.withOpacity(0.6),
              context: context,
              type: CoolAlertType.error,
              text: "Contact to Admin. Please Check login status.",
              title: getTranslated(context, 'Warning'),
              confirmBtnText: 'OK',
              confirmBtnColor: Colors.red,
              onConfirmBtnTap: (){
                Navigator.of(context).pop();},
            );
          }


        } else {

          String message = data["message"];
          final storage = new FlutterSecureStorage();
          storage.deleteAll();

          setState(() {
            _isloading = false;

          });


          CoolAlert.show(
            backgroundColor: PrimaryColor.withOpacity(0.6),
            context: context,
            type: CoolAlertType.error,
            text: message.toUpperCase(),
            title: getTranslated(context, 'Warning'),
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

      final storage = new FlutterSecureStorage();
      storage.deleteAll();
    }

  }


  Future<void> verifyusers() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http(
        "api.vastwebindia.com", "/Common/api/data/VeryFY_Profiles_users");
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

      setState(() {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => OTPTEST()));
      });
    } else {
      throw Exception('Failed');
    }
  }

  bool showvalue = false;
  bool _obscureText = true;
  bool _obscureText2 = false;
  bool _isloading = false;
  bool _isloading2 = false;
  bool _isVisible = false;
  String savelogin = "true";
  Position _currentPosition;
  String _currentAddress = "";
  var chek = "";
  var fcmtoken;

  void showToast() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }
  // ignore: unused_field
  String _password;
  SharedPreferences logindata;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  final snackBar = SnackBar(
    backgroundColor: Colors.red[900],
    content: Text('Connection Problem!! Please try Again',style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center,),
  );

  final wrongpass = SnackBar(
    backgroundColor: Colors.red[900],
    content: Text('Invalid User Id or Password !!!',style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
  );

  DateTime backbuttonpressedTime;

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

  TextEditingController inputController = TextEditingController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void rremember()async{

   /* _firebaseMessaging.getToken().then((token){
      fcmtoken = token;
      print("token - $fcmtoken");

      _firebaseMessaging.subscribeToTopic("vastweb").then((value) => Text("value"));
    });
*/


    final prefs = await SharedPreferences.getInstance();
    String eml = prefs.getString("emailidd");
    String pss = prefs.getString("passwordd");
    String remval = prefs.getString("remem");

    setState(() {
      nameController.text = eml;
      passwordController.text =pss;
    });

    if(remval == "true"){

      setState(() {
        showvalue = true;
      });
    }else{

      setState(() {
        showvalue = false;
      });

    }

    prefs.setString('emailidd', "");
    prefs.setString('passwordd', "");



  }

  void forgotPassworddialoge(){
    showDialog(
        barrierDismissible: false,
        context: context,
        useSafeArea: true,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setStatee){
            return Container(
              color: Colors.black.withOpacity(0.8),
              child: AlertDialog(
                  buttonPadding: EdgeInsets.all(0),
                  titlePadding: EdgeInsets.all(0),
                  contentPadding: EdgeInsets.only(left: 5,right: 5),
                  title: Container(
                    child: Column(
                      children:  [
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
                                  child: Text(getTranslated(context, 'Forgot Password'),
                                    style: TextStyle(color: TextColor,fontSize: 20),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                CloseButton(
                                  color: TextColor,
                                ),
                              ],
                            ),

                          ),
                        ),
                      ],
                    ),
                  ),
                  content: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 10,),
                          InputTextField(
                            controller: inputController,
                            hint: getTranslated(context, 'Enter EmailMobile No'),
                            label: getTranslated(context, 'Enter EmailMobile No'),
                            obscureText: false,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              alignment: Alignment.centerRight,
                              width: 120,
                              child: MainButtonSecodn(
                                  onPressed:() async{
                                    setState(() {
                                      _isloading = true;
                                      forgotPassword(inputController.text);
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  color: SecondaryColor,
                                  btnText:Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                          child: _isloading2 ? Center(child: Container(
                                            height: 10,
                                            width: 40,
                                            child: LinearProgressIndicator(backgroundColor: PrimaryColor,valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
                                          ),) : Text(getTranslated(context, 'Submit'),textAlign: TextAlign.center,style: TextStyle(color: TextColor),overflow: TextOverflow.ellipsis,maxLines: 1,)
                                      ),
                                    ],
                                  )
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
              ),
            );
          });
        });

  }

  Timer timer;

  Future<void> getlocationcall ()async{
    await getCurrentLocation();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getlocationcall();
   /* _firebaseMessaging.unsubscribeFromTopic("vastweb-retailer").then((value) => Text("value"));
    _firebaseMessaging.unsubscribeFromTopic("vastweb-dealer").then((value) => Text("value"));
    _firebaseMessaging.unsubscribeFromTopic("vastweb-master").then((value) => Text("value"));
    _firebaseMessaging.unsubscribeFromTopic("vastweb").then((value) => Text("value"));*/
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) => getCurrentLocation());
    rremember();
  }

  Future<void>forgotPassword(String email) async {

    var url = new Uri.http("api.vastwebindia.com", "/api/Account/ForgotPassword");
    Map map = {
      "Email":email,
    };
    String body = json.encode(map);

    final http.Response response = await http.post(
      url,
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
      },
      body: body,
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

      setState(() {
        _isloading = false;
      });
      var dataa = json.decode(response.body);
      var status3 = dataa["Response"];
      var msz3 = dataa["Message"];

      if (status3 == "Success") {


        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: getTranslated(context, 'Forgot SuccessFully'),
          title: getTranslated(context, 'Success'),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));},

        );

      } else {

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: msz3,
          title: getTranslated(context, 'Failed'),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.red,
          onConfirmBtnTap: (){
            Navigator.of(context).pop();},
        );
      }

    } else {
      throw Exception('Failed to load themes');
    }


  }

  final snackBar2 = SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Double Click to exit app',textAlign: TextAlign.center,style: TextStyle(color: Colors.yellowAccent),),
      ],
    ),
  );
  bool _validate = false;
  bool _validate1 = false;
  final _formKey = GlobalKey<FormState>();
  @override

  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _onbackpress,
      child: Scaffold(
        backgroundColor: TextColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.width * .40,
                  decoration: BoxDecoration(color: PrimaryColor),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        child: AppLogo(),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 250,
                              child: Text(
                                "Aasha Digital India",
                                style: TextStyle(
                                    height: 1.5,
                                    color: TextColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(height: 3,),
                            Container(
                              width: 250,
                              child: Text(
                                getTranslated(context, 'notshareidpass'),
                                style: TextStyle(
                                    color:SecondaryColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 11),
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  child: Form(
                      autovalidateMode: AutovalidateMode.always, key: _formKey,
                      child: Column(
                        children: [
                          Container(
                              child: InputTextField(
                                controller: nameController,
                                label: getTranslated(context, 'useremailmobile'),
                                labelStyle: TextStyle(
                                  color:PrimaryColor,),
                                borderSide: BorderSide(width: 2,),
                                obscureText: _obscureText2,
                                errorText:  _validate ? '' : null,
                                onChange: (String val){

                                },
                              )
                          ),
                          Container(
                            child: InputTextField(
                              controller: passwordController,
                              label:getTranslated(context, 'Password'),
                              labelStyle:TextStyle(
                                color: PrimaryColor,),
                              borderSide: BorderSide(width: 2,color: PrimaryColor),
                              errorText:  _validate1 ? '' : null,
                              onChange: (String val){

                              },
                              iButton: IconButton(
                                  onPressed: () {
                                    _toggle();
                                  },
                                  icon: Icon(_obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,color:_obscureText ? PrimaryColor: SecondaryColor,)),
                              suffixStyle: const TextStyle(color: SecondaryColor),
                              onSaved: (val) => _password = val,
                              obscureText: _obscureText,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: ()async{
                                  final prefs = await SharedPreferences.getInstance();

                                  if(showvalue == true){

                                    setState(() {
                                      showvalue = false;
                                      prefs.setString('emailidd', "");
                                      prefs.setString('passwordd', "");
                                    });
                                  }else{

                                    setState(() {
                                      showvalue = true;
                                      prefs.setString('emailidd', nameController.text);
                                      prefs.setString('passwordd', passwordController.text);
                                    });
                                  }
                                },
                                child: Row(
                                  children: [
                                    Checkbox(
                                      visualDensity:VisualDensity(horizontal: 0),
                                      activeColor: SecondaryColor,
                                      value: this.showvalue,
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      onChanged: (bool value) async {
                                        setState(() {
                                          this.showvalue = value;
                                        });
                                      },
                                    ),
                                    Container(
                                      width: 130,
                                      child: Text(getTranslated(context, 'Remember Password'),style: TextStyle(
                                          color: SecondaryColor,
                                          fontSize: 14,
                                      ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10,right: 10),
                                child: TextButton(
                                  clipBehavior: Clip.none,
                                  autofocus: true,
                                  onPressed:forgotPassworddialoge,
                                  child: Container(
                                    width: 140,
                                    child: Text(
                                        getTranslated(context, 'Forgot Password'),
                                        style: TextStyle(
                                          color: SecondaryColor,
                                          fontSize: 16,
                                        ),
                                        overflow: TextOverflow.ellipsis

                                    ),
                                  ),
                                  style:TextButton.styleFrom(
                                    padding: EdgeInsets.all(0),
                                    primary: Colors.white,
                                    backgroundColor: Colors.transparent,
                                  ),
                                )
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                    height: 50,
                                    margin: EdgeInsets.only(left: 10, right: 10),
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        padding: EdgeInsets.all(0),
                                        backgroundColor: SecondaryColor,
                                        shadowColor: Colors.transparent,
                                      ),
                                      onPressed:nameController.text == null ? (){}: () async {

                                        if(nameController.text == "" || nameController.text == "0") {
                                          setState(() {
                                            _validate = true;
                                          });
                                        }else{
                                          setState(() {
                                            _validate = false;
                                          });
                                        }
                                        if(passwordController.text == "" || passwordController.text == "0") {
                                          setState(() {
                                            _validate1 = true;
                                          });
                                        }else{
                                          setState(() {
                                            _validate1 = false;
                                          });
                                        }
                                        if (_formKey.currentState.validate()) {

                                          setState(() {
                                            _isloading = true;
                                          });

                                          _getAddressFromLatLng();

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

                                          String remmmva = showvalue.toString();

                                          setState(() {
                                            if(remmmva == "true"){

                                              prefs.setString('emailidd', nameController.text);
                                              prefs.setString('passwordd', passwordController.text);
                                              prefs.setString('remem', remmmva);

                                            }else{
                                              setState(() {
                                                prefs.setString('remem', remmmva);
                                              });
                                            }
                                          });

                                          OTPCheck(nameController.text, passwordController.text);
                                        }

                                      },
                                      child: _isloading ? Center(child: SizedBox(
                                           height: 20,
                                           child: LinearProgressIndicator(backgroundColor: PrimaryColor,valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
                                      ),) :Text(getTranslated(context, 'Login'),
                                           style: TextStyle(
                                            color: TextColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          )),
                                    )
                                ),
                              ),
                            ],
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 10,right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  BackButton(
                                    onPressed: (){
                                      Navigator.of(context).pop(true);
                                    },
                                    color: SecondaryColor,
                                  ),
                                  TextButtons(
                                    onPressed:(){
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => JoinPage()));
                                    },
                                    buttonText: getTranslated(context, 'Sign Up'),
                                    textButtonText:getTranslated(context, 'notaccount'),
                                    textButtonStyle: TextStyle(
                                      color: PrimaryColor,
                                      fontSize: 14,
                                    ),)
                                ],
                              )),
                        ],
                      )),
                ),

              ],
            ),
          ),
        ),
      ), );

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
