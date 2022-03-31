
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/CommanWidget/app_logo.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/IntroSliderPages/AppSignUpButton.dart';
import 'package:myapp/IntroSliderPages/IntroSlider.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/data/localSecureStorage/flutterStorageHelper.dart';
import 'package:myapp/networkConfig/ApiBaseHelper.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/login/OtpTest.dart';
import 'package:myapp/ui/pages/login/login.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:encrypt/encrypt.dart' as encrypt;


class JoinPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<JoinPage> with SingleTickerProviderStateMixin{

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repasswordController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController refcodeController = TextEditingController();
  TextEditingController compnameController = TextEditingController();

  static const platform = const MethodChannel('com.aasha/credoPay');

  bool valuefirst = false;
  bool valuesecond = false;
  bool _isVisible = false;
  List statename = [];
  bool disbtn = false;
  String stname = "";
  List statesList;
  List districtlist;
  String aadharstate,aadhardis;

  bool btndis = false;

  var status, msz;

  bool righttikvisi = false;

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

      for(var i = 0; i<dataa.length;i++){

        var stsname = dataa[i]["State Name"];

        if(stsname == aadharstate){

        setState(() {
          stateid = dataa[i]["Sate Id"];
        });

          distrilist(stateid.toString());

        }

      }

      setState(() {
        statesList = dataa;
      });


    } else {
      throw Exception('Failed');
    }
  }

  Future<void> distrilist(String code) async {
    String token = "";
    var url1 =
        new Uri.http("api.vastwebindia.com", "/Common/api/data/districtList", {
      "stateid": code,
    });
    final http.Response response = await http.get(
      url1,
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

      for(var i = 0; i<dataa.length;i++){

        var disname = dataa[i]["Dist Name"];

        if(disname == aadhardis){

          setState(() {
            distid = dataa[i]["Dist Id"];
          });


        }

      }

      setState(() {
        districtlist = dataa;
        disbtn = true;
      });
    } else {
      throw Exception('Failed');
    }
  }
  // ignore: non_constant_identifier_names
  Future<void> Registeruser(String name, String number, String email, String state, String dis, String pincode, String pass, String key, String vi, String usercmp) async {
    var url = new Uri.http("api.vastwebindia.com", "/api/Account/Register");
    Map map = {
      "Email": email,
      "Password": pass,
      "phone": number,
      "DealerId": "",
      "Name": name,
      "state": state,
      "distict": dis,
      "PIN": "1234",
      "PinCode": pincode,
      "ReferralCode": refcodeController.text,
      "CompanyName": usercmp,
      "valuess1": key,
      "valuesss2": vi
    };

    String body = json.encode(map);

    http.Response response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    print(response);



    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      status = dataa["Response"];
      msz = dataa["Message"];

      if (status == "Success") {
        _isloading = false;

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: msz,
          title: status,
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));},

        );
      } else {
        setState(() {
          _isloading = false;
        });

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: msz,
          title: getTranslated(context, 'Warning'),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.red,
          onConfirmBtnTap: (){
            Navigator.of(context).pop();},
        );
      }
    } else {
      throw Exception('Failed');
    }
  }

  Future<void> responsefromaaadharscan() async {
    String response = "";
    try {
      final result = await platform.invokeMethod('aadhar');

      setState(() {
        nameController.text = result['1'].toString();
        state = result['2'].toString();
        district = result['3'].toString();
        pincodeController.text = result['4'].toString();
        aadharstate = state;
        aadhardis = district;
        righttikvisi = true;

        setState(() {
          statelist();
        });


      });

    } on PlatformException catch (e) {
      response = "Failed to Invoke: '${e.message}'.";
    }



  }

  /*Future<void> checkpannumr(String pannum) async {


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
*/
  void showToast() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  TextEditingController _textController = TextEditingController();
  ScrollController listSlide = ScrollController();

  void statedialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setStatee) {
            return Container(
              color: Colors.black.withOpacity(0.8),
              child: AlertDialog(
                buttonPadding: EdgeInsets.all(0),
                titlePadding: EdgeInsets.all(0),
                contentPadding: EdgeInsets.only(left: 10, right: 10),
                title: Container(
                  child: Column(
                    children: [
                      Container(
                        color: PrimaryColor,
                        padding: EdgeInsets.only(
                          top: 8,
                        ),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 8, left: 8, right: 8),
                          color: PrimaryColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                getTranslated(context, 'Select Your State'),
                                style: TextStyle(
                                    color: TextColor, fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                              CloseButton(color: SecondaryColor,)
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: 8, bottom: 8, left: 10, right: 10),
                        color: PrimaryColor.withOpacity(0.9),
                        child: TextField(
                          onChanged: (value) {
                            setStatee(() {});
                          },
                          controller: _textController,
                          decoration: InputDecoration(
                            labelText:getTranslated(context, 'Search'),
                            hintText:getTranslated(context, 'Search'),
                            labelStyle: TextStyle(color: TextColor),
                            hintStyle: TextStyle(color: TextColor),
                            contentPadding: EdgeInsets.only(left: 25),
                            suffixIcon: Icon(
                              Icons.search,
                              color: TextColor,
                            ),
                            border: OutlineInputBorder(
                                gapPadding: 1,
                                borderRadius: BorderRadius.circular(50),
                                borderSide:
                                    BorderSide(width: 1, color: TextColor)),
                            enabledBorder: OutlineInputBorder(
                                gapPadding: 1,
                                borderRadius: BorderRadius.circular(50),
                                borderSide:
                                    BorderSide(width: 1, color: TextColor)),
                            focusedBorder: OutlineInputBorder(
                                gapPadding: 1,
                                borderRadius: BorderRadius.circular(50),
                                borderSide:
                                    BorderSide(width: 1, color: TextColor)),
                          ),
                          style: TextStyle(color: TextColor, fontSize: 20),
                          cursorColor: TextColor,
                          cursorHeight: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                content: Container(
                    // Change as per your requirement
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Container(
                        child: ListView.builder(
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          controller: listSlide,
                          itemCount: statesList.length,
                          itemBuilder: (context, index) {
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
                                            overlayColor:
                                                MaterialStateProperty.all(
                                                    Colors.transparent),
                                            shadowColor:
                                                MaterialStateProperty.all(
                                                    Colors.transparent),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.transparent),
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.all(0)),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              state = statesList[index]
                                                  ["State Name"];
                                            });
                                            stateid = statesList[index]["Sate Id"];
                                            String stid = stateid.toString();
                                            distrilist(stid);
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              statesList[index]["State Name"],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: PrimaryColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 1,
                                    color: PrimaryColor,
                                    margin: EdgeInsets.only(top: 0, bottom: 0),
                                  )
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
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.all(0)),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              state = statesList[index]
                                                  ["State Name"];
                                            });
                                            stateid =
                                                statesList[index]["Sate Id"];
                                            String stid = stateid.toString();
                                            distrilist(stid);

                                            _textController.clear();
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              statesList[index]["State Name"],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: PrimaryColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 1,
                                    color: PrimaryColor,
                                    margin: EdgeInsets.only(top: 0, bottom: 0),
                                  )
                                ],
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    )),
              ),
            );
          });
        });
  }

  void districtdialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setStatee) {
            return Container(
              color: Colors.black.withOpacity(0.8),
              child: AlertDialog(
                buttonPadding: EdgeInsets.all(0),
                titlePadding: EdgeInsets.all(0),
                contentPadding: EdgeInsets.only(left: 10, right: 10),
                title: Container(
                  child: Column(
                    children: [
                      Container(
                        color: PrimaryColor,
                        padding: EdgeInsets.only(
                          top: 8,
                        ),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 8, left: 8, right: 8),
                          color: PrimaryColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Select Your district",
                                style: TextStyle(
                                  color: TextColor,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              CloseButton(
                                color: SecondaryColor,)
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
                        color: PrimaryColor.withOpacity(0.9),
                        child: TextField(
                          onChanged: (value) {
                            setStatee(() {});
                          },
                          controller: _textController,
                          decoration: InputDecoration(
                            labelText:"Search",
                            hintText:"Search",
                            labelStyle: TextStyle(color: TextColor),
                            hintStyle: TextStyle(color: TextColor),
                            contentPadding: EdgeInsets.only(left: 25),
                            suffixIcon: Icon(
                              Icons.search,
                              color: TextColor,
                            ),
                            border: OutlineInputBorder(
                                gapPadding: 1,
                                borderRadius: BorderRadius.circular(50),
                                borderSide:
                                    BorderSide(width: 1, color: TextColor)),
                            enabledBorder: OutlineInputBorder(
                                gapPadding: 1,
                                borderRadius: BorderRadius.circular(50),
                                borderSide:
                                    BorderSide(width: 1, color: TextColor)),
                            focusedBorder: OutlineInputBorder(
                                gapPadding: 1,
                                borderRadius: BorderRadius.circular(50),
                                borderSide:
                                    BorderSide(width: 1, color: TextColor)),
                          ),
                          style: TextStyle(
                            color: TextColor,
                            fontSize: 18,
                          ),
                          cursorColor: TextColor,
                          cursorHeight: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                content: Container(
                    // Change as per your requirement
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Container(
                        child: ListView.builder(
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          controller: listSlide,
                          itemCount: districtlist.length,
                          itemBuilder: (context, index) {
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
                                            overlayColor:
                                                MaterialStateProperty.all(
                                                    Colors.transparent),
                                            shadowColor:
                                                MaterialStateProperty.all(
                                                    Colors.transparent),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.transparent),
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.all(0)),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              district = districtlist[index]
                                                  ["Dist Name"];
                                              distid = districtlist[index]
                                                  ["Dist Id"];
                                              Navigator.of(context).pop();
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              districtlist[index]["Dist Name"],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: PrimaryColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 1,
                                    color: PrimaryColor,
                                    margin: EdgeInsets.only(top: 0, bottom: 0),
                                  )
                                ],
                              );
                            } else if (districtlist[index]["Dist Name"]
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
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.all(0)),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              district = districtlist[index]
                                                  ["Dist Name"];
                                              distid = districtlist[index]
                                                  ["Dist Id"];
                                              _textController.clear();
                                              Navigator.of(context).pop();
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              districtlist[index]["Dist Name"],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: PrimaryColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 1,
                                    color: PrimaryColor,
                                    margin: EdgeInsets.only(top: 0, bottom: 0),
                                  )
                                ],
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    )),
              ),
            );
          });
        });
  }

  bool _obscureText = true;
  bool _obscureText1 = true;

  String _password;
  bool _isloading = false;

  // Toggles the password show hide status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggle1() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  final _formKey = GlobalKey<FormState>();
  final _animationDuration = Duration(seconds: 1);
  Timer _timer;
  Color _color;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkSignUpToken();
    statelist();
    _timer = Timer.periodic(_animationDuration, (timer) => _changeColor());
    _color = Colors.white;
  }

  Future<bool> _onbackpress() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => IntroSlider()));
  }

  void _changeColor() {
    final newColor = _color == Colors.white ? PrimaryColor : Colors.white;
    setState(() {
      _color = newColor;
    });
  }

  bool _validate = false;
  bool _validate1 = false;
  bool _validate2 = false;
  bool _validate3 = false;
  bool _validate4 = false;
  bool _validate5 = false;
  bool _validate6 = false;
  bool _validate7 = false;
  bool _validate8 = false;
  String state = "Select State";
  String district = "Select District";
  var distid;
  var stateid;

  bool mobileNumberVisible = true;
  bool mobileOtpVisible = false;
  bool emailVisible = true;
  bool emailOtpVisible = false;

  TextEditingController mobileOtpController = TextEditingController();
  TextEditingController emailOtpController = TextEditingController();

  bool _verifyMobile = false;
  bool _verifyEmail = false;

  bool aadharScan = false;

  bool checkUnable = false;
  bool mobileNumberEnable = false;
  bool emailIdEnable = false;
  bool colorChanging = false;
  bool iconVisible = false;
  bool iconMobileVisible = true;

  bool _isloading1 = false;
  bool _isloading2 = false;

  Future<void> checkSignUpToken() async {

    var url = new Uri.http(
        "api.vastwebindia.com", "/Common/api/data/dealertokenavailability",);
    final http.Response response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
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
      var tokenValue = dataa["tokenvalue"].toString();
      var tokenStatus = dataa["tokenstatus"];

      if(tokenStatus == "Success"){

        setState(() {
          mobileNumberEnable = true;
        });
      }else{
        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text("Not Having Retailer Create Token Contact to Your Dealer ",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);


      }


    } else {
      throw Exception('Failed');
    }
  }

  Future<void> MobileNumberCheck(String emailId ,String mobileNumber) async {

    var url = new Uri.http(
        "api.vastwebindia.com", "/Common/api/data/VeryFY_mailandphone",{
      "email" :  emailId,
      "mobile" : mobileNumber,

    });
    final http.Response response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
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
      var mobileStatus = dataa["mobilestatus"];

      if(mobileStatus == "Success"){

        setState(() {
          mobileNumberVisible = false;
          _isloading2 =false;
        });

      }else{
        setState(() {
          _isloading2 =false;
        });
        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text("Your Mobile Number Already Exist With Us Please Try another Number",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);


      }


    } else {
      throw Exception('Failed');
    }
  }

  Future<void> MobileNumberOtpVerify(String mobileotp, String emailotp,String mobileNumber,String email) async {

    var url = new Uri.http("api.vastwebindia.com", "/Common/api/data/VeryfyUserEmailOTP", {
      "hdmobileotp": mobileotp,
      "hdemailotp": emailotp,
      "mobile": mobileNumber,
      "email":email,
    });
    final http.Response response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );

    print(response);

    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      var mobileStatusOtp = dataa["mobilestatus"];

      setState(() {
        mobileotp1.clear();
        mobileotp2.clear();
        mobileotp3.clear();
        mobileotp4.clear();
      });

      if(mobileStatusOtp == "Success") {

        setState(() {
          mobileNumberVisible = true;
          mobileNumberEnable = false;
          emailIdEnable = true;
          iconMobileVisible = false;
          _isloading2 =false;
        });

      }else{

        setState(() {
          _isloading2 =false;
        });
        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text("Invalid OTP",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);
      }


    } else {
      throw Exception('Failed');
    }


  }

  Future<void> EmailIdCheck(String emailId , String mobileNumber) async {

    var url = new Uri.http(
        "api.vastwebindia.com", "/Common/api/data/VeryFY_mailandphone",{
      "email" :  emailId,
      "mobile" : mobileNumber,

    });
    final http.Response response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
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
      var emailStatus1 = dataa["emailstatus"];

      if(emailStatus1 == "Success"){

        setState(() {
          emailVisible = false;
          _isloading1 =false;
        });

      }else{
        setState(() {
          _isloading1 =false;
        });
        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text("Your Email Id Already Exist With Us Please Try another Email Id",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);



      }


    } else {
      throw Exception('Failed');
    }
  }

  Future<void> EmailIdOtpVerify(String mobileotp, String emailotp,String mobileNumber,String email) async {

    var url = new Uri.http("api.vastwebindia.com", "/Common/api/data/VeryfyUserEmailOTP", {
      "hdmobileotp": mobileotp,
      "hdemailotp": emailotp,
      "mobile": mobileNumber,
      "email":email,
    });
    final http.Response response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );

    print(response);

    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      var mobileStatusOtp1= dataa["mobilestatus"];
      var emailStatusOtp1= dataa["emailstatus"];

      setState(() {
        emailotp1.clear();
        emailotp2.clear();
        emailotp3.clear();
        emailotp4.clear();
      });

      if(emailStatusOtp1 == "Success") {

        setState(() {
          emailIdEnable = false;
          emailVisible = true;
          _isloading1 =false;
          iconVisible = true;
          checkUnable = true;
          aadharScan = false;
        });

      }else{

        setState(() {
          _isloading1 =false;
        });
        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text("Invalid OTP",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);
      }


    } else {
      throw Exception('Failed');
    }


  }

  String emailPattern = "[a-zA-Z0-9._-]+@[a-z]+\\.+[a-z]+";


  TextEditingController mobileotp1 = TextEditingController();
  TextEditingController mobileotp2 = TextEditingController();
  TextEditingController mobileotp3 = TextEditingController();
  TextEditingController mobileotp4 = TextEditingController();

  TextEditingController emailotp1 = TextEditingController();
  TextEditingController emailotp2 = TextEditingController();
  TextEditingController emailotp3 = TextEditingController();
  TextEditingController emailotp4 = TextEditingController();

  String code = "";
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

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onbackpress,
      child: Material(
        child: Scaffold(
          backgroundColor: TextColor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width * .30,
                    decoration: BoxDecoration(color: PrimaryColor),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          child: AppLogo(),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 250,
                                child: Text(
                                  "Aasha Digital India",
                                  style: TextStyle(
                                      height: 1.5,
                                      color: TextColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: 3,),
                              Container(
                                width: 250,
                                child: Text(getTranslated(context, 'details'),
                                  style: TextStyle(
                                      color:SecondaryColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11),
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: aadharScan,
                    child: Container(
                      color: PrimaryColor,
                      child: Row(
                        children: [
                          Expanded(
                              child: TextButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<OutlinedBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero,
                                          side: BorderSide(color: TextColor)
                                      )
                                  ),
                                  backgroundColor: MaterialStateProperty.all(SecondaryColor),
                                  padding: MaterialStateProperty.all(EdgeInsets.only(top: 12,bottom: 13,left: 10,right: 10))
                                ),
                                onPressed: (){
                                  responsefromaaadharscan();
                                },
                                child: Container(
                                  child: Stack(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.qr_code_sharp,color: TextColor,size: 28,),
                                          SizedBox(width: 5,),
                                          Row(
                                            children: [
                                              AnimatedContainer(
                                                  duration: _animationDuration,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.only(left: 5,right: 5,top: 1,bottom: 1),
                                                        decoration: BoxDecoration(
                                                            color: TextColor,
                                                            shape: BoxShape.rectangle,
                                                            borderRadius: BorderRadius.circular(5)
                                                        ),
                                                        child: Text(getTranslated(context, 'Click Here'),style: TextStyle(fontSize: 8,color: SecondaryColor),),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(context).size.width/1.2,
                                                          margin: EdgeInsets.only(top: 3),
                                                          child: Text(getTranslated(context, 'aadhaarscan'),style: TextStyle(color: _color),overflow: TextOverflow.ellipsis,)),
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                        top: 0,
                                        left: 30,
                                          child: Container(
                                            padding: EdgeInsets.only(left: 5,right: 5,top: 1,bottom: 1),
                                        decoration: BoxDecoration(
                                          color: TextColor,
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.circular(5)
                                        ),
                                        child: Text(getTranslated(context, 'Click Here'),style: TextStyle(fontSize: 8,color: SecondaryColor),),
                                      ))
                                    ],
                                  ),
                                ),
                              )
                          )
                        ],
                      )
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Visibility(
                          visible: mobileNumberVisible,
                          replacement: Container(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 5, right: 6, top: 8, bottom: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.black
                                )
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "OTP received on your Registered Mobile No.",
                                    style: TextStyle(
                                        fontSize: 11,color:Colors.red,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                      child:Container(
                                        height: 60,
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(child: TextField(
                                              controller: mobileotp1,
                                              textAlign: TextAlign.center,
                                              keyboardType: TextInputType.number,
                                              maxLength: 1,
                                              cursorColor: PrimaryColor,
                                              cursorHeight: 20,
                                              decoration: InputDecoration(
                                                hintText: "-",
                                                counterText: '',
                                                hintStyle: TextStyle(color: Colors.black, fontSize: 20.0),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),),
                                                    borderRadius: BorderRadius.circular(2)
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),width: 2),
                                                  borderRadius: BorderRadius.circular(3),

                                                ),

                                              ),
                                              onChanged: (value){
                                                if(value.length == 1){
                                                  FocusScope.of(context).nextFocus();
                                                }
                                                else if(value.length == 0){
                                                  FocusScope.of(context).previousFocus();
                                                }
                                              },
                                            )),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(child: TextField(
                                              textAlign: TextAlign.center,
                                              controller: mobileotp2,
                                              keyboardType: TextInputType.number,
                                              maxLength: 1,
                                              cursorColor: PrimaryColor,
                                              cursorHeight: 20,
                                              decoration: InputDecoration(
                                                hintText: "-",
                                                counterText: '',
                                                hintStyle: TextStyle(color: Colors.black, fontSize: 20.0),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),),
                                                    borderRadius: BorderRadius.circular(2)
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),width: 2),
                                                  borderRadius: BorderRadius.circular(3),

                                                ),

                                              ),
                                              onChanged: (value){
                                                if(value.length == 1){
                                                  FocusScope.of(context).nextFocus();
                                                }
                                                else if(value.length == 0){
                                                  FocusScope.of(context).previousFocus();
                                                }
                                              },
                                            )),
                                            SizedBox(width: 10),
                                            Expanded(child: TextField(
                                              textAlign: TextAlign.center,
                                              controller: mobileotp3,
                                              keyboardType: TextInputType.number,
                                              maxLength: 1,
                                              cursorColor: PrimaryColor,
                                              cursorHeight: 20,
                                              decoration: InputDecoration(
                                                hintText: "-",
                                                counterText: '',
                                                hintStyle: TextStyle(color: Colors.black, fontSize: 20.0),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),),
                                                    borderRadius: BorderRadius.circular(2)
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),width: 2),
                                                  borderRadius: BorderRadius.circular(3),

                                                ),

                                              ),
                                              onChanged: (value){
                                                if(value.length == 1){
                                                  FocusScope.of(context).nextFocus();
                                                }
                                                else if(value.length == 0){
                                                  FocusScope.of(context).previousFocus();
                                                }
                                              },
                                            )),
                                            SizedBox(width: 10),
                                            Expanded(child: TextField(
                                              textAlign: TextAlign.center,
                                              controller: mobileotp4,
                                              keyboardType: TextInputType.number,
                                              maxLength: 1,
                                              cursorColor: PrimaryColor,
                                              cursorHeight: 20,
                                              decoration: InputDecoration(
                                                hintText: "-",
                                                counterText: '',
                                                hintStyle: TextStyle(color: Colors.black, fontSize: 20.0),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),),
                                                    borderRadius: BorderRadius.circular(2)
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),width: 2),
                                                  borderRadius: BorderRadius.circular(3),

                                                ),

                                              ),
                                              onChanged: (value){
                                                if(value.length == 1){
                                                  FocusScope.of(context).nextFocus();

                                                  String otpp = mobileotp1.text+mobileotp2.text+mobileotp3.text+mobileotp4.text;

                                                  MobileNumberOtpVerify(otpp,"",numberController.text,"");

                                                }
                                                else if(value.length == 0){
                                                  FocusScope.of(context).previousFocus();
                                                }
                                              },
                                            )),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          child: InputTextField(
                            checkenable: mobileNumberEnable,
                            controller: numberController,
                            keyBordType: TextInputType.number,
                            label: "Mobile Number",
                            labelStyle: TextStyle(color: Colors.black),
                            maxLength: 10,
                            obscureText: false,
                            iButton: _isloading2 ? Container(
                              padding: EdgeInsets.all(12),
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(SecondaryColor)),
                              ),
                            )  : Visibility(
                              visible: iconMobileVisible,
                               replacement: Icon(
                               Icons.check_circle,
                               color: Colors.green,
                             ),
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.transparent,
                              ),
                            ),
                            onChange: (val){
                              if(val.length > 9){
                                _isloading2 = true;

                                MobileNumberCheck("",numberController.text);

                              }else{

                              }
                             },

                          ),
                        ),
                        Visibility(
                          visible: emailVisible,
                          replacement: Container(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 5, right: 6, top: 8, bottom: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.black
                                  )
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    child: Center(
                                      child: Text(
                                        "OTP received on your Registered Email ID.",
                                        style: TextStyle(
                                            fontSize: 11,color:Colors.red,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                      child:Container(
                                        height: 60,
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(child: TextField(
                                              controller: emailotp1,
                                              textAlign: TextAlign.center,
                                              keyboardType: TextInputType.number,
                                              maxLength: 1,
                                              cursorColor: PrimaryColor,
                                              cursorHeight: 20,
                                              decoration: InputDecoration(
                                                hintText: "-",
                                                counterText: '',
                                                hintStyle: TextStyle(color: Colors.black, fontSize: 20.0),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),),
                                                    borderRadius: BorderRadius.circular(2)
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),width: 2),
                                                  borderRadius: BorderRadius.circular(3),

                                                ),

                                              ),
                                              onChanged: (value){
                                                if(value.length == 1){
                                                  FocusScope.of(context).nextFocus();
                                                }
                                                else if(value.length == 0){
                                                  FocusScope.of(context).previousFocus();
                                                }
                                              },
                                            )),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(child: TextField(
                                              textAlign: TextAlign.center,
                                              controller: emailotp2,
                                              keyboardType: TextInputType.number,
                                              maxLength: 1,
                                              cursorColor: PrimaryColor,
                                              cursorHeight: 20,
                                              decoration: InputDecoration(
                                                hintText: "-",
                                                counterText: '',
                                                hintStyle: TextStyle(color: Colors.black, fontSize: 20.0),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),),
                                                    borderRadius: BorderRadius.circular(2)
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),width: 2),
                                                  borderRadius: BorderRadius.circular(3),

                                                ),

                                              ),
                                              onChanged: (value){
                                                if(value.length == 1){
                                                  FocusScope.of(context).nextFocus();
                                                }
                                                else if(value.length == 0){
                                                  FocusScope.of(context).previousFocus();
                                                }
                                              },
                                            )),
                                            SizedBox(width: 10),
                                            Expanded(child: TextField(
                                              textAlign: TextAlign.center,
                                              controller: emailotp3,
                                              keyboardType: TextInputType.number,
                                              maxLength: 1,
                                              cursorColor: PrimaryColor,
                                              cursorHeight: 20,
                                              decoration: InputDecoration(
                                                hintText: "-",
                                                counterText: '',
                                                hintStyle: TextStyle(color: Colors.black, fontSize: 20.0),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),),
                                                    borderRadius: BorderRadius.circular(2)
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),width: 2),
                                                  borderRadius: BorderRadius.circular(3),

                                                ),

                                              ),
                                              onChanged: (value){
                                                if(value.length == 1){
                                                  FocusScope.of(context).nextFocus();
                                                }
                                                else if(value.length == 0){
                                                  FocusScope.of(context).previousFocus();
                                                }
                                              },
                                            )),
                                            SizedBox(width: 10),
                                            Expanded(child: TextField(
                                              textAlign: TextAlign.center,
                                              controller: emailotp4,
                                              keyboardType: TextInputType.number,
                                              maxLength: 1,
                                              cursorColor: PrimaryColor,
                                              cursorHeight: 20,
                                              decoration: InputDecoration(
                                                hintText: "-",
                                                counterText: '',
                                                hintStyle: TextStyle(color: Colors.black, fontSize: 20.0),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),),
                                                    borderRadius: BorderRadius.circular(2)
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),width: 2),
                                                  borderRadius: BorderRadius.circular(3),

                                                ),

                                              ),
                                              onChanged: (value){
                                                if(value.length == 1){
                                                  FocusScope.of(context).nextFocus();

                                                  String emailotpp = emailotp1.text+emailotp2.text+emailotp3.text+emailotp4.text;

                                                  EmailIdOtpVerify("",emailotpp,"",emailController.text);

                                                }
                                                else if(value.length == 0){
                                                  FocusScope.of(context).previousFocus();
                                                }
                                              },
                                            )),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          child: InputTextField(
                            checkenable: emailIdEnable,
                            controller: emailController,
                            keyBordType: TextInputType.text,
                            label: "Email Id",
                            labelStyle: TextStyle(color: emailVisible ? Colors.black : Colors.grey),
                            obscureText: false,
                            errorText: _validate2 ? '' : null,
                            iButton: _isloading1 ? Container(
                              padding: EdgeInsets.all(12),
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(SecondaryColor)),
                              ),
                            ) : Visibility(
                              visible: iconVisible,
                              replacement: IconButton(
                                icon: Icon(Icons.arrow_forward,color: Colors.grey,),
                                onPressed: (){
                                  _isloading1 = true;

                                  bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z]+\.[a-zA-Z]+").hasMatch(emailController.text);


                                  if(emailValid == true){

                                    _isloading1 = true;
                                    EmailIdCheck(emailController.text, "");
                                  }else{

                                    final snackBar2 = SnackBar(
                                      backgroundColor: Colors.red[900],
                                      content: Text("Please Enter Valid Email Id",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(snackBar2);

                                  }

                                },
                              ),
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                            ),
                            onChange: (val){
                              _isloading1 = false;
                              if(val.length >8){
                                iconVisible == true;

                              }
                            },
                          ),
                        ),
                        InputTextField(
                          checkenable: checkUnable,
                          keyBordType: TextInputType.text,
                          controller: nameController,
                          obscureText: false,
                          label:getTranslated(context, 'User Name'),
                          labelStyle: TextStyle(color: checkUnable ? Colors.black : Colors.grey),
                          errorText: _validate ? '' : null,
                          iButton: TextButton.icon(onPressed: (){

                            responsefromaaadharscan();

                          }, icon: Icon(Icons.qr_code,color: SecondaryColor,),
                              label: Text("AutoFill By \nAadharScan",style: TextStyle(fontSize: 9,color: SecondaryColor),)),

                        ),
                        InputTextField(
                         checkenable: checkUnable,
                         obscureText: false,
                         keyBordType: TextInputType.text,
                         controller: compnameController,
                          labelStyle: TextStyle(color: checkUnable ? Colors.black : Colors.grey),
                         errorText: _validate8 ? '' : null,
                         onChange: (value){

                           if(value.length > 1){

                             setState(() {
                               btndis = true;
                             });

                           }

                         },
                         label:getTranslated(context, 'Company Name'),
                       ),
                        Container(
                          padding:
                              EdgeInsets.only(top: 10, left: 10, right: 10),
                          child: OutlineButton(
                            onPressed: btndis == true ? statedialog : null,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            splashColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            clipBehavior: Clip.none,
                            autofocus: false,
                            disabledBorderColor: Colors.grey,
                            color: Colors.transparent,
                            highlightColor: Colors.transparent,
                            highlightedBorderColor: PrimaryColor,
                            focusColor: PrimaryColor,
                            padding: EdgeInsets.only(
                                top: 16, bottom: 16, left: 10, right: 10),
                            borderSide:
                                BorderSide(width: 1, color: PrimaryColor),
                            child: Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      state,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: true,
                                      style: TextStyle(
                                        color: btndis == true ? PrimaryColor : Colors.grey,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                    child: Visibility(
                                      visible: righttikvisi,
                                      child: Icon(Icons.check_circle,color: Colors.green,),
                                      replacement: Icon(
                                        Icons.arrow_drop_down,
                                        color: PrimaryColor,
                                      ),
                                    ),

                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(top: 18, left: 10, right: 10,bottom: 8),
                          child: Column(
                            children: [
                              OutlineButton(
                                onPressed: btndis == true ? districtdialog : null,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                splashColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                clipBehavior: Clip.none,
                                autofocus: false,
                                disabledBorderColor: Colors.grey,
                                color: Colors.transparent,
                                highlightColor: Colors.transparent,
                                highlightedBorderColor: PrimaryColor,
                                focusColor: PrimaryColor,
                                padding: EdgeInsets.only(
                                    top: 16, bottom: 16, left: 10, right: 10),
                                borderSide:
                                    BorderSide(width: 1, color: PrimaryColor),
                                child: Container(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          district,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          softWrap: true,
                                          style: TextStyle(
                                            color: btndis == true ? PrimaryColor : Colors.grey,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                        child: Visibility(
                                          visible: righttikvisi,
                                          child: Icon(Icons.check_circle,color: Colors.green,),
                                          replacement: Icon(
                                            Icons.arrow_drop_down,
                                            color: PrimaryColor,
                                          ),
                                        ),

                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        InputTextField(
                          checkenable: checkUnable,
                          obscureText: false,
                          keyBordType: TextInputType.number,
                          labelStyle: TextStyle(color: checkUnable ? Colors.black : Colors.grey),
                          controller: pincodeController,
                          label:getTranslated(context, 'Pin Code'),
                          errorText: _validate5 ? '' : null,
                        ),
                        InputTextField(
                          checkenable: checkUnable,
                          keyBordType: TextInputType.text,
                          controller: passwordController,
                          label:"Create password",
                          labelStyle: TextStyle(color: checkUnable ? Colors.black : Colors.grey),
                          errorText: _validate6 ? '' : null,
                          borderSide: BorderSide(width: 5, color: PrimaryColor),
                          suffixStyle: const TextStyle(color: PrimaryColor),
                          onSaved: (val) => _password = val,
                          obscureText: _obscureText,
                        ),
                        InputTextField(
                          checkenable: checkUnable,
                          keyBordType: TextInputType.text,
                          controller: repasswordController,
                          label:getTranslated(context, 'Re-enter password'),
                          errorText: _validate6 ? '' : null,
                          labelStyle: TextStyle(color: checkUnable ? Colors.black : Colors.grey),
                          borderSide: BorderSide(width: 5, color: PrimaryColor),
                          iButton: IconButton(
                              onPressed: () {
                                _toggle1();
                              },
                              icon: Icon(_obscureText1
                                  ? Icons.visibility_off
                                  : Icons.visibility,color: PrimaryColor,)),
                          suffixStyle: const TextStyle(color: PrimaryColor),
                          onSaved: (val) => _password = val,
                          obscureText: _obscureText1,
                        ),
                        InputTextField(
                          checkenable: checkUnable,
                          obscureText: false,
                          keyBordType: TextInputType.number,
                          controller: refcodeController,
                          labelStyle: TextStyle(color: checkUnable ? Colors.black : Colors.grey),
                          label:getTranslated(context, 'Referal Code'),
                          errorText: _validate7 ? '' : null,
                        )
                      ],
                    ),
                  ),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(5.0),
                        ),
                      ),
                      child: Row(children: [
                        Expanded(
                          child: MainButtonSecodn(
                            color: SecondaryColor,
                            onPressed: () {
                              if (nameController.text == "" || nameController.text == "0") {
                                setState(() {
                                  _validate = true;
                                });
                              }   else if (pincodeController.text == "" || pincodeController.text == "0") {
                                setState(() {
                                  _validate5 = true;
                                });
                              } else if (passwordController.text == "" || passwordController.text == "0" || repasswordController.text != passwordController.text) {
                                setState(() {
                                  _validate6 = true;
                                });
                              }  else if (compnameController.text == "" || compnameController.text == "0") {
                                setState(() {
                                  _validate8 = true;
                                });
                              } else {

                                setState(() {
                                  _isloading = true;
                                });

                                newuserdata(nameController.text, numberController.text, emailController.text, stateid.toString(), distid.toString(), pincodeController.text, passwordController.text, compnameController.text);
                              }
                            },
                            btnText:  _isloading
                                ? Center(
                              child: SizedBox(
                                height: 20,
                                child: LinearProgressIndicator(
                                  backgroundColor: PrimaryColor,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                            )
                                : Text(getTranslated(context, 'Request To Join Us'),
                                style: TextStyle(
                                  color: TextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                            ),
                          ),
                        ),
                      ]
                      ),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 10, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          BackButton(
                            color: SecondaryColor,
                          ),
                          TextButtons(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            },
                            buttonText: getTranslated(context, 'Login'),
                            textButtonText:getTranslated(context, 'I have an account'),
                            textButtonStyle: TextStyle(
                              color: PrimaryColor,
                              fontSize: 14,
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void newuserdata(String name, String mobile, String email, String state, String dis, String pincode, String pass, String compname) async {
    var uuid = Uuid();
    var keyst = uuid.v1().substring(0, 16);
    var ivstr = uuid.v4().substring(0, 16);

    String keySTR = keyst.toString(); //16 byte
    String ivSTR = ivstr.toString(); //16 byte

    String keyencoded = base64.encode(utf8.encode(keySTR));
    String viencoded = base64.encode(utf8.encode(ivSTR));

    final key = encrypt.Key.fromUtf8(keySTR);
    final iv = encrypt.IV.fromUtf8(ivSTR);

    final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));

    final encrypted1 = encrypter.encrypt(name, iv: iv);
    final encrypted2 = encrypter.encrypt(mobile, iv: iv);
    final encrypted3 = encrypter.encrypt(email, iv: iv);
    final encrypted4 = encrypter.encrypt(state, iv: iv);
    final encrypted5 = encrypter.encrypt(dis, iv: iv);
    final encrypted6 = encrypter.encrypt(pincode, iv: iv);
    final encrypted7 = encrypter.encrypt(pass, iv: iv);
    final encrypted9 = encrypter.encrypt(compname, iv: iv);

    String username = encrypted1.base64;
    String mobilenum = encrypted2.base64;
    String useremail = encrypted3.base64;
    String userstate = encrypted4.base64;
    String userdis = encrypted5.base64;
    String userpin = encrypted6.base64;
    String userpass = encrypted7.base64;
    String usercmp = encrypted9.base64;

    Registeruser(username, mobilenum, useremail, userstate, userdis, pincode,
        userpass, keyencoded, viencoded, usercmp);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('_password', _password));
  }
}

class SignInInput extends StatefulWidget {
  final String labelName, errorText;
  final TextEditingController controller;
  final TextInputType keyBordType;
  final Widget sideicon;
  final int maxlng;

  const SignInInput({
    Key key,
    this.nameController,
    this.labelName,
    this.controller,
    this.errorText, this.keyBordType, this.sideicon, this.maxlng,
  }) : super(key: key);

  final TextEditingController nameController;

  @override
  _SignInInputState createState() => _SignInInputState();
}

class _SignInInputState extends State<SignInInput> {
  @override
  Widget build(BuildContext context) {
    return InputTextField(
      inputFormatter: [ FilteringTextInputFormatter.allow(RegExp("[A-Z a-z 0-9 @ .]")),],
      keyBordType:widget.keyBordType ,
      controller: widget.controller,
      maxLength: widget.maxlng,
      label: widget.labelName,
      iButton: widget.sideicon,
      labelStyle: TextStyle(
        color: PrimaryColor,
      ),
      borderSide: BorderSide(
        width: 2,
      ),
      errorText: widget.errorText,
      obscureText: false,
      onChange: (String val) {


      },
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
