import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/DealerMainPage.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:http/http.dart'as http;

class PinForget extends StatefulWidget {
  const PinForget({Key key}) : super(key: key);

  @override
  _PinForgetState createState() => _PinForgetState();
}

class _PinForgetState extends State<PinForget> {


  TextEditingController emailController = TextEditingController();



  String userroll = "";


  Future<void> userRoll() async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "role");

    String rollUser = a;
    setState(() {
      userroll = rollUser;

    });
  }


  Future<void> trsactionPinForgot(String email1) async {


    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var uri = new Uri.http("api.vastwebindia.com", "/Retailer/api/data/Reset_TransPinFromRetailer", {
      "txtemail": email1,



    });
    final http.Response response = await http.post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 15), onTimeout: (){
      setState(() {
        _isloading = false;

      });
    });

    print(response);

    if (response.statusCode == 200) {

      _isloading = false;

      var data1 = json.decode(response.body);
      var status = data1["Response"];
      var msz = data1["Message"];

      if (status == "success") {

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
      } else {

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: msz,
          title: status,
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.red,
          onConfirmBtnTap: (){
            setState(() {
              _isloading = false;
            });
            Navigator.of(context).pop();
          },
        );
      }
    }

    else {
      _isloading = false;


      throw Exception('Failed to load data from internet');
    }
  }


  Future<void> dealerTrsactionPinForgot(String email1) async {


    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var uri = new Uri.http("api.vastwebindia.com", "/api/data/Reset_TransPinFromdealer", {
      "txtemail": email1,


    });
    final http.Response response = await http.post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 15), onTimeout: (){
      setState(() {
        _isloading = false;

      });
    });

    print(response);


    if (response.statusCode == 200) {

      _isloading = false;

      var data1 = json.decode(response.body);
      var status = data1["Response"];
      var msz = data1["Message"];

      if (status == "success") {

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.success,
          text: msz,
          title: status,
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DealermaninDashboard()));
          },
        );
      } else {

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: msz,
          title: status,
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.red,
          onConfirmBtnTap: (){
            setState(() {
              _isloading = false;
            });
            Navigator.of(context).pop();
          },
        );
      }
    }

    else {
      _isloading = false;


      throw Exception('Failed to load data from internet');
    }
  }


  bool _isloading = false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userRoll();

  }


  @override
  Widget build(BuildContext context) {
    return Container(

      padding: EdgeInsets.only(top: 1,bottom: 15,right: 1,left: 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: PrimaryColor.withOpacity(0.2 ),
      ),

      child: Container(
        child: Container(
          child: Column(
            children: [
              Container(
                child: Form(
                  child: Column(
                    children: [
                      InputTextField(
                        controller: emailController,
                        label: getTranslated(context, 'Enter Email Id'),
                        obscureText: false,
                        labelStyle: TextStyle(
                          color: PrimaryColor,
                        ),
                        borderSide: BorderSide(width: 2, style: BorderStyle.solid),

                        onChange: (String value) {
                        },


                      ),



                      MainButtonSecodn(
                          onPressed: () {

                            _isloading = true;


                            if(userroll == "Dealer"){

                              dealerTrsactionPinForgot(emailController.text);
                            }else{

                              trsactionPinForgot(emailController.text);

                            }






                          },
                          color: SecondaryColor,
                          btnText:Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: _isloading ? Center(child: SizedBox(
                                    height: 20,
                                    child: LinearProgressIndicator(backgroundColor: PrimaryColor,valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
                                  ),) : Text(getTranslated(context, 'Submit'),textAlign: TextAlign.center,style: TextStyle(color: TextColor),)
                              ),
                            ],
                          )
                      ),

                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
