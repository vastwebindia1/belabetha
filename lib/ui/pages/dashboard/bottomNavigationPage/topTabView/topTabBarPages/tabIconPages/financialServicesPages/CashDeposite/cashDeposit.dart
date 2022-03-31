import 'dart:convert';
import 'package:cool_alert/cool_alert.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
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
import 'package:http/http.dart'as http;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:myapp/ui/pages/locations/IpHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class CashDeposit extends StatefulWidget {
  const CashDeposit({Key key}) : super(key: key);

  @override
  _CashDepositState createState() => _CashDepositState();
}

class _CashDepositState extends State<CashDeposit> {

  List Banklist = [];

  bool _isloading = false;
  bool _validate = false;
  bool btnclick = false;
  bool otpButton = true;
  bool submitOtpButton = false;
  bool makepaymentButton = false;
  bool otpInput = false;
  bool benficiaryname = false;


  String bankhint = "Select Your Bank";
  String bankid = "";
  String bankiin = "";
  String modelname;
  String androidid;
  String lat,long;
  String fingPay= "";
  String cdPkId = "";
  String accountHoldername = "";
  String status3 = "";


  ScrollController listSlide = ScrollController();
  TextEditingController _textController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController accountController = TextEditingController();
  TextEditingController reAmountController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController beneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController amountController = TextEditingController();



