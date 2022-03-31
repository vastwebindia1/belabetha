import 'dart:convert';
import 'dart:math';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/BroadbandPage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/dthRechargePage.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:myapp/ui/pages/locations/IpHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upi_pay/upi_pay.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;

class Upimainpage extends StatefulWidget {
  Upimainpage({Key key, this.upiid, this.minamnt, this.maxamnt, this.amount}) : super(key: key);
  final String upiid,minamnt,maxamnt,amount;
  @override
  _UpimainpageState createState() => _UpimainpageState();
}

class _UpimainpageState extends State<Upimainpage> {

  bool visible = false;
  double amount;
  var uniqid;
  bool _validate = false;
  String netname, ipadd, modelname, androidid, lat, long, city, address, postcode,status,_message;
  Position _currentPosition;
  String _currentAddress = "";
  var name = "testingupii";
  String userupiid,paytmid,phonepeid,gpid,whstid,amazonid;

  TextStyle header = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  TextStyle value = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  List<ApplicationMeta> _apps;

  Future<void> upiuserdetails() async {

    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/UPI/api/data/UPI_Status");
    final http.Response response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var upilist = data["Upi_List"];

      for(int i=0; i < upilist.length;i++){

        String upiids = upilist[i]["VPATYPE"];

        if(upiids == "1"){

          setState(() {
            paytmid  = upilist[i]["VPAID"];
          });

        }else if(upiids == "2"){

          setState(() {
            phonepeid  = upilist[i]["VPAID"];
          });

        }else if(upiids == "3"){

          setState(() {
            gpid  = upilist[i]["VPAID"];
          });

        }else if(upiids == "4"){

          setState(() {
            amazonid  = upilist[i]["VPAID"];
          });

        }else if(upiids == "5"){

         setState(() {
           whstid  = upilist[i]["VPAID"];
         });

        }
      }


    } else {
      throw Exception('Failed');
    }
  }

  void upiservice() async{

    var uuid = Uuid();
    uniqid = uuid.v1().substring(0,16);

    final prefs = await SharedPreferences.getInstance();

    var hu = IpHelper().getconnectivity();
    var hdddu = IpHelper().getLocalIpAddress();

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;

    modelname = androidDeviceInfo.model;
    androidid = androidDeviceInfo.androidId;
    netname = prefs.getString('conntype');
    ipadd = prefs.getString('ipaddress');

    upitransaction(uniqid, widget.amount, ipadd, "lat", "long", modelname, "city", "postcode", netname, "address");
  }

  @override
  void initState() {
    upiservice();
    upiuserdetails();
    Future.delayed(Duration(milliseconds: 0), () async {
      _apps = await UpiPay.getInstalledUpiApplications(
          statusType: UpiApplicationDiscoveryAppStatusType.all);
      setState(() {});
    });
    super.initState();
    getCurrentLocation();
  }

  Future<void> upitxn(String trnsid, String amnt, String ipadd, String lat,String long, String model, String city, String pin,String intype,String address,var key, var iv) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    try{

      var uri = new Uri.http("api.vastwebindia.com", "/UPI/api/data/UPI_Insert_TXN", {
        "amount": amnt,
        "refid":trnsid,
        "Devicetoken": model,
        "ip": ipadd,
        "Latitude": lat,
        "Longitude": long,
        "ModelNo": model,
        "City": city,
        "PostalCode": pin,
        "InternetTYPE":intype,
        "Addresss":address,
        "value1":key,
        "value2":iv
      });
      final http.Response response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // ignore: missing_return
      ).timeout(Duration(seconds: 15), onTimeout: (){
        setState(() {

        });
      });

      print(response);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var status = data["Status"];
        var msz = data["Message"];

        if(status == true){

          setState(() {
            visible = true;
          });


        } else{

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

  Future<void> updateresponse(String refid, String status, String bankrrn) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    try{

      var uri = new Uri.http("api.vastwebindia.com", "/UPI/api/data/UPI_Update_TXN", {
        "refid": refid,
        "status":status,
        "bankrrn": bankrrn,

      });
      final http.Response response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // ignore: missing_return
      ).timeout(Duration(seconds: 15), onTimeout: (){
        setState(() {

        });
      });

      print(response);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var msz = data["Message"];

        setState(() {
          Navigator.pop(context);
        });

        final snackBar2 = SnackBar(
          backgroundColor: Colors.greenAccent,
          content: Text(msz,style: TextStyle(color: Colors.black),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);


        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));

      } else {
        throw Exception('Failed');
      }


    }catch(e){

      print(e);
    }

  }

  Future<void> _onTap(ApplicationMeta app) async {


    print(app.upiApplication.appName);

    final transactionRef = Random.secure().nextInt(1 << 32).toString();
    print("Starting transaction with id $transactionRef");

    showLoaderDialog(context);

    final prefs = await SharedPreferences.getInstance();
    name = prefs.getString("name");


    if(app.upiApplication.appName == "Paytm"){

      setState(() {
        userupiid = paytmid;
      });

    }else if(app.upiApplication.appName == "PhonePe"){

      setState(() {
        userupiid = phonepeid;
      });

    }else if(app.upiApplication.appName == "Amazon Pay"){

      setState(() {
        userupiid = amazonid;
      });

    }else if(app.upiApplication.appName == "Google Pay"){

      setState(() {
        userupiid = gpid;
      });

    }else if(app.upiApplication.appName == "WhatsApp"){

      setState(() {
        userupiid = whstid;
      });

    }else{

      setState(() {
        userupiid = widget.upiid;
      });

    }

    final response = await UpiPay.initiateTransaction(
      amount:widget.amount,
      app: app.upiApplication,
      receiverName: name,
      receiverUpiAddress: userupiid == null ? widget.upiid : userupiid,
      transactionRef: uniqid,
      transactionNote: 'UPI Payment trns',
      // merchantCode: '7372',
    );

    String statuss = response.status.toString();
    String txnidd = response.txnId.toString();
    String apprno = response.approvalRefNo.toString();

    if(statuss == "UpiTransactionStatus.success"){

      setState(() {
        statuss = "Success";
      });

    }else if(statuss == "UpiTransactionStatus.failure"){

      setState(() {
        statuss = "Failed";
      });

    }

    if(apprno == "null"){

      updateresponse(uniqid,statuss,txnidd);

    }else{

      updateresponse(uniqid,statuss,apprno);

    }

  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(color: SecondaryColor,),
          Container(
              margin: EdgeInsets.only(left: 10), child: Text("Please Wait...")),
        ],),
    );

    showDialog(barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Amount Shold be between \u{20B9} ${widget.minamnt} To \u{20B9} ${widget.maxamnt}  ',style: TextStyle(color: Colors.yellowAccent),),
    );
    return Material(
      child: AppBarWidget(
        title: CenterAppbarTitle(
          svgImage: 'assets/pngImages/BBPS.png',
          topText:getTranslated(context, 'Selected Info'),
          selectedItemName:getTranslated(context, 'UPI'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 15,bottom: 15,),
                decoration: BoxDecoration(
                  color:PrimaryColor.withOpacity(0.9),),
                child:Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 0,
                                  color: TextColor,
                                ),
                                shape: BoxShape.circle,
                                color: TextColor
                            ),
                            child: Image.asset('assets/pngImages/UPI.png',width: 60,),
                          ),
                          SizedBox(height: 8,),
                          Text(getTranslated(context, 'UPI'),style: TextStyle(color: TextColor,fontSize: 18,),)
                        ],
                      ),

                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Visibility(
                visible: visible,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: _androidApps(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  GridView _appsGrid(List<ApplicationMeta> apps) {
    apps.sort((a, b) => a.upiApplication
        .getAppName()
        .toLowerCase()
        .compareTo(b.upiApplication.getAppName().toLowerCase()));
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      // childAspectRatio: 1.6,
      physics: NeverScrollableScrollPhysics(),
      children: apps.map((it) => Material(
          key: ObjectKey(it.upiApplication),
          child: InkWell(
            onTap:() async {

              await _onTap(it);

            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                it.iconImage(48),
                Container(
                  margin: EdgeInsets.only(top: 4),
                  alignment: Alignment.center,
                  child: Text(
                    it.upiApplication.getAppName(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      )
          .toList(),
    );
  }

  void upitransaction(String trnsid, String amnt, String ipadd, String lat,String long, String model, String city, String pin,String intype,String address) async{

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

    final encrypted1 =encrypter.encrypt(trnsid, iv: iv);
    final encrypted2 =encrypter.encrypt(ipadd, iv: iv);
    final encrypted4 =encrypter.encrypt(lat, iv: iv);
    final encrypted5 =encrypter.encrypt(long, iv: iv);
    final encrypted6 =encrypter.encrypt(model, iv: iv);
    final encrypted7 =encrypter.encrypt(city, iv: iv);
    final encrypted8 =encrypter.encrypt(pin, iv: iv);
    final encrypted9 =encrypter.encrypt(intype, iv: iv);
    final encrypted10 =encrypter.encrypt(address, iv: iv);



    String trnstpee = encrypted1.base64;
    String ipadde = encrypted2.base64;
    String latt = encrypted4.base64;
    String longg = encrypted5.base64;
    String modell = encrypted6.base64;
    String city1 = encrypted7.base64;
    String pinn = encrypted8.base64;
    String inttypee = encrypted9.base64;
    String addrsss = encrypted10.base64;


    upitxn(trnstpee, amnt, ipadde, latt, longg, modell, city1, pinn, inttypee, addrsss, keyencoded, viencoded);
  }

  Widget _androidApps() {
    return Container(
      margin: EdgeInsets.only(top: 32, bottom: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 12),
            child: Text(
              'UPI Apps',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          if (_apps != null) _appsGrid(_apps.map((e) => e).toList()),
        ],
      )
    );
  }

  getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium).then((Position position) {
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
      List<Placemark> p = await placemarkFromCoordinates(_currentPosition.latitude, _currentPosition.longitude);

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