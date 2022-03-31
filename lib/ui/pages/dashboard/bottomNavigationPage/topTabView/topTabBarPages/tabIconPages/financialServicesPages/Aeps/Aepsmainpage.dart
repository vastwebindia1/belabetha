import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cool_alert/cool_alert.dart';
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
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/HistoryPage/AepsHistory.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/BroadbandPage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/dthRechargePage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/Aeps/Ministatement.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/Aeps/aepscheckbalance.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:usb_serial/transaction.dart';
import 'package:usb_serial/usb_serial.dart';
import 'package:uuid/uuid.dart';
import 'dart:ui' as ui;
import 'dart:io' as Io;

import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

class Aepsmain extends StatefulWidget {
  final String name,number,aadhrnum;
  const Aepsmain({Key key, this.name, this.number, this.aadhrnum}) : super(key: key);

  @override
  _AepsmainState createState() => _AepsmainState();
}

class _AepsmainState extends State<Aepsmain> {

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
  String remamount = "";
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

  Future<void> cashwithdrawl(var captures, var cardnum) async {

    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/AEPS/api/app/Aeps/cashWithdrawal");
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
      "Charge": servifee.text,
      "requestRemarks": "TN3000CA06532",
      "subMerchantId":"A2zsuvidhaa",
      "timestamp": datee,
      "transactionType": "CW",
      "name":consumername.text,
      "Address": address,
      "transactionAmount": amountcont.text,
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
    ).timeout(Duration(seconds: 15), onTimeout: (){
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
                                  builder: (context) => Aepshistorypage()));

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
      setState(() {
        _isloading = false;
      });
      var dataa = json.decode(response.body);
      debugPrint('withchedhdhminisdataa$dataa');
      var result = dataa["RESULT"].toString();
      var addinfo = dataa["ADDINFO"];


