import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';


class Registerform extends StatefulWidget {
  const Registerform({Key key}) : super(key: key);

  @override
  _RegisterformState createState() => _RegisterformState();
}

class _RegisterformState extends State<Registerform> {

  String name = "";
  String firmname = "";
  String email = "";
  String mobile = "";
  String dob = "";
  String pan = "";
  String aadhar = "";
  String pin = "";
  String address= "";

  bool indicator = false;

  Future<void> pancardforminformation() async {

    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/PAN/api/PAN/PencardRegisterInformation");
    final http.Response response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 10), onTimeout: () {});

    print(response);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var status = data["Response"];
      var dataa = data["Message"];



      setState(() {
        name = dataa["Name"];
        firmname = dataa["firmName"];
        email = dataa["Email"];
        mobile = dataa["Mobile"];
        String sdob = dataa["dob"];
        dob = sdob.substring(0,10);
        pan = dataa["PAN"];
        aadhar = dataa["Aadhar"];
        address = dataa["Address"];
        pin = dataa["PIN"];
      });



    } else {
      throw Exception('Failed');
    }
  }

  Future<void> Registerpancard() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/PAN/api/PAN/RegisterPSAPancard",{
      "txtpanname":name,
      "txtfirmnmpan":firmname,
      "txtemailpan":email,
      "panphone":mobile,
      "dobpan":dob,
      "panpancard":pan,
      "aadharpan":aadhar,
      "txtaddresspan":address,
      "pinpan":pin,
    });

    final http.Response response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 10), onTimeout: () {});

    print(response);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var status = data["Response"];
      var msz = data["Message"];

      setState(() {
        indicator = false;
      });

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
                    builder: (context) => Dashboard()));},

        );
      } else {


        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: msz,
          title: status,
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pancardforminformation();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey,
          appBar: AppBar(
            backgroundColor: SecondaryColor,
            title: Text("PANCARD REGISTER FORM",style: TextStyle(color: Colors.white),),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all()
                  ),
                  child: Text("Name : " + name,style: TextStyle(fontSize: 18),),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all()
                  ),
                  child: Text("Firm Name : " + firmname,style: TextStyle(fontSize: 18),),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all()
                  ),
                  child: Text("Register Email id : " + email,style: TextStyle(fontSize: 14),),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all()
                  ),
                  child: Text("Mobile : " + mobile,style: TextStyle(fontSize: 18),),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all()
                  ),
                  child: Text("DOB : " + dob,style: TextStyle(fontSize: 18),),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all()
                  ),
                  child: Text("Pancard Number : " + pan,style: TextStyle(fontSize: 18),),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all()
                  ),
                  child: Text("Aadhar Number : " + aadhar,style: TextStyle(fontSize: 18),),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all()
                  ),
                  child: Text("Address : " + address,style: TextStyle(fontSize: 18),),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all()
                  ),
                  child: Text("Pincode : "+ pin,style: TextStyle(fontSize: 18),),
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.all(10),
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: SecondaryColor
                      ),
                      onPressed: (){

                        setState(() {
                          indicator = true;
                        });

                        Registerpancard();

                      },
                      child: indicator ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ) : Text("Click TO Register"),
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


