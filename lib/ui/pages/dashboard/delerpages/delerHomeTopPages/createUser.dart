import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/IntroSliderPages/AppSignUpButton.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/DealerMainPage.dart';
import 'package:myapp/ui/pages/dashboard/delerpages/DealerDashboard.dart';
import 'package:myapp/ui/pages/login/join.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/ui/pages/login/login.dart';
import 'package:uuid/uuid.dart';
import 'package:encrypt/encrypt.dart' as encrypt;


class CreateUser extends StatefulWidget {
  const CreateUser({Key key}) : super(key: key);

  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  TextEditingController nameController = TextEditingController();
  TextEditingController firmController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController panController = TextEditingController();
  TextEditingController aadharController = TextEditingController();
  TextEditingController gstController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  bool valuefirst = false;
  bool valuesecond = false;
  bool _isVisible = false;
  int _value = 1;
  int _values = 1;
  List statename = [];

  String stname = "";

  List statesList;
  List districtlist;
  String _myState;
  String _mydis;

  bool _obscureText = true;

  String _password;
  bool _isloading = false;

  var status,msz;

  Future<void> statelist() async {


    String token = "";

    var url = new Uri.http("api.vastwebindia.com", "/Common/api/data/statelist");
    final http.Response response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

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

  Future<void> distrilist(String code) async {


    String token = "";

    var url1 = new Uri.http("api.vastwebindia.com", "/Common/api/data/districtList", {
      "stateid": code,
    });
    final http.Response response = await http.get(
      url1,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response);

    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);

      setState(() {
        districtlist = dataa;
      });

    } else {
      throw Exception('Failed');
    }


  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    statelist();
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

        Registeruser(nameController.text,firmController.text,mobileController.text,emailController.text,
            panController.text,aadharController.text,gstController.text,_myState,_mydis,pincodeController.text,
            "123456",addressController.text);

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
    var token = await storage.read(key: "accessToken");

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

        checkaadhar(aadharController.text);

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