  void banklistdialog(){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setStatee){
            return Container(
              color: Colors.black.withOpacity(0.8),
              child: AlertDialog(
                buttonPadding: EdgeInsets.all(0),
                titlePadding: EdgeInsets.all(0),
                contentPadding: EdgeInsets.only(left: 10,right: 10),
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
                                child: Text(getTranslated(context, 'Select Your Bank'),
                                  style: TextStyle(color: TextColor,fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),

                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 8,bottom: 8,left: 10,right: 10),
                        color: PrimaryColor.withOpacity(0.9),
                        child: TextField(
                          onChanged: (value) {
                            setStatee(() {

                            });
                          },
                          controller: _textController,
                          decoration: InputDecoration(
                            labelText:getTranslated(context, 'Search'),
                            hintText:getTranslated(context, 'Search'),
                            labelStyle: TextStyle(color: TextColor),
                            hintStyle: TextStyle(color: TextColor),
                            contentPadding: EdgeInsets.only(left: 25),
                            suffixIcon:Icon(Icons.search,color: TextColor,) ,
                            border: OutlineInputBorder(
                                gapPadding: 1,
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(width: 1,color: TextColor)
                            ),
                            enabledBorder: OutlineInputBorder(
                                gapPadding: 1,
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(width: 1,color: TextColor)
                            ),
                            focusedBorder:  OutlineInputBorder(
                                gapPadding: 1,
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(width: 1,color: TextColor)
                            ),
                          ),
                          style: TextStyle(color: TextColor,fontSize: 20),
                          cursorColor: TextColor,
                          cursorHeight: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                content: Container(// Change as per your requirement
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Container(
                        child: ListView.builder(
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          controller: listSlide,
                          itemCount: Banklist.length,
                          itemBuilder: (context,  index) {
                            if (_textController.text.isEmpty) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          style: ButtonStyle(
                                            overlayColor: MaterialStateProperty.all(Colors.transparent) ,
                                            shadowColor: MaterialStateProperty.all(Colors.transparent),
                                            backgroundColor:MaterialStateProperty.all(Colors.transparent) ,
                                            padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                                          ),
                                          onPressed: (){

                                            setState(() {
                                              bankhint = Banklist[index]["bankName"];
                                              bankid = Banklist[index]["id"].toString();
                                              bankiin = Banklist[index]["iINNo"] == null ? "":Banklist[index]["iINNo"];
                                              btnclick = true;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(Banklist[index]["bankName"],textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(height: 1,color: PrimaryColor,margin: EdgeInsets.only(top: 0,bottom: 0),)
                                ],
                              );
                            } else if (Banklist[index]["bankName"]
                                .toLowerCase()
                                .contains(_textController.text) || Banklist[index]["bankName"]
                                .toUpperCase()
                                .contains(_textController.text)) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          style: ButtonStyle(
                                            padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                                          ),
                                          onPressed: (){



                                            setState(() {
                                              bankhint = Banklist[index]["bankName"];
                                              bankid = Banklist[index]["id"].toString();
                                              bankiin = Banklist[index]["iINNo"] == null ? "":Banklist[index]["iINNo"];
                                              btnclick = true;
                                            });
                                            _textController.clear();
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(Banklist[index]["bankName"],textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(height: 1,color: PrimaryColor,margin: EdgeInsets.only(top: 0,bottom: 0),)
                                ],
                              );
                            } else {
                              return Container(
                              );
                            }

                          },
                        ),),
                    )
                ),
              ),
            );
          });
        });

  }

  Future<void> checkDeposit() async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var url = new Uri.http("api.vastwebindia.com", "/api/data/CashDepositCheck");
    final http.Response response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response);

    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      var status = dataa["Status"];
      var msz = dataa["Message"];

      if(status== true){

        cashDepositBank();

      }


    } else {
      throw Exception('Failed to load themes');
    }


  }


  Future<void> cashDepositBank() async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var url = new Uri.http("api.vastwebindia.com", "/AEPS/api/Aeps/banklist");
    final http.Response response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response);

    if (response.statusCode == 200) {
      var dataa1 = json.decode(response.body);
      var result = dataa1["RESULT"];
      var addinfo = dataa1["ADDINFO"];
      var status = addinfo["status"];
      var msz = addinfo["message"];
      var data = addinfo["data"];


      setState(() {

        Banklist = data;

      });


    } else {
      throw Exception('Failed to load themes');
    }


  }

  Future<void> generateOtp(String latitude, String longitude, String mobile, String iin,
      String ammount ,String account, String deviceid) async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var url = new Uri.http("api.vastwebindia.com", "/api/data/GenrateOtp",{
      "lat": latitude,
      "lon": longitude,
      "mobile": mobile,
      "iin":iin,
      "amount":ammount,
      "account":account,
      "deviceIMEI":deviceid,


    });
    final http.Response response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response);

    if (response.statusCode == 200) {

      var dataa1 = json.decode(response.body);
      var status = dataa1["Status"];
      var msz = dataa1["Message"];
      fingPay = dataa1["fingpayTransactionId"];
      cdPkId = dataa1["cdPkId"].toString();


      setState(() {
        fingPay;
        cdPkId;
      });


    } else {
      throw Exception('Failed to load themes');
    }


  }


  Future<void> verifyOtp(String latitude, String longitude, String mobile, String iin,
      String ammount ,String account,String fing, String otp, String cdid , String deviceid) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var url = new Uri.http("api.vastwebindia.com", "/api/data/Verifyotp", {
      "lat": latitude,
      "lon": longitude,
      "mobile": mobile,
      "iin": iin,
      "amount": ammount,
      "account": account,
      "fingpayTransactionId": fing,
      "otp": otp,
      "cdPkId": cdid,
      "deviceIMEI": deviceid,


    });
    final http.Response response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response);

    if (response.statusCode == 200) {
      var dataa2 = json.decode(response.body);
      String status1 = dataa2["Status"].toString();
      var msz1 = dataa2["Message"];
      accountHoldername = dataa2["benname"];



      if (status1 == "true") {

        setState(() {
          makepaymentButton = true;
          submitOtpButton = false;
          benficiaryname = true;
        });

      } else {
        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: msz1,
          title: status1,
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.red,
          onConfirmBtnTap: (){
            setState(() {
            });
            Navigator.of(context).pop();
          },
        );

        setState(() {
          submitOtpButton =false;
          otpInput = false;
          otpController.clear();
          otpButton = true;
        });

      }




    }else {
      throw Exception('Failed to load themes');
    }

  }



  Future<void> makePayment( String amount2,String lat3,String long3,String mobile3,String iin3,String account3,String fing3,
      String otp3,String cdpk2,String bank3,String benname3,String device3,String key1,String vi1) async  {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var url = new Uri.http("api.vastwebindia.com", "/api/data/CashDepositWithotp",{
      "lat": lat3,
      "lon": long3,
      "mobile": mobile3,
      "iin":iin3,
      "amount":amount2,
      "account":account3,
      "fingpayTransactionId":fing3,
      "otp":otp3,
      "cdPkId":cdpk2,
      "bankname":bank3,
      "benname":benname3,
      "deviceIMEI":device3,
      "value1":key1,
      "value2":vi1,


    });
    final http.Response response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 15), onTimeout: () {

      setState(() {
        _isloading = false;
      });
    });

    print(response);

    if (response.statusCode == 200) {

      _isloading= false;

      var dataa3 = json.decode(response.body);
      status3 = dataa3["Status"].toString();
      var msz3 = dataa3["Message"];
      var bankRrn = dataa3["bankrrn"].toString();

      if (status3 == "0") {

        _isloading= false;

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: msz3,
          title: getTranslated(context, 'Success'),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));
          },
        );

      } else {

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: msz3,
          title: status3,
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
      throw Exception('Failed to load themes');
    }


  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkDeposit();
    getCurrentLocation();
  }
  Position _currentPosition;

  @override
  Widget build(BuildContext context) {
    return SimpleAppBarWidget(
      title: CenterAppbarTitleImage(
        svgImage: 'assets/pngImages/cashDeposit.png',
        topText: getTranslated(context, 'Selected Info'),
        selectedItemName:getTranslated(context, 'Cash Deposit'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              margin: EdgeInsets.only(left: 10,right: 10,top: 10),
              child: OutlineButton(
                onPressed:banklistdialog,
                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(4) ),
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                clipBehavior: Clip.none,
                autofocus: false,
                color:Colors.transparent ,
                highlightColor:Colors.transparent ,
                highlightedBorderColor: PrimaryColor,
                focusColor:PrimaryColor ,
                disabledBorderColor: PrimaryColor,
                padding: EdgeInsets.only(top: 16,bottom: 16,left: 10,right: 10),
                borderSide: BorderSide(width: 1,color: PrimaryColor),
                child: Container(
                  child: Row(
                    children: [
                      Expanded(child: Text(bankhint,style: TextStyle(color: PrimaryColor,fontWeight: FontWeight.normal,fontSize: 18),overflow: TextOverflow.ellipsis,)),
                      SizedBox(width: 20,child: Icon(Icons.arrow_drop_down,color: PrimaryColor,),)
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),

            Container(
              child:InputTextField(
                controller: accountController,
                keyBordType: TextInputType.number,
                label: getTranslated(context, 'Account No'),
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
                controller: mobileController,
                keyBordType: TextInputType.number,
                label: getTranslated(context, 'Mobile Number'),
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
                controller: reAmountController,
                keyBordType: TextInputType.number,
                label: getTranslated(context, 'Re-Enter Amount'),
                obscureText: false,
                errorText:  _validate ? '' : null,
                labelStyle: TextStyle(
                  color: PrimaryColor,
                ),
                borderSide: BorderSide(width: 2, style: BorderStyle.solid),

              ),

            ),
            Visibility(
              visible: otpInput,
              child: Container(
                child:InputTextField(
                  controller: otpController,
                  keyBordType: TextInputType.number,
                  label: getTranslated(context, 'Enter OTP'),
                  obscureText: false,
                  labelStyle: TextStyle(
                    color: PrimaryColor,
                  ),
                  borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                  onChange: (String value){

                    if(value.length == 6){

                      setState(() {
                        btnclick = true;
                      });
                    }else{
                      setState(() {
                        btnclick = false;
                      });

                    }

                  },

                ),

              ),
            ),

            Visibility(
              visible: benficiaryname,
              child: Container(
                child:InputTextField(
                  controller: beneController,
                  checkenable:  false,
                  keyBordType: TextInputType.number,
                  label: accountHoldername,
                  hint: getTranslated(context, 'Beneficiary Name'),
                  obscureText: false,

                  labelStyle: TextStyle(
                    color: PrimaryColor,
                  ),
                  borderSide: BorderSide(width: 2, style: BorderStyle.solid),

                ),

              ),
            ),


            Visibility(
              visible: otpButton,
              child: MainButtonSecodn(
                  onPressed:btnclick == false ? null :() async {

                    String enteramnt = amountController.text;
                    String reenteramntt = reAmountController.text;

                    if(enteramnt == reenteramntt){

                      setState(() {
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

                      otpInput = true;
                      otpButton = false;
                      submitOtpButton = true;

                      generateOtp(lat,long,mobileController.text,bankiin,reAmountController.text,
                          accountController.text,androidid);

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
                          child:
                          Text(getTranslated(context, 'Send Otp'),style: TextStyle(color: TextColor),textAlign: TextAlign.center,)
                      ),
                    ],
                  )
              ),
            ),

            Visibility(
              visible: submitOtpButton,
              child: MainButtonSecodn(
                  onPressed:btnclick == false ? null : () async {

                    final prefs = await SharedPreferences.getInstance();
                    var dd= IpHelper().getCurrentLocation();
                    var hu= IpHelper().getconnectivity();
                    var hdddu= IpHelper().getLocalIpAddress();

                    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;

                    modelname = androidDeviceInfo.model;
                    androidid = androidDeviceInfo.androidId;

                    setState(() {

                      verifyOtp(lat,long,mobileController.text,bankiin,reAmountController.text,
                          accountController.text,fingPay,otpController.text,cdPkId,androidid);


                    });


                  },
                  color: SecondaryColor,
                  btnText:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child:
                          Text(getTranslated(context, 'Submit Otp'),textAlign: TextAlign.center,style: TextStyle(color: TextColor),)
                      ),
                    ],
                  )
              ),
            ),

            Visibility(
              visible: makepaymentButton,
              child: MainButtonSecodn(
                  onPressed: () async {

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

                    if(_currentPosition == null){

                      setState(() {
                        lat = "null";
                        long = "null";
                      });

                    }


                    makePaymentEncription(lat,long,mobileController.text,bankiin,
                        accountController.text,fingPay,otpController.text,bankhint,accountHoldername,androidid);


                  },
                  color: SecondaryColor,
                  btnText:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child:_isloading ? Center(child: SizedBox(
                            height: 20,
                            child: LinearProgressIndicator(backgroundColor: PrimaryColor,valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
                          ),) :
                          Text(getTranslated(context, 'Make Payment'),textAlign: TextAlign.center,style: TextStyle(color: TextColor),)
                      ),
                    ],
                  )
              ),
            ),


          ],


        ),



      ),
    );



  }

  void makePaymentEncription(String lat1, String long1,String mobile1, String iin1,String account1,String fing1, String otp1,String bank,String benname, String device1) async{


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

    final encrypted1 =encrypter.encrypt(lat1, iv: iv);
    final encrypted2 =encrypter.encrypt(long1, iv: iv);
    final encrypted3 =encrypter.encrypt(mobile1, iv: iv);
    final encrypted4 =encrypter.encrypt(iin1, iv: iv);
    final encrypted5 =encrypter.encrypt(account1, iv: iv);
    final encrypted6 =encrypter.encrypt(fing1, iv: iv);
    final encrypted7 =encrypter.encrypt(otp1, iv: iv);
    final encrypted8 =encrypter.encrypt(bank, iv: iv);
    final encrypted9 =encrypter.encrypt(benname, iv: iv);
    final encrypted10 =encrypter.encrypt(device1, iv: iv);



    String amount1 = reAmountController.text;
    String cdpk1 = cdPkId;

    String lat2 = encrypted1.base64;
    String long2 = encrypted2.base64;
    String mobile2 = encrypted3.base64;
    String iin2 = encrypted4.base64;
    String account2 = encrypted5.base64;
    String fing2 = encrypted6.base64;
    String otp2 = encrypted7.base64;
    String device2 = encrypted10.base64;
    String bank2 = encrypted8.base64;
    String benname2 = encrypted9.base64;




    makePayment(amount1,lat2,long2,mobile2,iin2,account2,fing2,otp2,cdpk1,
        bank2,benname2,device2,keyencoded,viencoded);

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
      });


    } catch (e) {
      print(e);
    }
  }





}
