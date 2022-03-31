import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cool_alert/cool_alert.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_auth/local_auth.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/HistoryPage/Rechargehistorypage.dart';
import 'package:myapp/ui/pages/locations/IpHelper.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:uuid/uuid.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../../../../../dashboard.dart';
import 'package:http/http.dart' as http;

import '../../../../../dataConnectionLost.dart';
import 'dthRechargePage.dart';

class MobileRecharge extends StatefulWidget {
  const MobileRecharge({Key key}) : super(key: key);

  @override
  _MobileRechargeState createState() => _MobileRechargeState();
}

class _MobileRechargeState extends State<MobileRecharge> with SingleTickerProviderStateMixin {

  var opt, cir;
  String operator = "Operator";
  String operator2 = "Operator";
  String circle = "Circle";
  String circle2 = "Circle";
  List operatorlisr;
  String optcode;
  String optcode2;

  bool _isvisible = false;
  bool _isvisible2 = true;
  bool _isvisible3 = false;

  bool _isloading = false;
  bool _isloading2 = false;
  bool _isloading3 = false;
  bool _isloading4 = false;

  bool amntedit = false;
  bool amntedit2 = false;

  bool isbuttondis = false;
  bool isbuttondis2 = false;
  Position _currentPosition;

  Timer timer;
  String netname, ipadd, modelname, androidid, lat, long, city, address, postcode;
  var status, msz;

  List statesList;
  List offerlist = [];
  List offerlist1 =[];
  List planlist =  [];
  List planlist2 = [];
  List planlist3 = [];
  List planlist4 = [];
  List planlist5 = [];
  List planlist6 = [];
  List planlist7 = [];
  List planlist8 = [];


  ScrollController _controllerList = new ScrollController();

  DateTime selectedDate = DateTime.now();
  DateTime selectedDate2 = DateTime.now();

  String frmDate = "";
  String toDate = "";
  var userid;
  bool isExpand=false;

  List rechhislist = [];
  List<int> list = [];

  int present = 0;
  int perPage;
  int pageIndex = 1;
  List originalItems = [];
  List items = [];

  bool recentHistoryVisible = true;
  bool recentPlanVisible = false;

  void retid() async{

    final storage = new FlutterSecureStorage();
    userid = await storage.read(key: "userId");
    rechargehistory(pageIndex.toString(),userid, frmDate, toDate, "Retailer", "ALL", "ALL", "ALL");
  }

  Future<void> rechargehistory(String pgrind ,String retailerid, String fromdate, String todate, String role, String rechargenum,String status, String optname) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    try{

      var uri =
      new Uri.http("api.vastwebindia.com", "/Recharge/api/data/rem_rch_report", {
        "pageindex": pgrind,
        "pagesize": "500",
        "retailerid": retailerid,
        "fromdate": fromdate,
        "todate": todate,
        "role": role,
        "rechargeNo": rechargenum,
        "status": status,
        "OperatorName": optname,
        "portno":"ALL",
      });
      final http.Response response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // ignore: missing_return
      ).timeout(Duration(seconds: 15), onTimeout: (){
        setState(() {
          _isloading = false;

        });
      });

      print(response);

