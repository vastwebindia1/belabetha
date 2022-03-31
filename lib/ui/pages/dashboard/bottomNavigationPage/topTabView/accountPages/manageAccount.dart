import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:http/http.dart'as http;
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/locations/IpHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import 'dart:io' as Io;


class ManageAccounts extends StatefulWidget {
  const ManageAccounts({Key key}) : super(key: key);

  @override
  _ManageAccountsState createState() => _ManageAccountsState();
}

TextEditingController controller = TextEditingController();
TextEditingController controller1 = TextEditingController();
TextEditingController controller2 = TextEditingController();
TextEditingController controller3 = TextEditingController();
TextEditingController controller4 = TextEditingController();
TextEditingController controller5 = TextEditingController();

ScrollController scrollController = ScrollController();
class _ManageAccountsState extends State<ManageAccounts> {

  bool visibleInput = false;
  bool visibleText = true;
  bool buttonVisible = false;
  List Banklist = [];
  String bankhint = "Select Your Bank";
  String bankIfsc = "";
  bool btnclick = false;
  bool _isloading = false;
  bool _validate = false;


  String modelname = "";
  String androidid = "";
  String lat = "";
  String long = "";
  String city = "";
  String address= "";
  String postcode = "";
  String netname = "";
  String ipadd = "";
  String deviceToken = "device";

  String accHolderName = "";
  String accNumber = "";
  String accIfscCode = "";
  String bankNamee = "";
  String bankBranch = "";
  String lastUpdateStatus = "";

  String cancelCheck = "";
  String cancelCheckPath1 = "";
  String idNumber = "";

  bool checkVisible  = false;
  bool checkdetails = true;

  String roll1 = "Retailer";


