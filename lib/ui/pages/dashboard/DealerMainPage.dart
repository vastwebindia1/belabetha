import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:myapp/CommanWidget/app_name.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/CommanWidget/drawer.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/delerpages/DealerDashboard.dart';
import 'package:myapp/ui/pages/dashboard/delerpages/dealerAccount.dart';
import 'package:myapp/ui/pages/dashboard/delerpages/dealerHistory.dart';
import 'package:myapp/ui/pages/dashboard/delerpages/dealerdrawer.dart';
import 'package:myapp/ui/pages/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

import '../../../ThemeColor/Color.dart';
import 'bottomNavigationPage/Account.dart';
import 'bottomNavigationPage/History.dart';
import 'bottomNavigationPage/HomePage.dart';
import 'bottomNavigationPage/OtherServices.dart';
import 'bottomNavigationPage/e_commerce.dart';

class DealermaninDashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<DealermaninDashboard> {
  String Message = "";
  var msz;
  String firmname = "";
  String adminfirmname = "";
  String balance = "";
  String posBalance = "";
  String photo = "";
  String header = "";
  List users = [];
  var News = "";


  Future<void> dealeruserdetails() async {

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
      var firmnamee = data["frmanems"];
      var adminfirm1 = data["adminfarmname"];
      var remainbal = data["remainbal"];
      var posremain = data["posremain"];
      var photoo = data["photoss"];
      var passcode = data["passcodests"]["Status"];
      users = dataa["newservices"];


      var keee = base64.decode(keyy);
      var viii = base64.decode(vii);

      String keySTR = utf8.decode(keee);
      String ivSTR = utf8.decode(viii);

      final key = encrypt.Key.fromUtf8(keySTR);
      final iv = encrypt.IV.fromUtf8(ivSTR);
      final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));

      final decrypted1 =
      encrypter.decrypt(encrypt.Encrypted.fromBase64(firmnamee), iv: iv);
      final decrypted2 =
      encrypter.decrypt(encrypt.Encrypted.fromBase64(remainbal), iv: iv);
      final decrypted4 =
      encrypter.decrypt(encrypt.Encrypted.fromBase64(posremain), iv: iv);
      final decrypted3 =
      encrypter.decrypt(encrypt.Encrypted.fromBase64(adminfirm1), iv: iv);

      if(photoo == null){
        photoo = "";
      }else{
        final decrypted3 = encrypter.decrypt(encrypt.Encrypted.fromBase64(photoo), iv: iv);
        photo = decrypted3.toString();
      }

       firmname = decrypted1.toString();
       balance = decrypted2.toString();
       posBalance = decrypted4.toString();
        adminfirmname = decrypted3.toString();


       final prefs = await SharedPreferences.getInstance();
       prefs.setString('dealerDpPhoto', photo);


    } else {
      throw Exception('Failed to load themes');
    }

    setState(() {

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
        title: getTranslated(context, 'Warning'),
        confirmBtnText: 'OK',
        confirmBtnColor: Colors.red,
        onConfirmBtnTap: (){
          SystemNavigator.pop();},
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

    var url = new Uri.http("api.vastwebindia.com", "/api/data/Dealer_CallAutofundtransfer",{
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
  int selectedPage = 0;
  final _pageOptions = [DealerDashboard(),  DealerAccount(),ECommerce(),OtherServices(),DealerHistory(), ];

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) => SessionOut());
    userIdenty();
    dealeruserdetails();
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Container(
      color: PrimaryColor,
      child: Container(
        color: TextColor.withOpacity(0.5),
        child: SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            drawer: new MyDrawerDealer(firmname: this.firmname),
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
                        Text(balance.toString(),style: TextStyle(color: TextColor,fontSize: 12),),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  color: TextColor,
                  margin: EdgeInsets.only(top: 8,bottom: 8,left: 4,right: 0),),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(top: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getTranslated(context, 'Pos Wallet'),
                        style: TextStyle(
                            color: TextColor,
                            fontSize: 8
                        ),),
                      SizedBox(height: 2,),
                      Text(posBalance.toString(),
                        style: TextStyle(
                            color: TextColor,fontSize: 12
                        ),
                        textAlign: TextAlign.center,),
                    ],
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
    ), onWillPop: _onbackpress);
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


  Future<void> dealerdetails() async {

    final prefs = await SharedPreferences.getInstance();
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var url = new Uri.http("api.vastwebindia.com", "/api/data/remaindealer");
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
      balance = dataa["RemainBal"].toString();


      setState(() {
        balance;
      });


    } else {
      throw Exception('Failed to load themes');
    }


  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dealerdetails();
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
                        Text(balance,style: TextStyle(color: TextColor,fontSize: 12,fontWeight: FontWeight.bold),),
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

class SimpleAppBarWidget1 extends StatefulWidget {
  final Widget title,body;
  const SimpleAppBarWidget1({key, this.title, this.body}) : super(key: key);

  @override
  _SimpleAppBarWidget1State createState() => _SimpleAppBarWidget1State();
}

class _SimpleAppBarWidget1State extends State<SimpleAppBarWidget1> {
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






