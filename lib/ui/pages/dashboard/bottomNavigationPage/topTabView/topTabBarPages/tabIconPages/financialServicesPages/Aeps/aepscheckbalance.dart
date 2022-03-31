import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/HistoryPage/AepsHistory.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/BroadbandPage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/dthRechargePage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/Aeps/Aadharpay.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:path_provider/path_provider.dart';
import 'package:safexpay/constants/constants.dart';
import 'package:share/share.dart';
import 'package:usb_serial/transaction.dart';
import 'package:usb_serial/usb_serial.dart';
import 'package:uuid/uuid.dart';
import 'dart:ui' as ui;
import 'Aepsmainpage.dart';
import 'Ministatement.dart';

class Aepscheckbalance extends StatefulWidget {
  final  String name,number,aadhrnum;
  const Aepscheckbalance({Key key, this.name, this.number, this.aadhrnum}) : super(key: key);

  @override
  _AepscheckbalanceState createState() => _AepscheckbalanceState();
}

class _AepscheckbalanceState extends State<Aepscheckbalance> {

  UsbPort _port;
  String _status = "Idle";
  List<Widget> _ports = [];
  List<Widget> _serialData = [];
  var captureResponse,cardnumberORUID;
  StreamSubscription<String> _subscription;
  Transaction<String> _transaction;
  UsbDevice _device;
  String toDate,currentdate;
  String trnstatus = "";
  String trnsamount = "";
  String trnbnkrrn = "";
  String trnsdatee = "";
  
  var uniquid;

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
      lodervisi = false;
      deviconn = false;
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

  static const platform = const MethodChannel('com.aasha/credoPay');
  String _responseFromNativeCode = 'Waiting for Response...';

