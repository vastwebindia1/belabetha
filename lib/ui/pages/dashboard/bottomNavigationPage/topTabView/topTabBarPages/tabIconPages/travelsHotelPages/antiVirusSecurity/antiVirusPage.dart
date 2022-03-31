import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:myapp/ui/pages/locations/IpHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:http/http.dart'as http;

class AntiVirusSecurity extends StatefulWidget {
  const AntiVirusSecurity({Key key}) : super(key: key);

  @override
  _AntiVirusSecurityState createState() => _AntiVirusSecurityState();
}

class _AntiVirusSecurityState extends State<AntiVirusSecurity> {

  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  List antiList = [];
  String sspco = "";
  String price = "";
  String mnt = "";
  String dev = "";
  String offpr = "";
  String plnme = "";

  String modelname = "";
  String androidid = "";
  String lat = "";
  String long =  "";
  String city =  "";
  String address = "";
  String postcode = "";
  String netname = "";
  String ipadd = "";
  String deviceToken = "device";

  String mrp = "";
  String rs = "";
  String discount = "";


  Future<void> antiVirusSecurity() async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url =
    new Uri.http("api.vastwebindia.com", "/api/data/AntiVirus_Security",{

    });
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
      var data = json.decode(response.body);
      var result = data["RESULT"];
      var adinfo = data["ADDINFO"];



