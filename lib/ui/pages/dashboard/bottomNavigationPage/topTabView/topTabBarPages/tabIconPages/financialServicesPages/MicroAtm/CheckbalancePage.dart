import 'dart:convert';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/locations/IpHelper.dart';
import 'package:myapp/ui/pages/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../../../../../../dashboard.dart';
import 'MicroatmmainPage.dart';
import 'cashatposmainpage.dart';

class CheckbalancePage extends StatefulWidget {
  const CheckbalancePage({Key key}) : super(key: key);

  @override
  _CheckbalancePageState createState() => _CheckbalancePageState();
}

class _CheckbalancePageState extends State<CheckbalancePage> {

  bool _validate = false;
  bool _isloading = false;
  var trnsidd = "";
  var loginid = "";
  var password = "";
  bool isnewlog;
  bool ismicroatm = true;
  bool ispurchase = false;
  bool chkbalance = false;
  TextEditingController amount = TextEditingController();
  String netname, ipadd, modelname, androidid, lat, long, city, address, postcode,status,_message;
  Position _currentPosition;
  String _currentAddress = "";
  String resss = "hh";

  Future<void> vm30activiation() async {

    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/MICROATM/api/data/ApiPassword");
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
      var isvalid = data["IsValidCustomer"];
      isnewlog = data["IsNewLogin"];
      loginid = data["LoginId"];
      password = data["Password"];


      setState(() {
        isnewlog;
      });


    } else {
      throw Exception('Failed');
    }
  }

  static const platform = const MethodChannel('com.aasha/credoPay');
  String _responseFromNativeCode = 'Waiting for Response...';

  Future<Null> checkbalance(bool isChangedPassword) async {

    try {
      final result = await platform.invokeMethod('payAmount', {'isChangePassword' : isChangedPassword,'loginid' : loginid,'password' : password,'newlogin' : isnewlog,'amount' : amount.text,'uniqid' : trnsidd,'ispurchase' : ispurchase,'ismicroatm' : ismicroatm,'chkblnce' : chkbalance});

      print(result);

      setState(() {
        resss = result.toString();
      });


    } on PlatformException catch (e) {
      _message = "Can't do native stuff ${e.message}.";
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    vm30activiation();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: TextColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 15,bottom: 15,),
                  decoration: BoxDecoration(
                    color:PrimaryColor.withOpacity(0.9),),
                  child:Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: TextColor,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(100),
                                  ),
                                  color: TextColor
                              ),
                              child: Image.asset('assets/pngImages/Check-Bal.png',width: 50,),
                            ),
                            SizedBox(height: 5,),
                            Text(getTranslated(context, 'Micro ATM Check Balance'),style: TextStyle(color: TextColor,fontSize: 18,),)
                          ],
                        ),
                      ),
                      Positioned(
                        left: 10,
                        top: 10,
                        child:Container(
                          margin: EdgeInsets.only(top: 0),
                          child: IconButton(
                            onPressed:(){
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation1, animation2) => Dashboard(),
                                  transitionDuration: Duration(seconds: 0),
                                ),);
                            },
                            icon: Icon(Icons.arrow_back,color: SecondaryColor,),

                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  child: Text(getTranslated(context, '1matm'),textAlign: TextAlign.justify,),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  child: Text(getTranslated(context, '2matm'),textAlign: TextAlign.justify,),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.all(15),
                            backgroundColor:SecondaryColor ,
                            shadowColor:Colors.transparent,),
                          onPressed:()async{

                            setState(() {
                              chkbalance = true;
                            });
                            checkbalance(false);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: _isloading ? Center(child: SizedBox(
                                    height: 20,
                                    child: LinearProgressIndicator(backgroundColor: PrimaryColor,valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
                                  ),) : Text(getTranslated(context, 'Check Balance'),textAlign: TextAlign.center,style: TextStyle(color: TextColor),)
                              ),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 150,
                      margin: EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(getTranslated(context, 'trmode'),style: TextStyle(color:SecondaryColor,fontSize: 14,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: (){

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CashatposPage()));

                          },
                          child: Container(
                            width: 100,
                              margin: EdgeInsets.only(right: 1),
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  border: Border.all(
                                      color: SecondaryColor
                                  ),
                                  color: TextColor
                              ),
                              child: Text(getTranslated(context, 'cashposh'),style: TextStyle(color: PrimaryColor,fontSize: 12),overflow: TextOverflow.ellipsis,)
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: (){

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MatmMainPage()));
                          },
                          child: Container(
                            width: 80,
                              margin: EdgeInsets.only(right: 10),
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  border: Border.all(
                                      color: SecondaryColor
                                  ),
                                  color: TextColor
                              ),
                              child: Text(getTranslated(context, 'Withdraw'),style: TextStyle(color: PrimaryColor,fontSize: 12),overflow: TextOverflow.ellipsis,)
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }




}
