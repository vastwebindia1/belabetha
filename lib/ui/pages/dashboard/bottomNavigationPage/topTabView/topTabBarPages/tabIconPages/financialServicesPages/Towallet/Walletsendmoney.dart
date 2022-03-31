import 'dart:convert';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/BroadbandPage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/dthRechargePage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/UPI/upiresponse.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/dmtPages/paymentresponse.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/dmtPages/registerSender.dart';
import 'package:myapp/ui/pages/locations/IpHelper.dart';
import 'package:myapp/ui/pages/login/join.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:uuid/uuid.dart';
import 'dart:io' as Io;
import '../../../../../../dashboard.dart';


class Walletmoneytransfer extends StatefulWidget {
  final String accnum, name,uniqid;
  const Walletmoneytransfer({Key key, this.accnum, this.name, this.uniqid}) : super(key: key);

  @override
  _WalletmoneytransferState createState() => _WalletmoneytransferState();
}

class _WalletmoneytransferState extends State<Walletmoneytransfer> {

  int id = 3;
  bool aasharvis = false;
  bool panvisi = false;
  bool btnclick = false;
  bool _isloading = false;
  bool _validate = false;
  bool idpr = true;
  int aadharnaun,pannummm;
  bool amnt = false;
  bool serv = false;
  bool aadhr = true;
  bool panc = true;
  bool trnoin = false;
  var imagepath;
  Position _currentPosition;
  String adhrrr,pancc;
  String netname, ipadd, modelname, androidid, lat, long, city, address, postcode,status;
  String sendnum;
  var acccno,ifscodee,amountt,bnknamee,dateortime,statuss,bnkrrid,txnidd;
  TextEditingController amount = TextEditingController();
  TextEditingController reamount = TextEditingController();
  TextEditingController servicefee = TextEditingController();
  TextEditingController aadharcard = TextEditingController();
  TextEditingController pancard = TextEditingController();
  TextEditingController transpin = TextEditingController();

  Future<void> sendmoneyapi(String userid, String num, String ifsc, String benefiid,String amunt,String dmtpin,String accno,String mode,String devicid,String bnkname, String ipaddr, String lat,String long, String model,String address,String city, String postcode,String intype,String key, String iv) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/Money/api/Money/yyyy2");
    Map map = {
      "umm": userid,
      "snn": num,
      "fggg": ifsc,
      "eee": benefiid,
      "ttt":amunt,
      "nnn": dmtpin,
      "nttt": accno,
      "peee": mode,
      "nbb": devicid,
      "bnm":bnkname,
      "kyc": aadharcard.text,
      "ip": ipaddr,
      "mac": pancard.text,
      "ottp": servicefee.text,
      "Devicetoken": city,
      "Latitude": lat,
      "Longitude": long,
      "ModelNo": model,
      "Address":address,
      "City": city,
      "PostalCode": postcode,
      "InternetTYPE":intype,
      "value1":key,
      "value2":iv,
      "uniqueid":widget.uniqid
    };

    String body = json.encode(map);

