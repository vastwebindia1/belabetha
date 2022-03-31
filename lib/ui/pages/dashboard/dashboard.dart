import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:device_info/device_info.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:myapp/CommanWidget/app_name.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/CommanWidget/drawer.dart';
import 'package:myapp/CommanWidget/passcodePage.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/dataConnectionLost.dart';
import 'package:myapp/ui/pages/dashboard/pancardcheckver.dart';
import 'package:myapp/ui/pages/locations/IpHelper.dart';
import 'package:myapp/ui/pages/login/OtpTest.dart';
import 'package:myapp/ui/pages/login/login.dart';
import 'package:myapp/ui/pages/login/videoKyc.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

import '../../../ThemeColor/Color.dart';
import 'Aadharorpanverfication.dart';
import 'bottomNavigationPage/Account.dart';
import 'bottomNavigationPage/History.dart';
import 'bottomNavigationPage/HomePage.dart';
import 'bottomNavigationPage/OtherServices.dart';
import 'bottomNavigationPage/e_commerce.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with WidgetsBindingObserver {

  String Message = "";
  var msz;
  String firmname = "";
  String adminfirmname = "";
  String balance = "";
  String photo = "";
  String header = "";
  List users = [];
  var News = "";
  String posBalance  = "";
  String userId="";

  Future<void> userIdenty() async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "userId");

    setState(() {

      autoFillWallet(a);
    });
  }

  Future<void> checkadharpanver() async {

    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");
    var userid = await storage.read(key: "userId");

    var url = new Uri.http("api.vastwebindia.com", "/api/Account/AAdharPan_Status",{
      "userid":userid
    });
    final http.Response response = await http.get(url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 15), onTimeout: (){

    });

    print(response);

    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      var aadhrstatus = dataa["aadhar_status"].toString();
      var panstatus = dataa["pan_status"].toString();
      var aadhar = dataa["aadhar"].toString();
      var pancrd = dataa["pan"].toString();

      if(aadhrstatus == "false"){

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => aadhrpanverify(aadharcard: aadhar,pancard: pancrd,)));

      }else if(panstatus == "false"){

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => pancardverf(aadharcard: aadhar,pancard: pancrd,)));

      }else if(aadhrstatus == "false" && panstatus == "false"){

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => aadhrpanverify(aadharcard: aadhar,pancard: pancrd,)));
      }

    } else {
      throw Exception('Failed to load themes');
    }

  }

  Future<void> autoFillWallet(String retailerId) async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");
    String token = a;

    var url = new Uri.http("api.vastwebindia.com", "/Retailer/api/data/Rem_CallAutofundtransfer",{
      "userid":retailerId,
    });
    final http.Response response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 15), onTimeout: (){

    });

    print(response);

    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);

    } else {
      throw Exception('Failed to load themes');
    }


  }

  DateTime parsedDate;
  DateTime selectedDate;

  Future<String> SessionOut() async{

    final storage = new FlutterSecureStorage();
    var tokendate = await storage.read(key: "tokendate");
    String token1 = tokendate;

    parsedDate = HttpDate.parse(token1);

    selectedDate = DateTime.now();

    if(selectedDate.isAfter(parsedDate) || selectedDate == parsedDate){

      final storage = new FlutterSecureStorage();
      storage.deleteAll();

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () async => false,
              child: CustomDialog(
                buttonText:getTranslated(context, 'ok'),
                color: Colors.red,
                description: "Your Session Time Is Expire So Login Again",
                title: getTranslated(context, 'Warning'),
                icon: Icons.cancel,
                onpress: (){
                  Navigator.of(context).pop();
                  SystemNavigator.pop();
                },
              ),
            );
          });
    }else{

    }
  }

  Future<void> userdetails() async {

    final prefs = await SharedPreferences.getInstance();
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var url = new Uri.http("api.vastwebindia.com", "/Common/api/inform/Get_User_Information");

    final http.Response response = await http.get(url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 15), onTimeout: (){

    });

    print(response);

    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      var data = dataa["data"];
      var keyy = data["kkkk"];
      var vii = data["vvvv"];
      var firmnamee = data["frmanems"];
      var remainbal = data["remainbal"];
      var photoo = data["photoss"];
      var adminfirmnam = data["adminfarmname"];
      var passcode = data["passcodests"]["Status"];

      var keee = base64.decode(keyy);
      var viii = base64.decode(vii);

      String keySTR = utf8.decode(keee);
      String ivSTR = utf8.decode(viii);

      final key = encrypt.Key.fromUtf8(keySTR);
      final iv = encrypt.IV.fromUtf8(ivSTR);

      final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));
      final decrypted1 = encrypter.decrypt(encrypt.Encrypted.fromBase64(firmnamee), iv: iv);
      final decrypted2 = encrypter.decrypt(encrypt.Encrypted.fromBase64(remainbal), iv: iv);

      if(adminfirmnam == null){

        setState(() {
          adminfirmname = "No Firm Name";
        });

      }else{

        final decrypted4 = encrypter.decrypt(encrypt.Encrypted.fromBase64(adminfirmnam), iv: iv);
        adminfirmname = decrypted4.toString();
      }

      if(photoo == null){
        photoo = "";
      }else{
        final decrypted3 = encrypter.decrypt(encrypt.Encrypted.fromBase64(photoo), iv: iv);
        photo = decrypted3.toString();
      }

      firmname = decrypted1.toString();
      balance = decrypted2.toString();

      allBalanceShow();

    } else {
      throw Exception('Failed to load themes');
    }

    setState(() {
      firmname;
      adminfirmname;
    });
    setState(() {
      if(balance == null || posBalance == null){
        blTest = true;
      }
      else{
        blTest = false;
      }
    });
  }

  Future<void> allBalanceShow() async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var url = new Uri.http("api.vastwebindia.com", "/Retailer/api/data/Show_ALL_balanceremRem");
    final http.Response response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 15), onTimeout: (){

    });

    print(response);

    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      var dataa1 = dataa["data"];
      posBalance =  dataa1[0]["posremain"].toString();

      print(posBalance.length);


      setState(() {
        posBalance;
      });

    } else {
      throw Exception('Failed to load themes');
    }


  }

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

  int selectedPage = 0;
  final _pageOptions = [Home(),  Account(),ECommerce(),OtherServices(),History()];


  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<void> authtask() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");
    try{

      var uri =
      new Uri.http("api.vastwebindia.com", "/Common/api/data/authenticate", {
        "Devicetoken": "fcmtoken",
        "ImeiNo": "androidid",
        "Latitude": "1234",
        "Longitude": "1234",
        "ModelNo": "modelname",
        "IPAddress": "ipadd",
        "Address": "address",
        "City": "city",
        "PostalCode": "123456",
        "InternetTYPE":"netname"
      });
      final http.Response response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // ignore: missing_return
      ).timeout(Duration(seconds: 15), onTimeout: (){
      });

      if (response.statusCode == 200) {

        var data = json.decode(response.body);
        String status = data["status"].toString();

        if (status == "SUCCESS") {

          var message = data["message"]["Status"];
          var loginsts = data["message"]["APPLOGINSTATUS"];
          var passType = data["message"]["BOXTYPE"];
          var verifymailmob = data["message"]["VEREmailPhone"].toString();

          if(loginsts == "Y"){

            if(message == "BOXOPEN"){

            }
            if (message == "BOXNOTOPEN") {

              if(verifymailmob == "true"){

                verifyusers();

              }else{

                var kycvideostatus = data["message"]["VIDEOKYC"];

                if(kycvideostatus =="VideoKYCNOTDONE"){

                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VideoKyc()));

                }else if(kycvideostatus == "VideoKYCPENDING"){

                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return WillPopScope(
                          onWillPop: () async => false,
                          child: CustomDialog(
                            buttonText:"Log out",
                            color: Colors.yellow[700],
                            description: "Your Video Kyc is Pending. Contact to Admin.",
                            title: "Pending",
                            icon: Icons.watch_later_outlined,
                            onpress: () {
                              final storage = new FlutterSecureStorage();
                              storage.deleteAll();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginPage()));
                            },
                          ),
                        );
                      });


                }else{

                }

              }



            }
          }

        }
      } else {

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

    var url = new Uri.http("api.vastwebindia.com", "/Common/api/data/VeryFY_Profiles_users");
    final http.Response response = await http.get(
      url,
      headers:{
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

      if(status == "NOTOTP"){

         authtask();

      }else{

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OTPTEST()));

      }


    } else {
      throw Exception('Failed');
    }
  }

  Future<void> checklogin() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");
    var fingerauthenticate = await storage.read(key: "authenticate");

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    String androidid = androidDeviceInfo.androidId;

    var url = new Uri.http("api.vastwebindia.com", "/api/Account/CheckLogin",{
      "imeino":androidid
    });
    final http.Response response = await http.post(
      url,
      headers:{
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response);

    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      var loginsts = dataa["loginstatus"];
      var changepassword = dataa["changepassword"];

      if(loginsts == true || changepassword == true){

        final storage = new FlutterSecureStorage();
        storage.deleteAll();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );

      }else{

        if(fingerauthenticate == "true"){
          _authenticateWithBiometrics();
        }else{
          print("pause");
        }

      }


    } else {
      throw Exception('Failed');
    }
  }

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
      });
      return;
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';

    if(message == "Authorized"){


    }else{
      SystemNavigator.pop();
    }

    setState(() {
      _authorized = message;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authtask();
    checklogin();
    //checkadharpanver();
    userIdenty();
    userdetails();
    timer = Timer.periodic(Duration(seconds: 60), (Timer t) => userIdenty());
    timer1 = Timer.periodic(Duration(seconds: 10), (Timer t) => SessionOut());
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    final storage = new FlutterSecureStorage();
    var fingerauthenticate = await storage.read(key: "authenticate");

    switch(state){
      case AppLifecycleState.paused:
          print("pause");
          break;
      case AppLifecycleState.resumed:
         checklogin();
         break;
    }

  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    timer.cancel();
    super.dispose();
  }


  AppLifecycleState _notification;
  final LocalAuthentication auth = LocalAuthentication();

  bool blTest = false;
  bool blTest1 = false;
  Timer timer,timer1;

  @override
  Widget build(BuildContext context) {

    setState(() {
      if(balance.length <1){
        blTest=true;
      }
      else{
        blTest=false;
      }
      if(posBalance.length  < 1){
        blTest1 = true;
      }
      else{
        blTest1 = false;
      }
    });

    return WillPopScope(
        child: Container(
          color: PrimaryColor,
          child: Container(
            color: TextColor.withOpacity(0.5),
            child: SafeArea(
              child: Scaffold(
                backgroundColor: TextColor,
                key: _scaffoldKey,
                drawer: new MyDrawer(firmname: this.firmname),
                appBar: AppBar(
                  backgroundColor:PrimaryColor,
                  toolbarHeight: 39,
                  shadowColor: Colors.transparent,
                  leading: IconButton(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 2,top: 0,bottom: 0,right: 0),
                    icon: Icon(Icons.menu_open_rounded,color: TextColor,size: 30,),
                    onPressed: () => _scaffoldKey.currentState.openDrawer(),
                  ),
                  title: Transform.translate(
                      offset: Offset(-30.0, 0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(firmname, style: TextStyle(fontSize: 8,color: TextColor),),
                          SizedBox(height: 3,),
                          Text(adminfirmname, style: TextStyle(fontSize: 12,color: TextColor),
                          ),
                        ],
                      )
                  ),
                  actions: <Widget>[
                    Transform.translate(
                      offset: Offset(5.0, 0.0),
                      child: GestureDetector(
                        onTap: (){
                          userdetails();
                          allBalanceShow();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 2,right: 3),
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                getTranslated(context, 'Main Wallet'),
                                style: TextStyle(
                                    color: TextColor,
                                    fontSize: 8
                                ),),
                              SizedBox(height:blTest ? 8: 2,),
                              blTest ? DoteLoaderWhiteColor():Text(balance,style: TextStyle(color: TextColor,fontSize: 12),),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                        visible: posBalance == "0.0" ? false : true,
                        child: Container(
                          width: 1,
                          color: TextColor,
                          margin: EdgeInsets.only(top: 8,bottom: 8,left: 4,right: 0),)),
                    Visibility(
                      visible: posBalance == "0.0" ? false : true,
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(top: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(getTranslated(context, 'Pos Wallet'),
                              style: TextStyle(
                                  color: TextColor,
                                  fontSize: 8
                              ),),
                            SizedBox(height:blTest1 ? 6: 2,),
                            blTest1 ? DoteLoaderWhiteColor():Text(posBalance,
                              style: TextStyle(
                                  color: TextColor,fontSize: 12
                              ),
                              textAlign: TextAlign.center,),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                body: Container(child: _pageOptions[selectedPage]),
                bottomNavigationBar: BottomNavyBar(
                  backgroundColor: SecondaryColor,
                  selectedIndex: selectedPage,
                  showElevation: false,
                  itemCornerRadius: 24,
                  curve: Curves.fastOutSlowIn,
                  onItemSelected: (index) => setState(() =>   selectedPage = index),
                  items: <BottomNavyBarItem>[
                    BottomNavyBarItem(
                      icon: Icon(Icons.home),
                      title: Text(getTranslated(context,  'Home',)),
                      inactiveColor: TextColor,
                      activeColor: TextColor,
                      textAlign: TextAlign.center,
                    ),
                    BottomNavyBarItem(
                      icon: Icon(Icons.person),
                      title:Text(getTranslated(context, 'Account'),),
                      inactiveColor: TextColor,
                      activeColor: TextColor,
                      textAlign: TextAlign.center,
                    ),
                    BottomNavyBarItem(
                      icon: Icon(Icons.shopping_cart),
                      title: Text(getTranslated(context, 'E-commerce'),),
                      inactiveColor: TextColor,
                      activeColor: TextColor,
                      textAlign: TextAlign.center,
                    ),
                    BottomNavyBarItem(
                      icon: Icon(Icons.wallet_giftcard),
                      title:Text(getTranslated(context, 'Services'),),
                      inactiveColor: TextColor,
                      activeColor: TextColor,
                      textAlign: TextAlign.center,
                    ),
                    BottomNavyBarItem(
                      icon: Icon(Icons.history),
                      title:Text(getTranslated(context, 'History'),),
                      inactiveColor: TextColor,
                      activeColor: TextColor,
                      textAlign: TextAlign.center,

                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        onWillPop: _onbackpress);
  }

}

class AppBarWidget extends StatefulWidget {

  final body;
  final Widget title;
  const AppBarWidget({
    key, this.body, this.title,
  }) : super(key: key);

  @override
  _AppBarWidgetState createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  String balance = "";
  Timer timer;

  Future<void> userdetails() async {

    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/Common/api/inform/Get_User_Information");
    final http.Response response = await http.get(url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 15), onTimeout: (){
      setState(() {

      });
    });

    print(response);

    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      var data = dataa["data"];
      var keyy = data["kkkk"];
      var vii = data["vvvv"];
      var remainbal = data["remainbal"];

      var keee = base64.decode(keyy);
      var viii = base64.decode(vii);

      String keySTR = utf8.decode(keee);
      String ivSTR = utf8.decode(viii);

      final key = encrypt.Key.fromUtf8(keySTR);
      final iv = encrypt.IV.fromUtf8(ivSTR);
      final encrypter = encrypt.Encrypter(
          encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));

      final decrypted2 = encrypter.decrypt(encrypt.Encrypted.fromBase64(remainbal), iv: iv);


      balance = decrypted2.toString();
    } else {
      throw Exception('Failed to load themes');
    }

    setState(() {
      balance;
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userdetails();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => userdetails());
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  bool blTest = false;
  @override
  Widget build(BuildContext context) {

    setState(() {
      if(balance.length <1){
        blTest = true;
      }
      else{
        blTest=false;
      }
    });

    return Material(
      color: PrimaryColor,
      child: Container(
        color: TextColor.withOpacity(0.5),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: TextColor,
            appBar: AppBar(
              title: widget.title,
              backgroundColor: PrimaryColor,
              toolbarHeight: 39,
              elevation: 0,
              leading: BackButtonsApBar(),
              leadingWidth: 60,
              actions:[
                Transform.translate(
                  offset: Offset(5.0, 0.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 2),
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(getTranslated(context, 'Main Wallet'),
                          style: TextStyle(
                              color: TextColor,
                              fontSize: 8,
                              fontWeight: FontWeight.bold
                          ),),
                        SizedBox( height: blTest ? 8 : 2,),
                        blTest ? DoteLoaderWhiteColor():Text(balance,style: TextStyle(color: TextColor,fontSize: 12,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  margin: EdgeInsets.only(top: 8,bottom: 8,left: 4,right: 5),),
              ],
            ),
            body: widget.body,
          ),
        ),
      ),
    );
  }
}

class AppBarWidget1 extends StatefulWidget {

  final body;
  final Widget title;
  const AppBarWidget1({
    key, this.body, this.title,
  }) : super(key: key);

  @override
  _AppBarWidget1State createState() => _AppBarWidget1State();
}

class _AppBarWidget1State extends State<AppBarWidget1> {
  String balance = "";
  Timer timer;

  Future<void> userdetails() async {

    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/Common/api/inform/Get_User_Information");
    final http.Response response = await http.get(url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 15), onTimeout: (){

    });

    print(response);

    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      var data = dataa["data"];
      var keyy = data["kkkk"];
      var vii = data["vvvv"];
      var remainbal = data["remainbal"];

      var keee = base64.decode(keyy);
      var viii = base64.decode(vii);

      String keySTR = utf8.decode(keee);
      String ivSTR = utf8.decode(viii);

      final key = encrypt.Key.fromUtf8(keySTR);
      final iv = encrypt.IV.fromUtf8(ivSTR);
      final encrypter = encrypt.Encrypter(
          encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));

      final decrypted2 = encrypter.decrypt(encrypt.Encrypted.fromBase64(remainbal), iv: iv);


      balance = decrypted2.toString();
    } else {
      throw Exception('Failed to load themes');
    }

    setState(() {
      balance;
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userdetails();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => userdetails());
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  bool blTest = false;

  @override
  Widget build(BuildContext context) {
    setState(() {
      if(balance.length <1){
        blTest = true;
      }
      else{
        blTest=false;
      }
    });

    return Material(
      color: PrimaryColor,
      child: Container(
        color: TextColor.withOpacity(0.5),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: TextColor,
            appBar: AppBar(
              title: widget.title,
              backgroundColor: PrimaryColor,
              toolbarHeight: 39,
              elevation: 0,
              leading: BackButtonsApBar1(),
              leadingWidth: 60,
              actions:[
                Transform.translate(
                  offset: Offset(5.0, 0.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 2),
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(getTranslated(context, 'Main Wallet'),
                          style: TextStyle(
                              color: TextColor,
                              fontSize: 8,
                              fontWeight: FontWeight.bold
                          ),),
                        SizedBox( height: blTest ? 8 : 2,),
                        blTest ? DoteLoaderWhiteColor():Text(balance,style: TextStyle(color: TextColor,fontSize: 12,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  margin: EdgeInsets.only(top: 8,bottom: 8,left: 4,right: 5),
                ),
              ],
            ),
            body: widget.body,
          ),
        ),
      ),
    );
  }

}

class AppBarWidget3 extends StatefulWidget {

  final body;
  final Widget title;
  const AppBarWidget3({
    key, this.body, this.title,
  }) : super(key: key);

  @override
  _AppBarWidgetState3 createState() => _AppBarWidgetState3();
}

class _AppBarWidgetState3 extends State<AppBarWidget3> {
  String posBalance = "";
  Timer timer;

  Future<void> allBalanceShow() async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var url = new Uri.http("api.vastwebindia.com", "/Retailer/api/data/Show_ALL_balanceremRem");
    final http.Response response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 15), onTimeout: (){
      setState(() {

        /*  final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(getTranslated(context, 'Data Not Found'),style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);*/

      });
    });

    print(response);

    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      var dataa1 = dataa["data"];

      debugPrint("posbaak:$dataa");
      posBalance =  dataa1[0]["posremain"].toString();


      setState(() {
        posBalance;
      });

    } else {
      throw Exception('Failed to load themes');
    }


  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allBalanceShow();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => allBalanceShow());
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }


  bool blTest = false;


  @override
  Widget build(BuildContext context) {

    return Material(
      color: PrimaryColor,
      child: Container(
        color: TextColor.withOpacity(0.5),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: TextColor,
            appBar: AppBar(
              title: widget.title,
              backgroundColor: PrimaryColor,
              toolbarHeight: 39,
              elevation: 0,
              leading: BackButtonsApBar(),
              leadingWidth: 60,
              actions:[
                Transform.translate(
                  offset: Offset(5.0, 0.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 2),
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(getTranslated(context, 'Pos Wallet'),
                          style: TextStyle(
                              color: TextColor,
                              fontSize: 8,
                              fontWeight: FontWeight.bold
                          ),),
                        SizedBox( height: blTest ? 8 : 2,),
                        blTest ? DoteLoaderWhiteColor():Text(posBalance,style: TextStyle(color: TextColor,fontSize: 12,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  margin: EdgeInsets.only(top: 8,bottom: 8,left: 4,right: 5),),
              ],
            ),
            body: widget.body,
          ),
        ),
      ),
    );
  }
}

class SimpleAppBarWidget extends StatefulWidget {
  final Widget title,body;
  const SimpleAppBarWidget({key, this.title, this.body}) : super(key: key);

  @override
  _SimpleAppBarWidgetState createState() => _SimpleAppBarWidgetState();
}

class _SimpleAppBarWidgetState extends State<SimpleAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: PrimaryColor,
      child: Container(
        color: TextColor.withOpacity(0.5),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: TextColor,
            appBar: AppBar(
              title: widget.title,
              backgroundColor: PrimaryColor,
              toolbarHeight: 39,
              elevation: 0,
              leading: BackButtonsApBar(),
              leadingWidth: 60,
            ),
            body: widget.body,
          ),
        ),
      ),
    );
  }
}

class DoteLoader extends StatefulWidget {
  @override
  _DoteLoaderState createState() => _DoteLoaderState();
}

class _DoteLoaderState extends State<DoteLoader> {
  @override
  Widget build(BuildContext context) {
    return CollectionScaleTransition(
      children: <Widget>[
        Icon(Icons.circle, size: 8, color: SecondaryColor,),
        Icon(Icons.circle, size: 8, color: SecondaryColor),
        Icon(Icons.circle, size: 8, color: SecondaryColor),
        Icon(Icons.circle, size: 8, color: SecondaryColor),
      ],
    );
  }
}

class DoteLoaderWhiteColor extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return CollectionScaleTransition(
      children: <Widget>[
        Icon(Icons.circle, size: 8, color: TextColor,),
        Icon(Icons.circle, size: 8, color: TextColor),
        Icon(Icons.circle, size: 8, color: TextColor),
        Icon(Icons.circle, size: 8, color: TextColor),
      ],
    );
  }
}