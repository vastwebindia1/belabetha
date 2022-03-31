import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cool_alert/cool_alert.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/dthRechargePage.dart';
import 'package:usb_serial/transaction.dart';
import 'package:usb_serial/usb_serial.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../dashboard.dart';


class Aepsekycscan extends StatefulWidget {
  const Aepsekycscan({Key key}) : super(key: key);

  @override
  _AepsekycscanState createState() => _AepsekycscanState();
}

class _AepsekycscanState extends State<Aepsekycscan> {

  bool lodervisi = true;
  String devicename;
  bool deviconn = false;
  UsbPort _port;
  String _status = "Idle";
  List<Widget> _ports = [];
  List<Widget> _serialData = [];
  var captureResponse,cardnumberORUID;
  StreamSubscription<String> _subscription;
  Transaction<String> _transaction;
  UsbDevice _device;
  bool _isloading = false;
  String late,long,address,uniqid,imei,datee;
  Position _currentPosition;
  DateTime now = DateTime.now();

  Future<bool> _connectTo(device) async {
    _serialData.clear();

    setState(() {
      lodervisi = true;
      deviconn = false;
    });

    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }

    if (_transaction != null) {
      _transaction.dispose();
      _transaction = null;
    }

    if (_port != null) {
      _port.close();
      _port = null;
    }

    if (device == null) {
      _device = null;
      setState(() {

        _status = "Disconnected";
      });
      return true;
    }

    _port = await device.create();
    if (await (_port.open()) != true) {
      setState(() {
        _status = "Failed to open port";
      });
      return false;
    }
    _device = device;

    await _port.setDTR(true);
    await _port.setRTS(true);
    await _port.setPortParameters(115200, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

    _transaction = Transaction.stringTerminated(_port.inputStream as Stream<Uint8List>, Uint8List.fromList([13, 10]));

    _subscription = _transaction.stream.listen((String line) {
      setState(() {
        _serialData.add(Text(line));
        if (_serialData.length > 20) {
          _serialData.removeAt(0);
        }
      });
    });

    setState(() {
      _status = "Connected";
    });
    return true;
  }

  void _getPorts() async {
    _ports = [];
    List<UsbDevice> devices = await UsbSerial.listDevices();
    if (!devices.contains(_device)) {
      _connectTo(null);
    }

    scnatime();
  }

