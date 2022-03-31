import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/masterPage/masterMainPage.dart';
import 'package:myapp/ui/pages/login/join.dart';
import 'package:http/http.dart' as http;


class MasterCreateUser extends StatefulWidget {
  const MasterCreateUser({Key key}) : super(key: key);

  @override
  _MasterCreateUserState createState() => _MasterCreateUserState();
}

class _MasterCreateUserState extends State<MasterCreateUser> {



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
  List statename = [];

  String stname = "";

  List statesList;
  List districtlist;
  String _myState;
  String _mydis;

  bool _obscureText = true;

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


  Future<void> creteDealer(String name2,String firmname2,String mobile2,String email2,
      String pan2,String aadhar2,String gst2, String state2,String district2,String pincode2,
      String address2,) async {


    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var url = new Uri.http("api.vastwebindia.com", "/api/master/createDealer");
    Map map = {
      "Dealerid":"",
      "Name": name2,
      "Firm": firmname2,
      "Mobile": mobile2,
      "Email": email2,
      "Pan": pan2,
      "Adhaar": aadhar2,
      "Gst": gst2,
      "District": district2,
      "State": state2,
      "Pincode": pincode2,
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
      status = dataa["Response"];
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
                context,
                MaterialPageRoute(
                    builder: (context) => MasterManinDashboard()));
          },
        );

      }else{

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: msz,
          title: status,
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
    return Container(

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
                      controller: mobileController,
                      labelName:getTranslated(context, 'Mobile No'),
                    ),
                    SignInInput(
                      controller: emailController,
                      labelName:getTranslated(context, 'Email'),
                    ),
                    SignInInput(
                      controller: panController,
                      labelName: getTranslated(context, 'pancard'),

                    ),
                    SignInInput(
                      controller: aadharController,
                      labelName: getTranslated(context, 'Aadhar'),

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

                        setState(() {
                          _isloading = true;
                        });

                        creteDealer(nameController.text,firmController.text,mobileController.text,emailController.text,
                            panController.text,aadharController.text,gstController.text,_myState,_mydis,pincodeController.text,
                           addressController.text);

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
    );
  }
}