      setState(() {
        antiList = adinfo;




      });

    } else {
      throw Exception('Failed to load themes');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    antiVirusSecurity();
  }


  Future<void> antiVirusPurchase(String sspCode, String offerPrice,String planeName,String month,
      String mobile,String email,String device,String deviceTo,String latitude,String longitude,
      String android,String city1,String postCode1,String netType,String address1,String ipAddress1) async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");
    String token = a;

    var uri = new Uri.http("api.vastwebindia.com", "/api/data/AntiVirus_Secu_Purcharse", {
      "sspcode":sspCode,
      "offerprice": offerPrice,
      "planname": planeName,
      "month": month,
      "txtmobile": mobile,
      "email": email,
      "device": device,
      "Devicetoken": deviceTo,
      "Latitude": latitude,
      "Longitude": longitude,
      "ModelNo": android,
      "City": city1,
      "PostalCode": postCode1,
      "InternetTYPE": netType,
      "Address": address1,
      "IPAddress": ipAddress1,


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

      var data1 = json.decode(response.body);
      var status = data1["Response"];
      var msz = data1["Message"];

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
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AntiVirusSecurity()));
          },
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
            setState(() {
            });
            Navigator.of(context).pop();
          },
        );
      }
    }


    else {



      throw Exception('Failed to load data from internet');
    }
  }


  void antiPurchaseddialoge(){
    showDialog(
        barrierDismissible: false,
        context: context,
        useSafeArea: false,
        builder: (BuildContext context) {
            return Container(
              color: Colors.black.withOpacity(0.8),
              child: AlertDialog(
                  buttonPadding: EdgeInsets.all(0),
                  titlePadding: EdgeInsets.all(0),
                  contentPadding: EdgeInsets.only(left: 5,right: 5),
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
                                  child: Text(getTranslated(context, 'Purchase'),
                                    style: TextStyle(color: TextColor,fontSize: 20),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                CloseButton(
                                  color: TextColor,
                                ),
                              ],
                            ),

                          ),
                        ),
                      ],
                    ),
                  ),
                  content: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Expanded(child: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 10,),
                                InputTextField(
                                  controller: mobileController,
                                  hint:getTranslated(context, 'Mobile Number'),
                                  labelStyle: TextStyle(color: PrimaryColor),
                                  label: getTranslated(context, 'Mobile Number'),
                                  obscureText: false,
                                ),
                                InputTextField(
                                  controller: emailController,
                                  labelStyle: TextStyle(color: PrimaryColor),
                                  hint:getTranslated(context, 'Enter Email'),
                                  label:getTranslated(context, 'Enter Email'),
                                  obscureText: false,
                                ),
                                Text(getTranslated(context, 'Note'),style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left),
                                Text(getTranslated(context, '1sec'),
                                  style: TextStyle(fontSize: 14),),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: MainButton(
                                    color: SecondaryColor,
                                    btnText: getTranslated(context, 'ConfirmPay'),
                                    style: TextStyle(color: TextColor),
                                    onPressed: (){

                                      setState(() async {

                                        final prefs = await SharedPreferences.getInstance();
                                        var dd = IpHelper().getCurrentLocation();
                                        var hu = IpHelper().getconnectivity();
                                        var hdddu = IpHelper().getLocalIpAddress();
                                        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                                        AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;

                                        modelname = androidDeviceInfo.model;
                                        androidid = androidDeviceInfo.androidId;

                                        lat =     prefs.getString('lat2');
                                        long =    prefs.getString('long2');
                                        city =     prefs.getString('city2');
                                        address = prefs.getString('add2');
                                        postcode=prefs.getString('post2');
                                        netname = prefs.getString('conntype');
                                        ipadd =   prefs.getString('ipaddress');

                                        antiVirusPurchase(sspco,offpr,plnme,mnt,mobileController.text,emailController.text,
                                            dev,deviceToken,lat,long,androidid,city,postcode,netname,address,ipadd);


                                      });

                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),)
                        ],
                      )
                  )
              ),
            );
        });

  }


  ScrollController _controllerList = new ScrollController();

  @override

  Widget build(BuildContext context) {
    return Material(
      child: SimpleAppBarWidget(
        title: Align(
            alignment:  Alignment(-.4, 0),
            child: Text(getTranslated(context, 'Security'),style: TextStyle(color: TextColor),textAlign: TextAlign.center,)),

        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                antiList.length == 0 ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DoteLoader(),
                  ],
                ):

                ListView.builder(
                    controller: _controllerList,
                    shrinkWrap: true,
                    itemCount:antiList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: PrimaryColor.withOpacity(0.08),
                                    blurRadius: .5,
                                    spreadRadius: 1,
                                    offset:
                                    Offset(.0, .0), // shadow direction: bottom right
                                  )
                                ],
                              ),
                              margin: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 10),
                              child: Container(
                                margin: EdgeInsets.only(left: 0.5,right: 0.5,
                                    top: 0.5,bottom: 0.5),
                                child: Container(
                                  color:Colors.white.withOpacity(0.5),
                                  padding: EdgeInsets.only(top: 5, bottom: 0, left: 5, right: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                      color: PrimaryColor.withOpacity(0.5),
                                                      width: 1,
                                                    ))
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(getTranslated(context, 'Norton LiteLock'),style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),

                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(getTranslated(context, 'Device'),style: TextStyle(fontSize: 10,),),
                                                    Text(antiList[index]["Device"].toString() == null ? "" : antiList[index]["Device"].toString(),
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Text(getTranslated(context, 'Month'),style: TextStyle(fontSize: 10,),),
                                                    Text(antiList[index]["Month"].toString() == null ? "" :antiList[index]["Month"].toString(),
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(top: 3,bottom: 3,),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                      color: PrimaryColor.withOpacity(0.5),
                                                      width: 1,
                                                    ))
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(antiList[index]["Plan_name"].toString() == null ? "" :antiList[index]["Plan_name"].toString(),style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),

                                              ],
                                            ),
                                          ),
                                          // CustomerInfo1(
                                          //   firstText: "ID",
                                          //   secondText: inforeport[index]["RequestId"].toString() == null ? "..." :inforeport[index]["RequestId"].toString(),
                                          // ),
                                        ],
                                      ),

                                      Container(
                                        height: 1,
                                        color: PrimaryColor.withOpacity(0.1),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [

                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [

                                                Text(getTranslated(context, 'MRP') + antiList[index]["Producation_price"].toString() == null ? "" :getTranslated(context, 'MRP') + antiList[index]["Producation_price"].toString(), style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),textAlign: TextAlign.center,),

                                              ],
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.centerRight,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [

                                                Text( (100*((double.parse(antiList[index]["Producation_price"].toString()) - double.parse(antiList[index]["offer_price"].toString())) / double.parse(antiList[index]["Producation_price"].toString()))).toStringAsFixed(2)
                                                    +" % OFF", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),textAlign: TextAlign.center,)
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 8,bottom: 8,),
                                        decoration: BoxDecoration(
                                            color: TextColor,
                                            border: Border.all(
                                            )
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              child: Padding(
                                                padding: const EdgeInsets.all(2.0),
                                                child: Text(getTranslated(context, 'Now Availbale Just For') + antiList[index]["offer_price"].toString() == null ? "" :getTranslated(context, 'Now Availbale Just For') + antiList[index]["offer_price"].toString(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),),
                                              ),
                                            ),

                                            Container(
                                              height: 10,
                                              width: 10,
                                              color: Colors.green,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 3,bottom: 3,),
                                        decoration: BoxDecoration(
                                            border: Border.all(

                                            )
                                        ),
                                        child: Text(getTranslated(context, 'Benefits'),style: TextStyle(fontSize: 12,),
                                          overflow: TextOverflow.clip,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 3,bottom: 3,),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Container(
                                              margin: EdgeInsets.only(right: 10),
                                              height: 10,
                                              width: 10,
                                              color: Colors.green,
                                            ),

                                            Flexible(
                                              flex: 2,
                                              child: Text(antiList[index]["features1"].toString() == null ? "" :antiList[index]["features1"].toString(),style: TextStyle(fontSize: 12),
                                                overflow: TextOverflow.clip,
                                                textAlign: TextAlign.left,),
                                            ),

                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 3,bottom: 3,),

                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(right: 10),
                                              height: 10,
                                              width: 10,
                                              color: Colors.green,
                                            ),
                                            Container(
                                              child: Expanded(
                                                child: Text(antiList[index]["features2"].toString() == null ? "" :antiList[index]["features2"].toString(),style: TextStyle(fontSize: 12),
                                                    overflow: TextOverflow.clip,
                                                    textAlign: TextAlign.left),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 3,bottom: 3,),

                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(right: 10),
                                              height: 10,
                                              width: 10,
                                              color: Colors.green,
                                            ),
                                            Container(
                                              child: Expanded(
                                                child: Text(antiList[index]["features3"].toString() == null ? "" :antiList[index]["features3"].toString(),style: TextStyle(fontSize: 12),
                                                    overflow: TextOverflow.clip,
                                                    textAlign: TextAlign.left),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 3,bottom: 3,),

                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(right: 10),
                                              height: 10,
                                              width: 10,
                                              color: Colors.green,
                                            ),
                                            Container(
                                              child: Expanded(
                                                child: Text(antiList[index]["features4"].toString() == null ? "" :antiList[index]["features4"].toString(),style: TextStyle(fontSize: 12),
                                                    overflow: TextOverflow.clip,
                                                    textAlign: TextAlign.left),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 3,bottom: 3,),

                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(right: 10),
                                              height: 10,
                                              width: 10,
                                              color: Colors.green,
                                            ),
                                            Container(
                                              child: Flexible(
                                                child: Text(antiList[index]["features5"].toString() == null ? "" :antiList[index]["features5"].toString(),style: TextStyle(fontSize: 12),
                                                  overflow: TextOverflow.clip,
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 3,bottom: 3,),

                                        child : MainButtonSecodn(
                                            onPressed: () {

                                              setState(() {

                                                sspco = antiList[index]["SSp_Code"];
                                                price = antiList[index]["Producation_price"].toString();
                                                mnt =   antiList[index]["Month"].toString();
                                                dev =   antiList[index]["Device"].toString();
                                                offpr = antiList[index]["offer_price"].toString();
                                                plnme = antiList[index]["Plan_name"];


                                                antiPurchaseddialoge();
                                              });


                                            },
                                            color: SecondaryColor,
                                            btnText:Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                    child:
                                                    Text(getTranslated(context, 'Purchase Now'),textAlign: TextAlign.center,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: TextColor),)
                                                ),
                                              ],
                                            )
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            )
                          ],
                        ),
                      );

                    }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