      if(result == "0"){

        var agentid = dataa["agentid"].toString();

        setState(() {
          trnstatus = addinfo["TransactionStatus"].toString();
          trnbnkrrn = addinfo["BankRrn"].toString();
          trnsamount = addinfo["TransactionAmount"].toString();
          remamount = addinfo["BalanceAmount"].toString();
          checkvideo(amountcont.text,agentid);
          //aepsresponsedialog();
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

  Future<void> checkaadhar(String aadharnum) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

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

  Future<void> checkvideo(String trnamnt, String agentid) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var uri = new Uri.http("api.vastwebindia.com", "/AEPS/api/app/AEPS/CheckAepsvideo", {
      "transamount": trnamnt,
      "agentid": agentid,
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

    debugPrint('responscode:${response.statusCode}');

    print(response);

    if (response.statusCode == 200) {

      var data = json.decode(response.body);
      var status = data["RESULT"];
      var msz = data["ADDINFO"];

      if(status == "0"){

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: "For this transaction Video Verification is Required.",
          title: "Required",
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            _pickVideoFromCamera(agentid);
            Navigator.of(context).pop();
          },
        );



      }else{

        aepsresponsedialog();


      }


    } else {
      throw Exception('Failed to load data from internet');
    }
  }

  bool pendingvideosts = false;

  ImagePicker picker = ImagePicker();
  File _cameraVideo;
  String video641;
  VideoPlayerController _cameraVideoPlayerController;

  _pickVideoFromCamera(String agentid) async {

    PickedFile pickedFile = await picker.getVideo(source: ImageSource.camera, maxDuration: Duration(seconds: 38));

    try{
      _cameraVideo = File(pickedFile.path);
    }catch(e){

    }

       if(pendingvideosts == false){

         setState(() {
           _isloading = true;
         });

       }


    MediaInfo mediaInfo = await VideoCompress.compressVideo(
      pickedFile.path,
      quality: VideoQuality.LowQuality,
      includeAudio: true,
      deleteOrigin: false,
    );

    MediaInfo mediaInfo1 = await VideoCompress.compressVideo(
      mediaInfo.path,
      quality: VideoQuality.LowQuality,
      includeAudio: true,
      deleteOrigin: false,
    );

    MediaInfo mediaInfo2 = await VideoCompress.compressVideo(
      mediaInfo1.path,
      quality: VideoQuality.LowQuality,
      includeAudio: true,
      deleteOrigin: false,
    );

    final bytes = Io.File(mediaInfo2.path).readAsBytesSync();

    video641 = base64Encode(bytes);

    uploadVideo(agentid,video641);

  }

  Future<void> uploadVideo(String agentid, String video) async {


    var url = new Uri.https("test.vastwebindia.com", "/api/user/Videolink");

    Map map = {
      "Videolink": video,
      "Agentid": agentid,
    };

    String body = json.encode(map);

    debugPrint('responsbody:$body');

    try{

      http.Response response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: body).timeout(Duration(seconds: 30), onTimeout: () {

      });;

      debugPrint('responscode2:${response.statusCode}');
      print(response);

      if (response.statusCode == 200) {
        var dataa = json.decode(response.body);
        var sts = dataa["status"].toString();
        var msz = dataa["msg"];

        setState(() {
          _isloading = false;
        });

        if (sts == "true") {

          CoolAlert.show(
            backgroundColor: PrimaryColor.withOpacity(0.7),
            context: context,
            type: CoolAlertType.success,
            text: "Video uploaded Successfully.",
            title: sts,
            confirmBtnText: 'OK',
            confirmBtnColor: Colors.green,
            onConfirmBtnTap: (){
              if(pendingvideosts == true){
                setState(() {
                  pendingvideosts = false;
                });
                Navigator.push(context, MaterialPageRoute(builder: (_) => Aepsmain()));
              }else{
                aepsresponsedialog();
              }
            },
          );
        }else{

          CoolAlert.show(
            backgroundColor: PrimaryColor.withOpacity(0.6),
            context: context,
            type: CoolAlertType.error,
            text: msz,
            title: sts,
            confirmBtnText: 'OK',
            confirmBtnColor: Colors.red,
            onConfirmBtnTap: (){
              Navigator.of(context).pop();
            },
          );

        }
      } else {

        throw Exception('Failed');
      }


    }catch(e){

      //uploadVideo2(userId,Role,video641);

    }
  }

  Future<void> checkaepstrnstatus() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var uri = new Uri.http("api.vastwebindia.com", "/AEPS/api/data/AepsStatus");
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
      var status = data["Response"];
      var msz = data["Message"];

      if(status == true){


        checkaepsvideostatus();


      }else{

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: msz,
          title: status.toString(),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.red,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Dashboard()));
          },
        );
      }


    } else {


      throw Exception('Failed to load data from internet');
    }
  }

  Future<void> checkaepsvideostatus() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var uri = new Uri.http("api.vastwebindia.com", "/AEPS/api/data/VideoStatus");
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
      var status = data["Status"];

      debugPrint('respns: $status');



      if(status == true){



      }else{


        var aadharnum = data["Aadhar"];
        var agentid = data["txnid"];
        var bnkrrn = data["bankrrn"].toString();
        var amont = data["amount"].toString();
        var datee = data["txndate"];


        aepsvideopresponsedialog(status.toString(),amont,datee,bnkrrn,aadharnum,agentid);


      }


    } else {


      throw Exception('Failed to load data from internet');
    }
  }

  @override
  void initState() {
    super.initState();
    checkaepstrnstatus();
    funt();
    getlocationcall();
    aepsbank();
    //getCurrentLocation();
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

  Future<void> getlocationcall ()async{

   await getCurrentLocation();
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
      var dataa = json.decode(response.body);
      var bnklist = dataa["ADDINFO"]["data"];

      setState(() {
        banklist = bnklist;
      });

    } else {
      throw Exception('Failed to load themes');
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
                                    'Cash Withdrawal Receipt'.toUpperCase(),
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
                  height: 230,
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
                              firstText:getTranslated(context, 'Amount'),
                              secondText: "\u{20B9} $trnsamount"
                          ),
                          CustomerInfo(
                            firstText:getTranslated(context, 'Remain Amount'),
                            secondText: "\u{20B9} $remamount",
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
                                onTap: (){

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
            )
          );
        });
  }

  void progressdialog(){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              child: StatefulBuilder(builder: (context, setStatee){
                return Container(
                  color: Colors.black.withOpacity(0.8),
                  child: AlertDialog(
                    buttonPadding: EdgeInsets.all(0),
                    titlePadding: EdgeInsets.all(0),
                    contentPadding: EdgeInsets.only(left: 10,right: 10),
                    content: Container(// Change as per your requirement
                        width:  50,
                        height: 75,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Please Wait...",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                            CircularProgressIndicator(color: SecondaryColor,)
                          ],
                        )
                    ),
                  ),
                );
              }),
              onWillPop: () {

                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));

              });
        });

  }

  void aepsvideopresponsedialog(String status, String amiunt, String date, String bnkrrn, String aadharnum, String agentid) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: RepaintBoundary(
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
                          height: 150,
                          color: PrimaryColor,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(

                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(top: 10,bottom: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(40)
                                          ),
                                          child: Icon(Icons.notification_important,size: 50,)),
                                      Expanded(
                                          child: Text("Dear User Your Video Verification is due For this transaction. So firstly upload video for more thransaction.",overflow: TextOverflow.clip,style: TextStyle(color: Colors.red,fontSize: 16),textAlign: TextAlign.justify,)),
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
                      height: 250,
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
                              Expanded(
                                  child: Text("Transaction Details",overflow: TextOverflow.clip,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),)),
                              CustomerInfo(
                                firstText:getTranslated(context, 'Transaction Status'),
                                secondText: status,
                              ),
                              CustomerInfo(
                                firstText: getTranslated(context, 'Bank RRN'),
                                secondText: bnkrrn,
                              ),
                              CustomerInfo(
                                firstText:getTranslated(context, 'Date & Time'),
                                secondText: date,
                              ),
                              CustomerInfo(
                                  firstText:getTranslated(context, 'Amount'),
                                  secondText: "\u{20B9} $amiunt"
                              ),
                              CustomerInfo(
                                firstText:"Aadhar Number",
                                secondText: aadharnum,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: ()async{

                                      setState(() {
                                        pendingvideosts = true;
                                      });

                                      Navigator.of(context).pop();
                                       progressdialog();
                                      _pickVideoFromCamera(agentid);
                                      //Navigator.of(context).pop();

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
                                            Icon(Icons.video_call,color: Colors.yellow,),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text("Now Video Upload",style: TextStyle(color: Colors.yellow,fontSize: 12,),),
                                          ],
                                        ),
                                    ),
                                  ),

                                  GestureDetector(
                                    onTap: (){


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
                )
            ),
          );
        });
  }

  TextEditingController amountcont = TextEditingController();
  TextEditingController servifee = TextEditingController();

  bool _validate = false;
  bool _validate2= false;
  bool _validate3 = false;
  bool _isloading = false;
  bool _amntvalidate = false;
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

        cashwithdrawl(dddfe,dsdsd);
      });

      response = result.toString();
    } on PlatformException catch (e) {
      response = "Failed to Invoke: '${e.message}'.";
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
      var dataa = json.decode(response.body);
      var result = dataa["RESULT"];

      setState(() {
        consumername.text = result;
      });

    } else {
      throw Exception('Failed to load themes');
    }

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

  @override
  Widget build(BuildContext context) {
    return AppBarWidget3(
      title: AepsAppbarTitle(
        svgImage: 'assets/pngImages/Aeps.png',
        topText:getTranslated(context, 'Aeps'),
        selectedItemName: "Cash Withdrawl",
      ),
      body: Container(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 2,),
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
                Container(
                  child: InputTextField(
                    label: getTranslated(context, 'Enter Amount'),
                    controller: amountcont,
                    errorText:  _amntvalidate ? '' : null,
                    obscureText: false,
                    keyBordType: TextInputType.number,
                    labelStyle: TextStyle(
                      color: PrimaryColor,
                    ),
                    borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                    onChange: (String val){

                      setState(() {
                        servifee.text = "0";
                      });

                    },
                  ),
                ),
                Container(
                  child: InputTextField(
                    label: getTranslated(context, 'Enter Service Fee'),
                    obscureText: false,
                    keyBordType: TextInputType.number,
                    controller: servifee,
                    labelStyle: TextStyle(
                      color: PrimaryColor,
                    ),
                    borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                    onChange: (String val){

                    },
                  ),
                ),
                SizedBox(height: 8,),
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
                Container(
                  transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                  child: MainButtonSecodn(
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

                      }else if(amountcont.text == "" || amountcont.text == "0"){

                        setState(() {
                          _amntvalidate = true;
                        });

                        final snackBar2 = SnackBar(
                          backgroundColor: Colors.red[900],
                          content: Text(getTranslated(context, 'Enter Valid Amount'),style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar2);
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
                            ),) : Text("Cash Withdraw",textAlign: TextAlign.center,style: TextStyle(color: TextColor),)
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 0,),
                Container(
                  margin: EdgeInsets.only(left: 0),
                  alignment: Alignment.center,
                  child: Text("!!  If you want to change the payment mode click on the following button",style: TextStyle(color:SecondaryColor,fontSize: 10,fontWeight: FontWeight.w500,),textAlign: TextAlign.center,),
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
                                ),
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
                              child: Text(getTranslated(context, 'History'),style: TextStyle(color: TextColor,fontSize: 12),overflow: TextOverflow.ellipsis,)
                          ),
                        ),
                      ),

                      Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation1, animation2) => Ministatement(
                                      name: consumername.text,aadhrnum: aadharnum.text,number: mobilenum.text,),
                                    transitionDuration: Duration(seconds: 0),
                                  ),
                              );
                            },
                            child: Container(
                              width: 105,
                                margin: EdgeInsets.only(right: 1),
                                padding: EdgeInsets.only(left: 10,right: 10,top: 8,bottom: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    border: Border.all(
                                        color: PrimaryColor
                                    ),
                                    color: PrimaryColor
                                ),
                                child: Text(getTranslated(context, 'Mini-Statement'),style: TextStyle(color: TextColor,fontSize: 12),overflow: TextOverflow.ellipsis,)
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: (){

                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation1, animation2) => Aepscheckbalance(
                                      name: consumername.text,aadhrnum: aadharnum.text,number: mobilenum.text,),
                                    transitionDuration: Duration(seconds: 0),
                                  ),
                              );
                            },
                            child: Container(
                              width: 120,
                                margin: EdgeInsets.only(right: 10),
                                padding: EdgeInsets.only(left: 10,right: 10,top: 8,bottom: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    border: Border.all(
                                        color: PrimaryColor
                                    ),
                                    color: PrimaryColor
                                ),
                                child: Text(getTranslated(context, 'Check Balance'),style: TextStyle(color: TextColor,fontSize: 12),overflow: TextOverflow.ellipsis,)
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