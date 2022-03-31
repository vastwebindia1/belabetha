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
import 'package:myapp/ui/pages/login/join.dart';
import 'package:http/http.dart'as http;


class PinChange extends StatefulWidget {
  const PinChange({Key key}) : super(key: key);

  @override
  _PinChangeState createState() => _PinChangeState();
}

bool _isloading = false;

class _PinChangeState extends State<PinChange> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Container(
            child: ChangePin()
        )
      ],
    );
  }
}




class ChangePin extends StatefulWidget {
  const ChangePin({Key key}) : super(key: key);

  @override
  _ChangePinState createState() => _ChangePinState();
}

class _ChangePinState extends State<ChangePin> {


  bool _validate = false;

  TextEditingController oldPin = TextEditingController();
  TextEditingController newPin = TextEditingController();
  TextEditingController confirmPin = TextEditingController();


  String userroll = "";


  Future<void> userRoll() async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "role");

    String rollUser = a;
    setState(() {
      userroll = rollUser;



    });
  }



  Future<void> trsactionPinChange(String oldPin1 ,String newPin1) async {


    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var uri = new Uri.http("api.vastwebindia.com", "/Retailer/api/data/changepin", {
      "OldPIN": oldPin1,
      "NewPIN": newPin1,



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
      var msz = data1["Message"];
      var status = data1["status"];

      if (status == "Success") {
        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: msz,
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));},

        );
      } else {

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: msz,
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.red,
          onConfirmBtnTap: (){
            setState(() {
              _isloading = false;
            });
            Navigator.of(context).pop();},
        );
      }
    }


    else {
      _isloading = false;


      throw Exception('Failed to load data from internet');
    }
  }


  Future<void> dealerTrsactionPinChange(String oldPin1 ,String newPin1) async {


    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var uri = new Uri.http("api.vastwebindia.com", "/api/data/Transectionpinchange", {
      "oldpin": oldPin1,
      "newpin": newPin1,



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
      var msz = data1["Message"];
      var status = data1["status"];

      if (status == "Success") {

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: msz,
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DealermaninDashboard()));},

        );
      } else {
        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: msz,
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.red,
          onConfirmBtnTap: (){
            setState(() {
              _isloading = false;
            });
            Navigator.of(context).pop();},
        );
      }
    }


    else {
      _isloading = false;


      throw Exception('Failed to load data from internet');
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    userRoll();

  }




  bool test = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 1,bottom: 10,right: 1,left: 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: PrimaryColor.withOpacity(0.2),
      ),

      child: Container(
        child: Column(
          children: [
            Container(
              child: Form(
                child: Column(
                  children: [
                    InputTextField(

                      controller: oldPin,
                      label: getTranslated(context, 'Old Pin'),
                      obscureText: false,
                      labelStyle: TextStyle(
                        color: PrimaryColor,
                      ),
                      borderSide: BorderSide(width: 2, style: BorderStyle.solid),

                      onChange: (String value) {
                      },


                    ),
                    InputTextField(
                      controller: newPin,
                      label:getTranslated(context, 'New Pin'),
                      obscureText: false,
                      errorText: _validate  ? "false": null,
                      labelStyle: TextStyle(
                        color: PrimaryColor,
                      ),
                      borderSide: BorderSide(width: 2, style: BorderStyle.solid),

                      onChange: (String value) {
                        setState(() {
                          if(newPin.text != confirmPin.text){
                            setState(() {
                              _validate = true;
                            });
                          }
                          else{
                            setState(() {
                              _validate=false;
                            });


                          }
                        });


                      },


                    ),
                    InputTextField(
                      controller: confirmPin,
                      label: getTranslated(context, 'Confirm Pin'),
                      errorText: _validate  ? "false": null,
                      obscureText: false,
                      labelStyle: TextStyle(
                        color: PrimaryColor,
                      ),
                      borderSide: BorderSide(width: 2, style: BorderStyle.solid),

                      onChange: (String value) {
                        setState(() {
                          if(confirmPin.text != newPin.text){
                            setState(() {
                              _validate = true;
                              test = false;
                            });
                          }
                          else{
                            setState(() {
                              _validate=false;
                              test = true;
                            });


                          }
                        });


                      },


                    ),

                    MainButtonSecodn(
                        onPressed:test ? () {

                          _isloading = true;

                          if(userroll == "Dealer"){

                            dealerTrsactionPinChange(oldPin.text,confirmPin.text);



                          }else{


                            trsactionPinChange(oldPin.text,confirmPin.text);

                          }

                        }:null,
                        color: test ? SecondaryColor : SecondaryColor.withOpacity(0.8),
                        btnText:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: _isloading ? Center(child: SizedBox(
                                  height: 20,
                                  child: LinearProgressIndicator(backgroundColor: PrimaryColor,valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
                                ),) :
                                Text(getTranslated(context, 'Submit'),textAlign: TextAlign.center,style: TextStyle(color: TextColor),)
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
    );
  }
}
