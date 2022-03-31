import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_auth/local_auth.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/HistoryPage/MircroATMhistory.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/MicroAtm/cashatposmainpage.dart';
import 'package:myapp/ui/pages/locations/IpHelper.dart';
import 'package:myapp/ui/pages/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../../../../../../dashboard.dart';

class MatmMainPage extends StatefulWidget {
  const MatmMainPage({Key key}) : super(key: key);

  @override
  _MatmMainPageState createState() => _MatmMainPageState();
}

class _MatmMainPageState extends State<MatmMainPage> {

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
  bool btnclick = true;

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

  Future<void> Apitransitions(String trnsid, String amnt, String ipadd, String type, String lat,String long, String model, String city, String pin,String intype,String address,var key, var iv) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    try{

      var uri = new Uri.http("api.vastwebindia.com", "/MICROATM/api/data/Apitransitions", {
        "Transtionid": trnsid,
        "Amount": amnt,
        "IPaddressss": ipadd,
        "Type": type,
        "Devicetoken": model,
        "Latitude": lat,
        "Longitude": long,
        "ModelNo": model,
        "City": city,
        "PostalCode": pin,
        "InternetTYPE":intype,
        "Addresss":address,
        "value1":key,
        "value2":iv
      });
      final http.Response response = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // ignore: missing_return
      ).timeout(Duration(seconds: 15), onTimeout: (){
        setState(() {
          _isloading = false;
          final snackBar2 = SnackBar(
            backgroundColor: PrimaryColor,
            content: Container(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Text("Request Submit Successfully. Please Check Your History.",style: TextStyle(color: TextColor,fontWeight: FontWeight.bold,fontSize: 18),textAlign: TextAlign.start)),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      color: SecondaryColor,
                      child: FlatButton(
                          onPressed: (){
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MATMhistorypage()));
                          }, child: Text("History",style: TextStyle(color: TextColor),)))
                ],
              ),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar2);
        });
      });

      print(response);

      if (response.statusCode == 200) {
        _isloading = false;
        var data = json.decode(response.body);
        var status = data["Status"];
        var msz = data["Message"];

        if(status == "Success"){

          setState(() {
            _isloading = false;
             chkbalance = false;
            btnclick = true;
          });


          _credoLpogin(false);
          /*Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CredoPay()));

*/
        } else{

          setState(() {
            _isloading = false;
          });

          CoolAlert.show(
            backgroundColor: PrimaryColor.withOpacity(0.6),
            context: context,
            type: CoolAlertType.error,
            text: msz,
            title: status,
            confirmBtnText: 'OK',
            confirmBtnColor: Colors.red,
            onConfirmBtnTap: (){
              Navigator.of(context).pop();
            },
          );
        }



      } else {
        _isloading = false;
        throw Exception('Failed');
      }


    }catch(e){

      print(e);
    }

  }

  static const platform = const MethodChannel('com.aasha/credoPay');
  String _responseFromNativeCode = 'Waiting for Response...';

  Future<Null> _credoLpogin(bool isChangedPassword) async {

    try {
      final String result = await platform.invokeMethod('payAmount', {'isChangePassword' : isChangedPassword,'loginid' : loginid,'password' : password,'newlogin' : isnewlog,'amount' : amount.text,'uniqid' : trnsidd,'ispurchase' : ispurchase,'ismicroatm' : ismicroatm,'chkblnce' : chkbalance});

      print(result);

    } on PlatformException catch (e) {
      _message = "Can't do native stuff ${e.message}.";
    }

  }

  final snackBar = SnackBar(
    content: Text('Amount Should be between \u{20B9} 201 To \u{20B9} 10000',style: TextStyle(color: Colors.yellowAccent),),
  );

  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    vm30activiation();
    getlocationcall();
  }

  Future<void> getlocationcall ()async{

    await getCurrentLocation();
  }

  Future<bool> hh(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(child: Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: TextColor,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 15,bottom: 15,),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [const Color(0xFFda0828),const Color(0xff141414),],
                      begin: FractionalOffset.centerLeft,
                      end: FractionalOffset.bottomRight,
                      tileMode: TileMode.clamp
                    )),
                  child:Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          child: Container(
                            child: Container(
                              child: Stack(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 120,
                                              width: 120,
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
                                              child: Image.asset('assets/pngImages/atm-machine.png'),
                                            ),
                                            SizedBox(height: 5,),
                                            Text(getTranslated(context, 'Micro ATM'),style: TextStyle(color: TextColor,fontSize: 18,),)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    top: 0,
                                    left: 0,
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

                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: InputTextField(
                    label: getTranslated(context, 'Enter Amount'),
                    errorText:  _validate ? '' : null,
                    maxLength: 12,
                    controller: amount,
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
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  child: Text(getTranslated(context, 'mratm'),textAlign: TextAlign.justify,),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  child: Text(getTranslated(context, '2matm'),textAlign: TextAlign.justify,),
                ),
                SizedBox(
                  height: 20,),
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.all(15),
                            backgroundColor:SecondaryColor,
                            shadowColor:Colors.transparent,),
                            onPressed:btnclick == false ? null :()async{
                            int amnt = int.parse(amount.text);

                            if(amount.text == "" || amnt <= 200 || amnt >10001){

                              setState(() {
                                _validate = true;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);

                            }else {

                              var uuid = Uuid();
                              trnsidd = uuid.v1().substring(0, 16);
                              final prefs = await SharedPreferences.getInstance();
                              var hu = IpHelper().getconnectivity();
                              var hdddu = IpHelper().getLocalIpAddress();

                              DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                              AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;

                              modelname = androidDeviceInfo.model;
                              androidid = androidDeviceInfo.androidId;
                              netname = prefs.getString('conntype');
                              ipadd = prefs.getString('ipaddress');

                              setState(() {
                                _isloading = true;
                                btnclick = false;
                              });

                              Apitransitionsencrypt(trnsidd, amount.text, ipadd, "microatm", "lat", "long", modelname, "city", "postcode", netname, "address");
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: _isloading ? Center(child: SizedBox(
                                    height: 20,
                                    child: LinearProgressIndicator(backgroundColor: PrimaryColor,valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
                                  ),) : Text(getTranslated(context, 'Pay'),textAlign: TextAlign.center,style: TextStyle(color: TextColor,fontSize: 18),)
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
                      width: 200,
                      margin: EdgeInsets.only(left: 10),
                      padding: EdgeInsets.only(top: 3,bottom: 3,left: 5,right: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(getTranslated(context, 'trmode'),style: TextStyle(color:SecondaryColor,fontSize: 16,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,),
                    ),
                    Container(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) => CashatposPage(),
                              transitionDuration: Duration(seconds: 0),
                            ),);
                        },
                        child: Container(
                            width: 100,
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                border: Border.all(
                                    color: SecondaryColor
                                ),
                                color: TextColor
                            ),
                            child: Text(getTranslated(context, 'cashposh'),style: TextStyle(color: PrimaryColor),overflow: TextOverflow.ellipsis,)
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ), onWillPop: hh);

  }

   void Apitransitionsencrypt(String trnsid, String amnt, String ipadd, String type, String lat,String long, String model, String city, String pin,String intype,String address) async{

    final storage = new FlutterSecureStorage();
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

    final encrypted1 =encrypter.encrypt(trnsid, iv: iv);
    final encrypted2 =encrypter.encrypt(ipadd, iv: iv);
    final encrypted3 =encrypter.encrypt(type, iv: iv);
    final encrypted4 =encrypter.encrypt(lat, iv: iv);
    final encrypted5 =encrypter.encrypt(long, iv: iv);
    final encrypted6 =encrypter.encrypt(model, iv: iv);
    final encrypted7 =encrypter.encrypt(city, iv: iv);
    final encrypted8 =encrypter.encrypt(pin, iv: iv);
    final encrypted9 =encrypter.encrypt(intype, iv: iv);
    final encrypted10 =encrypter.encrypt(address, iv: iv);



    String trnstpee = encrypted1.base64;
    String ipadde = encrypted2.base64;
    String typee = encrypted3.base64;
    String latt = encrypted4.base64;
    String longg = encrypted5.base64;
    String modell = encrypted6.base64;
    String city1 = encrypted7.base64;
    String pinn = encrypted8.base64;
    String inttypee = encrypted9.base64;
    String addrsss = encrypted10.base64;
  


   Apitransitions(trnstpee, amnt, ipadde, typee, latt, longg, modell, city1, pinn, inttypee, addrsss, keyencoded, viencoded);
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
