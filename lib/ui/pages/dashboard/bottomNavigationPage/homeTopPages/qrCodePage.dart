
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/IntroSliderPages/AppSignUpButton.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;




class QRCodePage extends StatefulWidget {
  final String qramount,status;
  const QRCodePage({Key key, this.qramount, this.status}) : super(key: key);

  @override
  _QRCodePageState createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {

  Uint8List showqr;
  var qrcode1;
  var mszz = "Create";

  Future<void> Qrcodestatus() async {

    final prefs = await SharedPreferences.getInstance();
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/UPI/api/data/UPI_Transfer",{
      "amountqr":widget.qramount
    });

    final http.Response response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 15), onTimeout: (){
      setState(() {

      });
    });

    print(response);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var status = data["Status"];
      mszz = data["Message"];


      if(status == "Success"){

        showqrcode();

      }else{

        setState(() {
          mszz;
        });
      }


    } else {
      throw Exception('Failed');
    }
  }

  Future<void> showqrcode() async {


    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url = new Uri.http("api.vastwebindia.com", "/UPI/api/data/UPI_Transfer",{
      "amountqr":widget.qramount
    });
    final http.Response response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 15), onTimeout: (){
      setState(() {

        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(getTranslated(context, 'Data Not Found') + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);

      });
    });

    print(response);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var status1 = data["Status"];
      var msz1 = data["Message"];
      var charge1 = data["charge"];
      var min1 = data["min"];
       qrcode1 = data["QRCODE"];

      showqr = base64.decode(qrcode1);


      setState(() {
        showqr;
      });


    } else {
      throw Exception('Failed to load themes');
    }

  }

  Future<void> generateqrcode() async {


    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url = new Uri.http("api.vastwebindia.com", "/UPI/api/data/ADD_UPI_Transfer");
    final http.Response response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 15), onTimeout: (){
      setState(() {

        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(getTranslated(context, 'Data Not Found') + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);

      });
    });

    print(response);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var status = data["Status"].toString();
      var msz = data["Message"].toString();

      if (status == "Success") {

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          title: status,
          text: getTranslated(context, 'Add SuccessFully'),
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
          title: status,
          text: msz,
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.red,
          onConfirmBtnTap: (){
            Navigator.of(context).pop();
          },
        );
      }


    } else {
      throw Exception('Failed to load themes');
    }

  }


  List<String> imagePaths = [];
  var scr= new GlobalKey();
  static GlobalKey previewContainer = new GlobalKey();
  final _boundaryKey = GlobalKey();

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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Qrcodestatus();
  }

  @override
  Widget build(BuildContext context) {
    final snackBar = SnackBar(
      content: Text(getTranslated(context, 'QR Code Downloaded'),style: TextStyle(color: Colors.yellowAccent),),
    );
    String pickedFile = imagePaths ==null?"":imagePaths.toString();
    String trimmedFileName = pickedFile.split("/").last;
    return Material(
      child: Scaffold(
        backgroundColor: TextColor,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  /*select Option=============*/
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 60,
                    width: 60,
                    child: Stack(
                      fit: StackFit.loose,
                      alignment: Alignment.center,
                      children: [
                        ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                              width: 100, height: 100,),
                            child:FlatButton(
                              shape: CircleBorder(
                                  side: BorderSide(
                                      width:1,color: Colors.green)),
                              color: Colors.transparent,
                              onPressed: (){

                              },
                              child:Image.asset('assets/pngImages/qr-code.png',height: 35,),
                            )
                        ),
                        Positioned(
                          top: -1,
                          right: -2,
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(100),
                                ),
                                color: TextColor,
                              ),
                              child: Icon(Icons.check_circle,color: Colors.green,)
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Visibility(
                    visible: widget.status == "PRICEBASE" ? false : true,
                      child: Container(
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(getTranslated(context, 'BY QR CODE')),
                            Text("\u{20B9}" + widget.qramount,style: TextStyle(fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                      replacement: Container(
                        child: Text("QR CODE",style: TextStyle(fontWeight: FontWeight.bold),),
                      ),),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: mszz == "Create" ? Image.asset('assets/pngImages/qr-code.png',height: 35) :RepaintBoundary(
                      key: previewContainer,
                      child: Image.memory(showqr),
                    ) ,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Visibility(
                    visible: mszz == "Create" ? true : false,
                    child: MainButtonSecodn(
                        onPressed: () async{

                          setState(() {
                            generateqrcode();
                          });
                        },
                        color: SecondaryColor,

                        btnText:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child:Text("Generate QR Code",style: TextStyle(color: TextColor),textAlign: TextAlign.center,)
                            ),
                          ],
                        )
                    ),),
                  Visibility(
                    visible:widget.status == "PRICEBASE" ? false : true ,
                    child: Container(
                      margin: EdgeInsets.only(right: 15,left: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BackButtons(),
                          TextButtons(
                            onPressed: ()async{

                              Uint8List bytes = base64.decode(qrcode1);
                              String dir = (await getApplicationDocumentsDirectory()).path;
                              String fullPath = '$dir/abc.png';
                              print("local file full path ${fullPath}");
                              File file = File(fullPath);
                              await file.writeAsBytes(bytes);
                              final result = await ImageGallerySaver.saveImage(bytes);
                              SnackBar;
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);

                            },
                            textButtonStyle: TextStyle(color: SecondaryColor,fontSize: 14),
                            buttonText: getTranslated(context, 'Download QR Code'),
                            textButtonText:"" ,
                          )
                        ],
                      ),
                    ),
                    replacement:Container(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.all(15),
                        backgroundColor:SecondaryColor ,
                        shadowColor:Colors.transparent,),
                      onPressed:()async{

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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Text("Share QR Code",textAlign: TextAlign.center,style: TextStyle(color: TextColor,fontSize: 18),)
                          ),
                        ],
                      ),
                    ),
                  ),),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



}
