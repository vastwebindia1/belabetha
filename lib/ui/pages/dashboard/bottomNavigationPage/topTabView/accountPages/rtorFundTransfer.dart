import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_auth/local_auth.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/Account.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/dthRechargePage.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:myapp/ui/pages/locations/IpHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:http/http.dart'as http;



class RToRFund extends StatefulWidget {
  const RToRFund({Key key}) : super(key: key);

  @override
  _RToRFundState createState() => _RToRFundState();
}

class _RToRFundState extends State<RToRFund> {

  TextEditingController mobileController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController reAmountController = TextEditingController();
  TextEditingController commentController = TextEditingController();


  String modelname,androidid,lat,long,city,address,postcode,netname,ipadd;
  String deviceToken = "token";
  Position _currentPosition;
  bool btnclick = false;
  bool _isloading = false;
  bool _validate = false;

  String retailerFirm = "";
  String retailerEmail = "";
  String retailerMobile = "";
  String retailerName = "";

  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(localizedReason: 'Scan your fingerprint (or face or whatever) to authenticate',
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      }
      );
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = "Error - ${e.message}";

        setState(() {
          _validate = false;
          _isloading = true;
          btnclick = false;
        });

        retailerFundEncription(mobileController.text,commentController.text,
            ipadd,deviceToken,lat,long,androidid,city,postcode,netname,address);


      });
      return;
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';

    if(message == "Authorized"){

      setState(() {
        _validate = false;
        _isloading = true;
        btnclick = false;
      });

      retailerFundEncription(mobileController.text,commentController.text,
          ipadd,deviceToken,lat,long,androidid,city,postcode,netname,address);

    }
    setState(() {
      _authorized = message;
    });
  }

  Future<void> rtorFundTransfer(String retailer2, String amount1,String comment2,String ip2,
      String device2,String latitude2,String longitude2,String model2,String city2,String postal2,
      String internet2,String address2,String key1,String vii1) async {


    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var uri = new Uri.http("api.vastwebindia.com", "/Retailer/api/data/rem_rem_fund_transfer", {
      "RetailerId":retailer2,
      "txtbal": amount1,
      "comment": comment2,
      "IP": ip2,
      "Devicetoken": device2,
      "Latitude": latitude2,
      "Longitude": longitude2,
      "ModelNo": model2,
      "City": city2,
      "PostalCode": postal2,
      "InternetTYPE": internet2,
      "Addresss": address2,
      "value1": key1,
      "value2": vii1,


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
        btnclick = true;
        _isloading = false;
      });


      var data1 = json.decode(response.body);
      var status = data1["Response"];
      var msz = data1["Message"];

      if (status == "Success") {

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

  Future<void> retailerInformation(String retailer) async {


    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var uri = new Uri.http("api.vastwebindia.com", "/Retailer/api/data/rem_rem_Information", {
      "rememail":retailer,


    });
    final http.Response response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 15), onTimeout: (){
      setState(() {

        _isloading = false;

        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(getTranslated(context, 'Data Not Found'),style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);

      });
    });

    print(response);

    if (response.statusCode == 200) {
      var data1 = json.decode(response.body);
      var status = data1["sts"];
      var msz = data1["data"];

      if(status == "Success") {

        setState(() {

          retailerFirm  =  msz["Frm_Name"];
          retailerEmail = msz["Email"];
          retailerMobile = msz["Mobile"];
          retailerName = msz["RetailerName"];
          retailerDetailsdialog();

        });

      }


    }
    else {

      throw Exception('Failed to load data from internet');
    }
  }

  void retailerDetailsdialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(5),
            ),
            alignment: Alignment.topLeft,
            child: AlertDialog(

              insetPadding: EdgeInsets.only(bottom: 0),
              buttonPadding: EdgeInsets.all(0),
              titlePadding: EdgeInsets.all(0),
              contentPadding: EdgeInsets.only(left: 10, right: 10),
              title: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: PrimaryColor,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5))
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(
                                top: 5, bottom: 5, left: 10, right: 10),
                            child: Text(
                              getTranslated(context, 'Retailer Info'),
                              style:
                              TextStyle(color: TextColor, fontSize: 18),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            Icons.clear,
                            color: TextColor,
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),


              content: Container(
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getTranslated(context, 'Retailer Name') +": ",
                          style: TextStyle(fontSize: 14,),
                        ),
                        Container(
                          child: Expanded(
                            child: Text(retailerName == null ? "" :retailerName,
                              style: TextStyle(color: SecondaryColor,fontSize: 14,fontWeight: FontWeight.bold),
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        Text(
                          getTranslated(context, getTranslated(context, 'Firm Name')) +": ",
                          style: TextStyle(fontSize: 14,),
                        ),
                        Expanded(
                          child: Text(retailerFirm == null ? "" : retailerFirm,
                            style: TextStyle(color: SecondaryColor,fontSize: 14,fontWeight: FontWeight.bold),
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        Text(
                          getTranslated(context, 'Mobile No') +": ",
                          style: TextStyle(fontSize: 14,),
                        ),
                        Expanded(
                          child: Text(retailerMobile == null ? "" : retailerMobile,
                            style: TextStyle(color: SecondaryColor,fontSize: 14,fontWeight: FontWeight.bold),
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        Text(
                          getTranslated(context, 'Email Id') +": ",
                          style: TextStyle(fontSize: 14,),
                        ),
                        Expanded(
                          child: Text(retailerEmail == null ? "" : retailerEmail,
                            style: TextStyle(color: SecondaryColor,fontSize: 14,fontWeight: FontWeight.bold),
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            ),
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }


  @override
  Widget build(BuildContext context) {

    setState(() {
      getCurrentLocation;
    });
    return SimpleAppBarWidget(
      title: CenterAppbarTitle(
        svgImage: 'assets/pngImages/BBPS.png',
        topText: getTranslated(context, 'Selected Info'),
        selectedItemName: getTranslated(context, 'RToR Fund Transfer'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10.0),
                ),
              ),
              child: InputTextField(
                obscureText: false,
                controller: mobileController,
                label: getTranslated(context, 'Enter Retailer ID'),
                onChange: (String val) {

                  if(val.length == 10) {

                    retailerInformation(mobileController.text);


                  }else{


                    retailerInformation(mobileController.text);


                  }

                 },
                labelStyle: TextStyle(color: PrimaryColor),
              ),
            ),

            Container(
              child:InputTextField(
                keyBordType: TextInputType.number,
                controller: amountController,
                label: getTranslated(context, 'Enter Amount'),
                obscureText: false,
                labelStyle: TextStyle(
                  color: PrimaryColor,
                ),
                borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                onChange: (String value) {

                },
              ),

            ),
            Container(
              child:InputTextField(
                keyBordType: TextInputType.number,
                controller: reAmountController,
                label: getTranslated(context, 'Re-Enter Amount'),
                errorText:  _validate ? '' : null,
                obscureText: false,
                labelStyle: TextStyle(
                  color: PrimaryColor,
                ),
                borderSide: BorderSide(width: 2, style: BorderStyle.solid),

                onChange: (String val){

                  String enteramnt = amountController.text;
                  String reenteramntt = reAmountController.text;

                  if(enteramnt == reenteramntt){

                    setState(() {
                      btnclick =true;
                      _validate = false;
                    });
                  }else{

                    setState(() {
                      _validate = true;
                    });

                  }

                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "null";
                  }
                  return null;
                },

              ),

            ),
            Container(
              child:InputTextField(
                controller: commentController,
                label: getTranslated(context, 'Comments'),
                obscureText: false,
                labelStyle: TextStyle(
                  color: PrimaryColor,
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "null";
                  }
                  return null;
                },

                borderSide: BorderSide(width: 2, style: BorderStyle.solid),

              ),

            ),


            MainButtonSecodn(
                onPressed:btnclick == false ? null : () async {
                  String enteramnt = amountController.text;
                  String reenteramntt = reAmountController.text;

                  if (enteramnt == reenteramntt) {


                    final prefs = await SharedPreferences.getInstance();
                    var dd = IpHelper().getCurrentLocation();
                    var hu = IpHelper().getconnectivity();
                    var hdddu = IpHelper().getLocalIpAddress();
                    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;

                    modelname = androidDeviceInfo.model;
                    androidid = androidDeviceInfo.androidId;
                    netname = prefs.getString('conntype');
                    ipadd = prefs.getString('ipaddress');

                    if(_currentPosition == null){

                      setState(() {
                        lat = "null";
                        long = "null";
                        city = "null";
                        address = "null";
                        postcode = "null";
                      });

                    }

                    setState(() {
                      _validate = false;
                      _isloading = true;
                      btnclick = false;
                    });

                    retailerFundEncription(mobileController.text,commentController.text,
                        ipadd,deviceToken,lat,long,androidid,city,postcode,netname,address);


                  } else {
                    setState(() {
                      _validate = true;
                    });
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
                        ),) :
                        Text(getTranslated(context, 'Fund Transfer'),style: TextStyle(color: TextColor),textAlign: TextAlign.center,)
                    )
                  ],
                )
            ),


          ],


        ),



      ),
    );
  }

  void retailerFundEncription(String retailer, String comment,String ip, String device,
      String latitude,String longitude,String model,String city,String postal,
      String internet,String address) async{


    var uuid = Uuid();
    var keyst = uuid.v1().substring(0,16);
    var ivstr = uuid.v4().substring(0,16);

    String keySTR = keyst.toString(); //16 byte
    String ivSTR =  ivstr.toString(); //16 byte

    String keyencoded = base64.encode(utf8.encode(keySTR));
    String viencoded = base64.encode(utf8.encode(ivSTR));


    final key = encrypt.Key.fromUtf8(keySTR);
    final iv = encrypt.IV.fromUtf8(ivSTR);

    final encrypter = encrypt.Encrypter(encrypt.AES(key,mode: encrypt.AESMode.cbc,padding: 'PKCS7'));

    final encrypted1 =encrypter.encrypt(retailer, iv: iv);
    final encrypted2 =encrypter.encrypt(comment, iv: iv);
    final encrypted3 =encrypter.encrypt(ip, iv: iv);
    final encrypted4 =encrypter.encrypt(device, iv: iv);
    final encrypted5 =encrypter.encrypt(latitude, iv: iv);
    final encrypted6 =encrypter.encrypt(longitude, iv: iv);
    final encrypted7 =encrypter.encrypt(model, iv: iv);
    final encrypted8 =encrypter.encrypt(city, iv: iv);
    final encrypted9 =encrypter.encrypt(postal, iv: iv);
    final encrypted10 =encrypter.encrypt(internet, iv: iv);
    final encrypted11 =encrypter.encrypt(address, iv: iv);


    String amount = reAmountController.text;

    String retailer1 = encrypted1.base64;
    String comment1 = encrypted2.base64;
    String ip1 = encrypted3.base64;
    String device1 = encrypted4.base64;
    String latitude1 = encrypted5.base64;
    String longitude1 = encrypted6.base64;
    String model1 = encrypted7.base64;
    String city1 = encrypted8.base64;
    String postal1 = encrypted9.base64;
    String internet1 = encrypted10.base64;
    String address1 = encrypted11.base64;


    rtorFundTransfer(retailer1,amount,comment1,ip1,device1,latitude1,longitude1,model1,city1,
        postal1,internet1,address1,keyencoded,viencoded);

  }



  getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy:LocationAccuracy.medium)
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
