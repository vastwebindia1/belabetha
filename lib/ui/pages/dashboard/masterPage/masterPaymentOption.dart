import 'dart:convert';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/comingSoonPage.dart';
import 'package:myapp/ui/pages/locations/IpHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'masterRequestToAdmin.dart';

class MasterPaymentOption extends StatefulWidget {
  final String amount;

  const MasterPaymentOption({Key key, this.amount, }) : super(key: key);


  @override
  _MasterPaymentOptionState createState() => _MasterPaymentOptionState();
}
bool check = true;
bool check1 = false;
bool check2 = false;
bool check3 = false;
bool check4 = false;
bool check5 = false;
bool check6 = false;
bool check7 = false;
bool check8 = false;
String text = "";


class _MasterPaymentOptionState extends State<MasterPaymentOption> {


  var selfupistatus;
  var statuss,marsalt;
  var Merchantkey,Merchantid,USERID,Privatekey,txnsuccessUrl,txnfailureUrl,mrchname,merchemail,merchmobile;
  String uniqid;
  String typee;
  var uuid = Uuid();
  Position _currentPosition;
  String netname, ipadd, modelname, androidid, lat, long, city, address, postcode,status,_message;


  Future<void> gatewaytype(String type) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    try{
      var uri = new Uri.http("api.vastwebindia.com", "/Common/api/data/GatewayAuth", {
        "type": type,
      });
      final http.Response response = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // ignore: missing_return
      ).timeout(Duration(seconds: 15), onTimeout: (){
        setState(() {
          final snackBar2 = SnackBar(
            backgroundColor: Colors.greenAccent,
            content: Text(getTranslated(context, 'Data Not Found'),style: TextStyle(color: Colors.black),textAlign: TextAlign.center),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar2);
        });
      });

      print(response);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var resp = data["Response"];
        var msz = data["Message"];

