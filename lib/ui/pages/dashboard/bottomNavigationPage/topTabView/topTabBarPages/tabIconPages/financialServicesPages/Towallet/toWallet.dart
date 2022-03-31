import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/homeTopPages/addMoney.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/BroadbandPage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/dthRechargePage.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:myapp/ui/pages/locations/IpHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart'as http;
import 'package:encrypt/encrypt.dart' as encrypt;


class walletPay extends StatefulWidget {
  const walletPay({Key key}) : super(key: key);
  @override
  _walletPayState createState() => _walletPayState();
}

class _walletPayState extends State<walletPay> {

  List walletType = ["PAYTM WALLET"];

  String walletType1 = "PAYTM WALLET";

  String modelname,androidid;

  bool _validate = false;

  String userId;
  String lat,long,city,address,postcode,netname,ipadd;
  String abc = "test";
  String abd = "na";
  String abf = "na";
  String abg = "na";
  String abi = "na";
  String peee = "Wallet";
  String bnm = "PAYTMBANK";
  String eee = "Paytm123";



  bool btnclick = false;
  bool _isloading = false;


  TextEditingController mobileController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController reamountController = TextEditingController();
  TextEditingController pinController = TextEditingController();



  Future<void> userIdenty() async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "userId");

    String userid = a;
    setState(() {
      userId = userid;
    });
  }

  void walletdialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.black.withOpacity(0.8),
            alignment: Alignment.topLeft,
            child: AlertDialog(
              /*insetPadding: EdgeInsets.only(right: 122, left: 0,top: 38,),*/
              buttonPadding: EdgeInsets.all(0),
              titlePadding: EdgeInsets.all(0),
              contentPadding: EdgeInsets.only(left: 10, right: 10),
              title: Container(
                margin: EdgeInsets.only(bottom: 8),
                padding:
                EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
                color: PrimaryColor,
                child: Text(getTranslated(context, 'Select Wallet'),
                  style: TextStyle(color: TextColor, fontSize: 22),
                ),
              ),
              content: Container(
                // Change as per your requirement
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                  itemCount: walletType.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      visualDensity: VisualDensity(vertical: 0, horizontal: 0),
                      isThreeLine: false,
                      contentPadding: EdgeInsets.all(0),
                      minVerticalPadding: 2,
                      horizontalTitleGap: 0,
                      onTap: () {

                        setState(() {

                          walletType1 = walletType[index];


                        });

                        Navigator.of(context).pop();
                      },
                      title: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              walletType[index],
                              textAlign: TextAlign.left,
                            ),
                            Container(
                              height: 1,
                              color: PrimaryColor,
                              margin: EdgeInsets.only(top: 8, bottom: 0),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        });
  }

  Future<void> PaytWalletmyyyy(String user3,String peee3,String bnm3,String eee3,String fggg3,String mobile4,String amount1, String pin3,String mobile5,String abc3,
      String abd3,String abe3,String abf3, String abg3,String lat3,String long3,String abh3,String address3,String city3,
      String postcode3,String abi3,String key1,String iv1) async {


    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var uri = new Uri.http("api.vastwebindia.com", "/Money/api/Money/PaytWalletmyyyy2", {
      "umm": user3,
      "peee": peee3,
      "bnm": bnm3,
      "eee": eee3,
      "fggg": fggg3,
      "snn": mobile4,
      "ttt": amount1,
      "nnn": pin3,
      "nttt": mobile5,
      "nbb": abc3,
      "kyc": abd3,
      "ip": abe3,
      "mac": abf3,
      "Devicetoken": abg3,
      "Latitude": lat3,
      "Longitude": long3,
      "ModelNo": abh3,
      "Address": address3,
      "City": city3,
      "PostalCode": postcode3,
      "InternetTYPE": abi3,
      "value1": key1,
      "value2": iv1,
    });
    final http.Response response = await http.post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 15), onTimeout: (){
      setState(() {
        _isloading = false;

      });
    });

    print(response);

    if (response.statusCode == 200) {

      _isloading = false;

      var data1 = json.decode(response.body);
      var accountno = data1["Accountno"];
      var amontTotal = data1["TotalAmount"];
      var time = data1["Time"];
      var data2 = data1["data"];
      var amount = data2[0]["Amount"];
      var status = data2[0]["Status"];
      var msz = data2[0]["bankrefid"];


      if (status == "Success") {

        CoolAlert.show(
            backgroundColor: PrimaryColor.withOpacity(0.6),
            context: context,
            type: CoolAlertType.success,
            text: getTranslated(context, 'Add SuccessFully'),
            confirmBtnText: 'OK',
            confirmBtnColor: Colors.green,
            onConfirmBtnTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));
            }
        );
      } else {

        CoolAlert.show(
            backgroundColor: PrimaryColor.withOpacity(0.6),
            context: context,
            type: CoolAlertType.error,
            text: msz,
            confirmBtnColor: Colors.red,
            onConfirmBtnTap: (){
              setState(() {
                _isloading = false;
              });
              Navigator.of(context).pop();
            }
        );
      }
    }


    else {
      _isloading = false;


      throw Exception('Failed to load data from internet');
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userIdenty();

  }





  @override
  Widget build(BuildContext context) {
    return SimpleAppBarWidget(
      title:CenterAppbarTitle(
        svgImage: 'assets/pngImages/BBPS.png',
        topText: getTranslated(context, 'Selected Info'),
        selectedItemName:getTranslated(context, 'To Wallet'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 10,right: 10,top: 20,),
              child: OutlineButton(
                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(4) ),
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                clipBehavior: Clip.none,
                autofocus: false,
                color:Colors.transparent ,
                highlightColor:Colors.transparent ,
                highlightedBorderColor: PrimaryColor,
                focusColor:PrimaryColor ,
                padding: EdgeInsets.only(top: 16,bottom: 16,left: 10,right: 10),
                borderSide: BorderSide(width: 1,color: PrimaryColor),
                onPressed: walletdialog,
                child: Container(
                  child: Row(
                    children: [
                      Expanded(child: Text(walletType1,style: TextStyle(color: PrimaryColor,fontSize: 18,fontWeight: FontWeight.normal),)),
                      SizedBox(width: 20,child: Icon(Icons.arrow_drop_down,color: PrimaryColor,),)
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              child:InputTextField(
                controller: mobileController,
                keyBordType: TextInputType.number,
                maxLength: 10,
                label:getTranslated(context, 'PayTm No'),
                obscureText: false,

                labelStyle: TextStyle(
                  color: PrimaryColor,
                ),
                borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                onChange: (String value) {

                },
              ),

            ),
            Container(
              child:InputTextField(
                controller: amountController,
                keyBordType: TextInputType.number,
                label: getTranslated(context, 'Enter Amount'),
                obscureText: false,
                labelStyle: TextStyle(
                  color: PrimaryColor,
                ),
                borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                onChange: (String value) {

                },
              ),

            ),
            Container(
              child:InputTextField(
                controller: reamountController,
                keyBordType: TextInputType.number,
                label: getTranslated(context, 'Re-Enter Amount'),
                obscureText: false,
                errorText:  _validate ? '' : null,
                labelStyle: TextStyle(
                  color: PrimaryColor,
                ),
                borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                onChange: (String value) {

                },
              ),

            ),
            Container(
              child:InputTextField(
                controller: pinController,
                keyBordType: TextInputType.number,
                label: getTranslated(context, 'Transaction Pin'),
                obscureText: false,

                labelStyle: TextStyle(
                  color: PrimaryColor,
                ),
                borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                onChange: (String val){


                  if(val.length == 4){

                    setState(() {
                      btnclick = true;
                    });
                  }else{
                    setState(() {
                      btnclick = false;
                    });

                  }

                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "null";
                  }
                  return null;
                },
              ),

            ),
            MainButtonSecodn(
                onPressed: btnclick == false ? null : () async{


                  String enteramnt = amountController.text;
                  String reenteramntt = reamountController.text;

                  if(enteramnt == reenteramntt){

                    setState(() {
                      _isloading = true;
                      _validate = false;
                    });

                    final prefs = await SharedPreferences.getInstance();
                    var dd= IpHelper().getCurrentLocation();
                    var hu= IpHelper().getconnectivity();
                    var hdddu= IpHelper().getLocalIpAddress();

                    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;

                    modelname = androidDeviceInfo.model;
                    androidid = androidDeviceInfo.androidId;

                    lat = prefs.getString('lat2');
                    long = prefs.getString('long2');
                    city = prefs.getString('city2');
                    address = prefs.getString('add2');
                    postcode = prefs.getString('post2');
                    netname = prefs.getString('conntype');
                    ipadd = prefs.getString('ipaddress');




                    PaytWalletencrypt(userId,peee,bnm,eee,walletType1,mobileController.text,pinController.text,
                        mobileController.text,abc,abd,ipadd,abf,abg,lat,long,androidid,address,city,postcode,netname);


                  }else{

                    setState(() {
                      _validate = true;

                    });


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
                        ),) :
                        Text(getTranslated(context, 'Submit'),textAlign: TextAlign.center,style: TextStyle(color: TextColor),)
                    ),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }

  void PaytWalletencrypt(String user, String peee1,String bnm1, String eee1, String fggg1,String mobile,String pin,String mobile1,String abc1,String abd1,String abe1, String abf1, String abg1, String lat1,String long1, String abh1, String address1, String city1, String postcode1, String abi1) async{


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

    final encrypted1 =encrypter.encrypt(user, iv: iv);
    final encrypted2 =encrypter.encrypt(peee1, iv: iv);
    final encrypted3 =encrypter.encrypt(bnm1, iv: iv);
    final encrypted4 =encrypter.encrypt(eee1, iv: iv);
    final encrypted5 =encrypter.encrypt(fggg1, iv: iv);
    final encrypted6 =encrypter.encrypt(mobile, iv: iv);
    final encrypted7 =encrypter.encrypt(pin, iv: iv);
    final encrypted8 =encrypter.encrypt(mobile1, iv: iv);
    final encrypted9 =encrypter.encrypt(abc1, iv: iv);
    final encrypted10 =encrypter.encrypt(abd1, iv: iv);
    final encrypted11 =encrypter.encrypt(abe1, iv: iv);
    final encrypted12 =encrypter.encrypt(abf1, iv: iv);
    final encrypted13 =encrypter.encrypt(abg1, iv: iv);
    final encrypted14 =encrypter.encrypt(lat1, iv: iv);
    final encrypted15 =encrypter.encrypt(long1, iv: iv);
    final encrypted16 =encrypter.encrypt(abh1, iv: iv);
    final encrypted17 =encrypter.encrypt(address1, iv: iv);
    final encrypted18 =encrypter.encrypt(city1, iv: iv);
    final encrypted19 =encrypter.encrypt(postcode1, iv: iv);
    final encrypted20 =encrypter.encrypt(abi1, iv: iv);


    String amount = reamountController.text;

    String user2 = encrypted1.base64;
    String peee2 = encrypted2.base64;
    String bnm2 = encrypted3.base64;
    String eee2 = encrypted4.base64;
    String fggg2 = encrypted5.base64;
    String mobile2 = encrypted6.base64;
    String pin2 = encrypted7.base64;
    String mobile3 = encrypted8.base64;
    String abc2 = encrypted9.base64;
    String abd2 = encrypted10.base64;
    String abe2 = encrypted11.base64;
    String abf2 = encrypted12.base64;
    String abg2 = encrypted13.base64;
    String lat2 = encrypted14.base64;
    String long2 = encrypted15.base64;
    String abh2 = encrypted16.base64;
    String address2 = encrypted17.base64;
    String city2 = encrypted18.base64;
    String postcode2 = encrypted19.base64;
    String abi2 = encrypted20.base64;



    PaytWalletmyyyy(user2,peee2,bnm2,eee2,fggg2,mobile2,amount,pin2,mobile3,abc2,abd2,abe2,abf2,
        abg2,lat2,long2,abh2,address2,city2,postcode2,abi2,keyencoded,viencoded);

  }








}