  void uploaddialog() {
    showDialog(

        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.black.withOpacity(0.8),
            alignment: Alignment.topLeft,
            child: AlertDialog(
              insetPadding: EdgeInsets.only(bottom: 0),
              buttonPadding: EdgeInsets.all(0),
              titlePadding: EdgeInsets.only(left: 0, right: 0,top: 0),
              contentPadding: EdgeInsets.only(left: 10, right: 10,top: 10,bottom: 15,),
              title: Container(
                color: PrimaryColor.withOpacity(0.8),
                padding: EdgeInsets.only(top: 7,bottom: 7,left: 10,right: 10,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.upload_file,color: SecondaryColor,size: 20,),
                        Container(width: MediaQuery.of(context).size.width/1.6,child: Text(getTranslated(context, 'upload Cancel Check') , style: TextStyle(fontSize: 18,color: TextColor,),overflow: TextOverflow.ellipsis,)),
                      ],
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 25,
                      width: 25,
                      child: FlatButton(
                        color: PrimaryColor.withOpacity(0.8),
                        shape:RoundedRectangleBorder(side: BorderSide(color: PrimaryColor, width: 1, style: BorderStyle.solid),
                          borderRadius: new BorderRadius.circular(50),),
                        padding: EdgeInsets.all(0),
                        onPressed: () => Navigator.of(context).pop(),
                        child:Icon(Icons.clear,color: TextColor,size: 22,),
                      ),
                    ),

                  ],
                ),
              ),
              content: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        height: 30,
                        child: FlatButton(
                          color: TextColor,
                          shape:RoundedRectangleBorder(side: BorderSide(
                              color: SecondaryColor.withOpacity(0.8),
                              width: 2,
                              style: BorderStyle.solid
                          ),borderRadius: new BorderRadius.circular(0),),
                          padding: EdgeInsets.only(left: 5,right: 5,),
                          onPressed: () {
                            setState(() {

                              _pickImageFromGallery3();

                            });
                          },
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.insert_photo_outlined,color: SecondaryColor,size: 14,),
                              SizedBox(width: 2,),
                              Container(
                                width: 100,
                                child: Text(
                                  getTranslated(context, 'Upload From Gallery'),
                                  style: TextStyle(fontSize: 12,fontWeight: FontWeight.normal,letterSpacing: -0.5,),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 7,),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        height: 30,
                        child: FlatButton(
                          color: TextColor,
                          shape:RoundedRectangleBorder(side: BorderSide(
                              color: SecondaryColor.withOpacity(0.8),
                              width: 2,
                              style: BorderStyle.solid
                          ),borderRadius: new BorderRadius.circular(0),),
                          padding: EdgeInsets.only(left: 5,right: 5,),
                          onPressed: () {
                            setState(() {

                              _pickImageFromCamera3();

                            });
                          },
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt_rounded,color: SecondaryColor,size: 14,),
                              SizedBox(width: 2,),
                              Container(
                                width: 100,
                                child: Text(
                                  getTranslated(context, 'Upload From Camera'),
                                  style: TextStyle(fontSize: 12,fontWeight: FontWeight.normal,letterSpacing: -0.5,),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ),
          );
        });
  }

  void viewdialog() {
    showDialog(

        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.black.withOpacity(0.8),
            alignment: Alignment.topLeft,
            child: AlertDialog(
              insetPadding: EdgeInsets.only(bottom: 0),
              buttonPadding: EdgeInsets.all(0),
              titlePadding: EdgeInsets.only(left: 0, right: 0,top: 0),
              contentPadding: EdgeInsets.only(left: 0, right: 0,top: 0,bottom: 0,),
              title: Container(
                color: PrimaryColor.withOpacity(0.8),
                padding: EdgeInsets.only(left: 10, right: 10,top: 10,bottom: 10,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.image_rounded,color: SecondaryColor,size: 20,),
                        Text(getTranslated(context, 'View Cancel Cheque')  , style: TextStyle(fontSize: 18,color: TextColor),),
                      ],
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 25,
                      width: 25,
                      child: FlatButton(
                        color: PrimaryColor.withOpacity(0.8),
                        shape:RoundedRectangleBorder(side: BorderSide(color: PrimaryColor, width: 1, style: BorderStyle.solid),
                          borderRadius: new BorderRadius.circular(50),),
                        padding: EdgeInsets.all(0),
                        onPressed: () => Navigator.of(context).pop(),
                        child:Icon(Icons.clear,color: TextColor,size: 22,),
                      ),
                    ),

                  ],
                ),
              ),
              content: Container(
                height: 250,
                padding: EdgeInsets.only(left: 10, right: 10,top: 10,bottom: 10,),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 5,color: PrimaryColor)
                      ),
                      child:Image(
                        width: 290,
                        height: 200,
                        fit: BoxFit.fill,
                        image: NetworkImage("https://test.vastwebindia.com/" + cancelCheckPath1),
                      )
                    ),

                  ],
                ),
              ),

            ),
          );
        });
  }


  final panGalleryPicker = ImagePicker();
  _pickImageFromGallery3() async {
    PickedFile pickedFile = await panGalleryPicker.getImage(source: ImageSource.gallery, imageQuality: 50);

    /* File image = File(pickedFile.path);*/

    final bytes2 = Io.File(pickedFile.path).readAsBytesSync();

    cancelCheck = base64Encode(bytes2);


    setState(() {

      uploadCancelCheck(cancelCheck,idNumber,roll1);

      Navigator.of(context).pop();



    });
  }


  final panCamerapicker = ImagePicker();
  _pickImageFromCamera3() async {
    PickedFile pickedFile = await panCamerapicker.getImage(source: ImageSource.camera, imageQuality: 50);

    /*File image = File(pickedFile.path);*/

    final bytes1 = Io.File(pickedFile.path).readAsBytesSync();

    cancelCheck = base64Encode(bytes1);

    setState(() {

      uploadCancelCheck(cancelCheck,idNumber,roll1);

      Navigator.of(context).pop();



    });
  }


  Future<void> uploadCancelCheck(String check ,String id,String roll) async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url =
    new Uri.https("test.vastwebindia.com", "/api/user/Uploadcancelledcheque");
    Map map = {
      "cancelledcheque" : check,
      "cancellchecque_idno" : id,
      "currentrole" : roll,


    };

    String body = json.encode(map);

    http.Response response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body).timeout(Duration(seconds: 15), onTimeout: (){
      setState(() {

        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(getTranslated(context, 'Data Not Found'),style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);

      });
    });
    print(response);

    if (response.statusCode == 201) {
      var dataa = json.decode(response.body);
      var sts = dataa["Message"];


      if (sts == "Image Updated Successfully.") {
        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: sts,
          title: getTranslated(context, 'Success'),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ManageAccounts()));},

        );
      }else{

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: sts,
          title: getTranslated(context, 'Failed'),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.red,
          onConfirmBtnTap: (){
            Navigator.of(context).pop();},
        );

      }
    } else {
      throw Exception('Failed');
    }
  }



  TextEditingController _textController = TextEditingController();
  ScrollController listSlide = ScrollController();


  Future<void> bankList() async {

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


  Future<void> bankDetailsSubmit(String accHolder2,String accNo2,String bankIfsc2,String bankName2,
      String bankAddress2, String ip2,String deviceToken2,String latitude2,String longitude2,
      String model2,String city2,String postal2,String internet2,String address2) async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var url = new Uri.http("api.vastwebindia.com", "/Retailer/api/data/UpdateRetailerBank");

    Map map = {
      "txtaccholder": accHolder2,
      "txtbankaccountno": accNo2,
      "txtifsc": bankIfsc2,
      "txtbankname": bankName2,
      "txtbranchaddress": bankAddress2,
      "IP" : ip2,
      "Devicetoken" : deviceToken2,
      "Latitude" : latitude2,
      "Longitude" : longitude2,
      "ModelNo" : model2,
      "City" : city2,
      "PostalCode" : postal2,
      "InternetTYPE" : internet2,
      "Addresss" : address2,

    };

    String body = json.encode(map);

    http.Response response = await http.post(url,
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      },
      body: body,

    ).timeout(Duration(seconds: 15), onTimeout: (){
      setState(() {

        _isloading = false;

        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(getTranslated(context, 'Data Not Found'),style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);

      });
    });


    print(response);


    if (response.statusCode == 200) {
      _isloading = false;

      var data = json.decode(response.body);
      var status = data["Response"];
      var msz = data["Message"];
      idNumber = data["idno"].toString();



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
            setState(() {
              _isloading = false;
              checkdetails = true;
              visibleInput = false;

            });
            Navigator.of(context).pop();},

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
            Navigator.of(context).pop();},
        );
      }
    }else {

      _isloading = false;

      throw Exception('Failed');
    }
  }





  Future<void> showBankDetails() async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var url = new Uri.http("api.vastwebindia.com", "/Retailer/api/Data/ShowBankinfo");
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
          content: Text(getTranslated(context, 'Data Not Found'),style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);

      });
    });

    print(response);

    if (response.statusCode == 200) {
      var dataa1 = json.decode(response.body);
      var result = dataa1["Response"];
      var message = dataa1["Message"];
       accHolderName = message["accountholder"];
       accNumber = message["Bankaccountno"];
       accIfscCode = message["Ifsccode"];
       bankNamee = message["bankname"];
       bankBranch = message["bankAddress"];
       lastUpdateStatus = message["LastAddedAcStatus"];
       cancelCheckPath1 = message["canbcelchkpath"];




    } else {
      throw Exception('Failed to load themes');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showBankDetails();
    bankList();
  }





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
                                             /* bankid = Banklist[index]["id"].toString();
                                              bankiin = Banklist[index]["iINNo"] == null ? "":Banklist[index]["iINNo"];*/
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

  @override
  Widget build(BuildContext context) {
    /*setState(() {
      controller.text = accName;
      controller1.text = accNumber;
      controller2.text = ifsCode;
      controller3.text = accBranch;
    });*/
    return Scaffold(
      backgroundColor: TextColor,
      body: Material(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(
                      10,
                    ),
                    decoration: BoxDecoration(
                      color: PrimaryColor.withOpacity(0.8),
                    ),
                    child: Container(
                      padding: EdgeInsets.only(
                        top: 0,
                        left: 0,
                        bottom: 10,
                        right: 0,
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: lastUpdateStatus == "Pending" ?Icon(
                                              Icons.watch_later,
                                              color: Colors.yellow[800],
                                              size: 100,
                                            ) : lastUpdateStatus == "Success" ? Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                              size: 100,
                                            ) :lastUpdateStatus == "Failed" ? Icon(
                                              Icons.cancel,
                                              color: Colors.red,
                                              size: 100,
                                            ) :lastUpdateStatus == "Approved" ? Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                              size: 100,
                                            ): Icon(
                                              Icons.warning,
                                              color: Colors.yellow,
                                              size: 100,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      left: 0,
                                      child:  Container(
                                      margin: EdgeInsets.only(top: 0),
                                      child: BackButton(color: SecondaryColor,)
                                    ),)
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(lastUpdateStatus == null ? "status" :lastUpdateStatus.toUpperCase(),
                                style: TextStyle(color: TextColor),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: PrimaryColor.withOpacity(0.08),
                          blurRadius: 0,
                          spreadRadius: 1,
                          offset: Offset(.0, .0), // shadow direction: bottom right
                        )
                      ],
                    ),
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 0.5, right: 0.5, top: 0.5, bottom: 0.5),
                      child: Container(
                        color: TextColor.withOpacity(0.5),
                        padding:EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                        child: Column(
                          children: [
                            Visibility(
                              visible: checkdetails,
                              child: Container(
                                margin: EdgeInsets.only(top: 10,right: 0,left: 0,bottom: 0),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1,color: PrimaryColor,
                                    )),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                lastUpdateStatus == "Pending"  && cancelCheckPath1 == null ?Icon(Icons.cancel,color: Colors.red,size: 14,)
                                                    :lastUpdateStatus == "Success" ? Icon(Icons.check_circle,color: Colors.green,size: 14,)
                                                    :lastUpdateStatus == "Pending" && cancelCheckPath1 != null ?Icon(Icons.watch_later,color: Colors.yellow[800],size: 14,)
                                                    : Icon(Icons.cancel,color: Colors.red,size: 14,),
                                                SizedBox(width: 3,),
                                                Text(
                                                  getTranslated(context, 'Cancel Cheque') ,
                                                  style: TextStyle(
                                                    fontSize: 12,),
                                                ),
                                              ],
                                            ),
                                            Text(getTranslated(context, 'Cancel Cheque') , style: TextStyle(fontSize: 16,),)

                                          ],
                                        ),
                                        Container(
                                          alignment: Alignment.centerRight,
                                          height: 28,
                                          child: FlatButton(
                                              color: TextColor,
                                              shape:RoundedRectangleBorder(side: BorderSide(
                                                  color: SecondaryColor.withOpacity(0.8),
                                                  width: 1,
                                                  style: BorderStyle.solid
                                              ),borderRadius: new BorderRadius.circular(0),),
                                              padding: EdgeInsets.all(0),
                                              onPressed: (){
                                                setState(() {

                                                  if(lastUpdateStatus == "Pending" && cancelCheckPath1 == null){

                                                    uploaddialog();
                                                  }else if(lastUpdateStatus == "Success"){
                                                    viewdialog();
                                                  }else if (lastUpdateStatus == "Pending" && cancelCheckPath1 != null){

                                                    viewdialog();
                                                  }else{

                                                    uploaddialog();
                                                  }

                                                });
                                              },
                                              child: lastUpdateStatus == "Pending" && cancelCheckPath1 == null ?Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.upload_file,color: SecondaryColor,size: 16,),
                                                  SizedBox(width: 3,),
                                                  Text(
                                                    getTranslated(context, 'Upload'),
                                                    style: TextStyle(color: SecondaryColor,fontSize: 16,fontWeight: FontWeight.normal),
                                                  ),
                                                ],
                                              ) :lastUpdateStatus == "Success" ? Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.upload_file,color: SecondaryColor,size: 16,),
                                                  SizedBox(width: 3,),
                                                  Text(
                                                    getTranslated(context, 'View'),
                                                    style: TextStyle(color: SecondaryColor,fontSize: 16,fontWeight: FontWeight.normal),
                                                  ),
                                                ],
                                              ) :lastUpdateStatus == "Pending" && cancelCheckPath1 != null ?  Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.upload_file,color: SecondaryColor,size: 16,),
                                                  SizedBox(width: 3,),
                                                  Text(
                                                    getTranslated(context, 'View'),
                                                    style: TextStyle(color: SecondaryColor,fontSize: 16,fontWeight: FontWeight.normal),
                                                  ),
                                                ],
                                              ) :Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.upload_file,color: SecondaryColor,size: 16,),
                                                  SizedBox(width: 3,),
                                                  Text(
                                                    getTranslated(context, 'Upload'),
                                                    style: TextStyle(color: SecondaryColor,fontSize: 16,fontWeight: FontWeight.normal),
                                                  ),
                                                ],
                                              )
                                          ),
                                        ),

                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: visibleText,
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top: 5, bottom: 10),
                                    decoration: BoxDecoration(
                                        border:visibleInput ? Border() : Border(
                                            bottom: BorderSide(
                                              color: PrimaryColor.withOpacity(0.1),
                                              width: 1,
                                            ))),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.account_balance_sharp,
                                                  size: 16,
                                                  color: SecondaryColor,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  getTranslated(context, 'Bank Account Info') ,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: SecondaryColor),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ],
                                            ),
                                            visibleInput ? IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  visibleText = false;
                                                  visibleInput = true;
                                                  buttonVisible = true;
                                                  controller.clear();
                                                  controller1.clear();
                                                  controller2.clear();
                                                  controller3.clear();
                                                  controller4.clear();
                                                });
                                              },
                                              icon: Icon(Icons.close),
                                            ) :
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  visibleInput = true;
                                                  visibleText = false;
                                                  buttonVisible = true;
                                                  checkdetails = false;

                                                });
                                              },
                                              icon: Icon(Icons.edit),
                                            )
                                          ],
                                        ),
                                        Visibility(
                                          maintainSize: false,
                                          visible: visibleText,
                                          child: Container(
                                            child: Row(
                                              mainAxisAlignment:MainAxisAlignment.start,
                                              crossAxisAlignment:CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(bankNamee == null ?getTranslated(context, 'Bank')  :bankNamee
                                                      ,style: TextStyle(fontSize: 20,color:PrimaryColor),
                                                      overflow:TextOverflow.clip,
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          maintainSize: false,
                                          visible: visibleInput,
                                          child:Container(
                                            height: 40,
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
                                              padding: EdgeInsets.only(left: 10,right: 10),
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
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 10, bottom: 10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                      color: PrimaryColor.withOpacity(0.1),
                                      width: 1,
                                    ))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          getTranslated(context, 'AC Name') ,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Expanded(
                                          child: Container(
                                              alignment: Alignment.centerRight,
                                              child: Text(accHolderName == null ? getTranslated(context, 'Name') :accHolderName,
                                                style:
                                                    TextStyle(fontSize: 17),
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 10, bottom: 10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                      color: PrimaryColor.withOpacity(0.1),
                                      width: 1,
                                    ))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          getTranslated(context, 'A/C Number') ,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Expanded(
                                          child: Container(
                                              alignment: Alignment.centerRight,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(accNumber == null ?getTranslated(context, 'Number')  :accNumber,
                                                    style:
                                                        TextStyle(fontSize: 17),
                                                  ),
                                                ],
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 10, bottom: 10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                      color: PrimaryColor.withOpacity(0.1),
                                      width: 1,
                                    ))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          getTranslated(context, 'IFSCode') ,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Expanded(
                                          child: Container(
                                              alignment: Alignment.centerRight,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(accIfscCode == null ? getTranslated(context, 'Ifsc')  :accIfscCode,
                                                    style:
                                                        TextStyle(fontSize: 17),
                                                  ),
                                                ],
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 10, bottom: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          getTranslated(context, 'Branch') ,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(bankBranch == null ? getTranslated(context, 'Branch')  :bankBranch,
                                                  style: TextStyle(fontSize: 17),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: visibleInput,
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top: 5, bottom: 10),
                                    decoration: BoxDecoration(
                                        border:visibleInput ? Border() : Border(
                                            bottom: BorderSide(
                                              color: PrimaryColor.withOpacity(0.1),
                                              width: 1,
                                            ))),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.account_balance_sharp,
                                                  size: 16,
                                                  color: SecondaryColor,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  getTranslated(context, 'Bank Account Info') ,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: SecondaryColor),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ],
                                            ),
                                            visibleInput ? IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  visibleText = true;
                                                  visibleInput = false;
                                                  buttonVisible = false;
                                                  checkdetails = true;
                                                  controller.clear();
                                                  controller1.clear();
                                                  controller2.clear();
                                                  controller3.clear();
                                                  controller4.clear();
                                                });
                                              },
                                              icon: Icon(Icons.close),
                                            ) :
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  visibleInput = true;
                                                  visibleText = false;
                                                  buttonVisible = true;
                                                  checkdetails = false;

                                                });
                                              },
                                              icon: Icon(Icons.clear),
                                            )
                                          ],
                                        ),
                                        Visibility(
                                          maintainSize: false,
                                          visible: visibleText,
                                          child: Container(
                                            child: Row(
                                              mainAxisAlignment:MainAxisAlignment.start,
                                              crossAxisAlignment:CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(bankNamee == null ?getTranslated(context, 'Bank')  :bankNamee
                                                      ,style: TextStyle(fontSize: 20,color:PrimaryColor),
                                                      overflow:TextOverflow.clip,
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          maintainSize: false,
                                          visible: visibleInput,
                                          child:Container(
                                            height: 40,
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
                                              padding: EdgeInsets.only(left: 10,right: 10),
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
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 10, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Container(
                                              alignment: Alignment.centerRight,
                                              child: Container(
                                                height: 40,
                                                  child: TextFormField(
                                                    controller: controller,
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        return "null";
                                                      }
                                                      return null;
                                                    },
                                                    decoration:InputDecoration(
                                                      contentPadding:EdgeInsets.only(left: 10),
                                                      labelText: getTranslated(context, 'A/C Holder Name') ,
                                                      labelStyle: TextStyle(color: PrimaryColor)
                                                    ),
                                                  ))),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 10, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Container(
                                              alignment: Alignment.centerRight,
                                              child: Container(
                                                  height: 40,
                                                  child: TextFormField(
                                                    controller: controller1,
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        return "null";
                                                      }
                                                      return null;
                                                    },
                                                    decoration:InputDecoration(
                                                        contentPadding:EdgeInsets.only(left: 10),
                                                        labelText: getTranslated(context, 'A/C Number') ,
                                                        labelStyle: TextStyle(color: PrimaryColor)
                                                    ),
                                                  ))),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 10, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Container(
                                              alignment: Alignment.centerRight,
                                              child: Container(
                                                  height: 40,
                                                  child: TextFormField(
                                                    controller: controller5,
                                                    onChanged: (String val){

                                                      String enteramnt = controller1.text;
                                                      String reenteramntt = controller5.text;

                                                      if(enteramnt == reenteramntt){

                                                        setState(() {
                                                          _validate = false;
                                                        });
                                                      }else{

                                                        setState(() {
                                                          _validate = true;
                                                        });

                                                      }

                                                    },
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        return "null";
                                                      }
                                                      return null;
                                                    },

                                                    decoration:InputDecoration(
                                                        contentPadding:EdgeInsets.only(left: 10),
                                                        labelText: getTranslated(context, 'Re Enter A/C Number') ,
                                                        errorText:  _validate ? '' : null,
                                                        labelStyle: TextStyle(color: PrimaryColor)
                                                    ),
                                                  ))),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 10, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Container(
                                              alignment: Alignment.centerRight,
                                              child: Container(
                                                  height: 40,
                                                  child: TextFormField(
                                                    controller: controller2,
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        return "null";
                                                      }
                                                      return null;
                                                    },
                                                    decoration:InputDecoration(
                                                        contentPadding:EdgeInsets.only(left: 10),
                                                        labelText: getTranslated(context, 'IFSCode') ,
                                                        labelStyle: TextStyle(color: PrimaryColor)
                                                    ),
                                                  ))),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 10, bottom: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Container(
                                              alignment: Alignment.centerRight,
                                              child: Container(
                                                  height: 40,
                                                  child: TextFormField(
                                                    controller: controller3,
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        return "null";
                                                      }
                                                      return null;
                                                    },
                                                    decoration:InputDecoration(
                                                        contentPadding:EdgeInsets.only(left: 10),
                                                        labelText: getTranslated(context, 'Branch') ,
                                                        labelStyle: TextStyle(color: PrimaryColor)
                                                    ),
                                                  ))),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 10, bottom: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Visibility(
                                                visible: buttonVisible,
                                                child: MainButtonSecodn(
                                                    onPressed:btnclick == false ? null : ()async{

                                                      String enteramnt = controller1.text;
                                                      String reenteramntt = controller5.text;

                                                      if(enteramnt == reenteramntt){

                                                        setState(() {
                                                          _isloading = true;
                                                          _validate = false;
                                                        });



                                                        final prefs =
                                                        await SharedPreferences.getInstance();
                                                        var dd = IpHelper().getCurrentLocation();
                                                        var hu = IpHelper().getconnectivity();
                                                        var hdddu = IpHelper().getLocalIpAddress();

                                                        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                                                        AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;

                                                        modelname = androidDeviceInfo.model;
                                                        androidid = androidDeviceInfo.androidId;

                                                        lat = prefs.getString(
                                                            'lat2');
                                                        long = prefs.getString(
                                                            'long2');
                                                        city = prefs.getString(
                                                            'city2');
                                                        address = prefs.getString(
                                                            'add2');
                                                        postcode = prefs.getString(
                                                            'post2');
                                                        netname = prefs.getString(
                                                            'conntype');
                                                        ipadd = prefs.getString(
                                                            'ipaddress');



                                                        bankDetailsSubmit(controller.text,controller5.text,controller2.text,bankhint,
                                                            controller3.text,ipadd,deviceToken,lat,long,androidid,city,postcode,netname,address);



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
                                                            Text(getTranslated(context, 'Submit'),style: TextStyle(color: TextColor),textAlign: TextAlign.center,)
                                                        )
                                                      ],
                                                    )
                                                ),),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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













}