        if(resp == "Success"){
          Merchantkey = data["Merchantkey"];
          Merchantid = data["Merchantid"];
          marsalt = data["MerchantSalt"];
          USERID = data["USERID"];
          Privatekey = data["Privatekey"];
          txnsuccessUrl = data["txnsuccessUrl"];
          txnfailureUrl = data["txnfailureUrl"];

          merchemail = data["email"];
          merchmobile = data["mobile"];
          mrchname = data["name"];


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

          if(type == "CC"){

            setState(() {
              typee = "CC";
              uniqid = uuid.v1().substring(0,16);
            });

            Apitransitionsencrypt(widget.amount, "CC", androidid, "lat", "long", modelname, "city", "postcode", netname, ipadd, "address");

          }else if(type == "DC"){

            setState(() {
              typee = "DC";
              uniqid = uuid.v1().substring(0,16);
            });

            Apitransitionsencrypt(widget.amount, "DC", androidid, "lat", "long", modelname, "city", "postcode", netname, ipadd, "address");

          }else if(type == "WA"){

            setState(() {
              typee = "WA";
              uniqid = uuid.v1().substring(0,16);
            });

            Apitransitionsencrypt(widget.amount, "WA", androidid, "lat", "long", modelname, "city", "postcode", netname, ipadd, "address");

          }else if(type == "NB"){

            setState(() {
              typee = "NB";
              uniqid = uuid.v1().substring(0,16);
            });

            Apitransitionsencrypt(widget.amount, "NB", androidid, "lat", "long", modelname, "city", "postcode", netname, ipadd, "address");

          }else if(type == "UPI"){

            setState(() {
              typee = "UPI";
              uniqid = uuid.v1().substring(0,16);
            });

            Apitransitionsencrypt(widget.amount, "UP", androidid, "lat", "long", modelname, "city", "postcode", netname, ipadd, "address");

          }

        }else{

          final snackBar2 = SnackBar(
            backgroundColor: Colors.red[900],
            content: Text(msz + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar2);

        }



      } else {
        throw Exception('Failed');
      }


    }catch(e){

      print(e);
    }

  }

  Future<void> paymodegate(String amount, String type, String devtoke,String lat, String long,String model, String city, String post, String InternetTYPE, String ip, String addesss, String value1, String value2) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    try{

      var uri = new Uri.http("api.vastwebindia.com", "/Common/api/data/sendgateway_request", {
        "txtamt": amount,
        "txnid":uniqid,
        "ddltypes": type,
        "Devicetoken": devtoke,
        "Latitude": lat,
        "Longitude": long,
        "ModelNo": model,
        "City": city,
        "PostalCode": post,
        "InternetTYPE": InternetTYPE,
        "IP": ip,
        "Addresss": addesss,
        "value1": value1,
        "value2": value2,

      });
      final http.Response response = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // ignore: missing_return
      ).timeout(Duration(seconds: 15), onTimeout: (){
        setState(() {

          final snackBar2 = SnackBar(
            backgroundColor: Colors.greenAccent,
            content: Text(getTranslated(context, 'Data Not Found'),style: TextStyle(color: Colors.black),textAlign: TextAlign.center),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar2);

        });
      });

      print(response);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var resp = data["Status"];
        //var msz = data["txnid"];

        if(resp == "Success"){

          if(typee == "CC"){

            gatwaypay("CC");
            //Navigator.push(context, MaterialPageRoute(builder: (_) => creditgatway(amount: widget.amount,creditamnt: widget.creditcharge2,creditnet: widget.creditnet2,mercentid: Merchantid,merchkey: Merchantkey,succurl: txnsuccessUrl,failurl: txnfailureUrl,uniqid: uniqid,)));

          }else if(typee == "DC"){


            gatwaypay("DC");
            //Navigator.push(context, MaterialPageRoute(builder: (_) => debitgetway(amount: widget.amount,debitamnt: widget.debitcharge2,debitnet: widget.debitnet2,mercentid: Merchantid,merchkey: Merchantkey,succurl: txnsuccessUrl,failurl: txnfailureUrl,uniqid: uniqid,)));

          }else if(typee == "WA"){


            gatwaypay("WA");
            //Navigator.push(context, MaterialPageRoute(builder: (_) => walletgetway(amount: widget.amount,walletcredi: widget.walletcharge2,walletnet: widget.walletnet2,mercentid: Merchantid,merchkey: Merchantkey,succurl: txnsuccessUrl,failurl: txnfailureUrl,uniqid: uniqid)));

          }else if(typee == "NB"){

            gatwaypay("NB");

            //Navigator.push(context, MaterialPageRoute(builder: (_) => netbankingpage(amount: widget.amount,netbnkcredit: widget.netbankingcharge2,netbnknet: widget.netbankingnet2,mercentid: Merchantid,merchkey: Merchantkey,succurl: txnsuccessUrl,failurl: txnfailureUrl,uniqid: uniqid)));

          }else if(typee == "UPI"){

            gatwaypay("UPI");

            //Navigator.push(context, MaterialPageRoute(builder: (_) => netbankingpage(amount: widget.amount,netbnkcredit: widget.netbankingcharge2,netbnknet: widget.netbankingnet2,mercentid: Merchantid,merchkey: Merchantkey,succurl: txnsuccessUrl,failurl: txnfailureUrl,uniqid: uniqid)));

          }

        }else{



          var msz = data["txnid"];

          final snackBar2 = SnackBar(
            backgroundColor: Colors.red[900],
            content: Text(msz + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar2);

        }



      } else {
        throw Exception('Failed');
      }


    }catch(e){

      print(e);
    }

  }

  static const platform = const MethodChannel('com.aasha/credoPay');

  Future<Null> gatwaypay(String type) async {

    try {
      final String result = await platform.invokeMethod('paygatway', {'type' : type, 'pyamount' : widget.amount, 'pysurl' : txnsuccessUrl, 'pyfurl': txnfailureUrl, 'pykey': Merchantkey,'pysalt':marsalt,'pyname':mrchname,'pyemail':merchemail,'pymobile':merchmobile});
      print(result);
    } on PlatformException catch (e) {
      String _message = "Can't do native stuff ${e.message}.";
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
    void onTap(){

      setState(() {

        check = true;
        check1 = false;
        check2 = false;
        check3 = false;
        check4 = false;
        check5 = false;
        check6 = false;
        check7 = false;
        check8 = false;
      });

    }
    void onTap1() {
      setState(() {
        check1 = true;
        check  = false;
        check2 = false;
        check3 = false;
        check4 = false;
        check5 = false;
        check6 = false;
        check7 = false;
        check8 = false;
      });


    }
    void onTap2() async{
      setState(() {
        check1 = false;
        check  = false;
        check2 = true;
        check3 = false;
        check4 = false;
        check5 = false;
        check6 = false;
        check7 = false;
        check8 = false;
      });
    }
    void onTap3() async{
      setState(() {
        check1 = false;
        check  = false;
        check2 = false;
        check3 = true;
        check4 = false;
        check5 = false;
        check6 = false;
        check7 = false;
        check8 = false;
      });
    }
    void onTap4() async{
      setState(() {
        check4 = true;
        check  = false;
        check2 = false;
        check3 = false;
        check1 = false;
        check5 = false;
        check6 = false;
        check7 = false;
        check8 = false;
      });
    }
    void onTap5() async{
      setState(() {
        check5 = true;
        check  = false;
        check2 = false;
        check3 = false;
        check4 = false;
        check1 = false;
        check6 = false;
        check7 = false;
        check8 = false;
      });
    }
    void onTap6() async{
      setState(() {
        check6 = true;
        check  = false;
        check2 = false;
        check3 = false;
        check4 = false;
        check5 = false;
        check1 = false;
        check7 = false;
        check8 = false;
      });
    }
    void onTap7() async{
      setState(() {
        check7 = true;
        check  = false;
        check2 = false;
        check3 = false;
        check4 = false;
        check5 = false;
        check6 = false;
        check1 = false;
        check8 = false;
      });
    }
    void onTap8() async{
      setState(() {
        check8 = true;
        check  = false;
        check2 = false;
        check3 = false;
        check4 = false;
        check5 = false;
        check6 = false;
        check7 = false;
        check1 = false;
      });
    }
    TextStyle style= TextStyle(fontSize: 12,color: PrimaryColor);
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        color: PrimaryColor,
                        child: Container(
                          margin: EdgeInsets.only(left: 10, right: 10, top: 15,bottom: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                child: Center(
                                    child: Text(getTranslated(context, 'Add Amount'),
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: TextColor
                                        ))),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5,),
                                child: Text("\u{20B9} " + widget.amount,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 50,
                                      color: TextColor
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30,left: 10,right: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 60,
                                        width: 60,
                                        child: PaymentsButtons(
                                          onPressed: (){
                                            onTap();
                                          },
                                          color1: check ? Colors.white: Colors.transparent,
                                          color2:check ? Colors.green: Colors.black38,
                                          color3: check ? Colors.green:Colors.transparent,
                                          widget: Image.asset('assets/pngImages/UPI.png',height: 35,),
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(getTranslated(context, 'UPI'),style: style,),
                                    ],
                                  ),
                                ),

                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 60,
                                        width: 60,
                                        child: PaymentsButtons(
                                          onPressed: (){
                                            onTap1();
                                          },
                                          color1: check1 ? Colors.white: Colors.transparent,
                                          color2:check1 ? Colors.green: Colors.black38,
                                          color3: check1 ? Colors.green:Colors.transparent,
                                          widget: Image.asset('assets/pngImages/qr-code.png',height: 35,),
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(getTranslated(context, 'QR Code'),style: style,),
                                    ],
                                  ),
                                ),

                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 60,
                                        width: 60,
                                        child: PaymentsButtons(
                                          onPressed: (){
                                            onTap2();
                                          },
                                          color1: check2 ? Colors.white: Colors.transparent,
                                          color2:check2 ? Colors.green: Colors.black38,
                                          color3: check2 ? Colors.green:Colors.transparent,
                                          widget: Image.asset('assets/pngImages/creditCard.png',height: 38,),
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(getTranslated(context, 'Credit Card'),style: style,),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 60,
                                        width: 60,
                                        child: PaymentsButtons(
                                          onPressed: (){
                                            onTap3();
                                          },
                                          color1: check3 ? Colors.white: Colors.transparent,
                                          color2:check3 ? Colors.green: Colors.black38,
                                          color3: check3 ? Colors.green:Colors.transparent,
                                          widget: Image.asset('assets/pngImages/Debitcard.png',),
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(getTranslated(context, 'Debit Card01'),style: style,),
                                    ],
                                  ),
                                ),

                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 60,
                                        width: 60,
                                        child: PaymentsButtons(
                                          onPressed: (){
                                            onTap4();
                                          },
                                          color1: check4 ? Colors.white: Colors.transparent,
                                          color2:check4 ? Colors.green: Colors.black38,
                                          color3: check4 ? Colors.green:Colors.transparent,
                                          widget: Image.asset('assets/pngImages/netBanking.png',height: 35,),
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(getTranslated(context, 'Net Banking'),style: style,),
                                    ],
                                  ),
                                ),

                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 60,
                                        width: 60,
                                        child: PaymentsButtons(
                                          onPressed: (){
                                            onTap5();
                                          },
                                          color1: check5 ? Colors.white: Colors.transparent,
                                          color2:check5 ? Colors.green: Colors.black38,
                                          color3: check5 ? Colors.green:Colors.transparent,
                                          widget: Image.asset('assets/pngImages/wallets.png',height: 35,),
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(getTranslated(context, 'Wallets'),style: style,),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Row(
                              children: [

                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 60,
                                        width: 60,
                                        child: PaymentsButtons(
                                          onPressed: (){
                                            onTap6();
                                          },
                                          color1: check6 ? Colors.white: Colors.transparent,
                                          color2:check6 ? Colors.green: Colors.black38,
                                          color3: check6 ? Colors.green:Colors.transparent,
                                          widget: Image.asset('assets/pngImages/internationalCard.png',height: 35,),
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(getTranslated(context, 'International Card'),textAlign: TextAlign.center,style: style,),
                                    ],
                                  ),
                                ),

                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 60,
                                        width: 60,
                                        child: PaymentsButtons(
                                          onPressed: (){
                                            onTap8();
                                          },
                                          color1: check8 ? Colors.white: Colors.transparent,
                                          color2:check8 ? Colors.green: Colors.black38,
                                          color3: check8 ? Colors.green:Colors.transparent,
                                          widget: Image.asset('assets/pngImages/reqToAdmin.png',height: 35,),
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(getTranslated(context, 'Request to Admin'),style: style,textAlign: TextAlign.center,),
                                    ],
                                  ),
                                ),

                                Expanded(child: Container())
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: MainButton(
                      onPressed: (){
                        check8? Navigator.push(context, MaterialPageRoute(builder: (_) => MasterRequestAdmin(adminamount: widget.amount,))):
                        check2? gatewaytype("CC")://gatwaypay("CC"):
                        check3? gatewaytype("DC"):
                        check5? gatewaytype("WA"):
                        check4? gatewaytype("NB"):
                        check?  gatewaytype("UPI"):
                        Navigator.push(context, MaterialPageRoute(builder: (_) => ComingSoon()));
                      },
                      btnText:
                      check  ? getTranslated(context, 'Pay By UPI'):
                      check1 ? getTranslated(context, 'Pay By QR'):
                      check2 ? getTranslated(context, 'Pay By Credit Card'):
                      check3 ? getTranslated(context, 'Pay By Debit Card'):
                      check4 ? getTranslated(context, 'Pay By Net Banking'):
                      check5 ? getTranslated(context, 'Pay By Wallets'):
                      check6 ? getTranslated(context, 'Pay By International Card'):
                      check7 ? getTranslated(context, 'Request to Admin'):
                      check8 ? getTranslated(context, 'Request to Admin'):getTranslated(context, 'Pay By UPI'),
                      color: SecondaryColor,
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        BackButtons(
                          btnText: getTranslated(context, 'back'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void Apitransitionsencrypt(String amount, String type, String devtoke, String lat, String long,String model, String city, String post, String InternetTYPE, String ip, String addesss) async{

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

    final encrypted1 =encrypter.encrypt(type, iv: iv);
    final encrypted2 =encrypter.encrypt(devtoke, iv: iv);
    final encrypted3 =encrypter.encrypt(lat, iv: iv);
    final encrypted4 =encrypter.encrypt(long, iv: iv);
    final encrypted5 =encrypter.encrypt(model, iv: iv);
    final encrypted6 =encrypter.encrypt(city, iv: iv);
    final encrypted7 =encrypter.encrypt(post, iv: iv);
    final encrypted8 =encrypter.encrypt(InternetTYPE, iv: iv);
    final encrypted9 =encrypter.encrypt(ip, iv: iv);
    final encrypted10 =encrypter.encrypt(addesss, iv: iv);



    String trnstpee = encrypted1.base64;
    String ipadde = encrypted2.base64;
    String typee = encrypted3.base64;
    String latt = encrypted4.base64;
    String longg = encrypted5.base64;
    String modell = encrypted6.base64;
    String city1 = encrypted7.base64;
    String pinn = encrypted8.base64;
    String inttypee = encrypted9.base64;
    String addrsss = encrypted10.base64;



    paymodegate(amount,trnstpee, ipadde, typee, latt, longg, modell, city1, pinn, inttypee, addrsss, keyencoded, viencoded);
  }

  getCurrentLocation() {
    Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium)
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


class PaymentsButtons extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget widget;
  final Color color1, color2,color3;
  const PaymentsButtons({
    Key key, this.onPressed, this.widget, this.color1, this.color2, this.color3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        fit: StackFit.loose,
        alignment: Alignment.center,
        children: [
          ConstrainedBox(
              constraints: BoxConstraints.tightFor(
                width: 100, height: 100,),
              // ignore: deprecated_member_use
              child:FlatButton(
                shape: CircleBorder(
                    side: BorderSide(
                        width:1,color: color2)),
                color: Colors.transparent,
                onPressed: onPressed,
                child:widget,
              )
          ),
          Positioned(
            top: -1,
            right: -2,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100),
                  ),
                  color: color1,
                ),
                child: Icon(Icons.check_circle,color: color3,)
            ),
          ),
        ],
      ),
    );
  }
}