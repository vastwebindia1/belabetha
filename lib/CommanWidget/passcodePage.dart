import 'dart:convert';
import 'dart:io';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart'as http;
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/CommanWidget/numeric_pad.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/DealerMainPage.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:myapp/ui/pages/dashboard/masterPage/masterMainPage.dart';
import 'package:myapp/ui/pages/login/login.dart';


class VerifyPassCode extends StatefulWidget {
  final String typePasscode;

  const VerifyPassCode({Key key, this.typePasscode}) : super(key: key);

  @override
  _VerifyPassCodeState createState() => _VerifyPassCodeState();
}

class _VerifyPassCodeState extends State<VerifyPassCode> {


  String code = "";
  bool _isloading = false;
  String netname,ipadd;

  String roll1 = "";


  void userRoll() async{

    final storage = new FlutterSecureStorage();
    var b = await storage.read(key: "role");
    roll1 = b;

    setState(() {
      roll1;
    });



  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userRoll();

  }





  Future<void> resendPasscode() async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url = new Uri.http("api.vastwebindia.com", "/Common/api/data/ResendPASSCODEPASSWORD");
    final http.Response response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response);

    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      var status = dataa["Status"];


    } else {
      throw Exception('Failed to load themes');
    }


  }



  Future<void> submitPasscode(String pass) async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url = new Uri.http("api.vastwebindia.com", "/Common/api/data/CHECKPASSCODEPASSWORD", {
      "Passscodes" :pass,
    });

    final http.Response response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response);

    if (response.statusCode == 200) {

      _isloading = false;
      var dataa = json.decode(response.body);
      var status2 = dataa["Status"];

      if (status2 == "BOXNOTOPEN") {

        if(roll1 == "Retailer"){

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));
        }else if(roll1 == "Dealer"){

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DealermaninDashboard()));
        }else{

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MasterManinDashboard()));
        }



      } else {

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: getTranslated(context, 'Something Went Wrong'),
          title: getTranslated(context, 'Failed'),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.red,
          onConfirmBtnTap: (){
            setState(() {
              _isloading = false;
            });
            Navigator.of(context).pop();},
        );
      }


    } else {
      _isloading = false;
      throw Exception('Failed to load themes');
    }


  }



  Future<bool> _onbackpress() async {

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));


  }






  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onbackpress,
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: IconButton(
              icon: Icon(Icons.arrow_back,color: Colors.black),
              onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          ),
          title: Text(widget.typePasscode + " PassCode",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          backgroundColor: TextColor,
          elevation: 0,
          centerTitle: true,
          textTheme: Theme.of(context).textTheme,
        ),
        body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                Expanded(
                  child: Container(
                    color: TextColor,
                    child: Column(
                      children: <Widget>[

                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Text(
                            "PassCode is sent to Your Number ",
                            style: TextStyle(
                              fontSize: 22,
                              color: Color(0xFF818181),
                            ),
                          ),
                        ),

                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                              buildCodeNumberBox(code.length > 0 ? code.substring(0, 1) : ""),
                              buildCodeNumberBox(code.length > 1 ? code.substring(1, 2) : ""),
                              buildCodeNumberBox(code.length > 2 ? code.substring(2, 3) : ""),
                              buildCodeNumberBox(code.length > 3 ? code.substring(3, 4) : ""),
                              buildCodeNumberBox(code.length > 4 ? code.substring(4, 5) : ""),
                              buildCodeNumberBox(code.length > 5 ? code.substring(5, 6) : ""),


                            ],
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                              Text(
                                "Didn't recieve code? ",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF818181),
                                ),
                              ),

                              SizedBox(
                                width: 8,
                              ),

                              GestureDetector(
                                onTap: () {
                                  resendPasscode();
                                },
                                child: Text(
                                  "Resend",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),

                        Container(
                            margin: EdgeInsets.only(left: 5,
                                right: 5),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.all(15),
                                backgroundColor: SecondaryColor,
                                shadowColor: Colors.transparent,
                              ),
                              onPressed: () async{

                                setState(() {
                                  _isloading = true;

                                });

                                final interfaces = await NetworkInterface.list(type: InternetAddressType.IPv4, includeLinkLocal: true);
                                NetworkInterface interface = interfaces.firstWhere((element) => ! (element.name == "tun0" || element.name == "wlan0"));
                                netname = interface.name;
                                ipadd = interface.addresses.first.address;

                                submitPasscode(code);
                              },
                              child: _isloading
                                  ? Center(child: SizedBox(
                                height: 20,
                                child: LinearProgressIndicator(backgroundColor: PrimaryColor,valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
                              ),)
                                  :Text("Verify PassCode",
                                  style: TextStyle(
                                    color: TextColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  )),
                            )
                        ),
                      ],
                    ),
                  ),
                ),

                NumericPad(
                  onNumberSelected: (value) {
                    print(value);
                    setState(() {
                      if(value != -1){
                        if(code.length < 6){
                          code = code + value.toString();


                        }
                      }
                      else{
                        code = code.substring(0, code.length - 1);
                      }
                      print(code);
                    });
                  },
                ),

              ],
            )
        ),
      ),
    );

  }

  Widget buildCodeNumberBox(String codeNumber) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: SizedBox(
        width: 40,
        height: 40,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFF6F5FA),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 25.0,
                  spreadRadius: 1,
                  offset: Offset(0.0, 0.75)
              )
            ],
          ),
          child: Center(
            child: Text(
              codeNumber,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F1F1F),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