  void scnatime(){


    Future.delayed(const Duration(seconds: 7),(){

      setState(() {
        responseFromNativeCode();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    datee = DateFormat('EEE d MMM kk:mm:ss').format(now);
    UsbSerial.usbEventStream.listen((UsbEvent event) {
      _getPorts();
    });

    _getPorts();

  }

  @override
  void dispose() {
    super.dispose();
    _connectTo(null);
  }

  static const platform = const MethodChannel('com.aasha/credoPay');
  String _responseFromNativeCode = 'Waiting for Response...';

  Future<void> responseFromNativeCode() async  {
    String response = "";
    try {
      final result = await platform.invokeMethod('deviceconnect');

      debugPrint('devicccccce:$result');

      response = result.toString();
    } on PlatformException catch (e) {
      response = "Failed to Invoke: '${e.message}'.";
    }
    setState(() {

      if(response == "com.mantra.rdservice"){

        _responseFromNativeCode = "Device is Connected";
        lodervisi = false;
        deviconn = false;
        devicename = "MANTRA";

      }else if(response == "com.acpl.registersdk"){

        _responseFromNativeCode = "Device is Connected";
        lodervisi = false;
        deviconn = false;
        devicename = "STARTEK";
      }else if(response == "com.scl.rdservice"){

        _responseFromNativeCode = "Device is Connected";
        lodervisi = false;
        deviconn = false;
        devicename = "MORPHO";

      }else{

        _responseFromNativeCode = "Device is Not Connected";
        lodervisi = false;
        deviconn = true;
      }




    });
  }

  Future<void> responseFromNativeCode2() async  {
    String response = "";


    try {
      final result = await platform.invokeMethod('ekycscandevice',{

        'aaadharnum' : "",
        'mobilnum': "",
        'namee': "",
        'banknam' : "",
        'bankid':"",
        'lat' : "",
        'long' : "",
        'address' : "",
        'imei' : "",
        'otp' : "",
        'date': ""

      });

      setState(() {
        captureResponse = result['0'];
        cardnumberORUID = result['1'];

        var dddfe = json.decode(captureResponse);
        var dsdsd = json.decode(cardnumberORUID);

        ekycaeps(dddfe,dsdsd);
      });

      response = result.toString();
    } on PlatformException catch (e) {
      response = "Failed to Invoke: '${e.message}'.";
    }
  }

  Future<void> ekycaeps(var captures, var cardnum) async {

    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/AEPS/api/data/EkycVerifyFinger");
    Map map = {
      "captureResponse": captures,
      "cardnumberORUID": cardnum,
      "languageCode": "en",
      "latitude": late,
      "longitude": long,
      "mobileNumber": "",
      "merchantTranId":uniqid,
      "merchantTransactionId":uniqid,
      "paymentType": "B",
      "otpnum": "",
      "requestRemarks": "TN3000CA06532",
      "subMerchantId":"A2zsuvidhaa",
      "timestamp": datee,
      "transactionType": "",
      "name":"",
      "Address": address,
      "transactionAmount": "",
    };


    String body = json.encode(map);

    http.Response response = await http.post(
      url,
      headers: {
        "trnTimestamp": datee,
        "deviceIMEI": imei,
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      },
      body: body,
    );
    print(response);
    if (response.statusCode == 200) {
      setState(() {
        _isloading = false;
      });
      var dataa = json.decode(response.body);
      var status = dataa["Status"];
      var addinfo = dataa["Message"];

      debugPrint('teshgs:$dataa');

      if(status == true){

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: addinfo,
          title: status.toString(),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => Dashboard()));
          },
        );



      }else{

        setState(() {
          _isloading = false;
        });
        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(addinfo + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);
      }

      setState(() {
        _responseFromNativeCode = dataa.toString();
      });


    } else {

      setState(() {
        _isloading = false;
      });
      throw Exception('Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBarWidget(
      title: CenterAppbarTitleImage(
        svgImage: 'assets/pngImages/Aeps.png',
        topText:getTranslated(context, 'Aeps'),
        selectedItemName: "E-Kyc Scan",
      ),
      body: Container(
        child: SingleChildScrollView(
          child: SafeArea(
              child: Column(
                children: [

                  SizedBox(height: 10,),
                  Visibility(
                    visible: lodervisi,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                          color: PrimaryColor
                      ),
                      margin: EdgeInsets.only(left: 10,right: 10),
                      child: Center(
                        child: Column(
                          children: [
                            Text("Device Connection in Progress",style: TextStyle(fontSize: 16,color: SecondaryColor),),
                            SizedBox(
                              width: 220,
                              child: LinearProgressIndicator(
                                color: SecondaryColor,

                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    replacement:Container(
                      padding: EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                          color: PrimaryColor
                      ),
                      margin: EdgeInsets.only(left: 10,right: 10),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("DEVICE CONNECTED - ${devicename}",style: TextStyle(fontSize: 16,color: SecondaryColor),),
                            Icon(Icons.check_circle)

                          ],
                        ),
                      ),
                    ),),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10,right: 10),
                    child: Column(
                      children: [
                        Text("1 Dear Customer Your E - KYC is Not Completed. So Firstly Complete Your E - KYC.",style: TextStyle(fontSize: 14,color: SecondaryColor),textAlign: TextAlign.justify,),
                        SizedBox(
                          height: 10,
                        ),
                        Text("2 For Complete Your E - KYC please Click to 'Scan' Button.",style: TextStyle(fontSize: 14,color: PrimaryColor),textAlign: TextAlign.justify,),
                        SizedBox(
                          height: 10,
                        ),
                        Text("3 Plese firstly Connect Your Mobile with Finger Print Scanner Device (Morpho , Mantra , Startek).",style: TextStyle(fontSize: 14,color: PrimaryColor),textAlign: TextAlign.justify,)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MainButtonSecodn(

                      onPressed:() async{

                        var uuid = Uuid();
                        uniqid = uuid.v1().substring(0,16);

                        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                        AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;

                        imei = androidDeviceInfo.androidId;

                        setState(() {
                          _isloading = true;
                        });

                        responseFromNativeCode2();

                      },
                      color: SecondaryColor,
                      btnText:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: _isloading ? Center(child: SizedBox(
                                height: 20,
                                child: LinearProgressIndicator(backgroundColor: PrimaryColor,valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
                              ),) : Text("SCAN",textAlign: TextAlign.center,style: TextStyle(color: TextColor),)
                          ),
                        ],
                      )
                  ),
                ],
              )
          ),
        ),
      ),
    );
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
        late = _currentPosition.latitude.toString();
        long = _currentPosition.longitude.toString();
        address = place.street;
      });


    } catch (e) {
      print(e);
    }
  }
}