      if (response.statusCode == 200) {

        setState(() {
          /* loadersho = false;*/
          _isloading = false;
        });

        var data = json.decode(response.body);

        for(int i=0;i<data.length; i++){

          if(i > 4){
            break;
          }else{

            items.add(data[i]);

          }

        }

      } else {
        _isloading = false;
        throw Exception('Failed');
      }


    }catch(e){

      print(e);
    }

  }

  Future<void> Checkcircle(String number) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url1 = new Uri.http("api.vastwebindia.com", "/Recharge/api/Data/Checkcircle", {
      "mobileno": number,
    });

    final http.Response response = await http.post(
      url1,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 15), onTimeout: () {
      setState(() {
        _isloading = false;
      });
      operatordialog();
      statelist();
    });

    print(response);

    if (response.statusCode == 200) {
      _isloading = false;
      _isloading2 = true;
      var data = json.decode(response.body);
      opt = data["Response"]["Operator"];
      cir = data["Response"]["Circle"];

      operator = opt.toString();
      circle = cir.toString();

      _isvisible3 = true;
      recentHistoryVisible = false;
      recentPlanVisible = true;


      if (operator == "" || operator == "BSNL") {
        operator = "Operator";
        circle = "circle";
      }

      bestplan(operator, number);

      for (var i = 0; i < operatorlisr.length; i++) {
        String op = operatorlisr[i]["Operatorname"];

        if (op.contains(operator)) {
          optcode = operatorlisr[i]["OPtCode"];
          break;
        }
      }


      statelist();
    } else {
      _isloading = false;

      throw Exception('Failed');
    }

    setState(() {
      operator;
      circle;
    });
  }

  Future<void> operatorlist(String name) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url1 = new Uri.http("api.vastwebindia.com", "/Recharge/api/data/Optcodelist", {
      "opttype": name,
    });

    final http.Response response = await http.get(
      url1,
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
      _isloading = false;
      var data = json.decode(response.body);
      var datalist = data["myprop2Items"];

      setState(() {
        operatorlisr = datalist;
      });
    } else {
      _isloading = false;

      throw Exception('Failed');
    }
  }

  Future<void> statelist() async {
    String token = "";

    var url = new Uri.http("api.vastwebindia.com", "/Common/api/data/statelist");
    final http.Response response = await http.get(
      url,
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

      setState(() {
        statesList = dataa;
      });
    } else {
      throw Exception('Failed');
    }
  }

  Future<void> bestplan(String operator, String number) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var uri = new Uri.http(
        "api.vastwebindia.com", "/Recharge/api/Data/BestOfferPlan", {
      "optname": operator,
      "mobileno": number,
    });
    final http.Response response = await http.post(
      uri,
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
      var data = json.decode(response.body);
      var offelist = data["Response"];


      /* if (offelist.contains(null) ||
          offerlist1.length == "" ||
          offerlist1.length == 0) {
        plancheking(operator, circle, "FULLTT", "mobile");
      }*/

      setState(() {
        _isvisible = true;
        _isvisible3 = true;
        _isloading2 = false;
        offerlist = offelist;
      });
    } else {
      throw Exception('Failed to load data from internet');
    }
  }

  Future<void> plancheking(String opt, String cir, String name, String typ) async {
    _isvisible2 = true;
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");
    String token = a;

    var uri =
    new Uri.http("api.vastwebindia.com", "/Recharge/api/Data/Plandetails", {
      "optname": opt,
      "circlename": cir,
      "name": name,
      "type": typ,
    });
    final http.Response response = await http.post(
      uri,
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

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var planlistt = data["Response"];

      setState(() {
        _isloading3 = false;
        planlist = planlistt;
      });
    } else {
      throw Exception('Failed to load data from internet');
    }
  }

  Future<void> plancheking2(String opt, String cir, String name, String typ) async {
    _isvisible2 = true;
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");
    String token = a;

    var uri =
    new Uri.http("api.vastwebindia.com", "/Recharge/api/Data/Plandetails", {
      "optname": opt,
      "circlename": cir,
      "name": name,
      "type": typ,
    });
    final http.Response response = await http.post(
      uri,
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

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var planlistt = data["Response"];

      setState(() {
        _isloading3 = false;
        planlist2 = planlistt;
      });
    } else {
      throw Exception('Failed to load data from internet');
    }
  }

  Future<void> plancheking3(String opt, String cir, String name, String typ) async {
    _isvisible2 = true;
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");
    String token = a;

    var uri =
    new Uri.http("api.vastwebindia.com", "/Recharge/api/Data/Plandetails", {
      "optname": opt,
      "circlename": cir,
      "name": name,
      "type": typ,
    });
    final http.Response response = await http.post(
      uri,
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

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var planlistt = data["Response"];

      setState(() {
        _isloading3 = false;
        planlist3 = planlistt;
      });
    } else {
      throw Exception('Failed to load data from internet');
    }
  }

  Future<void> plancheking4(String opt, String cir, String name, String typ) async {
    _isvisible2 = true;
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");
    String token = a;

    var uri =
    new Uri.http("api.vastwebindia.com", "/Recharge/api/Data/Plandetails", {
      "optname": opt,
      "circlename": cir,
      "name": name,
      "type": typ,
    });
    final http.Response response = await http.post(
      uri,
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

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var planlistt = data["Response"];

      setState(() {
        _isloading3 = false;
        planlist4 = planlistt;
      });
    } else {
      throw Exception('Failed to load data from internet');
    }
  }

  Future<void> plancheking5(String opt, String cir, String name, String typ) async {
    _isvisible2 = true;
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");
    String token = a;

    var uri =
    new Uri.http("api.vastwebindia.com", "/Recharge/api/Data/Plandetails", {
      "optname": opt,
      "circlename": cir,
      "name": name,
      "type": typ,
    });
    final http.Response response = await http.post(
      uri,
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

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var planlistt = data["Response"];

      setState(() {
        _isloading3 = false;
        planlist5 = planlistt;
      });
    } else {
      throw Exception('Failed to load data from internet');
    }
  }

  Future<void> plancheking6(String opt, String cir, String name, String typ) async {
    _isvisible2 = true;
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");
    String token = a;

    var uri =
    new Uri.http("api.vastwebindia.com", "/Recharge/api/Data/Plandetails", {
      "optname": opt,
      "circlename": cir,
      "name": name,
      "type": typ,
    });
    final http.Response response = await http.post(
      uri,
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

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var planlistt = data["Response"];

      setState(() {
        _isloading3 = false;
        planlist6 = planlistt;
      });
    } else {
      throw Exception('Failed to load data from internet');
    }
  }

  Future<void> plancheking7(String opt, String cir, String name, String typ) async {
    _isvisible2 = true;
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");
    String token = a;

    var uri =
    new Uri.http("api.vastwebindia.com", "/Recharge/api/Data/Plandetails", {
      "optname": opt,
      "circlename": cir,
      "name": name,
      "type": typ,
    });
    final http.Response response = await http.post(
      uri,
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

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var planlistt = data["Response"];

      setState(() {
        _isloading3 = false;
        planlist7 = planlistt;
      });
    } else {
      throw Exception('Failed to load data from internet');
    }
  }

  Future<void> plancheking8(String opt, String cir, String name, String typ) async {
    _isvisible2 = true;
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");
    String token = a;

    var uri =
    new Uri.http("api.vastwebindia.com", "/Recharge/api/Data/Plandetails", {
      "optname": opt,
      "circlename": cir,
      "name": name,
      "type": typ,
    });
    final http.Response response = await http.post(
      uri,
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

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var planlistt = data["Response"];

      setState(() {
        _isloading3 = false;
        planlist8 = planlistt;
      });
    } else {
      throw Exception('Failed to load data from internet');
    }
  }

  Future<String> dataconnection() async{

    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => DataConnectionLost()));


    }
  }

  Future<void> rechtask(String id, String num, String opt, String amnt, String lat, String long, String city, String address, String pin, String intype, String ipadd, String model, String key, String iv) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    try {
      var uri =
      new Uri.http("api.vastwebindia.com", "/Recharge/api/data/hkhk2", {
        "rd": id,
        "n": num,
        "ok": opt,
        "amn": amnt,
        "pc": "",
        "bu": "",
        "acno": "",
        "lt": "",
        "ip": ipadd,
        "mc": "",
        "em": "",
        "offerprice": "",
        "commAmount": "",
        "Devicetoken": city,
        "Latitude": lat,
        "Longitude": long,
        "ModelNo": model,
        "City": city,
        "PostalCode": pin,
        "InternetTYPE": intype,
        "Addresss": address,
        "value1": key,
        "value2": iv
      });
      final http.Response response = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // ignore: missing_return
      ).timeout(Duration(seconds: 12), onTimeout: (){
        setState(() {
          setState(() {
            _isloading4 = false;
          });
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
                                    builder: (context) => Rechargehistory()));

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
        setState(() {
          _isloading4 = false;
        });
        var data = json.decode(response.body);
        status = data["Response"];
        msz = data["Message"];

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
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Dashboard()));
            },
          );
        } else {

          CoolAlert.show(
            backgroundColor: PrimaryColor.withOpacity(0.6),
            context: context,
            type: CoolAlertType.confirm,
            text: msz,
            title: status,
            confirmBtnText: 'Stay Page',
            confirmBtnColor: Colors.orange,
            onConfirmBtnTap: (){
              Navigator.of(context).pop();
            },
            cancelBtnText: 'Back To Home',
            cancelBtnTextStyle: TextStyle(
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.solid,
              color: Colors.red,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),

            onCancelBtnTap: (){
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Dashboard()));
            },

          );
        }
      } else {
        _isloading4 = false;
        throw Exception('Failed');
      }
    } catch (e) {}
  }

  final TextEditingController controller = TextEditingController();
  final TextEditingController amntcontroller = TextEditingController();

  final TextEditingController postnumber = TextEditingController();
  final TextEditingController postamntcontroller = TextEditingController();

  TextEditingController _textController = TextEditingController();
  ScrollController listSlide = ScrollController();

  void operatordialog(){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState){
            return Container(
              color: Colors.black.withOpacity(0.8),
              child: AlertDialog(
                buttonPadding: EdgeInsets.all(0),
                titlePadding: EdgeInsets.all(0),
                contentPadding: EdgeInsets.only(left: 10,right: 10),
                title: Container(
                  child: Column(
                    children: [
                      Container(
                        color:PrimaryColor,
                        padding: EdgeInsets.only(top: 8,),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 8,left: 8,right: 8),
                          color: PrimaryColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(getTranslated(context, 'Select Your Operator'),
                                  style: TextStyle(color: TextColor, fontSize: 18,),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),

                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 8,bottom: 8,left: 10,right: 10),
                        color: PrimaryColor.withOpacity(0.9),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {

                            });
                          },
                          controller: _textController,
                          decoration: InputDecoration(
                            labelText:getTranslated(context, 'Search'),
                            hintText:getTranslated(context, 'Search'),
                            labelStyle: TextStyle(color: TextColor),
                            hintStyle: TextStyle(color: TextColor),
                            contentPadding: EdgeInsets.only(left: 25),
                            suffixIcon:Icon(Icons.search,color: TextColor,) ,
                            border: OutlineInputBorder(
                                gapPadding: 1,
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(width: 1,color: TextColor)
                            ),
                            enabledBorder: OutlineInputBorder(
                                gapPadding: 1,
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(width: 1,color: TextColor)
                            ),
                            focusedBorder:  OutlineInputBorder(
                                gapPadding: 1,
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(width: 1,color: TextColor)
                            ),
                          ),
                          style: TextStyle(color: TextColor, fontSize: 18,),
                          cursorColor: TextColor,
                          cursorHeight: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                content: Container(// Change as per your requirement
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Container(
                        child: ListView.builder(
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          controller: listSlide,
                          itemCount: operatorlisr.length,
                          itemBuilder: (context,  index) {
                            if (_textController.text.isEmpty) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          style: ButtonStyle(
                                            overlayColor: MaterialStateProperty.all(Colors.transparent) ,
                                            shadowColor: MaterialStateProperty.all(Colors.transparent),
                                            backgroundColor:MaterialStateProperty.all(Colors.transparent) ,
                                            padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                                          ),
                                          onPressed: (){
                                            setState(() {
                                              operator = operatorlisr[index]["Operatorname"];
                                              operator2 = operatorlisr[index]["Operatorname"];
                                              optcode = operatorlisr[index]["OPtCode"];
                                              optcode2 = operatorlisr[index]["OPtCode"];

                                              if (operator == "Idea" || operator == "Airtel" || operator == "Vodafone") {
                                                setState(() {
                                                  _isloading2 = true;
                                                });
                                                bestplan(operator, controller.text);

                                              } else {
                                                setState(() {
                                                  _isloading2 = true;
                                                });
                                                plancheking(operator, circle, "FULLTT", "mobile");
                                              }

                                              Navigator.of(context).pop();
                                            });
                                            statedialog();
                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(operatorlisr[index]["Operatorname"],textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(height: 1,color: PrimaryColor,margin: EdgeInsets.only(top: 0,bottom: 0),)
                                ],
                              );
                            } else if (operatorlisr[index]["Operatorname"]
                                .toLowerCase()
                                .contains(_textController.text)) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          style: ButtonStyle(
                                            padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                                          ),
                                          onPressed: (){
                                            setState(() {
                                              operator = operatorlisr[index]["Operatorname"];
                                              operator2 = operatorlisr[index]["Operatorname"];
                                              optcode = operatorlisr[index]["OPtCode"];
                                              optcode2 = operatorlisr[index]["OPtCode"];

                                              if (operator == "Idea" || operator == "Airtel" || operator == "Vodafone") {
                                                setState(() {
                                                  _isloading2 = true;
                                                });
                                                bestplan(operator, controller.text);
                                              } else {
                                                setState(() {
                                                  _isloading2 = true;
                                                });
                                                plancheking(operator, circle, "FULLTT", "mobile");
                                              }

                                              _textController.clear();
                                              Navigator.of(context).pop();
                                            });
                                            statedialog();
                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(operatorlisr[index]["Operatorname"],textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(height: 1,color: PrimaryColor,margin: EdgeInsets.only(top: 0,bottom: 0),)
                                ],
                              );
                            } else {
                              return Container(
                              );
                            }

                          },
                        ),),
                    )
                ),
              ),
            );
          });
        });

  }
  void statedialog(){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState){
            return Container(
              color: Colors.black.withOpacity(0.8),
              child: AlertDialog(
                buttonPadding: EdgeInsets.all(0),
                titlePadding: EdgeInsets.all(0),
                contentPadding: EdgeInsets.only(left: 10,right: 10),
                title: Container(
                  child: Column(
                    children: [
                      Container(
                        color:PrimaryColor,
                        padding: EdgeInsets.only(top: 8,),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 8,left: 8,right: 8),
                          color: PrimaryColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text('Select Your Circle'.toUpperCase(),
                                  style: TextStyle(color: TextColor, fontSize: 18,),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),

                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 8,bottom: 8,left: 10,right: 10),
                        color: PrimaryColor.withOpacity(0.9),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {

                            });
                          },
                          controller: _textController,
                          decoration: InputDecoration(
                            labelText:getTranslated(context, 'Search'),
                            hintText:getTranslated(context, 'Search'),
                            labelStyle: TextStyle(color: TextColor),
                            hintStyle: TextStyle(color: TextColor),
                            contentPadding: EdgeInsets.only(left: 25),
                            suffixIcon:Icon(Icons.search,color: TextColor,) ,
                            border: OutlineInputBorder(
                                gapPadding: 1,
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(width: 1,color: TextColor)
                            ),
                            enabledBorder: OutlineInputBorder(
                                gapPadding: 1,
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(width: 1,color: TextColor)
                            ),
                            focusedBorder:  OutlineInputBorder(
                                gapPadding: 1,
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(width: 1,color: TextColor)
                            ),
                          ),
                          style: TextStyle(color: TextColor, fontSize: 18,
                          ),
                          cursorColor: TextColor,
                          cursorHeight: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                content: Container(// Change as per your requirement
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Container(
                        child: ListView.builder(
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          controller: listSlide,
                          itemCount: statesList.length,
                          itemBuilder: (context,  index) {
                            if (_textController.text.isEmpty) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          style: ButtonStyle(
                                            overlayColor: MaterialStateProperty.all(Colors.transparent) ,
                                            shadowColor: MaterialStateProperty.all(Colors.transparent),
                                            backgroundColor:MaterialStateProperty.all(Colors.transparent) ,
                                            padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                                          ),
                                          onPressed: (){
                                            setState(() {
                                              circle = statesList[index]["State Name"];
                                              circle2 = statesList[index]["State Name"];
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(statesList[index]["State Name"],textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(height: 1,color: PrimaryColor,margin: EdgeInsets.only(top: 0,bottom: 0),)
                                ],
                              );
                            } else if (statesList[index]["State Name"]
                                .toLowerCase()
                                .contains(_textController.text)) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          style: ButtonStyle(
                                            padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                                          ),
                                          onPressed: (){
                                            setState(() {
                                              circle = statesList[index]["State Name"];
                                              circle2 = statesList[index]["State Name"];
                                              _textController.clear();
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(statesList[index]["State Name"],textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(height: 1,color: PrimaryColor,margin: EdgeInsets.only(top: 0,bottom: 0),)
                                ],
                              );
                            } else {
                              return Container(
                              );
                            }

                          },
                        ),),
                    )
                ),
              ),
            );
          });
        });

  }

  double _dragPercentage = 0;


  @override
  void initState() {
    // TODO: implement initState
    dataconnection();
    frmDate = "${selectedDate2.toLocal()}".split(' ')[0];
    toDate = "${selectedDate.toLocal()}".split(' ')[0];
    retid();
    _tabController = TabController(length: 9, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
    super.initState();
    statelist();
    getCurrentLocation();
    operatorlist("Prepaid");
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }
  final List<Color> colors = [
    Colors.red[900],
    Colors.green[900],
    Colors.blue[900],
    Colors.brown[900]
  ];

  final List<int> duration = [900, 700, 600, 800, 500];
  @override

  void _handleTabIndex() {
    if (_tabController.index == 1) {
      if (planlist.length == 0) {
        setState(() {
          _isloading3 = true;
        });

        plancheking(operator, circle, "FULLTT", "mobile");
      }
    } else if (_tabController.index == 2) {
      if (planlist2.length == 0) {
        setState(() {
          _isloading3 = true;
        });
        plancheking2(operator, circle, "TOPUP", "mobile");
      }
    } else if (_tabController.index == 3) {
      if (planlist3.length == 0) {
        setState(() {
          _isloading3 = true;
        });
        plancheking3(operator, circle, "DATA", "mobile");
      }
    } else if (_tabController.index == 4) {
      if (planlist4.length == 0) {
        setState(() {
          _isloading3 = true;
        });
        plancheking4(operator, circle, "SMS", "mobile");
      }
    } else if (_tabController.index == 5) {
      if (planlist5.length == 0) {
        setState(() {
          _isloading3 = true;
        });
        plancheking5(operator, circle, "Romaing", "mobile");
      }
    } else if (_tabController.index == 6) {
      if (planlist6.length == 0) {
        setState(() {
          _isloading3 = true;
        });
        plancheking6(operator, circle, "FRC", "mobile");
      }
    } else if (_tabController.index == 7) {
      if (planlist7.length == 0) {
        setState(() {
          _isloading3 = true;
        });
        plancheking7(operator, circle, "STV", "mobile");
      }
    } else if (_tabController.index == 8) {
      if (planlist8.length == 0) {
        setState(() {
          _isloading3 = true;
        });
        plancheking8(operator, circle, "JioPhone", "mobile");
      }
    }
  }

  bool viewVisible = true;
  bool btnvisible = true;
  bool viewVisible1 = false;
  bool _isButtonDisabled = false;
  bool _isButtonDisabled2 = false;
  final GlobalKey dropdownKey = GlobalKey();

  void showWidget() {
    setState(() {
      viewVisible = true;
      viewVisible1 = false;
    });
  }

  void hideWidget() {
    setState(() {
      viewVisible = false;
      viewVisible1 = true;
    });
  }

  TabController _tabController ;
  bool test = false;
  bool test1 = false;
  double tabHeight;

  @override
  Widget build(BuildContext context) {

    return AppBarWidget(
      title: CenterAppbarTitleImage(
        svgImage: 'assets/pngImages/mobile-phone.png',
        topText:getTranslated(context, 'Selected Info'),
        selectedItemName:getTranslated(context, 'Mobile Recharge'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                /*select Option=============*/
                SizedBox(
                  height: 20,
                ),
                /*Recharge Tab Bar============*/
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showWidget();
                          operatorlist("Prepaid");
                          operator = "Operator";
                          circle = "Circle";
                          postnumber.clear();
                          postamntcontroller.clear();
                          controller.clear();
                          amntcontroller.clear();
                          isbuttondis = false;
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                            top: viewVisible1 ? 7 : 6,
                            bottom: viewVisible1 ? 8 : 6,
                            right: viewVisible1 ? 20 : 8,
                            left: viewVisible1 ? 20 : 8,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(border: Border.all(color: SecondaryColor,),
                              borderRadius: BorderRadius.all(Radius.circular(50))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(viewVisible ? Icons.check_circle : Icons.check_circle,color:SecondaryColor, size: viewVisible ? 19 : 0,),
                              SizedBox(
                                width: viewVisible ? 5 : 0,
                              ),
                              Container(
                                child: Text(getTranslated(context, 'Prepaid').toUpperCase(),
                                  style: TextStyle(
                                      fontWeight: viewVisible
                                          ? FontWeight.bold
                                          : viewVisible1
                                          ? FontWeight.normal
                                          : FontWeight.normal),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          hideWidget();
                          operatorlist("Postpaid");
                          operator2 = "Operator";
                          circle = "Circle";
                          controller.clear();
                          amntcontroller.clear();
                          postnumber.clear();
                          postamntcontroller.clear();
                          isbuttondis2 = false;
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                            top: viewVisible ? 7 : 6,
                            bottom: viewVisible ? 7 : 6,
                            right: viewVisible ? 18 : 5,
                            left: viewVisible ? 18 : 5,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: SecondaryColor,
                              ),
                              borderRadius:
                              BorderRadius.all(Radius.circular(50))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                viewVisible1 ? Icons.check_circle : Icons.check_circle,color:SecondaryColor, size: viewVisible1 ? 19 : 0,
                              ),
                              SizedBox(
                                width: viewVisible1 ? 5 : 0,
                              ),
                              Container(
                                child: Text(
                                  getTranslated(context, 'Postpaid'),
                                  style: TextStyle(
                                      fontWeight: viewVisible1 ? FontWeight.bold : viewVisible ? FontWeight.normal : FontWeight.normal),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Column(
                        children: <Widget>[
                          Container(
                            child: Container(
                              child: Column(
                                children: [
                                  /*PrePaid*/
                                  Visibility(
                                    maintainSize: false,
                                    maintainAnimation: true,
                                    maintainState: true,
                                    visible: viewVisible,
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              const BorderRadius.all(
                                                const Radius.circular(10.0),
                                              ),
                                            ),
                                            child: TextFormField(
                                              inputFormatters: [new FilteringTextInputFormatter.allow(RegExp("[0-9]")),],
                                              controller: controller,
                                              keyboardType: TextInputType.number,
                                              onChanged: (String value) async {
                                                if (value.length == 10) {

                                                  setState(() {
                                                    _isloading = true;
                                                    test = true;
                                                    amntedit = true;
                                                    isbuttondis = true;
                                                    tabHeight = MediaQuery.of(context).size.height / 1;
                                                  });
                                                  FocusScopeNode currentFocus =
                                                  FocusScope.of(context);
                                                  currentFocus.unfocus();
                                                  Checkcircle(controller.text);

                                                } else if (value.length == 0) {
                                                  setState(() {
                                                    amntcontroller.clear();
                                                    _isvisible = false;
                                                    _isvisible2 = false;
                                                    _isvisible3 = false;
                                                    test = false;
                                                    operator = "Operator";
                                                    circle = "Circle";
                                                    planlist.clear();
                                                    isbuttondis = false;
                                                    tabHeight = 100;
                                                  });
                                                }
                                              },
                                              maxLength: 10,
                                              buildCounter:
                                                  (BuildContext context,
                                                  {int currentLength,
                                                    int maxLength,
                                                    bool isFocused}) =>
                                              null,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(top: 18,bottom: 18,left: 10),
                                                labelStyle: TextStyle(
                                                    color: PrimaryColor,fontSize: 14),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    width: 0,
                                                    color: PrimaryColor,
                                                  ),
                                                ),
                                                prefixText: "+91 ",
                                                labelText:getTranslated(context, 'Mobile Number'),
                                                suffixIcon: IconButton(
                                                  icon: _isloading
                                                      ? Center(
                                                    child: SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                      child: CircularProgressIndicator(
                                                          valueColor: AlwaysStoppedAnimation<Color>(SecondaryColor)),
                                                    ),
                                                  )
                                                      : Icon(
                                                    Icons.contacts,
                                                    color: SecondaryColor,
                                                  ),
                                                  onPressed: ()async{

                                                    final PhoneContact contact = await FlutterContactPicker.pickPhoneContact();
                                                    String num = contact.phoneNumber.number;
                                                    String number = num.replaceAll("+91", "");
                                                    setState(() {
                                                      controller.text = number.replaceAll(" ", "");
                                                    });

                                                    if(controller.text.length == 10){

                                                      setState(() {
                                                        _isloading = true;
                                                        test = true;
                                                        amntedit = true;
                                                        isbuttondis = true;
                                                      });

                                                      FocusScopeNode currentFocus = FocusScope.of(context);
                                                      currentFocus.unfocus();
                                                      Checkcircle(controller.text);
                                                    }

                                                  },
                                                ),
                                              ),
                                              style: TextStyle( fontSize: 18, color: PrimaryColor,letterSpacing: 0.2),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "null";
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.all(10),
                                                  child: OutlineButton(
                                                    onPressed: isbuttondis == false ? null : operatordialog,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                                    splashColor: Colors.transparent,
                                                    hoverColor: Colors.transparent,
                                                    clipBehavior: Clip.none,
                                                    autofocus: false,
                                                    disabledBorderColor:PrimaryColor,
                                                    color: Colors.transparent,
                                                    highlightColor:Colors.transparent,
                                                    highlightedBorderColor: PrimaryColor,
                                                    focusColor: PrimaryColor,
                                                    padding: EdgeInsets.only(top: 16, bottom: 16, left: 10, right: 10),
                                                    borderSide: BorderSide(width: 1, color: PrimaryColor),
                                                    child: Container(
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              operator,
                                                              overflow:TextOverflow.ellipsis,
                                                              maxLines: 1,
                                                              softWrap: true,
                                                              style: TextStyle(color: PrimaryColor,fontWeight:FontWeight.normal, fontSize: 18,),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 20,
                                                            child: Icon(Icons.arrow_drop_down, color: PrimaryColor,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.all(10),
                                                  child: OutlineButton(
                                                    onPressed:isbuttondis == false ? null: statedialog,
                                                    shape:RoundedRectangleBorder(
                                                      borderRadius:BorderRadius.circular(4),
                                                    ),
                                                    splashColor: Colors.transparent,
                                                    hoverColor: Colors.transparent,
                                                    clipBehavior: Clip.none,
                                                    autofocus: false,
                                                    disabledBorderColor: PrimaryColor,
                                                    color: Colors.transparent,
                                                    highlightColor: Colors.transparent,
                                                    highlightedBorderColor: PrimaryColor,
                                                    focusColor: PrimaryColor,
                                                    padding: EdgeInsets.only(top: 16, bottom: 16, left: 10, right: 10),
                                                    borderSide: BorderSide(width: 1, color: PrimaryColor),
                                                    child: Container(
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(circle, overflow: TextOverflow.ellipsis,
                                                              maxLines: 1,
                                                              softWrap: true,
                                                              style: TextStyle(color: PrimaryColor, fontWeight: FontWeight.normal, fontSize: 18,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 20,
                                                            child: Icon(Icons.arrow_drop_down, color: PrimaryColor),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 0,
                                          ),
                                          StickyHeader(
                                            overlapHeaders: false,
                                            header: Container(
                                              color: TextColor,
                                              child: Column(children: [
                                                Container(
                                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                                  decoration: BoxDecoration(
                                                    borderRadius: const BorderRadius.all(const Radius.circular(10.0),
                                                    ),
                                                  ),
                                                  child: TextFormField(
                                                    inputFormatters: [new FilteringTextInputFormatter.allow(RegExp("[0-9]")),],
                                                    enabled: amntedit,
                                                    controller: amntcontroller,
                                                    keyboardType: TextInputType.number,
                                                    decoration: InputDecoration(
                                                      contentPadding: EdgeInsets.only(top: 18,bottom: 18,left: 10),
                                                      disabledBorder: OutlineInputBorder(),
                                                      labelStyle: TextStyle(
                                                          color: PrimaryColor,fontSize: 14),
                                                      border:
                                                      OutlineInputBorder(
                                                        borderSide: BorderSide(width: 0,color: PrimaryColor,
                                                        ),
                                                      ),
                                                      labelText:getTranslated(context, 'Enter Amount'),
                                                    ),
                                                    maxLength: 4,
                                                    onChanged: (String value) {
                                                      if (value.length > 0) {
                                                        setState(() {
                                                          _isButtonDisabled = true;
                                                        });
                                                      } else if (value.length == 0) {
                                                        setState(() {
                                                          _isButtonDisabled = false;
                                                        });
                                                      }
                                                    },
                                                    buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        return "null";
                                                      }
                                                      return null;
                                                    },
                                                    style: TextStyle( fontSize: 18, color: PrimaryColor),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Visibility(
                                                          visible: btnvisible,
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                width: MediaQuery.of(context).size.width,
                                                                margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                                                                child: OutlinedButton(
                                                                  style: OutlinedButton.styleFrom(padding: EdgeInsets.all(15),
                                                                    backgroundColor: SecondaryColor,
                                                                    shadowColor: Colors.transparent,
                                                                  ),
                                                                  onPressed: _isButtonDisabled == false ? null : () async {

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
                                                                      _isloading4 = true;
                                                                    });

                                                                    showDialog(
                                                                        barrierDismissible: false,
                                                                        context: context,
                                                                        builder: (BuildContext context) {
                                                                          return CustomDialogWidget(
                                                                            buttonText:getTranslated(context, 'Pay Now'),
                                                                            description:getTranslated(context, 'Mobile Number'),
                                                                            description0: controller.text,
                                                                            description1:getTranslated(context, 'Operator Name'),
                                                                            description01: operator,
                                                                            textStyle: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w800),
                                                                            description2:getTranslated(context, 'Recharge Amount'),
                                                                            description02: amntcontroller.text,
                                                                            title:getTranslated(context, 'Please Verify Below Details'),
                                                                            icon: Icons.help,
                                                                            buttonText1:getTranslated(context, 'Cancel'),
                                                                            buttonColor1: PrimaryColor,
                                                                            buttonColor: SecondaryColor,
                                                                            onpress2: () {
                                                                              Navigator.of(context).pop();
                                                                              setState(() {
                                                                                _isloading4 = true;
                                                                              });

                                                                              FocusScopeNode currentFocus = FocusScope.of(context);
                                                                              currentFocus.unfocus();

                                                                              rechdetails(controller.text, optcode, amntcontroller.text, "lat", "long", "city", "address", "postcode", netname, ipadd, androidid);
                                                                            },
                                                                            onpress: () {
                                                                              setState(() {
                                                                                _isloading4 = false;
                                                                              });

                                                                              Navigator.of(context).pop();
                                                                            },
                                                                          );
                                                                        });
                                                                  },

                                                                  child: _isloading4 ? Center(
                                                                    child: SizedBox(height: 20,
                                                                      child:
                                                                      LinearProgressIndicator(
                                                                        backgroundColor:
                                                                        PrimaryColor,
                                                                        valueColor:
                                                                        AlwaysStoppedAnimation<Color>(Colors.white),
                                                                      ),
                                                                    ),
                                                                  )
                                                                      : Text("Next", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18,
                                                                  )),
                                                                ),

                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Container(
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Column(
                                                                      children: [
                                                                        GestureDetector(
                                                                            onTap: (){
                                                                              setState(() {

                                                                                if(_isvisible3 == true){
                                                                                  _isvisible3 = false;
                                                                                  recentHistoryVisible = true;
                                                                                  recentPlanVisible = false;
                                                                                  offerlist.clear();
                                                                                  planlist.clear();
                                                                                  planlist2.clear();
                                                                                  planlist3.clear();
                                                                                  planlist4.clear();
                                                                                  planlist5.clear();
                                                                                  planlist6.clear();
                                                                                  planlist7.clear();
                                                                                  planlist8.clear();
                                                                                }
                                                                              });

                                                                            },
                                                                            child: Container(
                                                                                padding: EdgeInsets.only(left: 5),
                                                                                child: Text("Recent 5 Transaction", style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),))),

                                                                        SizedBox(
                                                                          height: 5,
                                                                        ),

                                                                        Visibility(
                                                                          visible: recentHistoryVisible,
                                                                          child: Container(
                                                                            height: 2,
                                                                            width: 135,
                                                                            color: Colors.black,
                                                                            margin: EdgeInsets.only(left:8,),

                                                                          ),
                                                                        ),

                                                                      ],
                                                                    ),
                                                                    Column(
                                                                      children: [
                                                                        GestureDetector(
                                                                            onTap: (){
                                                                              setState(() {

                                                                                if(_isvisible3 == false){
                                                                                  _isvisible3 = true;
                                                                                  recentHistoryVisible = false;
                                                                                  recentPlanVisible = true;

                                                                                }else{

                                                                                }


                                                                              });

                                                                            },
                                                                            child: Container(
                                                                                padding: EdgeInsets.only(right: 10),
                                                                                child: Text("Best Plans/Offers", style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),))),

                                                                        SizedBox(
                                                                          height:5,
                                                                        ),
                                                                        Visibility(
                                                                          visible: recentPlanVisible,
                                                                          child: Container(
                                                                            margin: EdgeInsets.only(right:10,),
                                                                            width: 120,
                                                                            height:2,
                                                                            color: Colors.black,
                                                                          ),
                                                                        ),

                                                                      ],
                                                                    ),

                                                                  ],
                                                                ),
                                                              ),

                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                Visibility(
                                                  visible: _isvisible3,
                                                  replacement: SingleChildScrollView(
                                                    child: Container(
                                                      color: TextColor,
                                                      child: Container(
                                                        margin: EdgeInsets.only(left: 8,right: 8),
                                                        child: ListView.builder(
                                                          controller: _controllerList,
                                                          shrinkWrap: true,
                                                          padding: EdgeInsets.zero,
                                                          scrollDirection: Axis.vertical,
                                                          itemCount: (present <= originalItems.length) ? items.length + 1 : items.length,
                                                          itemBuilder: (BuildContext context, int index) {
                                                            if ((index == items.length )) {
                                                              return originalItems.length > 20 ? Container(
                                                                margin: EdgeInsets.only(left: 0,right: 0,top: 20),
                                                                color: SecondaryColor,
                                                              ) :Container(
                                                                child: Text(""),
                                                              );
                                                            } else {
                                                              return
                                                                Container(
                                                                  margin: EdgeInsets.only(top: 5),
                                                                  padding: EdgeInsets.all(1),
                                                                  decoration: BoxDecoration(
                                                                    color: SecondaryColor.withOpacity(0.04),
                                                                    border: Border.all(width: 1,color: SecondaryColor.withOpacity(0.09),),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors.white38,
                                                                        blurRadius: 0.5,
                                                                        spreadRadius: 0,
                                                                        offset: Offset(0.0, .0), // shadow direction: bottom right
                                                                      )
                                                                    ],
                                                                  ),
                                                                  child: Container(
                                                                    child:Container(
                                                                      child: Container(
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Container(
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    children: [
                                                                                      Container(
                                                                                        alignment: Alignment.centerRight,
                                                                                        color: items[index]["Status"] == "SUCCESS" ? Colors.green
                                                                                            : items[index]["Status"] == "Pending" ? Colors.yellow[800]
                                                                                            : items[index]["Status"] == "FAILED" ? Colors.red
                                                                                            : Colors.deepPurple,
                                                                                        child: Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                                              children: [
                                                                                                items[index]["Status"] == "SUCCESS" ? Icon(Icons.check_circle,color: Colors.white,size: 32,) : items[index]["Status"] == "Pending" ? Icon(Icons.watch_later,color: Colors.white,size: 32,) :items[index]["Status"] == "FAILED" ?Icon(Icons.cancel,color: Colors.white,size: 32,) : Container(child: Icon(Icons.replay_circle_filled,color: Colors.white,size: 40,)),

                                                                                              ],
                                                                                            ),

                                                                                          ],
                                                                                        ),
                                                                                      ),

                                                                                      Container(
                                                                                        padding: EdgeInsets.only(left: 5,),
                                                                                        child: Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          children: [
                                                                                            Text(items[index]["Reqesttime"].toString(),overflow: TextOverflow.ellipsis,textAlign: TextAlign.right,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                                                            SizedBox(height: 4,),

                                                                                            Row(
                                                                                              children: [
                                                                                                Text(items[index]["Recharge_number"].toString(),overflow: TextOverflow.ellipsis,textAlign: TextAlign.right,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)
                                                                                              ],
                                                                                            )

                                                                                          ],
                                                                                        ),
                                                                                      ),


                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                  child: Container(
                                                                                    margin: EdgeInsets.only(right:5,),
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                                                      children: [
                                                                                        Text(" \u{20B9} " + items[index]["Recharge_amount"].toString(),textAlign: TextAlign.right,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold)),
                                                                                        SizedBox(height: 3,),
                                                                                        Row(
                                                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                                                          children: [
                                                                                            Flexible(child: Text(items[index]["Operator_name"].toString().toLowerCase(),overflow: TextOverflow.clip,textAlign: TextAlign.right,style: TextStyle(fontSize: 12 ,fontWeight: FontWeight.bold),)),
                                                                                          ],
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),


                                                                              ],
                                                                            ),
                                                                            /*Visibility(
                                              visible: items[index]["Operator_name"] == "Sun Direct" && items[index]["Status"] == "SUCCESS"?true:false,
                                              child: Row(
                                                crossAxisAlignment:CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                  child: Container(
                                                    child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Heavy Request",textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                                      SizedBox(height: 2,),
                                                      IconButton(
                                                        onPressed: (){
                                                          String opeStatus = items[index]["Status"];
                                                          if(opeStatus == "SUCCESS"){

                                                            String opeConsumer = items[index]["Operator_name"];
                                                            String opeNumber = items[index]["Recharge_number"];
                                                            heavyRequest(opeConsumer, opeNumber);

                                                          }

                                                        },
                                                        icon: Icon(Icons.refresh,color: SecondaryColor,),
                                                      ),

                                                    ],
                                                    ),
                                                  ),
                                                  ),


                                                ],
                                              ),
                                            ),*/
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),

                                                                    /*children: [
                                                                      Column(
                                                                        children: [
                                                                          Container(
                                                                            margin: EdgeInsets.only(top: 0,bottom: 8),
                                                                            height: 1,
                                                                            color: PrimaryColor.withOpacity(0.1),
                                                                          ),
                                                                          Container(
                                                                            child: Container(
                                                                              child: Container(
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Container(
                                                                                      child:Column(
                                                                                        children: [
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            children: [
                                                                                              Expanded(
                                                                                                child: Container(
                                                                                                  alignment: Alignment.centerLeft,
                                                                                                  child: Column(
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    children: [
                                                                                                      Text(
                                                                                                        getTranslated(context, 'Requst ID'),
                                                                                                        style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),
                                                                                                        overflow: TextOverflow.ellipsis,softWrap: true,textAlign: TextAlign.left,),
                                                                                                      SizedBox(height: 2,),
                                                                                                      SelectableText(
                                                                                                        items[index]["Request_ID"].toString(),textAlign: TextAlign.right,
                                                                                                      )
                                                                                                      //Text(items[index]["Request_ID"].toString(),textAlign: TextAlign.right,)
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              Expanded(
                                                                                                child: Container(
                                                                                                  alignment: Alignment.centerRight,
                                                                                                  child: Column(
                                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                                                    children: [
                                                                                                      Text(
                                                                                                        getTranslated(context, 'Operator ID'),
                                                                                                        style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),
                                                                                                        overflow: TextOverflow.ellipsis,softWrap: true,textAlign: TextAlign.right,),
                                                                                                      SizedBox(height: 2,),
                                                                                                      SelectableText(items[index]["Operatorid"].toString(),textAlign: TextAlign.right,)
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          Container(
                                                                                            margin: EdgeInsets.only(top: 5,bottom: 8),
                                                                                            height: 1,
                                                                                            color: PrimaryColor.withOpacity(0.1),
                                                                                          ),
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            children: [
                                                                                              Expanded(
                                                                                                child: Container(
                                                                                                  alignment: Alignment.centerLeft,
                                                                                                  child: Column(
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    children: [
                                                                                                      Text(getTranslated(context, 'Pre Balance'),textAlign: TextAlign.left,style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                                                                      SizedBox(height: 1,),
                                                                                                      Text("\u{20B9} " + items[index]["RemainPre"].toString(),textAlign: TextAlign.right,)
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                width: 1,
                                                                                                height: 28,
                                                                                                child: Container(
                                                                                                  width: 2,
                                                                                                  color: Colors.black12,
                                                                                                ),
                                                                                              ),
                                                                                              Expanded(
                                                                                                child: Container(
                                                                                                  alignment: Alignment.center,
                                                                                                  child: Column(
                                                                                                    children: [
                                                                                                      items[index]["Creditamount"] == 0.0 ? Text(getTranslated(context, 'Debit') + "\u{20B9}",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,softWrap: true,) : Text("Credit \u{20B9}".toUpperCase(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                                                                      SizedBox(height: 2,),
                                                                                                      items[index]["Creditamount"] == 0.0 ? Text("\u{20B9} "+items[index]["Debitamount"].toString(),textAlign: TextAlign.right,) : Text("\u{20B9} "+items[index]["Creditamount"].toString(),textAlign: TextAlign.right,)
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                width: 1,
                                                                                                height: 28,
                                                                                                child: Container(
                                                                                                  width: 2,
                                                                                                  color: Colors.black12,
                                                                                                ),
                                                                                              ),
                                                                                              Expanded(
                                                                                                child: Container(
                                                                                                  alignment: Alignment.centerRight,
                                                                                                  child: Column(
                                                                                                    children: [
                                                                                                      Text(getTranslated(context, 'Post Balance') ,style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                                                                      SizedBox(height: 1,),
                                                                                                      Text("\u{20B9} " + items[index]["RemainPost"].toString(),textAlign: TextAlign.center,)
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              // items[index]["Status"] == "SUCCESS" ? Expanded(
                                                                                              //   child: Container(
                                                                                              //     alignment: Alignment.centerRight,
                                                                                              //     child: Column(
                                                                                              //       children: [
                                                                                              //         Container(
                                                                                              //
                                                                                              //           height: 32,
                                                                                              //           child: TextButton(
                                                                                              //               onPressed: (){
                                                                                              //
                                                                                              //                 idno = items[index]["Idno"].toString();
                                                                                              //                 disputeresiondialog();
                                                                                              //               },
                                                                                              //               style: ButtonStyle(backgroundColor: MaterialStateProperty.all(SecondaryColor)),
                                                                                              //               child: Text("Complain", style: TextStyle(fontSize: 12,color: TextColor),)),
                                                                                              //         )
                                                                                              //       ],
                                                                                              //     ),
                                                                                              //   ),
                                                                                              // ) : Text(""),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 5,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],*/

                                                                  ),
                                                                );
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  child: Container(
                                                    color: TextColor,
                                                    child: Column(
                                                      children:[
                                                        Padding(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                                          child: TabBar(
                                                              controller: _tabController,
                                                              labelColor: SecondaryColor,
                                                              isScrollable: true,
                                                              labelPadding: EdgeInsets.only(top: 5, left: 8, right: 8, bottom: 10),
                                                              indicatorColor: Colors.transparent,
                                                              unselectedLabelColor: Colors.grey,
                                                              unselectedLabelStyle: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w700,
                                                              ),
                                                              labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
                                                              ),
                                                              tabs: [

                                                                Container(
                                                                  child: operator == "JIO" ? Text(getTranslated(context, 'Special')):Text(getTranslated(context, 'Best Offer')),
                                                                ),
                                                                Container(
                                                                  child:operator == "JIO" ? Text(getTranslated(context, 'SmartPhone')): Text(getTranslated(context, 'TalkTime')),
                                                                ),
                                                                Container(
                                                                  child: Text(getTranslated(context, 'TOPUP')),
                                                                ),
                                                                Container(
                                                                  child: Text(getTranslated(context, 'DATA')),
                                                                ),
                                                                Container(
                                                                  child: Text(getTranslated(context, 'SMS')),
                                                                ),
                                                                Container(
                                                                  child: Text(getTranslated(context, 'Romaing')),
                                                                ),
                                                                Container(
                                                                  child: Text(getTranslated(context, 'FRC')),
                                                                ),
                                                                Container(
                                                                  child: Text(getTranslated(context, 'STV')),
                                                                ),
                                                                Container(
                                                                  child:operator == "JIO" ? Text(getTranslated(context, 'JioPhone')) :Text(""),
                                                                ),
                                                              ]),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                            ),
                                            content:Container(
                                              height:250,
                                              constraints:BoxConstraints(maxHeight:MediaQuery.of(context).size.height / 1) ,
                                              child: TabBarView(
                                                controller: _tabController,
                                                children: <Widget>[
                                                  _isloading2 ? Center(
                                                    child: CollectionScaleTransition(
                                                      children: <Widget>[
                                                        Icon(Icons.circle, size: 10, color: SecondaryColor,),
                                                        Icon(Icons.circle, size: 10, color: SecondaryColor),
                                                        Icon(Icons.circle, size: 10, color: SecondaryColor),
                                                        Icon(Icons.circle, size: 10, color: SecondaryColor),
                                                      ],
                                                    ),
                                                  ) : offerlist.length == 0 ?
                                                  Visibility(
                                                    visible: _isvisible2,
                                                    child: _isloading2 ? Container(
                                                      alignment: Alignment.topCenter,
                                                      child: CollectionScaleTransition(
                                                        children: <Widget>[
                                                          Icon(Icons.circle, size: 10, color: SecondaryColor,),
                                                          Icon(Icons.circle, size: 10, color: SecondaryColor),
                                                          Icon(Icons.circle, size: 10, color: SecondaryColor),
                                                          Icon(Icons.circle, size: 10, color: SecondaryColor),
                                                        ],
                                                      ),
                                                    ) : Center(
                                                        child: Text("No Data Found")
                                                    ),
                                                  )
                                                      : Visibility(
                                                    visible: _isvisible,
                                                    maintainSize: false,
                                                    child: _isloading2 ? Center(child: CollectionScaleTransition(
                                                      children: <
                                                          Widget>[
                                                        Icon(Icons.circle, size: 10,color: SecondaryColor,),
                                                        Icon(Icons.circle, size: 10, color: SecondaryColor),
                                                        Icon(Icons.circle, size: 10, color: SecondaryColor),
                                                        Icon(Icons.circle, size: 10, color: SecondaryColor),
                                                      ],
                                                    ),) :
                                                    ListView.builder(
                                                        itemCount: offerlist.length,
                                                        itemBuilder: (context, index) {
                                                          if (offerlist.contains(null) || offerlist.length < 0)
                                                            return Center(child: CircularProgressIndicator());
                                                          return Column(
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
                                                                child: Container(
                                                                  margin: EdgeInsets.only(left: 0.5,right: 0.5,top: 0.5,bottom: 0.5),
                                                                  child: Container(
                                                                    color: TextColor.withOpacity(0.5),
                                                                    child: PlansWidget(
                                                                      onTap: () {
                                                                        setState(() {
                                                                          _isButtonDisabled = true;
                                                                        });
                                                                        amntcontroller.text = offerlist[index]["price"];
                                                                      },
                                                                      textAmount: offerlist[index]["price"],
                                                                      dayCount: offerlist[index]["offer"],
                                                                      userName: offerlist[index]["offerDetails"],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              )
                                                            ],
                                                          );
                                                        }),
                                                  ),
                                                  Visibility(
                                                    visible: _isvisible2,
                                                    child: _isloading3 ? Center(
                                                      child: CollectionScaleTransition(
                                                        children: <Widget>[
                                                          Icon(Icons.circle, size: 10, color:SecondaryColor,),
                                                          Icon(Icons.circle, size: 10, color:SecondaryColor),
                                                          Icon(Icons.circle, size: 10, color:SecondaryColor),
                                                          Icon(Icons.circle, size: 10, color:SecondaryColor),
                                                        ],
                                                      ),
                                                    )
                                                        : ListView.builder(
                                                        itemCount: planlist.length,
                                                        itemBuilder: (context, index) {
                                                          if (planlist.contains(null) || planlist.length < 0)
                                                            return Center(child: CircularProgressIndicator());
                                                          return Column(
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 2),
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
                                                                child: Container(
                                                                  margin: EdgeInsets.only(left: 0.5,right: 0.5,top: 0.5,bottom: 0.5),
                                                                  child: Container(
                                                                    color: TextColor.withOpacity(0.5),
                                                                    child: PlansWidget(
                                                                      onTap: () {
                                                                        setState(() {
                                                                          _isButtonDisabled = true;
                                                                        });
                                                                        amntcontroller.text =
                                                                        planlist[index]["price"];
                                                                      },
                                                                      textAmount:
                                                                      planlist[index]["price"],
                                                                      dayCount:
                                                                      planlist[index]["Validity"],
                                                                      userName:
                                                                      planlist[index]["description"],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              )
                                                            ],
                                                          );
                                                        }),
                                                  ),
                                                  Visibility(
                                                    visible: _isvisible2,
                                                    child: _isloading3 ? Center(
                                                      child: CollectionScaleTransition(
                                                        children: <Widget>[
                                                          Icon(Icons.circle,size: 10,color: SecondaryColor,),
                                                          Icon(Icons.circle,size: 10,color: SecondaryColor),
                                                          Icon(Icons.circle,size: 10,color: SecondaryColor),
                                                          Icon(Icons.circle,size: 10,color: SecondaryColor),
                                                        ],
                                                      ),
                                                    )
                                                        : ListView.builder(
                                                        itemCount: planlist2.length,
                                                        itemBuilder:(context,index) {
                                                          if (planlist2.contains(null) || planlist2.length <0)
                                                            return Center(
                                                                child:CircularProgressIndicator());
                                                          return Column(
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
                                                                child: Container(
                                                                  margin: EdgeInsets.only(left: 0.5,right: 0.5,top: 0.5,bottom: 0.5),
                                                                  child: Container(
                                                                    color: TextColor.withOpacity(0.5),
                                                                    child: PlansWidget(
                                                                      onTap:(){
                                                                        setState(() {
                                                                          _isButtonDisabled = true;
                                                                        });
                                                                        amntcontroller.text = planlist2[index]["price"];
                                                                      },
                                                                      textAmount: planlist2[index]["price"],
                                                                      dayCount: planlist2[index]["Validity"],
                                                                      userName: planlist2[index]["description"],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(height: 10)
                                                            ],
                                                          );
                                                        }),
                                                  ),
                                                  Visibility(
                                                    visible: _isvisible2,
                                                    child: _isloading3 ? Center(
                                                      child: CollectionScaleTransition(
                                                        children: <Widget>[
                                                          Icon(Icons.circle, size: 10, color: SecondaryColor,),
                                                          Icon(Icons.circle, size: 10, color: SecondaryColor),
                                                          Icon(Icons.circle, size: 10, color: SecondaryColor),
                                                          Icon(Icons.circle, size: 10, color: SecondaryColor),
                                                        ],
                                                      ),
                                                    )
                                                        : ListView.builder(
                                                        itemCount: planlist3.length,
                                                        itemBuilder: (context, index) {
                                                          if (planlist3.contains(null) || planlist3.length < 0)
                                                            return Center(
                                                                child: CircularProgressIndicator());
                                                          return Column(
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
                                                                child: Container(
                                                                  margin: EdgeInsets.only(left: 0.5,right: 0.5,top: 0.5,bottom: 0.5),
                                                                  child: Container(
                                                                    color: TextColor.withOpacity(0.5),
                                                                    child: PlansWidget(
                                                                      onTap: () {
                                                                        setState(() {
                                                                          _isButtonDisabled = true;
                                                                        });
                                                                        amntcontroller.text = planlist3[index]["price"];
                                                                      },
                                                                      textAmount: planlist3[index]["price"],
                                                                      dayCount: planlist3[index]["Validity"],
                                                                      userName: planlist3[index]["description"],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              )
                                                            ],
                                                          );
                                                        }),
                                                  ),
                                                  Visibility(
                                                    visible: _isvisible2,
                                                    child: _isloading3
                                                        ? Center(
                                                      child:
                                                      CollectionScaleTransition(
                                                        children: <Widget>[
                                                          Icon(Icons.circle, size: 10, color: SecondaryColor,),
                                                          Icon(Icons.circle, size: 10, color: SecondaryColor),
                                                          Icon(Icons.circle, size: 10, color: SecondaryColor),
                                                          Icon(Icons.circle, size: 10, color: SecondaryColor),
                                                        ],
                                                      ),
                                                    )
                                                        : ListView.builder(
                                                        itemCount: planlist4.length,
                                                        itemBuilder: (context, index) {
                                                          if (planlist4.contains(null) || planlist4.length < 0)
                                                            return Center(
                                                                child: CircularProgressIndicator());
                                                          return Column(
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
                                                                child: Container(
                                                                  margin: EdgeInsets.only(left: 0.5,right: 0.5,top: 0.5,bottom: 0.5),
                                                                  child: Container(
                                                                    color: TextColor.withOpacity(0.5),
                                                                    child: PlansWidget(
                                                                      onTap: () {
                                                                        setState(() {_isButtonDisabled = true;
                                                                        });
                                                                        amntcontroller.text = planlist4[index]["price"];
                                                                      },
                                                                      textAmount: planlist4[index]["price"],
                                                                      dayCount: planlist4[index]["Validity"],
                                                                      userName: planlist4[index]["description"],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              )
                                                            ],
                                                          );
                                                        }),
                                                  ),
                                                  Visibility(
                                                    visible: _isvisible2,
                                                    child: _isloading3
                                                        ? Center(
                                                      child:
                                                      CollectionScaleTransition(
                                                        children: <Widget>[
                                                          Icon(Icons.circle, size: 10, color: SecondaryColor,),
                                                          Icon(Icons.circle, size: 10, color: SecondaryColor),
                                                          Icon(Icons.circle, size: 10, color: SecondaryColor),
                                                          Icon(Icons.circle, size: 10, color: SecondaryColor),
                                                        ],
                                                      ),
                                                    )
                                                        : ListView.builder(
                                                        itemCount: planlist5.length,
                                                        itemBuilder: (context, index) {
                                                          if (planlist5.contains(null) || planlist5.length < 0)
                                                            return Center(
                                                                child:
                                                                CircularProgressIndicator());
                                                          return Column(
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
                                                                child: Container(
                                                                  margin: EdgeInsets.only(left: 0.5,right: 0.5,top: 0.5,bottom: 0.5),
                                                                  child: Container(
                                                                    color: TextColor.withOpacity(0.5),
                                                                    child: PlansWidget(
                                                                      onTap: () {
                                                                        setState(() {
                                                                          _isButtonDisabled = true;
                                                                        });
                                                                        amntcontroller.text = planlist5[index]["price"];
                                                                      },
                                                                      textAmount: planlist5[index]["price"],
                                                                      dayCount: planlist5[index]["Validity"],
                                                                      userName: planlist5[index]["description"],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              )
                                                            ],
                                                          );
                                                        }),
                                                  ),
                                                  Visibility(
                                                    visible: _isvisible2,
                                                    child: _isloading3
                                                        ? Center(
                                                      child:
                                                      CollectionScaleTransition(
                                                        children: <Widget>[
                                                          Icon(Icons.circle, size: 10, color: SecondaryColor),
                                                          Icon(Icons.circle, size: 10, color: SecondaryColor),
                                                          Icon(Icons.circle, size: 10, color: SecondaryColor),
                                                          Icon(Icons.circle, size: 10, color: SecondaryColor),
                                                        ],
                                                      ),
                                                    )
                                                        : ListView.builder(
                                                        itemCount: planlist6.length,
                                                        itemBuilder: (context, index) {
                                                          if (planlist6.contains(null) || planlist6.length < 0)
                                                            return Center(
                                                                child:
                                                                CircularProgressIndicator());
                                                          return Column(
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
                                                                child: Container(
                                                                  margin: EdgeInsets.only(left: 0.5,right: 0.5,top: 0.5,bottom: 0.5),
                                                                  child: Container(
                                                                    color: TextColor.withOpacity(0.5),
                                                                    child: PlansWidget(
                                                                      onTap: () {
                                                                        setState(() {
                                                                          _isButtonDisabled = true;
                                                                        });
                                                                        amntcontroller.text = planlist6[index]["price"];
                                                                      },
                                                                      textAmount: planlist6[index]["price"],
                                                                      dayCount: planlist6[index]["Validity"],
                                                                      userName: planlist6[index]["description"],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              )
                                                            ],
                                                          );
                                                        }),
                                                  ),
                                                  Visibility(
                                                    visible: _isvisible2,
                                                    child: _isloading3
                                                        ? Center(
                                                      child:
                                                      CollectionScaleTransition(
                                                        children: <Widget>[
                                                          Icon(Icons.circle, size: 10, color: SecondaryColor,),
                                                          Icon(Icons.circle, size: 10, color: SecondaryColor),
                                                          Icon(Icons.circle, size: 10, color: SecondaryColor),
                                                          Icon(Icons.circle, size: 10, color: SecondaryColor),
                                                        ],
                                                      ),
                                                    )
                                                        : ListView.builder(
                                                        itemCount: planlist7.length,
                                                        itemBuilder: (context, index) {
                                                          if (planlist7.contains(null) || planlist7.length < 0)
                                                            return Center(
                                                                child:
                                                                CircularProgressIndicator());
                                                          return Column(
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
                                                                child: Container(
                                                                  margin: EdgeInsets.only(left: 0.5,right: 0.5,top: 0.5,bottom: 0.5),
                                                                  child: Container(
                                                                    color: TextColor.withOpacity(0.5),
                                                                    child: PlansWidget(
                                                                      onTap: () {
                                                                        setState(() {
                                                                          _isButtonDisabled = true;
                                                                        });
                                                                        amntcontroller.text = planlist7[index]["price"];
                                                                      },
                                                                      textAmount: planlist7[index]["price"],
                                                                      dayCount: planlist7[index]["Validity"],
                                                                      userName: planlist7[index]["description"],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              )
                                                            ],
                                                          );
                                                        }),
                                                  ),
                                                  Visibility(
                                                    visible: _isvisible2,
                                                    child: _isloading3
                                                        ? Center(
                                                      child:
                                                      CollectionScaleTransition(
                                                        children: <Widget>[
                                                          Icon(Icons.circle, size: 10, color: SecondaryColor,),
                                                          Icon(Icons.circle, size: 10, color: SecondaryColor),
                                                          Icon(Icons.circle, size: 10, color: SecondaryColor),
                                                          Icon(Icons.circle, size: 10, color: SecondaryColor),
                                                        ],
                                                      ),
                                                    )
                                                        : ListView.builder(
                                                        itemCount: planlist8.length,
                                                        itemBuilder: (context, index) {
                                                          if (planlist8.contains(null) || planlist8.length < 0)
                                                            return Center(
                                                                child:
                                                                CircularProgressIndicator());
                                                          return Column(
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
                                                                child: Container(
                                                                  margin: EdgeInsets.only(left: 0.5,right: 0.5,top: 0.5,bottom: 0.5),
                                                                  child: Container(
                                                                    color: TextColor.withOpacity(0.5),
                                                                    child: PlansWidget(
                                                                      onTap: () {
                                                                        setState(() {
                                                                          _isButtonDisabled = true;
                                                                        });
                                                                        amntcontroller.text = planlist8[index]["price"];
                                                                      },
                                                                      textAmount: planlist8[index]["price"],
                                                                      dayCount: planlist8[index]["Validity"],
                                                                      userName: planlist8[index]["description"],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              )
                                                            ],
                                                          );
                                                        }),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          /*lsit==========*/
                                        ],
                                      ),
                                    ),
                                  ),
                                  /*PostPaid*/
                                  Visibility(
                                    maintainSize: false,
                                    maintainAnimation: true,
                                    maintainState: true,
                                    visible: viewVisible1,
                                    child: Container(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 10, right: 10),
                                            child: TextFormField(
                                              inputFormatters: [new FilteringTextInputFormatter.allow(RegExp("[0-9]")),],
                                              controller: postnumber,
                                              keyboardType:
                                              TextInputType.number,
                                              onChanged: (String value) async {
                                                if (value.length == 10) {
                                                  setState(() {
                                                    amntedit2 = true;
                                                    test1 = true;
                                                    isbuttondis2 = true;
                                                  });
                                                  FocusScopeNode currentFocus = FocusScope.of(context);
                                                  currentFocus.unfocus();
                                                  /*  Checkcircle2(postnumber.text);*/
                                                } else if (value.length == 0) {
                                                  setState(() {
                                                    postamntcontroller.clear();
                                                    operator = "Operator";
                                                    circle = "Circle";
                                                    test = false;
                                                    isbuttondis2 = false;
                                                  });
                                                }
                                              },
                                              maxLength: 10,
                                              buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(top: 18,bottom: 18,left: 10),
                                                disabledBorder:
                                                OutlineInputBorder(),
                                                labelStyle: TextStyle(color: PrimaryColor,fontSize: 14),
                                                border: OutlineInputBorder(borderSide: BorderSide(width: 0, color: PrimaryColor,),
                                                ),
                                                prefixText: "+91 ",
                                                labelText:getTranslated(context, 'Mobile Number'),
                                                suffixIcon: IconButton(
                                                  icon: _isloading
                                                      ? Center(
                                                      child: SizedBox(
                                                        height: 20,
                                                        width: 20,
                                                        child: CircularProgressIndicator(
                                                            valueColor:
                                                            AlwaysStoppedAnimation<
                                                                Color>(
                                                                SecondaryColor)),
                                                      ))
                                                      : Icon(
                                                    Icons.contacts,
                                                    color: SecondaryColor,
                                                  ),
                                                  onPressed: () async {

                                                    final PhoneContact contact = await FlutterContactPicker.pickPhoneContact();
                                                    String num = contact.phoneNumber.number;
                                                    String number = num.replaceAll("+91", "");
                                                    setState(() {
                                                      postnumber.text = number.replaceAll(" ", "");
                                                    });

                                                    if(postnumber.text.length == 10){
                                                      FocusScopeNode currentFocus =
                                                      FocusScope.of(context);
                                                      currentFocus.unfocus();
                                                      /*Checkcircle2(controller.text);*/
                                                    }
                                                  },
                                                ),
                                              ),

                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "null";
                                                }
                                                return null;
                                              },
                                              style: TextStyle(
                                                  fontSize: 18,

                                                  color: PrimaryColor),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.all(10),
                                                    child: OutlineButton(
                                                      onPressed: isbuttondis2 == false ? null : operatordialog,
                                                      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(4)),
                                                      splashColor:
                                                      Colors.transparent,
                                                      hoverColor:
                                                      Colors.transparent,
                                                      clipBehavior: Clip.none,
                                                      autofocus: false,
                                                      disabledTextColor:
                                                      PrimaryColor,
                                                      color: Colors.transparent,
                                                      highlightColor:
                                                      Colors.transparent,
                                                      highlightedBorderColor:
                                                      PrimaryColor,
                                                      focusColor: PrimaryColor,
                                                      disabledBorderColor:
                                                      PrimaryColor,
                                                      padding: EdgeInsets.only(top: 16, bottom: 16, left: 10, right: 10),
                                                      borderSide: BorderSide(width: 1, color: PrimaryColor),
                                                      child: Container(
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(operator2, overflow: TextOverflow.ellipsis, softWrap: true, maxLines: 1,
                                                                style: TextStyle(color: PrimaryColor, fontWeight: FontWeight.normal, fontSize: 18,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 20,
                                                              child: Icon(Icons.arrow_drop_down, color: PrimaryColor,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                              Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.all(10),
                                                    child: OutlineButton(
                                                      onPressed: isbuttondis2 == false ? null : statedialog,
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                                      splashColor: Colors.transparent,
                                                      hoverColor: Colors.transparent,
                                                      clipBehavior: Clip.none,
                                                      autofocus: false,
                                                      disabledBorderColor:
                                                      PrimaryColor,
                                                      color: Colors.transparent,
                                                      highlightColor:
                                                      Colors.transparent,
                                                      highlightedBorderColor:
                                                      PrimaryColor,
                                                      focusColor: PrimaryColor,
                                                      padding: EdgeInsets.only(top: 16, bottom: 16, left: 10, right: 10),
                                                      borderSide: BorderSide(width: 1, color: PrimaryColor),
                                                      child: Container(
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                                child: Text(circle2, overflow: TextOverflow.ellipsis, maxLines: 1, softWrap: true, style: TextStyle(color: PrimaryColor, fontWeight: FontWeight.normal, fontSize: 18,),
                                                                )),
                                                            SizedBox(
                                                              width: 20,
                                                              child: Icon(Icons.arrow_drop_down, color: PrimaryColor,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 10, right: 10),
                                            child: TextFormField(
                                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]")),],
                                              enabled: amntedit2,
                                              controller: postamntcontroller,
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(top: 18,bottom: 18,left: 10),
                                                disabledBorder:
                                                OutlineInputBorder(),
                                                labelStyle: TextStyle(
                                                    color: PrimaryColor,fontSize: 14),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    width: 0,
                                                    color: PrimaryColor,
                                                  ),
                                                ),
                                                labelText: getTranslated(context, 'Enter Amount'),
                                              ),
                                              maxLength: 4,
                                              onChanged: (String value) {
                                                if (value.length > 0) {
                                                  setState(() {
                                                    _isButtonDisabled2 = true;
                                                  });
                                                } else if (value.length == 0) {
                                                  setState(() {
                                                    _isButtonDisabled2 = false;
                                                  });
                                                }
                                              },
                                              buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return "null";
                                                }
                                                return null;
                                              },
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: PrimaryColor),
                                            ),
                                          ),
                                          /*Buttons*/
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Visibility(
                                                    visible: btnvisible,
                                                    child: Container(
                                                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                                                      child: OutlinedButton(
                                                        style: OutlinedButton.styleFrom(
                                                          padding: EdgeInsets.all(15),
                                                          backgroundColor: SecondaryColor,
                                                          shadowColor: Colors.transparent,
                                                        ),
                                                        onPressed: _isButtonDisabled2 == false ? null : () async {

                                                          setState(() {
                                                            _isloading4 = true;
                                                          });

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

                                                          showDialog(context: context, builder: (BuildContextcontext) {
                                                            return CustomDialogWidget(
                                                              buttonText: getTranslated(context, 'Pay Now'),
                                                              description:getTranslated(context, 'Mobile Number'),
                                                              description0:postnumber.text,
                                                              description1:getTranslated(context, 'Operator Name'),
                                                              description01:operator,
                                                              textStyle:TextStyle(fontSize: 32.0, fontWeight: FontWeight.w800),
                                                              description2:getTranslated(context, 'Recharge Amount'),
                                                              description02:postamntcontroller.text,
                                                              title:getTranslated(context, 'Please Verify Below Details'),
                                                              icon:Icons.help,
                                                              buttonText1:getTranslated(context, 'Cancel'),
                                                              buttonColor1: PrimaryColor,
                                                              buttonColor: SecondaryColor,
                                                              onpress2: () {
                                                                Navigator.of(context).pop();
                                                                rechdetails(postnumber.text, optcode, postamntcontroller.text, "lat", "long", "city", "address", "postcode", netname, ipadd, androidid);
                                                              },
                                                              onpress: () {
                                                                setState(() {
                                                                  _isloading4 = false;
                                                                });
                                                                Navigator.of(context).pop();
                                                              },
                                                            );
                                                          });
                                                        },
                                                        child: _isloading4
                                                            ? Center(
                                                          child: SizedBox(
                                                            height: 20,
                                                            child: LinearProgressIndicator(
                                                              backgroundColor: PrimaryColor,
                                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                            ),
                                                          ),
                                                        )
                                                            : Text(getTranslated(context, 'Pay'),
                                                          style: TextStyle(color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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

              ],
            ),
          ),
        ),
      ),
    );
  }

  void rechdetails(String number, String operator, String amnt, String lat, String long, String city, String address, String pascode, String contype, String ipadd, String andid) async {

    final storage = new FlutterSecureStorage();
    var userid = await storage.read(key: "userId");

    var uuid = Uuid();
    var keyst = uuid.v1().substring(0, 16);
    var ivstr = uuid.v4().substring(0, 16);

    String keySTR = keyst.toString(); //16 byte
    String ivSTR = ivstr.toString(); //16 byte

    String keyencoded = base64.encode(utf8.encode(keySTR));
    String viencoded = base64.encode(utf8.encode(ivSTR));

    final key = encrypt.Key.fromUtf8(keySTR);
    final iv = encrypt.IV.fromUtf8(ivSTR);

    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));

    final encrypted1 = encrypter.encrypt(userid, iv: iv);
    final encrypted2 = encrypter.encrypt(number, iv: iv);
    final encrypted3 = encrypter.encrypt(operator, iv: iv);
    final encrypted4 = encrypter.encrypt(amnt, iv: iv);
    final encrypted5 = encrypter.encrypt(lat, iv: iv);
    final encrypted6 = encrypter.encrypt(long, iv: iv);
    final encrypted7 = encrypter.encrypt(city, iv: iv);
    final encrypted8 = encrypter.encrypt(address, iv: iv);
    final encrypted9 = encrypter.encrypt(pascode, iv: iv);
    final encrypted10 = encrypter.encrypt(contype, iv: iv);
    final encrypted11 = encrypter.encrypt(ipadd, iv: iv);
    final encrypted12 = encrypter.encrypt(andid, iv: iv);

    String useridd = encrypted1.base64;
    String numberr = encrypted2.base64;
    String opert = encrypted3.base64;
    String amnt1 = encrypted4.base64;
    String lat1 = encrypted5.base64;
    String long1 = encrypted6.base64;
    String city1 = encrypted7.base64;
    String addre1 = encrypted8.base64;
    String pascode1 = encrypted9.base64;
    String cont1 = encrypted10.base64;
    String ipd1 = encrypted11.base64;
    String andiddd = encrypted12.base64;

    rechtask(useridd, numberr, opert, amnt, lat1, long1, city1, addre1, pascode1, cont1, ipd1, andiddd, keyencoded, viencoded);
  }

  getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium)
        .then((Position position) {

      setState(() {
        _currentPosition = position;
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

class PlansWidget extends StatelessWidget {
  final String textAmount;
  final GestureTapCallback onTap;
  final String dayCount;
  final String userName;

  const PlansWidget({
    Key key,
    this.textAmount,
    this.onTap,
    this.dayCount,
    this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Row(
                      children: [
                        Text('\u20B9 ${textAmount}'),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 2,
                          height: 25,
                          color: Colors.black12,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        /*Text(dayCount,softWrap: false,overflow: TextOverflow.ellipsis,textScaleFactor: 1,maxLines: 10,),*/
                        Flexible(
                          fit: FlexFit.loose,
                          child: Text(
                            dayCount,
                            softWrap: true,
                            overflow: TextOverflow.clip,
                            maxLines: 10,
                            textWidthBasis: TextWidthBasis.longestLine,
                            textScaleFactor: 1,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 50,
                  margin: EdgeInsets.only(bottom: 5),
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.chevron_right,
                    size: 25,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              userName,
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}