    try{

      http.Response response = await http.post(url,
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
        body: body,

      ).timeout(Duration(seconds: 30), onTimeout: () {

        setState(() {
          _isloading = false;
        });
      });

      print(response);

      if (response.statusCode == 200) {

        setState(() {
          _isloading = false;
          btnclick = true;
        });

        var data = json.decode(response.body);
        acccno = data["Accountno"];
        ifscodee = data["Ifsccode"];
        amountt = data["TotalAmount"].toString();
        bnknamee = data["BankName"];
        dateortime = data["Time"];
        var detsils = data["data"];
        statuss = detsils[0]["Status"];
        bnkrrid = detsils[0]["bankrefid"];

        Navigator.push(context, MaterialPageRoute(builder: (context) => Upiresponse(bankname: bnknamee,accnum:acccno ,bankrrn: bnkrrid,status: statuss,ifsc: "WALLET",date: dateortime,mode: "Wallet ID",amount: amountt,sservicefee: servicefee.text,name: widget.name,)),);

      } else {
        _isloading = false;
        throw Exception('Failed');
      }


    }catch(e){

    }

  }

  Future<void> sendmoneyapi2(String userid, String num, String ifsc, String benefiid,String amunt,String dmtpin,String accno,String mode,String devicid,String bnkname, String ipaddr, String lat,String long, String model,String address,String city, String postcode,String intype,String key, String iv) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/Money/api/Money/yyyy2");

    Map map = {

      "umm": userid,
      "snn": num,
      "fggg": ifsc,
      "eee": benefiid,
      "ttt":amunt,
      "nnn": dmtpin,
      "nttt": accno,
      "peee": mode,
      "nbb": devicid,
      "bnm":bnkname,
      "kyc": aadharcard.text,
      "ip": ipaddr,
      "mac": pancard.text,
      "ottp": servicefee.text,
      "Devicetoken": city,
      "Latitude": lat,
      "Longitude": long,
      "ModelNo": model,
      "Address":address,
      "City": city,
      "PostalCode": postcode,
      "InternetTYPE":intype,
      "impsphotocaptures":imagepath,
      "value1":key,
      "value2":iv,
      "uniqueid":widget.uniqid
    };

    String body = json.encode(map);

    http.Response response = await http.post(url,
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      },
      body: body,

    ).timeout(Duration(seconds: 30), onTimeout: () {

      setState(() {
        _isloading = false;
      });
    });

    print(response);

    if (response.statusCode == 200) {

      setState(() {
        _isloading = false;
        btnclick = true;
      });

      var data = json.decode(response.body);
      acccno = data["Accountno"];
      ifscodee = data["Ifsccode"];
      amountt = data["TotalAmount"].toString();
      bnknamee = data["BankName"];
      dateortime = data["Time"];
      var detsils = data["data"];
      statuss = detsils[0]["Status"];
      bnkrrid = detsils[0]["bankrefid"];
      /* txnidd = detsils[0]["txnids"];*/

      Navigator.push(context, MaterialPageRoute(builder: (context) => Upiresponse(bankname: bnknamee,accnum:acccno ,bankrrn: bnkrrid,status: statuss,ifsc: "WALLET",date: dateortime,mode: "Wallet ID",amount: amountt,sservicefee: servicefee.text,name: widget.name,)),);
    } else {
      _isloading = false;
      throw Exception('Failed');
    }


  }

  Future<void> checkaadhar(String aadharnum) async {


    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var uri = new Uri.http("api.vastwebindia.com", "/Common/api/data/AdharCardValidationCheck", {
      "aadharnumber": aadharnum,
    });
    final http.Response response = await http.get(
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
      var status = data["status"];

      if(status == true){

        _pickImageFromCamera3();

      }else{

        setState(() {
          _isloading = false;
        });

        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text("Invalid Aadhar Number" + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);

      }


    } else {


      throw Exception('Failed to load data from internet');
    }
  }

  Future<void> checkpannumr(String pannum) async {


    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var uri = new Uri.http("api.vastwebindia.com", "/Common/api/data/PancardCardValidationCheck", {
      "pannumber": pannum,
    });
    final http.Response response = await http.get(
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
      var status = data["status"];

      if(status == true){

        _pickImageFromCamera3();

      }else{

        setState(() {
          _isloading = false;
        });

        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text("Invalid Pan Card Number" + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);

      }


    } else {


      throw Exception('Failed to load data from internet');
    }
  }

  void getdata()async{

    final prefs = await SharedPreferences.getInstance();
    var dd= IpHelper().getCurrentLocation();
    var hu= IpHelper().getconnectivity();
    var hdddu= IpHelper().getLocalIpAddress();

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;

    modelname = androidDeviceInfo.model;
    androidid = androidDeviceInfo.androidId;

    sendnum = prefs.getString("sendnum");
    netname = prefs.getString('conntype');
    ipadd = prefs.getString('ipaddress');

  }

  final uploadimage = ImagePicker();

  _pickImageFromCamera3() async {

    PickedFile pickedFile = await uploadimage.getImage(source: ImageSource.camera, imageQuality: 50);

    try{

      final bytes1 = Io.File(pickedFile.path).readAsBytesSync();
      imagepath = base64Encode(bytes1);

      if(_currentPosition == null){

        setState(() {
          lat = "null";
          long = "null";
          city = "null";
          address = "null";
          postcode = "null";
        });

      }


      sendmoneydetails2(sendnum, "ifscc", "123456", amount.text, transpin.text, widget.accnum, "UPI", androidid, "null", ipadd, lat, long, modelname, address, city, postcode, netname);


    }catch(e){

      setState(() {
        _isloading = false;
      });

      final snackBar2 = SnackBar(
        backgroundColor: Colors.red[900],
        content: Text("Please Upload Your Selfie !!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    }



  }

  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
    getdata();
  }
  @override
  Widget build(BuildContext context) {
    setState(() {
      getCurrentLocation();
    });
    return AppBarWidget(
        title: CenterAppbarTitle(
          svgImage: 'assets/pngImages/money-transfer.png',
          topText: getTranslated(context, 'Selected Info'),
          selectedItemName:getTranslated(context, 'Money Transfer'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: PrimaryColor.withOpacity(0.9),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 10,right: 10,top: 15),
                        padding: EdgeInsets.only(top: 8,bottom: 0,right: 10,left: 10),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1,color: PrimaryColor),
                          borderRadius: BorderRadius.circular(0),
                          color: TextColor.withOpacity(0.8),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [

                                    SizedBox(
                                        width: 24,
                                        child: Image(
                                          image: AssetImage("assets/pngImages/wallet2.png",),
                                        )
                                    ),
                                    Text(widget.accnum,textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1,
                                          color: PrimaryColor
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(widget.name,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 18,color: PrimaryColor,fontWeight: FontWeight.bold,),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 3,),


                          ],
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 10,right: 10,top: 2,bottom: 8),
                        color: SecondaryColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Text(getTranslated(context, 'ID'),style: TextStyle(fontWeight:FontWeight.bold,fontSize: 18,color: TextColor),),
                                  Icon(Icons.play_arrow_outlined,color: TextColor,),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Radio(
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
                                    value: 1,
                                    groupValue: id,
                                    onChanged: (val) {
                                      setState(() {
                                        aasharvis = true;
                                        panvisi = false;
                                        idpr = true;
                                        id = 1;
                                        adhrrr = "true";
                                        pancc = "false";
                                      });
                                    },
                                  ),
                                  Text(getTranslated(context, 'Aadhaar'),
                                    style: new TextStyle(fontSize: 12,color: TextColor),
                                  ),
                                ],
                              ),
                            ),

                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Radio(
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
                                    value: 2,
                                    groupValue: id,
                                    onChanged: (val) {
                                      setState(() {
                                        aasharvis = false;
                                        panvisi = true;
                                        idpr = true;
                                        id = 2;
                                        adhrrr = "false";
                                        pancc = "true";
                                      });
                                    },
                                  ),
                                  Text(getTranslated(context, 'pancard'),
                                    style: new TextStyle(
                                        fontSize: 12,
                                        color: TextColor
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Expanded(child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Radio(
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  value: 3,
                                  fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
                                  groupValue: id,
                                  onChanged: (val) {
                                    setState(() {

                                      aasharvis = false;
                                      panvisi = false;
                                      idpr = false;
                                      id = 3;
                                      adhrrr = "false";
                                      pancc = "false";

                                    });
                                  },
                                ),
                                Text(getTranslated(context, 'none'),
                                  style: new TextStyle(fontSize: 12,color: TextColor),
                                )
                              ],
                            ))
                          ],
                        )
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 10,),
                  Container(
                    child: InputTextField(
                      label: getTranslated(context, 'Enter Amount'),
                      obscureText: true,

                      maxLength: 5,
                      controller: amount,
                      keyBordType: TextInputType.number,
                      labelStyle: TextStyle(
                        color: PrimaryColor,
                      ),
                      borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                      onChange: (String val){

                        if(val.length > 0){
                          setState(() {
                            trnoin = true;
                          });

                        }else{

                          setState(() {
                            trnoin = false;
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
                    child: InputTextField(
                      label: getTranslated(context, 'Re-Enter Amount'),
                      controller:reamount,
                      errorText:  _validate ? '' : null,

                      maxLength: 5,
                      obscureText: false,
                      keyBordType: TextInputType.number,
                      labelStyle: TextStyle(
                        color: PrimaryColor,
                      ),
                      borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                      onChange: (String val){

                        if(val.length > 0){

                          setState(() {
                            trnoin = true;
                            servicefee.text = "0";
                          });


                        }else{

                          setState(() {
                            trnoin = false;
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
                    child: InputTextField(
                      label: getTranslated(context, 'Enter Service Fee'),
                      obscureText: false,
                      maxLength: 3,

                      controller: servicefee,
                      keyBordType: TextInputType.number,
                      labelStyle: TextStyle(
                        color: PrimaryColor,
                      ),
                      borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                      onChange: (String val){

                        String enteramnt = amount.text;
                        String reenteramntt = reamount.text;

                        if(enteramnt == reenteramntt){

                          setState(() {
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
                  Visibility(
                    visible: aasharvis,
                    child: Container(
                      child: InputTextField(
                        label:getTranslated(context, 'Enter Aadhaar Number'),

                        controller: aadharcard,
                        maxLength: 12,
                        checkenable: aadhr,
                        obscureText: false,
                        keyBordType: TextInputType.number,
                        labelStyle: TextStyle(
                          color: PrimaryColor,
                        ),
                        borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                        onChange: (String val){

                          if(val.length > 4){
                            setState(() {
                              trnoin = true;
                            });
                          }else{
                            setState(() {
                              trnoin = false;
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
                    ),),
                  Visibility(
                    visible: panvisi,
                    child: Container(
                      child: InputTextField(
                        label: getTranslated(context, 'Enter Pan Number'),
                        checkenable: panc,
                        inputFormatter: [ WhitelistingTextInputFormatter(RegExp("[a-z A-Z 0-9]")),],
                        controller: pancard,
                        maxLength: 10,
                        obscureText: false,
                        labelStyle: TextStyle(
                          color: PrimaryColor,
                        ),
                        borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                        onChange: (String val){
                          pancard.value = TextEditingValue(
                              text: val.toUpperCase(),
                              selection: pancard.selection);
                          if(val.length > 4){

                            setState(() {
                              trnoin = true;
                            });
                          }else{
                            setState(() {
                              trnoin = false;
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
                    ),),
                  Container(
                    child: InputTextField(
                      label: getTranslated(context, 'Enter Transaction PIN'),
                      checkenable: trnoin,

                      obscureText: false,
                      maxLength: 4,
                      controller: transpin,
                      keyBordType: TextInputType.number,
                      labelStyle: TextStyle(
                        color: PrimaryColor,
                      ),
                      borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                      onChange: (String val){

                        if(val.length == 4){

                          setState(() {
                            btnclick = true;
                          });
                        }else{
                          setState(() {
                            btnclick = false;
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
                  MainButtonSecodn(
                      onPressed: btnclick == false ? null : ()async{

                        FocusScopeNode currentFocus = FocusScope.of(context);
                        currentFocus.unfocus();

                        setState(() {
                          _validate = false;
                        });

                        int amnt = int.parse(amount.text);

                        String enteramnt = amount.text;
                        String reenteramntt = reamount.text;

                        aadharnaun = aadharcard.text.length;
                        pannummm = pancard.text.length;

                        if(adhrrr == "true"  && aadharnaun < 12){

                          final snackBar2 = SnackBar(
                            backgroundColor: Colors.red[900],
                            content: Text(getTranslated(context, 'Please Enter Valid Aadhar Number'),style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar2);
                        }else if(pancc == "true" && pannummm < 10){

                          final snackBar2 = SnackBar(
                            backgroundColor: Colors.red[900],
                            content: Text(getTranslated(context, 'Please Enter Valid Pan Card Number'),style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar2);

                        }else{

                          if(enteramnt != reenteramntt){

                            setState(() {
                              _validate = true;
                            });

                            final snackBar2 = SnackBar(
                              backgroundColor: Colors.red[900],
                              content: Text(getTranslated(context, 'Enter Same Amount'),style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(snackBar2);

                          }else if(amount.text == "0" || amount.text == ""){

                            final snackBar2 = SnackBar(
                              backgroundColor: Colors.red[900],
                              content: Text(getTranslated(context, 'Please Enter Valid Amount'),style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(snackBar2);

                          }else if(amnt > 24999){

                            if(adhrrr == "true" && aadharnaun < 12){

                              final snackBar2 = SnackBar(
                                backgroundColor: Colors.red[900],
                                content: Text(getTranslated(context, 'Please Enter Valid Aadhar Number'),style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(snackBar2);

                            }else if(pancc == "true" && pannummm < 10){

                              final snackBar2 = SnackBar(
                                backgroundColor: Colors.red[900],
                                content: Text(getTranslated(context, 'Please Enter Valid Pan Card Number'),style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(snackBar2);

                            }else if(adhrrr == "true"  && aadharnaun == 12){

                              setState(() {
                                _isloading = true;
                                _validate = false;
                                btnclick = false;
                              });

                              checkaadhar(aadharcard.text);

                            }else if(pancc == "true" && pannummm == 10){

                              setState(() {
                                _isloading = true;
                                _validate = false;
                                btnclick = false;
                              });

                              checkpannumr(pancard.text);

                            }else {

                              setState(() {
                                amount.text = "24999";
                                reamount.text = "24999";
                              });

                              final snackBar2 = SnackBar(
                                backgroundColor: Colors.red[900],
                                content: Text(
                                    getTranslated(context, 'aadhaarpanrequired'),
                                    style: TextStyle(
                                        color: Colors.yellowAccent),
                                    textAlign: TextAlign.center),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(snackBar2);

                            }
                          } else{


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
                              _isloading = true;
                              _validate = false;
                              btnclick = false;
                            });
                            sendmoneydetails(sendnum, "null", "123456", amount.text, transpin.text, widget.accnum, "WALLET", androidid, "null", ipadd, lat, long, modelname, address, city, postcode, netname);
                          }

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
                              ),) : Text(getTranslated(context, 'Pay'),textAlign: TextAlign.center,style: TextStyle(color: TextColor),)
                          ),
                        ],
                      )
                  )
                ],
              ),
            ],
          ),
        )
    );
  }

  void sendmoneydetails(String num, String ifsc, String benefiid,String amunt,String dmtpin,String accno,String mode,String devicid,String bnkname, String ipaddr, String lat,String long, String model,String address,String city, String postcode,String intype) async{


    final storage = new FlutterSecureStorage();
    var userid = await storage.read(key: "userId");

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

    final encrypted1 =encrypter.encrypt(userid, iv: iv);
    final encrypted2 =encrypter.encrypt(num, iv: iv);
    final encrypted3 =encrypter.encrypt(ifsc, iv: iv);
    final encrypted4 =encrypter.encrypt(benefiid, iv: iv);
    final encrypted5 =encrypter.encrypt(dmtpin, iv: iv);
    final encrypted6 =encrypter.encrypt(accno, iv: iv);
    final encrypted7 =encrypter.encrypt(mode, iv: iv);
    final encrypted8 =encrypter.encrypt(devicid, iv: iv);
    final encrypted9 =encrypter.encrypt(bnkname, iv: iv);
    final encrypted10 =encrypter.encrypt(ipaddr, iv: iv);
    final encrypted11 =encrypter.encrypt(lat, iv: iv);
    final encrypted12 =encrypter.encrypt(long, iv: iv);
    final encrypted13 =encrypter.encrypt(model, iv: iv);
    final encrypted14 =encrypter.encrypt(address, iv: iv);
    final encrypted15 =encrypter.encrypt(city, iv: iv);
    final encrypted16 =encrypter.encrypt(postcode, iv: iv);
    final encrypted17 =encrypter.encrypt(intype, iv: iv);



    String useridd = encrypted1.base64;
    String numberr = encrypted2.base64;
    String ifscc = encrypted3.base64;
    String benefiiddd = encrypted4.base64;
    String dmtpinnn = encrypted5.base64;
    String accnooo = encrypted6.base64;
    String modeee = encrypted7.base64;
    String deviceiddd = encrypted8.base64;
    String bnknameee = encrypted9.base64;
    String ipadddrrr = encrypted10.base64;
    String lattt = encrypted11.base64;
    String longgg = encrypted12.base64;
    String modellll = encrypted13.base64;
    String adresss = encrypted14.base64;
    String cityyyy = encrypted15.base64;
    String postall = encrypted16.base64;
    String intttyp = encrypted17.base64;


    sendmoneyapi(useridd, numberr, ifscc, benefiiddd, amunt, dmtpinnn, accnooo, modeee, deviceiddd, bnknameee, ipadddrrr, lattt, longgg, modellll, adresss, cityyyy, postall, intttyp, keyencoded, viencoded);

  }

  void sendmoneydetails2(String num, String ifsc, String benefiid,String amunt,String dmtpin,String accno,String mode,String devicid,String bnkname, String ipaddr, String lat,String long, String model,String address,String city, String postcode,String intype) async{


    final storage = new FlutterSecureStorage();
    var userid = await storage.read(key: "userId");

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

    final encrypted1 =encrypter.encrypt(userid, iv: iv);
    final encrypted2 =encrypter.encrypt(num, iv: iv);
    final encrypted3 =encrypter.encrypt(ifsc, iv: iv);
    final encrypted4 =encrypter.encrypt(benefiid, iv: iv);
    final encrypted5 =encrypter.encrypt(dmtpin, iv: iv);
    final encrypted6 =encrypter.encrypt(accno, iv: iv);
    final encrypted7 =encrypter.encrypt(mode, iv: iv);
    final encrypted8 =encrypter.encrypt(devicid, iv: iv);
    final encrypted9 =encrypter.encrypt(bnkname, iv: iv);
    final encrypted10 =encrypter.encrypt(ipaddr, iv: iv);
    final encrypted11 =encrypter.encrypt(lat, iv: iv);
    final encrypted12 =encrypter.encrypt(long, iv: iv);
    final encrypted13 =encrypter.encrypt(model, iv: iv);
    final encrypted14 =encrypter.encrypt(address, iv: iv);
    final encrypted15 =encrypter.encrypt(city, iv: iv);
    final encrypted16 =encrypter.encrypt(postcode, iv: iv);
    final encrypted17 =encrypter.encrypt(intype, iv: iv);



    String useridd = encrypted1.base64;
    String numberr = encrypted2.base64;
    String ifscc = encrypted3.base64;
    String benefiiddd = encrypted4.base64;
    String dmtpinnn = encrypted5.base64;
    String accnooo = encrypted6.base64;
    String modeee = encrypted7.base64;
    String deviceiddd = encrypted8.base64;
    String bnknameee = encrypted9.base64;
    String ipadddrrr = encrypted10.base64;
    String lattt = encrypted11.base64;
    String longgg = encrypted12.base64;
    String modellll = encrypted13.base64;
    String adresss = encrypted14.base64;
    String cityyyy = encrypted15.base64;
    String postall = encrypted16.base64;
    String intttyp = encrypted17.base64;


    sendmoneyapi2(useridd, numberr, ifscc, benefiiddd, amunt, dmtpinnn, accnooo, modeee, deviceiddd, bnknameee, ipadddrrr, lattt, longgg, modellll, adresss, cityyyy, postall, intttyp, keyencoded, viencoded);

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