  Future<void> responseFromNativeCode() async  {
    String response = "";
    try {
      final result = await platform.invokeMethod('deviceconnect');
      debugPrint('checkreee:$result');
      response = result.toString();
    }  catch (e) {
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

  Future<void> balanceinq(var captures, var cardnum) async {

    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/AEPS/api/app/AEPS/balanceEnquiry");
    Map map = {
      "captureResponse": captures,
      "cardnumberORUID": cardnum,
      "languageCode": "en",
      "latitude": lat,
      "longitude": long,
      "mobileNumber": mobilenum.text,
      "merchantTranId":uniquid,
      "merchantTransactionId":uniquid,
      "paymentType": "B",
      "otpnum": "",
      "requestRemarks": "TN3000CA06532",
      "subMerchantId":"A2zsuvidhaa",
      "timestamp": datee,
      "transactionType": "BE",
      "name":consumername.text,
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
      var dataa = json.decode(response.body);
      debugPrint('chedhdhdataa$dataa');

      String result = dataa["RESULT"].toString();
      var addinfo = dataa["ADDINFO"];

      if(result == "0"){

        setState(() {
          trnstatus = addinfo["TransactionStatus"].toString();
          trnbnkrrn = addinfo["BankRrn"].toString();
          trnsamount = addinfo["BalanceAmount"].toString();
          trnsdatee = addinfo["RequestTransactionTime"].toString();
          aepsresponsedialog();
        });

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
  void initState() {
    super.initState();
    getlocationcall();
    funt();
    aepsbank();
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

  void funt(){

    setState(() {
      consumername.text = widget.aadhrnum;
      aadharnum.text = widget.aadhrnum;
      mobilenum.text = widget.number;
    });
  }

  String rdServices,MyDevice;

  Future<void> aepsbank() async {

    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/AEPS/api/Aeps/banklist");
    final http.Response response = await http.post(url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response);

    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      var bnklist = dataa["ADDINFO"]["data"];

      setState(() {
        banklist = bnklist;
      });




    } else {
      throw Exception('Failed to load themes');
    }

  }

  Future<void> aepsnamenum(String num) async {

    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/AEPS/api/app/Aeps/AEPSNAMEFIND",{
      "mobile":num
    });
    final http.Response response = await http.get(url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response);

    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      var result = dataa["RESULT"];

      setState(() {
        consumername.text = result;
      });

    } else {
      throw Exception('Failed to load themes');
    }

  }

  TextEditingController amountcont = TextEditingController();

  bool _validate = false;
  bool _validate2= false;
  bool _validate3 = false;
  bool _isloading = false;
  bool amntservisi = true;
  bool showdetatis = false;
  int id = 1;
  String bankname = "Select Your Bank";
  TextEditingController _textController = TextEditingController();
  TextEditingController aadharnum = TextEditingController();
  TextEditingController mobilenum = TextEditingController();
  TextEditingController consumername = TextEditingController();
  ScrollController listSlide = ScrollController();
  List banklist = [];
  String bankid,lat,long,address,imei,datee;
  String otp = "";
  Position _currentPosition;
  double ltt,lng;
  bool lodervisi = true;
  String devicename;
  bool deviconn = false;
  DateTime now = DateTime.now();

  Future<void> responseFromNativeCode2() async  {
    String response = "";

    debugPrint("datssfeee:");
    try {
      final result = await platform.invokeMethod('scandevice',{

        'aaadharnum' : aadharnum.text,
        'mobilnum': mobilenum.text,
        'namee': consumername.text,
        'banknam' : bankname,
        'bankid':bankid,
        'lat' : "lat",
        'long' : "long",
        'address' : "address",
        'imei' : imei,
        'otp' : otp,
        'date': datee

      });

      setState(() {
        captureResponse = result['0'];
        cardnumberORUID = result['1'];

        var dddfe = json.decode(captureResponse);
        var dsdsd = json.decode(cardnumberORUID);

        debugPrint("output:$dddfe");
        debugPrint("output2:$dsdsd");

        balanceinq(dddfe,dsdsd);
      });

      response = result.toString();
    } on PlatformException catch (e) {
      response = "Failed to Invoke: '${e.message}'.";
    }
  }

  Future<void> responsefromaaadharscan() async {
    String response = "";
    try {
      final result = await platform.invokeMethod('aadhar');

      setState(() {
        consumername.text = result['1'].toString();
        aadharnum.text = result['5'].toString();

      });

    } on PlatformException catch (e) {
      response = "Failed to Invoke: '${e.message}'.";
    }



  }

  void aepsresponsedialog() {

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return RepaintBoundary(
            key: previewContainer,
            child: Container(
              color: Colors.black.withOpacity(0.8),
              alignment: Alignment.topLeft,
              child: AlertDialog(
                insetPadding: EdgeInsets.only(right: 10, left: 10,top: 30,bottom: 30),
                /*insetPadding: EdgeInsets.only(right: 122, left: 0,top: 38,),*/
                buttonPadding: EdgeInsets.all(0),
                titlePadding: EdgeInsets.all(0),
                contentPadding: EdgeInsets.only(left: 10, right: 10),
                title: Column(
                  children: [
                    Container(
                      color: PrimaryColor,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 15, bottom: 15, left: 10, right: 10),
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle,color: Colors.green,),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    'Check Balance Receipt'.toUpperCase(),
                                    style:
                                    TextStyle(color: TextColor, fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
                content: Container(
                  height: 200,
                  margin: EdgeInsets.only(left: 0, right: 0, top: 10,bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0XFFe8e8e8),
                          blurRadius: .5,
                          spreadRadius: 1,
                          offset:
                          Offset(.0, .0), // shadow direction: bottom right
                        )
                      ],
                    ),
                    child: Container(
                      color: TextColor,
                      padding: EdgeInsets.only(
                          top: 10, bottom: 0, left: 5, right: 5),
                      child: Column(
                        children: [
                          CustomerInfo(
                            firstText:getTranslated(context, 'Transaction Status'),
                            secondText: trnstatus,
                          ),
                          CustomerInfo(
                            firstText: getTranslated(context, 'Bank RRN'),
                            secondText: trnbnkrrn,
                          ),
                          CustomerInfo(
                            firstText:getTranslated(context, 'Date & Time'),
                            secondText: datee,
                          ),
                          CustomerInfo(
                            firstText:getTranslated(context, 'Remain Amount'),
                            secondText: "\u{20B9} $trnsamount",
                          ),
                          CustomerInfo(
                            firstText:getTranslated(context, 'Bank Name'),
                            secondText: bankname,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: ()async{

                                  RenderRepaintBoundary boundary = previewContainer.currentContext.findRenderObject();
                                  ui.Image image = await boundary.toImage();
                                  final directory = (await getApplicationDocumentsDirectory()).path;
                                  ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
                                  Uint8List pngBytes = byteData.buffer.asUint8List();
                                  print(pngBytes);
                                  File imgFile =new File('$directory/ddd.png');
                                  imgFile.writeAsBytes(pngBytes);

                                  final result = await ImageGallerySaver.saveImage(pngBytes);

                                  final imagePicker = ImagePicker();
                                  final pickedFile = await imagePicker.getImage(
                                    source: ImageSource.gallery,
                                  );
                                  if (pickedFile != null) {
                                    setState(() {
                                      imagePaths.add(pickedFile.path);
                                    });
                                  }

                                  _onShareData(context);


                                },
                                child: Container(
                                    margin: EdgeInsets.only(right: 1),
                                    padding: EdgeInsets.only(left: 10,right: 10,top: 8,bottom: 8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        border: Border.all(
                                            color: PrimaryColor
                                        ),
                                        color: PrimaryColor
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.share,color: TextColor,size: 16,),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(getTranslated(context, 'Share Receipt'),style: TextStyle(color: TextColor,fontSize: 12),),
                                      ],
                                    )
                                ),
                              ),

                              GestureDetector(
                                onTap: () {

                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));

                                },
                                child: Container(
                                    margin: EdgeInsets.only(right: 0),
                                    padding: EdgeInsets.only(left: 10,right: 10,top: 8,bottom: 8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        border: Border.all(
                                            color: PrimaryColor
                                        ),
                                        color: PrimaryColor
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.clear,color: TextColor,size: 16,),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(getTranslated(context, 'Close'),style: TextStyle(color: TextColor,fontSize: 12)),
                                      ],
                                    )
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  void aepsbanklistdialog(){
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
                          itemCount: banklist.length,
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
                                              bankname = banklist[index]["bankName"];
                                              bankid = banklist[index]["iINNo"].toString();
                                              Navigator.of(context).pop();
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(banklist[index]["bankName"],textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(height: 1,color: PrimaryColor,margin: EdgeInsets.only(top: 0,bottom: 0),)
                                ],
                              );
                            } else if (banklist[index]["bankName"]
                                .toLowerCase()
                                .contains(_textController.text) || banklist[index]["bankName"]
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
                                              bankname = banklist[index]["bankName"];
                                              bankid = banklist[index]["iINNo"].toString();
                                              _textController.clear();
                                              Navigator.of(context).pop();
                                            });

                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(banklist[index]["bankName"],textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
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

  Future<void> checkaadhar(String aadharnum) async {


    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var uri = new Uri.http("api.vastwebindia.com", "/Common/api/data/AdharCardValidationCheck", {
      "aadharnumber": aadharnum,
    });
    final http.Response response = await http.get(
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

      var data = json.decode(response.body);
      debugPrint("dateee:$data");
      var status = data["status"];

      if(status == true){

        responseFromNativeCode2();
      }else{

        setState(() {
          _isloading = false;
        });

        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text("Invalid Aadhar Number" + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);

      }


    } else {


      throw Exception('Failed to load data from internet');
    }
  }

  List<String> imagePaths = [];
  var scr= new GlobalKey();
  static GlobalKey previewContainer = new GlobalKey();
  _onShareData(BuildContext context) async {

    final RenderBox box = context.findRenderObject();

    if (imagePaths.isNotEmpty) {
      await Share.shareFiles(imagePaths,
          text: "",
          subject: "",
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    } else {
      await Share.share("",
          subject: "",
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }


  Future<void> getlocationcall ()async{

    await getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {

    String pickedFile = imagePaths ==null?"":imagePaths.toString();
    String trimmedFileName = pickedFile.split("/").last;

    return AppBarWidget3(
      title: AepsAppbarTitle(
        svgImage: 'assets/pngImages/Check-Bal.png',
        topText:getTranslated(context, 'Aeps'),
        selectedItemName: "Balance Check",
      ),
      body: Container(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [

                SizedBox(height: 5,),
                Visibility(
                  visible: lodervisi,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 5,top: 5),
                        decoration: BoxDecoration(
                          color: PrimaryColor.withOpacity(0.2),
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
                        margin: EdgeInsets.only(left: 10,right: 10),
                        child: Center(
                          child: Column(
                            children: [
                              Text(getTranslated(context, 'Device Connection in Progress'),style: TextStyle(fontSize: 16,color: PrimaryColor),),

                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 5),
                        margin: EdgeInsets.only(left: 10,right: 10),
                        child: Center(
                          child: LinearProgressIndicator(
                            color: SecondaryColor,
                            backgroundColor: PrimaryColor.withOpacity(0.4),

                          ),
                        ),
                      ),
                    ],
                  ),
                  replacement:Container(
                    padding: EdgeInsets.only(bottom: 5,left: 5,right: 5),
                    decoration: BoxDecoration(
                      color: PrimaryColor.withOpacity(0.2),
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
                    margin: EdgeInsets.only(left: 10,right: 10),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(getTranslated(context, 'DEVICE CONNECTED'),style: TextStyle(fontSize: 16,color: SecondaryColor),),
                              Text("${devicename}",style: TextStyle(fontSize: 12,color: SecondaryColor),),
                            ],
                          ),
                          Icon(Icons.check_circle,color: Colors.green,),


                        ],
                      ),
                    ),
                  ),),
                SizedBox(height: 2,),
                Container(
                  child: InputTextField(
                    label: getTranslated(context, 'Enter Aadhar Number'),
                    errorText:  _validate ? '' : null,
                    controller: aadharnum,

                    maxLength: 12,
                    obscureText: false,
                    iButton: IconButton(
                      onPressed: (){

                        responsefromaaadharscan();

                      },
                      icon: Icon(Icons.qr_code,color: SecondaryColor,size: 30,),

                    ),
                    keyBordType: TextInputType.number,
                    labelStyle: TextStyle(
                      color: PrimaryColor,
                    ),
                    borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                    onChange: (String val){

                    },
                  ),
                ),
                Container(
                  child: InputTextField(
                    label:getTranslated(context, 'Enter Mobile Number'),
                    errorText:  _validate2 ? '' : null,
                    controller: mobilenum,

                    maxLength: 10,
                    obscureText: false,
                    keyBordType: TextInputType.number,
                    labelStyle: TextStyle(
                      color: PrimaryColor,
                    ),
                    borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                    onChange: (String val){

                      if(val.length == 10){

                        aepsnamenum(mobilenum.text);

                      }else{

                        setState(() {
                          consumername.clear();
                        });
                      }

                    },
                  ),
                ),
                Container(
                  child: InputTextField(
                    label: getTranslated(context, 'Enter Consumer Name'),
                    controller: consumername,
                    errorText:  _validate3 ? '' : null,
                    obscureText: false,
                    labelStyle: TextStyle(
                      color: PrimaryColor,
                    ),
                    borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                    onChange: (String val){

                    },
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  child: OutlineButton(
                    onPressed:aepsbanklistdialog,
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
                          Expanded(child: Text(bankname,style: TextStyle(color: PrimaryColor,fontWeight: FontWeight.normal,fontSize: 18),overflow: TextOverflow.ellipsis,)),
                          SizedBox(width: 20,child: Icon(Icons.arrow_drop_down,color: PrimaryColor,),)
                        ],
                      ),
                    ),
                  ),
                ),
                MainButtonSecodn(
                    onPressed:() async{

                      FocusScopeNode currentFocus = FocusScope.of(context);
                      currentFocus.unfocus();

                      int aadhrnum = aadharnum.text.length;
                      int mobile = mobilenum.text.length;

                      if(aadhrnum < 12) {

                        setState(() {
                          _validate = true;
                        });

                        final snackBar = SnackBar(
                          backgroundColor: Colors.red[900],
                          content: Text(getTranslated(context, 'Enter Valid Aadhar Number'),style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                      }else if(mobile < 10){

                        setState(() {
                          _validate2 = true;
                        });

                        final snackBar1 = SnackBar(
                          backgroundColor: Colors.red[900],
                          content: Text(getTranslated(context, 'Enter Valid Mobile Number'),style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar1);

                      }else if(consumername.text == ""){

                        setState(() {
                          _validate3 = true;
                        });

                        final snackBar2 = SnackBar(
                          backgroundColor: Colors.red[900],
                          content: Text(getTranslated(context, 'Enter Name'),style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar2);


                      }else if(bankname == "Select Your Bank"){

                        final snackBar3 = SnackBar(
                          backgroundColor: Colors.red[900],
                          content: Text(getTranslated(context, 'Select Your Bank'),style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar3);

                      }else {

                        setState(() {
                          _isloading = true;
                          showdetatis = false;
                        });

                        var uuid = Uuid();
                        uniquid = uuid.v1().substring(0,16);

                        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                        AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;

                        imei = androidDeviceInfo.androidId;


                        checkaadhar(aadharnum.text);


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
                            ),) : Text(getTranslated(context, 'Check Balance'),textAlign: TextAlign.center,style: TextStyle(color: TextColor),)
                        ),
                      ],
                    ),
                ),
                SizedBox(height: 10,),
                Container(
                  margin: EdgeInsets.only(left: 0),
                  alignment: Alignment.center,
                  child: Text("If you want to change the payment mode click on the following button",style: TextStyle(color:SecondaryColor,fontSize: 10,fontWeight: FontWeight.w500,),textAlign: TextAlign.center,),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10,top: 2,bottom: 4),
                  height: 1,
                  color: PrimaryColor,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation1, animation2) => Aepshistorypage(),
                                  transitionDuration: Duration(seconds: 0),
                                )
                            );
                          },
                          child: Container(
                              margin: EdgeInsets.only(right: 1),
                              padding: EdgeInsets.only(left: 15,right: 15,top: 8,bottom: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  border: Border.all(
                                      color: SecondaryColor
                                  ),
                                  color: SecondaryColor
                              ),
                              child: Text(getTranslated(context, 'History'),style: TextStyle(color: TextColor,fontSize: 12),)
                          ),
                        ),
                      ),

                      Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation1, animation2) => Aepsmain(
                                      name: consumername.text,aadhrnum: aadharnum.text,number: mobilenum.text,),
                                    transitionDuration: Duration(seconds: 0),
                                  )
                              );
                            },
                            child: Container(
                                margin: EdgeInsets.only(right: 1),
                                padding: EdgeInsets.only(left: 10,right: 10,top: 8,bottom: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    border: Border.all(
                                        color: PrimaryColor
                                    ),
                                    color: PrimaryColor
                                ),
                                child: Text("Cash Withdrawal",style: TextStyle(color: TextColor,fontSize: 12),)
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation1, animation2) => Aadharpay(
                                    name: consumername.text,aadhrnum: aadharnum.text,number: mobilenum.text,),
                                  transitionDuration: Duration(seconds: 0),
                                ),
                              );

                            },
                            child: Container(
                                margin: EdgeInsets.only(right: 10),
                                padding: EdgeInsets.only(left: 10,right: 10,top: 8,bottom: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    border: Border.all(
                                        color: PrimaryColor
                                    ),
                                    color: PrimaryColor
                                ),
                                child: Text(getTranslated(context, 'Aadhar Pay'),style: TextStyle(color: TextColor,fontSize: 12))
                            ),
                          )
                        ],
                      ),

                    ],
                  ),
                ),
                SizedBox(height: 10,),

              ],
            ),
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
        lat = _currentPosition.latitude.toString();
        long = _currentPosition.longitude.toString();
        address = place.street;
        debugPrint('latiii:$lat');

      });



    } catch (e) {
      print(e);
    }
  }

}


class CustomerInfo extends StatelessWidget {
  final String firstText, secondText;
  final Widget test;

  const CustomerInfo({
    Key key,
    this.firstText,
    this.secondText, this.test,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 3, bottom: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Text(firstText)),
              Expanded(
                  child: Text(secondText,
                      style: TextStyle(fontSize: 16,),
                      textAlign: TextAlign.right))
            ],
          ),
        ),
        Container(
          height: 1,

          color: PrimaryColor.withOpacity(0.1),
        )
      ],
    );
  }
}
