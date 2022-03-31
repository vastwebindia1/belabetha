import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';


class mAtmstatuscheck extends StatefulWidget {
  const mAtmstatuscheck({Key key}) : super(key: key);

  @override
  _mAtmstatuscheckState createState() => _mAtmstatuscheckState();
}

class _mAtmstatuscheckState extends State<mAtmstatuscheck> {

  TextEditingController panname = TextEditingController();
  TextEditingController pananum = TextEditingController();

  bool visiblee = true;

  Future<void> statuscheck() async {

    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/MICROATM/api/data/StatusCheck");
    final http.Response response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 10), onTimeout: () {});

    print(response);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var status = data["status"];
      var msz = data["msg"];

      if(status == "Success"){

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));


      }else if(status == "REFER_BACK"){

        setState(() {
          visiblee = false;
        });
        refferback();

      } else{

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: msz,
          title: status,
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.red,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));
          },
        );

      }




    } else {
      throw Exception('Failed');
    }
  }

  Future<void> refferback() async {

    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/MICROATM/api/data/FillRetailerInformation");
    final http.Response response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 10), onTimeout: () {});

    print(response);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var renname = data["remname"];
      var pannamee = data["pancardname"];

      setState(() {

        panname.text= renname;
        pananum.text = pannamee;
      });

    } else {
      throw Exception('Failed');
    }
  }

  Future<void> reffsubmit(String username, String pannume) async {

    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/MICROATM/api/data/UpdateRetailerDetailsnamepancard",{
      "remusrname":username,
      "rempanno":pannume
    });
    final http.Response response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 10), onTimeout: () {});

    print(response);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var status = data["status"];
      var msg = data["msg"];

      if(status == "Success"){

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: msg,
          title: status,
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));
          },
        );

      }else{
        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: msg,
          title: status,
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.red,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));
          },
        );

      }


    } else {
      throw Exception('Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => Dashboard(),
              transitionDuration: Duration(seconds: 0),
            ),);
        },icon: Icon(Icons.arrow_back,color: TextColor,),),
        title: Align(
            alignment:  Alignment(-.4, 0),
            child: Text("",style: TextStyle(color: TextColor),textAlign: TextAlign.center,)),
        elevation: 0,
        toolbarHeight: 39,
        leadingWidth: 60,
        backgroundColor: PrimaryColor,
      ),
      backgroundColor: TextColor,
      body: Column(
        children: [
          Visibility(
            visible: visiblee,
            child: Container(
              margin: EdgeInsets.only(top: 30),
              child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Image.asset('assets/pngImages/pending_watch.png',width: 100,),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Text(getTranslated(context, 'mrstatus'),style: TextStyle(color:SecondaryColor,fontWeight: FontWeight.bold,fontSize: 20),),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  child: MainButtonSecodn(
                    color: SecondaryColor,
                    onPressed: (){

                      statuscheck();
                    },
                    btnText: Text(getTranslated(context, 'Check Status'),style: TextStyle(color: TextColor),),
                  ),
                )
              ],
          ),
            ),
            replacement: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(getTranslated(context, 'panstatus'),style: TextStyle(color:SecondaryColor,fontWeight: FontWeight.bold,fontSize: 20),),
              ),
              Container(
                child: InputTextField(
                  label:getTranslated(context, 'Enter Name'),
                  obscureText: false,
                  controller: panname,
                  keyBordType: TextInputType.text,
                  labelStyle: TextStyle(
                    color: PrimaryColor,
                  ),
                  borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                  onChange: (String val){

                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: InputTextField(
                  label: getTranslated(context, 'PAN Number'),

                  maxLength: 10,
                  controller: pananum,
                  obscureText: false,
                  keyBordType: TextInputType.number,
                  labelStyle: TextStyle(
                    color: PrimaryColor,
                  ),
                  borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                  onChange: (String val){

                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 10,right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.all(15),
                          backgroundColor:SecondaryColor ,
                          shadowColor:Colors.transparent,

                        ),
                        onPressed:(){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));
                        },
                        child: Text(getTranslated(context, 'Cancle'),style: TextStyle(color: TextColor),),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.all(15),
                          backgroundColor:SecondaryColor ,
                          shadowColor:Colors.transparent,

                        ),
                        onPressed:(){

                          reffsubmit(panname.text,pananum.text);

                        },
                        child: Text(getTranslated(context, "UPDATE"),style: TextStyle(color: TextColor),),
                      ),
                    ),
                  ],
                ),
              )

            ],
          ),),
        ],
      ),
    );
  }
}
