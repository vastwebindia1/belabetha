import 'dart:convert';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/CommanWidget/numeric_pad.dart';
import 'package:myapp/CommanWidget/passcodePage.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/data/localSecureStorage/flutterStorageHelper.dart';
import 'package:myapp/networkConfig/ApiBaseHelper.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/DealerMainPage.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:myapp/ui/pages/dashboard/masterPage/masterMainPage.dart';
import 'package:myapp/ui/pages/locations/IpHelper.dart';
import 'package:myapp/ui/pages/login/login.dart';
import 'package:myapp/ui/pages/login/videoKyc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class VerifyPhone extends StatefulWidget {
  final String email;
  final String pass;

  const VerifyPhone({Key key, this.email, this.pass}) : super(key: key);

  @override
  _VerifyPhoneState createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {

  String code = "";
  bool _isloading = false;
  String netname,ipadd,modelname,androidid;
  String passType;

  String role;
  Position _currentPosition;
  String lat,long,city,address,postcode;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }

  Future<void> _executeLogin(String otp) async {
    Map body = {
      'UserName': widget.email,
      'Password': widget.pass,
      'grant_type': 'password',
      'X-OTP':otp
    };
    try {
      final Map response = await ApiBaseHelper().post('/token', {}, body);
      var flutterStorage = FlutterStorageHelper();
      flutterStorage.addNewItem('accessToken', response['access_token']);
      flutterStorage.addNewItem('userId', response['userId']);
      flutterStorage.addNewItem('role', response['role']);
      authtask();

    } catch (e) {


      print(e);

      setState(() {
        _isloading = false;

      });

      CoolAlert.show(
        backgroundColor: PrimaryColor.withOpacity(0.6),
        context: context,
        type: CoolAlertType.error,
        text: "Invalid OTP",
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
    var token = await storage.read(key: "accessToken");
    role = await storage.read(key: "role");



    try{


      var uri =
      new Uri.http("api.vastwebindia.com", "/Common/api/data/authenticate", {
        "Devicetoken": "testing",
        "ImeiNo": androidid,
        "Latitude": "1234",
        "Longitude": "1234",
        "ModelNo": modelname,
        "IPAddress": ipadd,
        "Address": "null",
        "City": "null",
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

          if(loginsts == "Y"){

            if(message == "BOXOPEN"){

              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VerifyPassCode(typePasscode: passType,)));


            }

            if (message == "BOXNOTOPEN") {
              _isloading = false;

              if(role == "Retailer"){

                var kycvideostatus = data["message"]["VIDEOKYC"];

                if(kycvideostatus =="VideoKYCNOTDONE"){

                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VideoKyc()));

                } else {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Dashboard()));
                }

              }else if (role == "Dealer"){

                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => DealermaninDashboard()));
              }else{

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
              text: loginsts==null ?getTranslated(context, 'Something Went Wrong'):loginsts,
              title: getTranslated(context, 'Warning'),
              confirmBtnText: 'OK',
              confirmBtnColor: Colors.red,
              onConfirmBtnTap: (){
                Navigator.of(context).pop();},
            );
          }


        }else {

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

      setState(() {
        _isloading = false;

      });

      final storage = new FlutterSecureStorage();
      storage.deleteAll();
    }

  }

  // ignore: non_constant_identifier_names
  Future<void> OTPCheck() async {
    String token = "";

    var uri = new Uri.http("api.vastwebindia.com", "/api/Account/getOtp",
        {"userid": widget.email, "pwd": widget.pass});
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


    } else {
      throw Exception('Service Failed');
    }
  }

  final snackBar = SnackBar(
    content: Text('Connection Problem!! Please try Again',style: TextStyle(color: Colors.yellowAccent),),
  );

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
    bool backButton = backbuttonpressedTime == null || currentTime.difference(backbuttonpressedTime) > Duration(seconds: 3);

    if (backButton) {
      backbuttonpressedTime = currentTime;
      // ignore: unnecessary_statements
      SnackBar;ScaffoldMessenger.of(context).showSnackBar(snackBar2);
      return Future.value(false);
    }
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        child: Scaffold(
        appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: IconButton(
            icon: Icon(Icons.arrow_back,color: Colors.black),
            onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
            },
          ),
        ),
        title: Text("Verify OTP", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black,),),
        backgroundColor: TextColor,
        elevation: 0,
        centerTitle: true,
        textTheme: Theme.of(context).textTheme,),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

              Expanded(
                child: Container(
                  color: TextColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Text(
                          "OTP is sent to Your Number ",
                          style: TextStyle(
                            fontSize: 22,
                            color: Color(0xFF818181),
                          ),
                        ),
                      ),

                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            buildCodeNumberBox(code.length > 0 ? code.substring(0, 1) : ""),
                            buildCodeNumberBox(code.length > 1 ? code.substring(1, 2) : ""),
                            buildCodeNumberBox(code.length > 2 ? code.substring(2, 3) : ""),
                            buildCodeNumberBox(code.length > 3 ? code.substring(3, 4) : ""),
                            buildCodeNumberBox(code.length > 4 ? code.substring(4, 5) : ""),
                            buildCodeNumberBox(code.length > 5 ? code.substring(5, 6) : ""),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Didn't recieve code?",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF818181),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            GestureDetector(
                              onTap: () {
                                OTPCheck();
                              },
                              child: Text(
                                "Resend",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 5, right: 5),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.all(15),
                              backgroundColor: SecondaryColor,
                              shadowColor: Colors.transparent,
                            ),
                            onPressed: () async{

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

                              _executeLogin(code);

                            },
                            child: _isloading
                                ? Center(child: SizedBox(height: 20,
                              child: LinearProgressIndicator(backgroundColor: PrimaryColor,valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
                            ),)
                                :Text("Verify OTP",
                                style: TextStyle(
                                  color: TextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                )),
                          )
                      ),
                    ],
                  ),
                ),
              ),

              NumericPad(
                onNumberSelected: (value) {
                  print(value);
                  setState(() {
                    if(value != -1){
                      if(code.length < 6){
                        code = code + value.toString();
                      }
                    }
                    else{
                      code = code.substring(0, code.length - 1);
                    }
                    print(code);
                  });
                },
              ),

            ],
          )
      ),
    ),
        onWillPop: _onbackpress);
  }

  Widget buildCodeNumberBox(String codeNumber) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: SizedBox(
        width: 40,
        height: 40,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFF6F5FA),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 25.0,
                  spreadRadius: 1,
                  offset: Offset(0.0, 0.75)
              )
            ],
          ),
          child: Center(
            child: Text(
              codeNumber,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F1F1F),
              ),
            ),
          ),
        ),
      ),
    );
  }

  getCurrentLocation() {
    Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium)
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