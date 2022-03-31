import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/homeTopPages/addMoney.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/HistoryPage/PancardHistory.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/BroadbandPage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/dthRechargePage.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:myapp/ui/pages/locations/IpHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart'as http;
import 'package:encrypt/encrypt.dart' as encrypt;

class Pancardpage extends StatefulWidget {
  const Pancardpage({Key key, this.psaid}) : super(key: key);

  final String psaid;
  @override
  _PancardpageState createState() => _PancardpageState();
}

class _PancardpageState extends State<Pancardpage> {

  TextStyle style = TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold);
  TextStyle labelStyle = TextStyle(
    color: PrimaryColor,
    fontSize: 14,
  );
  Color color = PrimaryColor;
  _launchURL() async {
    const url = 'https://www.psaonline.utiitsl.com/psaonline/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  int phytoken = 0;
  int digtoken = 0;

  bool _isloading = false;

  String netname, ipadd, modelname, androidid, lat, long, city, address, postcode,status;
  Position _currentPosition;

  Future<void> tokenpurchase(String digitaltoken, String phystoken, String ipaddr, String lat,String long, String model,String city, String postcode,String intype,String address,String key, String iv) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    try{

      var uri = new Uri.http("api.vastwebindia.com", "/PAN/api/PAN/Pancardbuy", {
        "digitalCount": digitaltoken,
        "physicalCount": phystoken,
        "ipaddress": ipaddr,
        "Devicetoken": "testign",
        "Latitude": lat,
        "Longitude": long,
        "ModelNo": model,
        "City": city,
        "PostalCode": postcode,
        "InternetTYPE":intype,
        "Address":address,
        "value1":key,
        "value2":iv
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
          _isloading = false;
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
                                    builder: (context) => PancardHistory()));
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
        _isloading = false;
        var data = json.decode(response.body);
        var status = data["RESULT"];
        var msz = data["ADDINFO"];

        if(status == "0"){

          CoolAlert.show(
            backgroundColor: PrimaryColor.withOpacity(0.7),
            context: context,
            type: CoolAlertType.success,
            text: msz,
            confirmBtnText: 'OK',
            confirmBtnColor: Colors.green,
            onConfirmBtnTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));},

          );
        }else{

          CoolAlert.show(
            backgroundColor: PrimaryColor.withOpacity(0.6),
            context: context,
            type: CoolAlertType.error,
            text: msz,
            confirmBtnText: 'OK',
            confirmBtnColor: Colors.red,
            onConfirmBtnTap: (){
              Navigator.of(context).pop();},
          );

        }

      } else {
        throw Exception('Failed');
      }


    }catch(e){

    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final snackBar = SnackBar(content: Text(getTranslated(context, 'Please Enter Valid Token Number'),style: TextStyle(color: Colors.yellowAccent),),);
    return Material(
      child: AppBarWidget(
        title: CenterAppbarTitle(
          svgImage: 'assets/pngImages/BBPS.png',
          topText:getTranslated(context, 'pancard'),
          selectedItemName: getTranslated(context, 'pancard'),
        ),
        body: SafeArea(
          child: Container(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 5),
                      color: PrimaryColor.withOpacity(0.8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(top: 10, left: 5, right: 5,bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                              height: 50,
                                              alignment: Alignment.centerLeft,
                                              margin: EdgeInsets.only(left: 5,right: 0,top: 0),
                                              padding: EdgeInsets.only(top: 4,bottom: 4,right: 10,left: 10),
                                              decoration: BoxDecoration(
                                                border: Border.all(width: 1,color: PrimaryColor),
                                                borderRadius: BorderRadius.circular(0),
                                                color: TextColor.withOpacity(0.8),
                                              ),
                                              child: Container(
                                                child: Row(
                                                  children: [
                                                    Text(getTranslated(context, 'PSA ID'),style: style,overflow: TextOverflow.ellipsis,),
                                                    Flexible(
                                                      child: Text(" : " + widget.psaid,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                                                        overflow: TextOverflow.clip,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 120,
                                    decoration: BoxDecoration(
                                        color: SecondaryColor,
                                        border: Border.all(
                                            width: 1,
                                            color: PrimaryColor
                                        )
                                    ),
                                    child: FlatButton(
                                      onPressed: (){
                                        _launchURL();
                                      },
                                      child: Text(getTranslated(context, 'Login UTR'),style: TextStyle(color: TextColor),overflow: TextOverflow.ellipsis,),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5,right: 5),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: EdgeInsets.only(top: 5,bottom: 5),
                              child: Text(getTranslated(context, '1pan'),textAlign: TextAlign.start,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)),
                          Container(
                              padding: EdgeInsets.only(top: 5,bottom: 5),
                              child: Text(getTranslated(context, '2pan'),textAlign: TextAlign.start,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold))),
                          Container(
                              padding: EdgeInsets.only(top: 5,bottom: 5),
                              child: Text(getTranslated(context, '3pan'),textAlign: TextAlign.start,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10,right: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(getTranslated(context, 'Physical Token'),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: SecondaryColor,
                                    border: Border.all(
                                        width: 1,
                                        color: PrimaryColor
                                    )
                                ),
                                child: Center(
                                  child: FlatButton(
                                      onPressed: (){
                                        setState(() {
                                          setState(() {
                                            phytoken--;
                                          });
                                        });
                                      },
                                      child: Icon(Icons.remove,color: Colors.black,size: 20,)
                                  ),
                                )
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                    )
                                ),
                                child: Center(
                                  child: Text(phytoken.toString()),
                                )
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: SecondaryColor,
                                    border: Border.all(
                                        width: 1,
                                        color: PrimaryColor
                                    )
                                ),
                                child: Center(
                                  child: FlatButton(
                                    onPressed: (){

                                      setState(() {
                                        phytoken++;
                                      });
                                    },
                                    child: Icon(Icons.add,color: Colors.black,size: 20,),
                                  ),
                                )
                            ),
                            SizedBox(width: 10,)
                          ],
                        )

                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(getTranslated(context, 'Digital Token'),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),overflow: TextOverflow.ellipsis,),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: SecondaryColor,
                                      border: Border.all(
                                          width: 1,
                                          color: PrimaryColor
                                      )
                                  ),
                                  child: Center(
                                    child: FlatButton(
                                        onPressed: (){
                                          setState(() {
                                            setState(() {
                                              digtoken--;
                                            });
                                          });
                                        },
                                        child: Icon(Icons.remove,color: Colors.black,size: 20,)
                                    ),
                                  )
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                    )
                                ),
                                child: Center(
                                  child: Text(digtoken.toString()),
                                )
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: SecondaryColor,
                                    border: Border.all(
                                        width: 1,
                                        color: PrimaryColor
                                    )
                                ),
                                child: Center(
                                  child: FlatButton(
                                    onPressed: (){

                                      setState(() {
                                        digtoken++;
                                      });
                                    },
                                    child: Icon(Icons.add,color: Colors.black,size: 20,),
                                  ),
                                )
                            ),
                            SizedBox(width: 10,)
                          ],
                        )


                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MainButtonSecodn(
                        onPressed: () async {

                          if(phytoken == 0 || phytoken < 0){

                            ScaffoldMessenger.of(context).showSnackBar(snackBar);

                          }else if(digtoken < 0){

                            ScaffoldMessenger.of(context).showSnackBar(snackBar);

                          }else{
                            setState(() {

                              _isloading = true;
                            });

                            final prefs = await SharedPreferences.getInstance();
                            var dd= IpHelper().getCurrentLocation();
                            var hu= IpHelper().getconnectivity();
                            var hdddu= IpHelper().getLocalIpAddress();

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


                             tokenpur(digtoken.toString(), phytoken.toString(), ipadd, lat, long, modelname, city, postcode, netname, address);

                          }


                        },
                        color: SecondaryColor,
                        btnText:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: _isloading ? Center(child: SizedBox(
                                  height: 20,
                                  child: LinearProgressIndicator(backgroundColor: PrimaryColor,valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
                                ),) : Text(getTranslated(context, 'Purchase'),textAlign: TextAlign.center,style: TextStyle(color: TextColor),)
                            ),
                          ],
                        )
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void tokenpur(String digital, String physical,String ipadd, String lat,String long, String model, String city,String pascode, String contype,String address) async{


    final storage = new FlutterSecureStorage();

    var uuid = Uuid();
    var keyst = uuid.v1().substring(0,16);
    var ivstr = uuid.v4().substring(0,16);

    String keySTR = keyst.toString(); //16 byte
    String ivSTR =  ivstr.toString(); //16 byte

    String keyencoded = base64.encode(utf8.encode(keySTR));
    String viencoded = base64.encode(utf8.encode(ivSTR));


    final key = encrypt.Key.fromUtf8(keySTR);
    final iv = encrypt.IV.fromUtf8(ivSTR);

    final encrypter = encrypt.Encrypter(encrypt.AES(key,mode: encrypt.AESMode.cbc,padding: 'PKCS7'));

    final encrypted1 =encrypter.encrypt(digital, iv: iv);
    final encrypted2 =encrypter.encrypt(physical, iv: iv);
    final encrypted3 =encrypter.encrypt(ipadd, iv: iv);
    final encrypted4 =encrypter.encrypt(lat, iv: iv);
    final encrypted5 =encrypter.encrypt(long, iv: iv);
    final encrypted6 =encrypter.encrypt(model, iv: iv);
    final encrypted7 =encrypter.encrypt(city, iv: iv);
    final encrypted8 =encrypter.encrypt(pascode, iv: iv);
    final encrypted9 =encrypter.encrypt(address, iv: iv);
    final encrypted10 =encrypter.encrypt(contype, iv: iv);



    String dig = encrypted1.base64;
    String phy = encrypted2.base64;
    String ipda = encrypted3.base64;
    String lat1 = encrypted4.base64;
    String long1 = encrypted5.base64;
    String modell = encrypted6.base64;
    String city1 = encrypted7.base64;
    String pascode1 = encrypted8.base64;
    String addre1 = encrypted9.base64;
    String connty = encrypted10.base64;




    tokenpurchase(dig,phy,ipda,lat1,long1,modell,city1,pascode1,connty,addre1,keyencoded,viencoded);

  }


  getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        print(_currentPosition);
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