  Future<void> Registeruser(String name2,String firmname2,String mobile2,String email2,
      String pan2,String aadhar2,String gst2, String state2,String district2,String pincode2,
      String password2,String address2,) async {


    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var url = new Uri.http("api.vastwebindia.com", "/api/data/Retailer_create");
    Map map = {
      "Name": name2,
      "firmName": firmname2,
      "Mobile": mobile2,
      "Email": email2,
      "PAN": pan2,
      "Aadhar": aadhar2,
      "GST": gst2,
      "District": district2,
      "State": state2,
      "PINCode": pincode2,
      "PIN": "1234",
      "Password": password2,
      "Address": address2,

    };

    String body = json.encode(map);

    http.Response response = await http.post(url,
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"},
      body: body,
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
      _isloading = false;
      var dataa = json.decode(response.body);
      status = dataa["status"];
      msz = dataa["Message"];

      if(status == "Success"){
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
            Navigator.pushReplacement(
                context, MaterialPageRoute(
                builder: (context) => DealermaninDashboard()));
          },
        );

      }else{

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: msz,
          title: getTranslated(context, 'Warning'),
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

    } else {
      _isloading = false;
      throw Exception('Failed');
    }

  }



  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override

  Widget build(BuildContext context) {
    return
      Material(
        color: PrimaryColor,
        child: Container(
          color: TextColor.withOpacity(0.5),
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Container(
                color: TextColor,
                child: Column(
                  children: [
                    Container(
                      child: Form(
                        autovalidateMode: AutovalidateMode.always, key: _formKey,
                        child: Column(
                          children: [
                            SignInInput(
                              controller: nameController,
                              labelName:getTranslated(context, 'User Name'),

                            ),
                            SignInInput(
                              controller: firmController,
                              labelName: getTranslated(context, 'FirmName'),

                            ),
                            SignInInput(
                              maxlng: 10,
                              controller: mobileController,
                              labelName:getTranslated(context, 'Mobile No'),
                            ),
                            SignInInput(
                              controller: emailController,
                              labelName:getTranslated(context, 'Email'),
                            ),
                            SignInInput(
                              maxlng: 10,
                              controller: panController,
                              labelName: getTranslated(context, 'pancard'),

                            ),
                            Container(
                              child: InputTextField(
                                label: getTranslated(context, 'Enter Aadhar Number'),
                                obscureText: false,
                                maxLength: 12,

                                controller: aadharController,
                                keyBordType: TextInputType.number,
                                labelStyle: TextStyle(
                                  color: PrimaryColor,
                                ),
                                borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                                onChange: (String val){

                                },
                              ),
                            ),
                            SignInInput(
                              controller: gstController,
                              labelName: getTranslated(context, 'Gst Number'),

                            ),

                            Container(
                              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: getTranslated(context, 'Select State'),
                                  contentPadding: EdgeInsets.fromLTRB(10, 18, 10, 18),
                                ),
                                items:statesList?.map((item) {
                                  return new DropdownMenuItem(
                                    child:   Text(item['State Name']),
                                    value: item['Sate Id'].toString(),
                                  );
                                })?.toList() ??
                                    [],
                                onChanged: (String val) {

                                  setState(() {
                                    _myState = val;
                                    distrilist(_myState);
                                  });

                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: getTranslated(context, 'Select Distric'),
                                  contentPadding: EdgeInsets.fromLTRB(10, 18, 10, 18),
                                ),
                                items:districtlist?.map((item) {
                                  return new DropdownMenuItem(
                                    child: new Text(item['Dist Name']),
                                    value: item['Dist Id'].toString(),
                                  );
                                })?.toList() ??
                                    [],
                                onChanged: (String val) {

                                  setState(() {
                                    _mydis = val;
                                  });

                                },
                              ),
                            ),
                            SignInInput(
                              maxlng: 6,
                              controller: pincodeController,
                              labelName:getTranslated(context, 'Pin Code'),
                            ),

                            SignInInput(
                              controller: addressController,
                              labelName: getTranslated(context, 'Address'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                        height: 50,
                        margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Theme.of(context).accentColor,
                            Theme.of(context).primaryColor
                          ]),
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(5.0),
                          ),
                        ),
                        child:
                        Row(children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.all(15),
                                backgroundColor:SecondaryColor ,
                                shadowColor:Colors.transparent,
                              ),
                              onPressed:(){

                                int mobilenum = mobileController.text.length;
                                int pancard =   panController.text.length;
                                int aadhrcrd =  aadharController.text.length;
                                int pincodeee =  pincodeController.text.length;


                                if(nameController.text == ""){

                                  final snackBar2 = SnackBar(
                                    backgroundColor: Colors.red[900],
                                    content: Text("Enter User Name" + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(snackBar2);

                                }else if(firmController.text == ""){

                                  final snackBar2 = SnackBar(
                                    backgroundColor: Colors.red[900],
                                    content: Text(getTranslated(context, 'Enter Firm Name') + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(snackBar2);

                                }else if(mobilenum < 10){

                                  final snackBar2 = SnackBar(
                                    backgroundColor: Colors.red[900],
                                    content: Text("Enter Your Valid Mobile Number" + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(snackBar2);

                                }else if(emailController.text == ""){

                                  final snackBar2 = SnackBar(
                                    backgroundColor: Colors.red[900],
                                    content: Text("Enter Your Email id" + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(snackBar2);

                                }else if(pancard < 10){

                                  final snackBar2 = SnackBar(
                                    backgroundColor: Colors.red[900],
                                    content: Text("Enter Valid Pancard Number" + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(snackBar2);

                                }else if(aadhrcrd < 12){

                                  final snackBar2 = SnackBar(
                                    backgroundColor: Colors.red[900],
                                    content: Text("Enter Valid Aadhar Card Number" + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(snackBar2);

                                }else if(pincodeee < 4){

                                  final snackBar2 = SnackBar(
                                    backgroundColor: Colors.red[900],
                                    content: Text("Enter Valid Pincode Number" + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(snackBar2);

                                }else if(addressController.text == ""){

                                  final snackBar2 = SnackBar(
                                    backgroundColor: Colors.red[900],
                                    content: Text("Enter Your Address" + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(snackBar2);

                                }else {

                                  setState(() {
                                    _isloading = true;
                                  });

                                  checkpannumr(panController.text);

                                }

                              },
                              child: _isloading ? Center(child: SizedBox(height: 20, child: LinearProgressIndicator(backgroundColor: PrimaryColor,valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
                              ),) : Text(
                                  getTranslated(context, 'Create User'),
                                  style: TextStyle(
                                    color: TextColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  )
                              ),
                            ),
                          ),
                        ])),
                    Container(
                        margin: EdgeInsets.only(left: 10,bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            BackButtons(

                              btnText: getTranslated(context, 'back'),
                            ),
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
}
