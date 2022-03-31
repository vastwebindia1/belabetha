import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/dthRechargePage.dart';

import '../../../../../../dashboard.dart';


class Aepsactiveservice extends StatefulWidget {
  const Aepsactiveservice({Key key}) : super(key: key);

  @override
  _AepsactiveserviceState createState() => _AepsactiveserviceState();
}

class _AepsactiveserviceState extends State<Aepsactiveservice> {

  bool _isloading = false;
  bool _validate = false;
  bool otplay = true;

  TextEditingController otpcontroller = TextEditingController();

  Future<void> sendotpp() async {

    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/MICROATM/api/data/ActiveMicroATM");
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


    } else {
      throw Exception('Failed');
    }
  }

  Future<void> sumitotp(String otp) async {

    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/AEPS/api/data/EnterOtp",{
      "otp":otp
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

      setState(() {
        _isloading = false;
      });

      var data = json.decode(response.body);
      var status = data["Response"];
      var msz = data["Message"];

      if(status == "Success"){

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: msz,
          title: status.toString(),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => Dashboard()));
          },
        );


      }else{

        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(msz + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);

      }


    } else {
      throw Exception('Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBarWidget(
      title: CenterAppbarTitle(
        svgImage: 'assets/pngImages/BBPS.png',
        topText:getTranslated(context, 'Aeps'),
        selectedItemName: "Service Active",
      ),
      body: Container(
        child: SingleChildScrollView(
          child: SafeArea(
              child: Visibility(
                visible: otplay,
                child: Column(
                  children: [

                    SizedBox(height: 10,),

                    Center(
                        child:Text("Your AEPS Service Not Active !",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: SecondaryColor),)
                    ),
                    SizedBox(height: 10,),
                    Container(
                      margin: EdgeInsets.only(left: 10,right: 10),
                      child: Text("Your service is currently down, if you want to keep the service running smoothly, you will have to pay the service fee, which you see below and you can purchase the service by clicking the button.",style: TextStyle(fontSize: 16),textAlign: TextAlign.justify,),
                    ),
                    SizedBox(height: 10,),
                    MainButtonSecodn(

                        onPressed:() async{


                          setState(() {
                            otplay = false;
                          });

                          sendotpp();

                        },
                        color: SecondaryColor,
                        btnText:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: _isloading ? Center(child: SizedBox(
                                  height: 20,
                                  child: LinearProgressIndicator(backgroundColor: PrimaryColor,valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
                                ),) : Text("ACTIVE NOW",textAlign: TextAlign.center,style: TextStyle(color: TextColor),)
                            ),
                          ],
                        )
                    ),
                  ],
                ),
                replacement: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text("Please Enter Your OTP",style: TextStyle(color: SecondaryColor,fontSize: 18,fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: InputTextField(
                        label: "Enter OTP Number",
                        errorText:  _validate ? '' : null,
                        controller: otpcontroller,

                        maxLength: 7,
                        obscureText: false,
                        keyBordType: TextInputType.number,
                        labelStyle: TextStyle(
                          color: PrimaryColor,
                        ),
                        borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                        onChange: (String val){

                        },
                      ),
                    ),
                    MainButtonSecodn(

                        onPressed:() async{
                          int otp = otpcontroller.text.length;

                          if(otpcontroller == "" || otp < 4){

                            setState(() {
                              _validate = true;
                            });

                            final snackBar3 = SnackBar(
                              backgroundColor: Colors.red[900],
                              content: Text("Please Enter Valid OTP" + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(snackBar3);


                          }else{

                            setState(() {
                              _validate = false;
                              _isloading = true;
                            });

                            sumitotp(otpcontroller.text);
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
                                ),) : Text(getTranslated(context, 'Submit Otp'),textAlign: TextAlign.center,style: TextStyle(color: TextColor),)
                            ),
                          ],
                        )
                    ),

                  ],
                ),
              )
          ),
        ),
      ),
    );
  }
}
