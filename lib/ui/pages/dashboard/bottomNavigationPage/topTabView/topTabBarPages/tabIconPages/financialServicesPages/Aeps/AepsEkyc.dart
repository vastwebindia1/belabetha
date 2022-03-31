import 'dart:convert';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/dthRechargePage.dart';

import '../../../../../../dashboard.dart';
import 'AepsEkycScan.dart';


class Aepsekyc extends StatefulWidget {
  const Aepsekyc({Key key}) : super(key: key);

  @override
  _AepsekycState createState() => _AepsekycState();
}

class _AepsekycState extends State<Aepsekyc> {
  bool _validate = false;
  bool _isloading = false;
  bool otplayot = true;
  Position _currentPosition;
  String lat,long,androidid,primkeyid,encodeFPTxnId;
  TextEditingController otpcontroller = TextEditingController();

  Future<void> kycotpsend(String late, String long, String deviceid) async {

    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/AEPS/api/data/Ekycsendotp");
    Map map = {
      "latitude": late,
      "longitude": long,
      "ImeiNo": deviceid,

    };

    String body = json.encode(map);

    http.Response response = await http.post(
      url,
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      },
      body: body,
    );
    print(response);

    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      var status = dataa["Status"];
      var addinfo = dataa["Message"];
      primkeyid = dataa["primaryKeyId"].toString();
      encodeFPTxnId = dataa["encodeFPTxnId"].toString();

      if(status == true){

        setState(() {
          otplayot = false;
        });





      }else{


        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(addinfo + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);
      }



    } else {

      setState(() {
        _isloading = false;
      });
      throw Exception('Failed');
    }
  }

  Future<void> verifyotp(String late, String long, String deviceid, String otp, String prikey, String encodeFPTxnId) async {

    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/AEPS/api/data/EkycVerifyOtp");
    Map map = {
      "latitude": late,
      "longitude": long,
      "ImeiNo": deviceid,
      "otp": otp,
      "primaryKeyId": prikey,
      "encodeFPTxnId": encodeFPTxnId,
    };


    String body = json.encode(map);

    http.Response response = await http.post(
      url,
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      },
      body: body,
    );
    print(response);

    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      var status = dataa["Status"];
      var addinfo = dataa["Message"];


      if(status == true){


        Navigator.push(context, MaterialPageRoute(builder: (context) => Aepsekycscan()));


      }else{


        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(addinfo + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);
      }



    } else {

      setState(() {
        _isloading = false;
      });
      throw Exception('Failed');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return AppBarWidget(
      title: CenterAppbarTitleImage(
        svgImage: 'assets/pngImages/Aeps.png',
        topText:getTranslated(context, 'Aeps'),
        selectedItemName: "E-Kyc",
      ),
      body: Container(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Visibility(
              visible: otplayot,
              child: Column(
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Icon(Icons.cancel,size: 40,),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Center(
                    child: Text("E-KYC is Not Completed",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: SecondaryColor),),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10,right: 10),
                    child: Column(
                      children: [
                        Text("1 Dear Customer Your E - KYC is Not Completed. So Firstly Complete Your E - KYC.",style: TextStyle(fontSize: 14,),textAlign: TextAlign.justify,),
                        SizedBox(
                          height: 10,
                        ),
                        Text("2 For Complete Your E - KYC please Click to 'Ok' Button, after click you receive an otp  on Your Register Mobile Number",style: TextStyle(fontSize: 14),textAlign: TextAlign.justify,),
                        SizedBox(
                          height: 10,
                        ),
                        Text("3 Plese firstly Connect Your Mobile with Finger Print Scanner Device (Morpho , Mantra , Startek).",style: TextStyle(fontSize: 14),textAlign: TextAlign.justify,)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10,right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 150,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.all(15),
                              backgroundColor:PrimaryColor ,
                              shadowColor:Colors.transparent,

                            ),
                            onPressed:(){

                              Navigator.of(context).pop();

                            },
                            child: Text(getTranslated(context, 'Cancle'),style: TextStyle(color: TextColor),),
                          ),
                        ),
                        Container(
                          width: 150,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.all(15),
                              backgroundColor:SecondaryColor ,
                              shadowColor:Colors.transparent,

                            ),
                            onPressed:()async{

                              DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                              AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;

                              androidid = androidDeviceInfo.androidId;

                              kycotpsend(lat,long,androidid);

                            },
                            child: Text("KYC NOW",style: TextStyle(color: TextColor),),
                          ),
                        ),
                      ],
                    ),
                  )
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
                          });

                          verifyotp(lat,long,androidid,otpcontroller.text,primkeyid,encodeFPTxnId);

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
      });


    } catch (e) {
      print(e);
    }
  }
}
