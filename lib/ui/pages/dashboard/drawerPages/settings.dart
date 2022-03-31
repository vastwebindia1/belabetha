import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/data/localSecureStorage/flutterStorageHelper.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/drawerPages/passChange.dart';
import 'package:myapp/ui/pages/dashboard/drawerPages/pinChange.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:http/http.dart' as http;

import 'forgotPin.dart';

class AppSettings extends StatefulWidget {
  const AppSettings({Key key}) : super(key: key);
  @override
  _AppSettingsState createState() => _AppSettingsState();
}
bool visible1  = true;
bool visible2 = false;
bool visible3 = false;
bool visible4 = false;
bool visible5 = false;


bool firstTap = false;
bool secondTap = false;
bool viewVisible = true;
bool viewVisible1 = false;


class _AppSettingsState extends State<AppSettings> {

  int selectedIndex = 0;
  static List<StatefulWidget> _widgetOptions1 = [
    PasswordChange(),
    PinChange(),
    PinForget(),
  ];

  bool firstTap = true;
  bool secondTap = false;
  bool thirdTap = false;
  bool viewVisible = true;
  bool viewVisible1 = false;

  void changelay(int number) {
    if (number == 1) {
      setState(() {
        firstTap = true;
        secondTap = false;
        thirdTap = false;
        viewVisible = true;
        viewVisible1 = false;
        selectedIndex = 0;
      });
    } else if (number == 2) {
      setState(() {
        thirdTap = false;
        secondTap = true;
        firstTap = false;
        viewVisible = false;
        viewVisible1 = true;
        selectedIndex = 1;
      });
    }
    else if (number == 3) {
      setState(() {
        thirdTap = true;
        secondTap = false;
        firstTap = false;
        viewVisible = false;
        viewVisible1 = true;
        selectedIndex = 2;
      });
    }
  }


  String sts = "";
  String msy = "";
  String typee = "";
  String printType = "";

  String reqStatus = "";
  String reqMsz = "";




  String cityname1 = "";
  String cityname2 = "";
  String cityname3 = "";
  String appStatus  = "";
  String webStatus = "";
  String cityStatus = "";

  List cityLocation = [];

  bool visibleCity1 = false;
  bool visibleCity2 = false;
  bool visibleCity3 = false;
  bool visibleDescription = false;
  bool appVisible = false;
  bool webVisible = false;
  bool appNotVisible =false;
  bool webNotVisible =false;


  String userroll = "";

