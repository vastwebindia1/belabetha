import 'dart:async';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:intl/intl.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/CommanWidget/drawer.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/OtherServices.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/e_commerce.dart';
import 'package:myapp/ui/pages/dashboard/masterPage/masterAccount.dart';
import 'package:myapp/ui/pages/dashboard/masterPage/masterDashboard.dart';
import 'package:myapp/ui/pages/dashboard/masterPage/masterHistory.dart';
import 'package:myapp/ui/pages/dashboard/masterPage/masterdrawer.dart';
import 'package:myapp/ui/pages/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MasterManinDashboard extends StatefulWidget {
  @override
  _MasterManinDashboardState createState() => _MasterManinDashboardState();
}

class _MasterManinDashboardState extends State<MasterManinDashboard> {
  String Message = "";
  var msz;
  String firmname = "";
  String adminfirmname = "";
  String balance = "";
  String photo = "";
  String header = "";
  List users = [];
  var News = "";

  String mainBalance = "";

  Future<void> masteruserdetails() async {

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
      var data = dataa["data"];
      var keyy = data["kkkk"];
      var vii = data["vvvv"];
      var remainbal = data["remainbal"];
      var firm = data["frmanems"];
      var admin = data["adminfarmname"];
      var photto = data["photo"];

      var keee = base64.decode(keyy);
      var viii = base64.decode(vii);

      String keySTR = utf8.decode(keee);
      String ivSTR = utf8.decode(viii);

      final key = encrypt.Key.fromUtf8(keySTR);
      final iv = encrypt.IV.fromUtf8(ivSTR);
      final encrypter = encrypt.Encrypter(
          encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));

      final decrypted2 = encrypter.decrypt(encrypt.Encrypted.fromBase64(remainbal), iv: iv);
      final decrypted1 = encrypter.decrypt(encrypt.Encrypted.fromBase64(firm), iv: iv);
      final decrypted3 = encrypter.decrypt(encrypt.Encrypted.fromBase64(admin), iv: iv);

      if(photto == null){
        photto = "";
      }else{

        final decrypted3 = encrypter.decrypt(encrypt.Encrypted.fromBase64(photto), iv: iv);
        setState(() {
          photo = decrypted3.toString();
        });
      }

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('masterDpPhoto', photo);


      mainBalance = decrypted2.toString();
      firmname = decrypted1.toString();
      adminfirmname = decrypted3.toString();
    } else {
      throw Exception('Failed to load themes');
    }

    setState(() {
      mainBalance;
      firmname;
      adminfirmname;
    });
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


      CoolAlert.show(
        backgroundColor: PrimaryColor.withOpacity(0.6),
        context: context,
        type: CoolAlertType.error,
        text: "Your Session Time Is Expire So Login Again",
        confirmBtnText: 'OK',
        confirmBtnColor: Colors.red,
        onConfirmBtnTap: (){
          /*Navigator.of(context).pop();*/
          SystemNavigator.pop();
        },
      );
    }else{

    }
  }

  Future<void> userIdenty() async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "userId");

    setState(() {

      autoFillWallet(a);
    });
  }

  Future<void> autoFillWallet(String retailerId) async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");
    String token = a;

    var url = new Uri.http("api.vastwebindia.com", "/api/data/master_distributor_CallAutofundtransfer",{
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

  Timer timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userIdenty();
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) => SessionOut());
    masteruserdetails();
  }

  int selectedPage = 0;
  final _pageOptions = [MasterDashboard(),  MasterAccount(),ECommerce(),OtherServices(),MasterHistory(), ];

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PrimaryColor,
      child: Container(
        color: TextColor.withOpacity(0.5),
        child: SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            drawer: new MyDrawerMaster(firmname: this.firmname),
            appBar: AppBar(
              backgroundColor:PrimaryColor,
              toolbarHeight: 39,
              shadowColor: Colors.transparent,
              leading: IconButton(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                    left: 2,top: 0,bottom: 0,right: 0),
                icon: Icon(Icons.menu_open_rounded,color: TextColor,size: 30,),
                onPressed: () => _scaffoldKey.currentState.openDrawer(),
              ),
              /*title: Text("Aasha Digital India",style: TextStyle(fontSize: 14,fontWeight: FontWeight.normal),),*/
              title: Transform.translate(
                  offset: Offset(-30.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(firmname,
                        style: TextStyle(
                            fontSize: 8,color: TextColor
                        ),),
                      SizedBox(height: 3,),
                      Text(adminfirmname,
                        style: TextStyle(fontSize: 12,color: TextColor),
                      ),
                    ],
                  )
              ),
              actions: <Widget>[
                Transform.translate(
                  offset: Offset(5.0, 0.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 2),
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
                        SizedBox(height: 2,),
                        Text(mainBalance.toString(),style: TextStyle(color: TextColor,fontSize: 12),),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            body: _pageOptions[selectedPage],
            bottomNavigationBar: BottomNavyBar(
              backgroundColor: SecondaryColor,
              selectedIndex: selectedPage,
              showElevation: false,
              itemCornerRadius: 24,
              curve: Curves.fastOutSlowIn,
              onItemSelected: (index) => setState(() => selectedPage = index),
              items: <BottomNavyBarItem>[
                BottomNavyBarItem(
                  icon: Icon(Icons.home),
                  title: Text(getTranslated(context, 'Home')),
                  inactiveColor: TextColor,
                  activeColor: TextColor,
                  textAlign: TextAlign.center,

                ),
                BottomNavyBarItem(
                  icon: Icon(Icons.person),
                  title: Text(getTranslated(context, 'Account')),
                  inactiveColor: TextColor,
                  activeColor: TextColor,
                  textAlign: TextAlign.center,
                ),
                BottomNavyBarItem(
                  icon: Icon(Icons.shopping_cart),
                  title: Text(
                    getTranslated(context, 'E-commerce'),
                  ),
                  inactiveColor: TextColor,
                  activeColor: TextColor,
                  textAlign: TextAlign.center,
                ),
                BottomNavyBarItem(
                  icon: Icon(Icons.wallet_giftcard),
                  title: Text(getTranslated(context, 'Services')),
                  inactiveColor: TextColor,
                  activeColor: TextColor,
                  textAlign: TextAlign.center,
                ),
                BottomNavyBarItem(
                  icon: Icon(Icons.history),
                  title: Text(getTranslated(context, 'History')),
                  inactiveColor: TextColor,
                  activeColor: TextColor,
                  textAlign: TextAlign.center,

                ),
              ],
            ),
          ),
        ),
      ),
    );
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

  Future<void> masteruserdetails() async {

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
    masteruserdetails();

  }


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
                        Text(
                          getTranslated(context, 'Main Wallet'),
                          style: TextStyle(
                              color: TextColor,
                              fontSize: 8,
                              fontWeight: FontWeight.bold
                          ),),
                        SizedBox(height: 1,),
                        Text(balance.toString(),style: TextStyle(color: TextColor,fontSize: 12,fontWeight: FontWeight.bold),),
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
