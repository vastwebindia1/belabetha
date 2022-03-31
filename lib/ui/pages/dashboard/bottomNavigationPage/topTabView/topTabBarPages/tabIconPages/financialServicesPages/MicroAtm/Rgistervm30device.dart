import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/BroadbandPage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/dthRechargePage.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';


class registervm30 extends StatefulWidget {

  final String deviceSerial ;
  const registervm30({Key key, this.deviceSerial}) : super(key: key);

  @override
  _registervm30State createState() => _registervm30State();
}

class _registervm30State extends State<registervm30> {

  bool _validate = false;
  TextEditingController devicenum = TextEditingController();

  Future<void> deviceregis(String serialno) async {

    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/MICROATM/api/data/SubmitSnNo",{
      "DeviceSnNo":serialno
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
      var msz = data["msg"];

      if(status == "Success"){

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: msz,
          title: status,
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));
          },
        );

      } else{

        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(msz + "!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);

      }




    } else {
      throw Exception('Failed');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    devicenum.text = widget.deviceSerial;
  }

  @override
  Widget build(BuildContext context) {

    return Material(
      child:AppBarWidget(
        title: CenterAppbarTitle(
          svgImage: 'assets/pngImages/BBPS.png',
          topText: "",
          selectedItemName: getTranslated(context, 'Device Register'),
        ),
        body: Column(
          children: [
            Container(
                margin: EdgeInsets.only(top: 10,right: 10,left: 20),
                child: Row(
                  children: [
                    Text(getTranslated(context, 'Merchant Approved Successfully'),style: TextStyle(color:SecondaryColor,fontWeight: FontWeight.bold,fontSize: 18),),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.check_circle,color: Colors.green,)
                  ],
                )
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 10,right: 10),
              child: InputTextField(
                label: widget.deviceSerial,
                errorText:  _validate ? '' : null,
                obscureText: false,
                controller: devicenum,
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
              margin: EdgeInsets.only(left: 10,right: 10),
              child: MainButtonSecodn(
                color: SecondaryColor,
                onPressed: () {



                  if(devicenum.text == ""){
                    setState(() {
                      _validate = true;
                    });
                  }else{
                    deviceregis(devicenum.text);
                  }

                },
                btnText: Text(getTranslated(context, 'Active Device'),style: TextStyle(color: TextColor),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