  Future<void> userRoll() async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "role");

    String rollUser = a;
    setState(() {
      userroll = rollUser;



    });
  }




  Future<void> checkLoginStatus() async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url =
    new Uri.http("api.vastwebindia.com", "/Common/api/data/TwoFactorStatus");
    final http.Response response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
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

      loading = false;
      var data = json.decode(response.body);
      sts = data["status"];
      msy = data["Message"].toString();
      typee = data["type"].toString();

      if(typee == "ALLOFF"){

        printType = "LoginSecurity OFF";
      }else if(typee == "OTP"){

        printType = "OneTime Password";

      }else if(typee == "PERDAY"){

        printType = getTranslated(context, 'Daily Passcode');

      }else if(typee == "WEAKS"){

        printType = getTranslated(context, 'Weekly Passcode');

      }else if(typee == "MONTHS"){

        printType = getTranslated(context, 'Monthly Passcode');

      }

      setState(() {
        printType;

      });



    } else {

      loading = false;
      throw Exception('Failed to load themes');
    }
  }

  Future<void> loginSecurityRequest( String stf, String pass) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url =
    new Uri.http("api.vastwebindia.com", "/api/Account/TwoFactorAuthentication",{
      "status":stf,
      "passcodetype":pass,
    });
    final http.Response response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
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

      loading = true;
      var data = json.decode(response.body);
      reqStatus = data["status"];
      reqMsz = data["Message"];


      if(reqStatus == "SUCCESS"){

        checkLoginStatus();


      }


    } else {
      throw Exception('Failed to load themes');
    }
  }


  Future<void> locationAndStatus() async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url =
    new Uri.http("api.vastwebindia.com", "/Common/api/data/checkuser_Loginstatus");
    final http.Response response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
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
    }
    );

    print(response);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var securityInform = data["SecurityInform"];
      appStatus = securityInform["apploginsts"];
      webStatus = securityInform["webloginsts"];
      cityStatus = securityInform["citylocationsts"];



      if(appStatus == "Y" && webStatus == "Y"){
        appVisible = true;
        webVisible = true;
        appNotVisible=false;
        webNotVisible=false;
      }else if(appStatus == "Y" && webStatus == "N"){
        appVisible = true;
        webVisible = false;
        appNotVisible=false;
        webNotVisible=true;
      }else if(appStatus == "N" && webStatus == "Y"){
        appVisible = false;
        webVisible = true;
        appNotVisible=true;
        webNotVisible=false;
      }else if(appStatus == "N" && webStatus == "N"){
        appVisible = false;
        webVisible = false;
        appNotVisible=true;
        webNotVisible=true;
      }




      if (cityStatus == "Success"){

        setState(() {
          visibleCity1 = true;
          visibleCity2 = true;
          visibleCity3 = true;
          visibleDescription = false;

        });

        var cityname = securityInform["Citylist"];
        cityname1 = cityname[0]["nameofcity"].toString();
        cityname2 = cityname[1]["nameofcity"].toString();
        cityname3 = cityname[2]["nameofcity"].toString();



        setState(() {
          cityname3;
          cityname2;
          cityname1;
          appStatus;
          webStatus;



        });




      } else{
        visibleDescription = true;


      }






    } else {
      throw Exception('Failed to load themes');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    locationAndStatus();
    checkLoginStatus();
    userRoll();
  }

  bool loading = false;
  


  ScrollController headerScroll=ScrollController();

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontSize: 22,color: TextColor);
    final padding = EdgeInsets.only(left: 10,right: 10);
    double width = 265;
    TextStyle tabTextStyle= TextStyle(fontSize: 12,color: TextColor);
    return Material(
      child: SafeArea(
          child: Scaffold(
            backgroundColor: TextColor,
            body: Container(
              child: SafeArea(
                child: SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  child: StickyHeader(
                    overlapHeaders: false,
                    header:Container(
                      color: TextColor,
                      child: Container(
                        color: PrimaryColor.withOpacity(0.9),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  left: 10, right: 10, top: 10, bottom: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(width: 80,alignment: Alignment.centerLeft,child: BackButton(color:SecondaryColor,)),
                                      Container(
                                        child: Text(
                                          getTranslated(context, 'Manage Login Security'),
                                          style: TextStyle(fontSize: 18, color: TextColor),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Visibility(
                                    visible: visible1,
                                    maintainSize: false,
                                    child: Container(
                                      width: width,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color:Colors.green,
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(50)),
                                          color: Colors.green
                                      ),
                                      child: FlatButton(
                                          shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                          padding: EdgeInsets.all(0),
                                          onPressed: () async{
                                              setState(() {
                                              loading = true;
                                              });
                                              await Future.delayed(const Duration(seconds: 2), (){
                                              loading=false;

                                            setState(() {

                                              loading = true;
                                              visible2 = true;
                                              visible1 = false;

                                              String status11 = "false";
                                              String passType = "PERDAY";

                                              loginSecurityRequest(status11,passType);

                                            });

                                            });
                                          },
                                          child:Container(
                                            padding:padding,
                                            child:  Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Visibility(
                                                  visible: loading,
                                                  child: SizedBox(
                                                      height: 22,
                                                      width: 22,
                                                      child: CircularProgressIndicator(color: TextColor,strokeWidth: 2,)),
                                                ),
                                                Visibility(
                                                    visible: loading == true ? false:true,
                                                    child: Icon(Icons.swap_horizontal_circle_sharp,color: TextColor,size: 30,)),
                                                SizedBox(width: 10,),
                                                Container(
                                                  child: Text(printType == null ? getTranslated(context, 'Daily Passcode') :printType,
                                                    style:style,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Visibility(
                                    visible: visible2,
                                    maintainSize: false,
                                    child: Container(
                                      width: width,
                                      decoration: BoxDecoration(
                                        color:Colors.yellow.shade600,
                                        border: Border.all(
                                          color:Colors.yellow.shade600,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(50)),
                                      ),
                                      child: FlatButton(
                                          shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                          padding: EdgeInsets.all(0),
                                          onPressed: () async{
                                            setState(() {
                                              loading = true;
                                            });
                                            await Future.delayed(const Duration(seconds: 2), (){
                                              loading=false;
                                            setState(()  {

                                                visible3 = true;
                                                visible2 = false;
                                                String status11 = "false";
                                                String passType = "WEAKS";

                                                loginSecurityRequest(status11,passType);
                                              });
                                            });
                                          },
                                          child:Container(
                                            padding: padding,
                                            child:
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Visibility(
                                                  visible: loading,
                                                  child: SizedBox(
                                                      height: 22,
                                                      width: 22,
                                                      child: CircularProgressIndicator(color: TextColor,strokeWidth: 2,)),
                                                ),
                                                Visibility(
                                                  visible: loading == true ? false:true,
                                                    child: Icon(Icons.swap_horizontal_circle_sharp,color: TextColor,size: 30,)),
                                                SizedBox(width: 10,),
                                                Text(printType == null ? getTranslated(context, 'Weekly Passcode') :printType,
                                                  style: style,
                                                ),
                                              ],
                                            ),
                                          )
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: visible3,
                                    maintainSize: false,
                                    child: Container(
                                      width: width,
                                      decoration: BoxDecoration(
                                        color:Colors.orange,
                                        border: Border.all(
                                          color:Colors.orange,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(50)),
                                      ),
                                      child: FlatButton(
                                          shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                          padding: EdgeInsets.all(0),
                                          onPressed: () async{
                                            setState(() {
                                              loading = true;
                                            });
                                            await Future.delayed(const Duration(seconds: 2), (){
                                              loading=false;

                                              setState(() {
                                              visible4 = true;
                                              visible3 = false;


                                              String status11 = "false";
                                              String passType = "MONTHS";

                                              loginSecurityRequest(status11,passType);

                                            });
                                            });
                                          },
                                          child:Container(
                                            padding: padding,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Visibility(
                                                  visible: loading,
                                                  child: SizedBox(
                                                      height: 22,
                                                      width: 22,
                                                      child: CircularProgressIndicator(color: TextColor,strokeWidth: 2,)),
                                                ),
                                                Visibility(
                                                    visible: loading == true ? false:true,
                                                    child: Icon(Icons.swap_horizontal_circle_sharp,color: TextColor,size: 30,)),
                                                SizedBox(width: 10,),
                                                Text(printType == null ? getTranslated(context, 'Monthly Passcode') :printType,
                                                  style:style,
                                                ),
                                              ],
                                            ),
                                          )
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: visible4,
                                    maintainSize: false,
                                    child: Container(
                                      width: width,
                                      decoration: BoxDecoration(
                                        color:Colors.green,
                                        border: Border.all(
                                          color:Colors.green,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(50)),
                                      ),
                                      child: FlatButton(
                                          shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                          padding: EdgeInsets.all(0),
                                          onPressed: () async{
                                            setState(() {
                                              loading = true;
                                            });
                                            await Future.delayed(const Duration(seconds: 2), (){
                                              loading=false;

                                              setState(() {
                                              visible5 = true;
                                              visible4 = false;

                                              String status11 = "true";
                                              String passType = "OTP";

                                              loginSecurityRequest(status11,passType);

                                            });
                                            });
                                          },
                                          child:Container(
                                            padding: padding,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Visibility(
                                                  visible: loading,
                                                  child: SizedBox(
                                                      height: 22,
                                                      width: 22,
                                                      child: CircularProgressIndicator(color: TextColor,strokeWidth: 2,)),
                                                ),
                                                Visibility(
                                                    visible: loading == true ? false:true,
                                                    child: Icon(Icons.swap_horizontal_circle_sharp,color: TextColor,size: 30,)),
                                                SizedBox(width: 10,),
                                                Text(printType == null ? getTranslated(context, 'One Time Password') :printType,
                                                    style:style
                                                ),
                                              ],
                                            ),
                                          )
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: visible5,
                                    maintainSize: false,
                                    child: Container(
                                      width: width,
                                      decoration: BoxDecoration(
                                        color:Colors.red,
                                        border: Border.all(
                                          color:Colors.red,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(50)),
                                      ),
                                      child: FlatButton(
                                          shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                          padding: EdgeInsets.all(0),
                                          onPressed: () async{
                                            setState(() {
                                              loading = true;
                                            });
                                            await Future.delayed(const Duration(seconds: 2), (){
                                              loading=false;

                                              setState(() {
                                              visible1 = true;
                                              visible5 = false;

                                              String status11 = "false";
                                              String passType = "OFF";

                                              loginSecurityRequest(status11,passType);




                                            });
                                            });
                                          },
                                          child:Container(
                                            padding: padding,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Visibility(
                                                  visible: loading,
                                                  child: SizedBox(
                                                      height: 22,
                                                      width: 22,
                                                      child: CircularProgressIndicator(color: TextColor,strokeWidth: 2,)),
                                                ),
                                                Visibility(
                                                    visible: loading == true ? false:true,
                                                    child: Icon(Icons.swap_horizontal_circle_sharp,color: TextColor,size: 30,)),
                                                SizedBox(width: 10,),
                                                Text(printType == null ? getTranslated(context, 'Login Security Off') :printType,
                                                  style:style,
                                                ),
                                              ],
                                            ),
                                          )
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 25,right: 25,bottom: 12),
                              child: Text(
                                getTranslated(context, 'usermsg'),
                                style: TextStyle(color: TextColor,fontSize: 10.5),
                                textAlign: TextAlign.justify,

                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    content: Container(
                      child: Column(
                        children: [
                          Visibility(
                            visible: userroll == "master" ?false:true,
                            child: Container(
                              child: Container(
                                padding: EdgeInsets.only(bottom: 0,top: 0),
                                child: Container(
                                  height: 40,
                                  margin: EdgeInsets.only(left: 0,right: 0,top: 0),
                                  padding: EdgeInsets.all(0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: .5,
                                              color:secondTap ? PrimaryColor.withOpacity(0.9):thirdTap ? PrimaryColor.withOpacity(0.9):PrimaryColor,
                                            ),
                                            borderRadius: BorderRadius.all(Radius.circular(0)),
                                            color:secondTap ? PrimaryColor.withOpacity(0.9):thirdTap ? PrimaryColor.withOpacity(0.9): PrimaryColor,
                                          ),
                                          child: FlatButton(
                                            shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                            padding: EdgeInsets.all(0),
                                            onPressed: () {
                                              changelay(1);
                                            },
                                            child:firstTap ? Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.check_circle,size: 18,color: TextColor,),
                                                SizedBox(width: 2,),
                                                Container(
                                                  width: 80,
                                                  child: Text(
                                                    getTranslated(context, 'Change Password'),
                                                    style: tabTextStyle,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ): Text(getTranslated(context, 'Change Password'),
                                              style: tabTextStyle,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 8,right: 8),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            top: BorderSide(width: 0.5,color: firstTap ? PrimaryColor.withOpacity(0.9):thirdTap ? PrimaryColor.withOpacity(0.9):PrimaryColor),
                                            bottom: BorderSide(width: 0.5,color: firstTap ? PrimaryColor.withOpacity(0.9):thirdTap ? PrimaryColor.withOpacity(0.9):PrimaryColor),
                                            left: BorderSide(width: 0.5,color: firstTap ? PrimaryColor.withOpacity(0.9):thirdTap ? PrimaryColor.withOpacity(0.9):PrimaryColor),
                                            right: BorderSide(width: 0.5,color: firstTap ? PrimaryColor.withOpacity(0.9):thirdTap ? PrimaryColor.withOpacity(0.9):PrimaryColor),

                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(0)),
                                          color: firstTap ? PrimaryColor.withOpacity(0.9):thirdTap ? PrimaryColor.withOpacity(0.9) : PrimaryColor,
                                        ),
                                        child: FlatButton(
                                          shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                          padding: EdgeInsets.all(0),
                                          onPressed: () {
                                            changelay(2);
                                          },
                                          child:secondTap ? Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.check_circle,size: 18,color: TextColor,),
                                              SizedBox(width: 2,),
                                              Text(
                                                getTranslated(context, 'Change Pin'),
                                                style: tabTextStyle,
                                              ),
                                            ],
                                          ):Text(
                                            getTranslated(context, 'Change Pin'),
                                            style: tabTextStyle,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 8,right: 8),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 0.5,
                                            color:secondTap ? PrimaryColor.withOpacity(0.9):firstTap ? PrimaryColor.withOpacity(0.9):PrimaryColor,
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(0)),
                                          color: secondTap ? PrimaryColor.withOpacity(0.9):firstTap? PrimaryColor.withOpacity(0.9) : PrimaryColor,
                                        ),
                                        child: FlatButton(
                                          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                                          padding: EdgeInsets.all(0),
                                          onPressed: (){
                                            changelay(3);
                                          },
                                          child:thirdTap ? Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.check_circle,size: 18,color: TextColor,),
                                              SizedBox(width: 2,),
                                              Text(
                                                getTranslated(context, 'Forgot Pin'),
                                                style: tabTextStyle,
                                              ),
                                            ],
                                          ):Text(
                                            getTranslated(context, 'Forgot Pin'),
                                            style: tabTextStyle,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Visibility(
                            visible: userroll == "master"?false:true,
                            child: Container(
                                child: _widgetOptions1.elementAt(selectedIndex)),
                          ),

                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: PrimaryColor.withOpacity(0.08),
                                      blurRadius: 0,
                                      spreadRadius: 1,
                                      offset: Offset(.0, .0), // shadow direction: bottom right
                                    )
                                  ],
                                ),
                                margin: EdgeInsets.only(left: 10,right: 10,top: 20),
                                child: Container(
                                  padding: EdgeInsets.only(top: 5,bottom: 5),
                                  color: TextColor.withOpacity(0.5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          SizedBox(height: 4,),
                                          Text(getTranslated(context, 'Login Platform'),textAlign: TextAlign.center,style: TextStyle(fontSize: 20,),),

                                          SizedBox(height: 5,),
                                          Divider(height: 0.5,color: PrimaryColor,thickness: 1),
                                          SizedBox(height: 5,),

                                          Text(getTranslated(context, 'loginPlateMsg'),overflow: TextOverflow.clip,textAlign: TextAlign.justify,style: TextStyle(fontSize: 14),)
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Column(
                                        children: [
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Visibility(
                                                        maintainSize: false,
                                                        visible: appVisible,
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets.only(left: 8,right: 10,top: 3,bottom: 3),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      width: 1,
                                                                      color: PrimaryColor.withOpacity(0.2)
                                                                  ),
                                                                  color: TextColor
                                                              ),
                                                              child: Column(
                                                                children: [
                                                                  Container(width:150,child: Text(getTranslated(context, 'App Login Permission'),style: TextStyle(fontSize: 9,color: PrimaryColor),overflow: TextOverflow.ellipsis,)),
                                                                  SizedBox(
                                                                    height: 2 ,
                                                                  ),
                                                                  Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Container(
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                SizedBox(
                                                                                  height: 17,
                                                                                  width: 17,
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(
                                                                                        shape: BoxShape.circle,

                                                                                        color: Colors.green
                                                                                    ),
                                                                                    child: Icon(
                                                                                      Icons.check,
                                                                                      size: 14,
                                                                                      color: TextColor,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 5 ,
                                                                                ),
                                                                                Container(
                                                                                  child: Text(
                                                                                    getTranslated(context, 'Enabled'),
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.normal),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),

                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Visibility(
                                                        maintainSize: false,
                                                        visible: appNotVisible,
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets.only(left: 8,right: 10,top: 3,bottom: 3),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      width: 1,
                                                                      color: PrimaryColor.withOpacity(0.2)
                                                                  ),
                                                                  color: TextColor
                                                              ),
                                                              child: Column(
                                                                children: [
                                                                  Text(getTranslated(context, 'App Login Permission'),style: TextStyle(fontSize: 9,color: PrimaryColor),),
                                                                  SizedBox(
                                                                    height: 2 ,
                                                                  ),
                                                                  Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Container(
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                SizedBox(
                                                                                  height: 17,
                                                                                  width: 17,
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(
                                                                                        shape: BoxShape.circle,

                                                                                        color: Colors.red
                                                                                    ),
                                                                                    child: Icon(
                                                                                      Icons.close,
                                                                                      size: 14,
                                                                                      color: TextColor,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 5 ,
                                                                                ),
                                                                                Container(
                                                                                  child: Text(
                                                                                    getTranslated(context, 'Disabled'),
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.normal),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),

                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      Visibility(
                                                        maintainSize: false,
                                                        visible: webVisible,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets.only(left: 8,right: 10,top: 3,bottom: 3),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      width: 1,
                                                                      color: PrimaryColor.withOpacity(0.2)
                                                                  ),
                                                                  color: TextColor
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                children: [
                                                                  Text(getTranslated(context, 'Web Login Permission'),style: TextStyle(fontSize: 9,color: PrimaryColor),),
                                                                  SizedBox(
                                                                    height: 2 ,
                                                                  ),
                                                                  Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                                        children: [
                                                                          Container(
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                SizedBox(
                                                                                  height: 17,
                                                                                  width: 17,
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(30),
                                                                                        color: Colors.green
                                                                                    ),
                                                                                    child: Icon(
                                                                                      Icons.check,
                                                                                      size: 14,
                                                                                      color: TextColor,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 5 ,
                                                                                ),
                                                                                Container(
                                                                                  child: Text(
                                                                                    getTranslated(context, 'Enabled'),
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.normal),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),

                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Visibility(
                                                        maintainSize: false,
                                                        visible: webNotVisible,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets.only(left: 8,right: 10,top: 3,bottom: 3),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      width: 1,
                                                                      color: PrimaryColor.withOpacity(0.2)
                                                                  ),
                                                                  color: TextColor
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                children: [
                                                                  Text(getTranslated(context, 'Web Login Permission'),style: TextStyle(fontSize: 9,color: PrimaryColor),),
                                                                  SizedBox(
                                                                    height: 2 ,
                                                                  ),
                                                                  Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                                        children: [
                                                                          Container(
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                SizedBox(
                                                                                  height: 17,
                                                                                  width: 17,
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(30),
                                                                                        color: Colors.red
                                                                                    ),
                                                                                    child: Icon(
                                                                                      Icons.close,
                                                                                      size: 14,
                                                                                      color: TextColor,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 5 ,
                                                                                ),
                                                                                Container(
                                                                                  child: Text(
                                                                                    getTranslated(context, 'Disabled'),
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.normal),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),

                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                        ],
                                      ),
                                    ],
                                  )
                                ),
                              ),

                              Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: PrimaryColor.withOpacity(0.08),
                                      blurRadius: 0,
                                      spreadRadius: 1,
                                      offset: Offset(.0, .0), // shadow direction: bottom right
                                    )
                                  ],
                                ),
                                margin: EdgeInsets.only(left: 10,right: 10,top: 20,bottom: 10),
                                child: Container(
                                  padding: EdgeInsets.only(top: 5,bottom: 5),
                                  color: TextColor.withOpacity(0.5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          SizedBox(height: 4,),
                                          Text(getTranslated(context, 'Location Security'),textAlign: TextAlign.center,style: TextStyle(fontSize: 20,),),

                                          SizedBox(height: 5,),
                                          Divider(height: 0.5,color: PrimaryColor,thickness: 1),
                                          SizedBox(height: 5,),
                                          Visibility(
                                            visible: visibleDescription,
                                            child: Text(getTranslated(context, 'locationMsg'),overflow: TextOverflow.clip,textAlign: TextAlign.justify,style: TextStyle(fontSize: 14),)
                                          ),
                                          SizedBox(height: 10,),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Visibility(
                                                  maintainSize: false,
                                                  visible: cityname1.length < 1 ? false:true,
                                                  child: Expanded(
                                                    child: Container(
                                                      padding: EdgeInsets.only(left: 8,right: 10,top: 3,bottom: 3),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 1,
                                                              color: PrimaryColor.withOpacity(0.2)
                                                          ),
                                                          color: TextColor
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(getTranslated(context, 'Location/City'),style: TextStyle(fontSize: 9,color: PrimaryColor),),
                                                          SizedBox(
                                                            height: 2 ,
                                                          ),
                                                          Text( cityname1,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),

                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Visibility(
                                                  maintainSize: false,
                                                  visible:cityname2.length < 1 ? false:true,
                                                  child: Expanded(
                                                    child: Container(
                                                      padding: EdgeInsets.only(left: 8,right: 10,top: 3,bottom: 3),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 1,
                                                              color: PrimaryColor.withOpacity(0.2)
                                                          ),
                                                          color: TextColor
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(getTranslated(context, 'Location/City'),style: TextStyle(fontSize: 9,color: PrimaryColor),),
                                                          SizedBox(
                                                            height: 2 ,
                                                          ),
                                                          Text( cityname2,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),

                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                               Visibility(
                                                 maintainSize: false,
                                                 visible: cityname3.length < 1 ? false:true,
                                                 child: Expanded(
                                                   child: Container(
                                                     padding: EdgeInsets.only(left: 8,right: 10,top: 3,bottom: 3),
                                                     decoration: BoxDecoration(
                                                         border: Border.all(
                                                             width: 1,
                                                             color: PrimaryColor.withOpacity(0.2)
                                                         ),
                                                         color: TextColor
                                                     ),
                                                     child: Column(
                                                       crossAxisAlignment: CrossAxisAlignment.center,
                                                       children: [
                                                         Text(getTranslated(context, 'Location/City'),style: TextStyle(fontSize: 9,color: PrimaryColor),),
                                                         SizedBox(
                                                           height: 2 ,
                                                         ),
                                                         Text( cityname3,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),

                                                       ],
                                                     ),
                                                   ),
                                                 ),
                                               )
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          ),


                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
      ),
    );
  }
}
