import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../dashboard.dart';

class IrctcRailway extends StatefulWidget {
  const IrctcRailway({Key key}) : super(key: key);

  @override
  _IrctcRailwayState createState() => _IrctcRailwayState();
}

class _IrctcRailwayState extends State<IrctcRailway> {

  TextEditingController _firstname = TextEditingController();
  TextEditingController _lastname = TextEditingController();
  TextEditingController _mobilenum = TextEditingController();
  TextEditingController _firmname = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _emailid = TextEditingController();
  TextEditingController _pannumber = TextEditingController();
  TextEditingController _secondarynum = TextEditingController();
  TextEditingController _secondaryemail = TextEditingController();
  TextEditingController _gstnum = TextEditingController();
  TextEditingController _pincode = TextEditingController();
  TextEditingController _charge = TextEditingController();
  TextEditingController _country = TextEditingController();
  TextEditingController _state = TextEditingController();
  TextEditingController _district = TextEditingController();
  TextEditingController _city = TextEditingController();

  bool _isloading = false;
  bool btnclick = true;
  String checkPanPath1,checkregicer;
  String  status = "";
  String regdate= "";
  String regamnt= "";
  String expdate= "";
  String regmobi= "";
  String regemail= "";
  String regname= "";


  var idnoo;
  var panbase64,regibase64;

  Future<void> retailerinfo() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/Retailer/api/data/Rem_get_all_Information");

    final http.Response response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 10), onTimeout: () {});

    print(response);

    if (response.statusCode == 200) {
      var dataaa = json.decode(response.body);
      status = dataaa["data"];
      var userdet = dataaa["userdetails"];
      var data = userdet["tbl"];

      var retname = dataaa["name"];
      var lstname = dataaa["lastName"];
      var chargetk = dataaa["IRCTCTOKEN"].toString();
      var statename = userdet["statename"];
      var distrc = userdet["district"];
      var mobnum = data["Mobile"];
      var email = data["Email"];
      var address = data["Address"];
      var firmname = data["Frm_Name"];
      var pannum = data["PanCard"];
      var gstnum = data["gst"];
      var panimg = data["pancardPath"];
      var bussinesstype = ["BusinessType"];
      var pincode = data["Pincode"].toString();
      var city = data["city"];
      var regimg = data["Registractioncertificatepath"];


      var bytes = utf8.encode("https://test.vastwebindia.com/" + panimg);
      var base64Str = base64.encode(bytes);
      print("reee : $base64Str");


      if(lstname == null){

        setState(() {
          _lastname.text = "null";
        });
      }else{

        setState(() {
          _lastname.text = lstname;
        });

      }

      if(status == "NOTDONE"){

        setState(() {
          statuss = true;
          status;
        });
      }else{

        setState(() {
          statuss = false;
          status;
          checkhistory();
        });
      }

      if(regimg == null){

        setState(() {
          checkregicer = "null";
        });

      }else{

        setState(() {
          checkregicer = regimg;
        });
      }

      setState(() {
        _firstname.text = retname;
        _mobilenum.text = mobnum;
        _emailid.text = email;
        _address.text = address;
        _firmname.text = firmname;
        _pannumber.text = pannum;
        _gstnum.text = gstnum;
        _pincode.text = pincode;
        _city.text = city;
        checkPanPath1 = panimg;
        _charge.text =chargetk;
        _state.text = statename;
        _district.text = distrc;
        _country.text = "India";
      });

      networkImageToBase64();

    } else {
      throw Exception('Failed');
    }
  }

  Future<void> checkhistory() async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/Retailer/api/data/IRCTCTC_REPORST");

    final http.Response response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 10), onTimeout: () {});

    print(response);

    if (response.statusCode == 200) {
      var dataaa = json.decode(response.body);
      idnoo = dataaa[0]["idno"].toString();
     var regdatee = dataaa[0]["txn_date"].toString();
      regamnt = dataaa[0]["amount"].toString();
     var expdated = dataaa[0]["expire_time"].toString();
      regmobi = dataaa[0]["remmobile"].toString();
      regemail = dataaa[0]["remEmail"].toString();
      regname = dataaa[0]["RetailerName"].toString();

      DateTime tempDate1 = DateTime.parse(regdatee);
      var gg = DateFormat.yMMMMd().format(tempDate1);

      DateTime tempDate2 = DateTime.parse(expdated);
      var gg2 = DateFormat.yMMMMd().format(tempDate2);

      setState(() {
        idnoo;
        regdate;
        regdate = gg;
        expdate = gg2;
      });


    } else {
      throw Exception('Failed');
    }
  }

  Future<void> checkstatus(String idno) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/Retailer/api/data/Status_IRCTC_CHECK",{
      "idno":idno
    });

    final http.Response response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 10), onTimeout: () {});

    print(response);

    if (response.statusCode == 200) {
      var dataaa = json.decode(response.body);



    } else {
      throw Exception('Failed');
    }
  }

  Future<void> submitinfo(String Secmob, String Secemail, String panpath, String regispath) async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var url = new Uri.http("api.vastwebindia.com", "/Retailer/api/data/InsertIrctcInformation");

    Map map = {
      "txtirctcsecondmobileno": Secmob,
      "txtirctcsecondEmailid": Secemail,
      "pancardPath": panpath,
      "Registractioncertificatepath": regispath,
    };

    String body = json.encode(map);

      http.Response response = await http.post(url,
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
        body: body,

      ).timeout(Duration(seconds: 22), onTimeout: () {

        setState(() {
          _isloading = false;
        });
      });


      print(response);

    if (response.statusCode == 200) {

      setState(() {
        _isloading = false;
        btnclick = true;
      });
      var data = json.decode(response.body);


      if (data == "Token Purchase Successfully") {

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: data,
          title: getTranslated(context, 'Success'),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => Dashboard()));
          },
        );
      } else {
        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: data,
          title: status,
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.red,
          onConfirmBtnTap: (){
            getTranslated(context, 'Failed');
          },
        );
      }



    } else {
      throw Exception('Failed to load data from internet');
    }
  }

  Future<String> networkImageToBase64() async {

    var url = new Uri.http("test.vastwebindia.com", "$checkPanPath1");
    http.Response response = await http.get(url);
    final bytes = response.bodyBytes;

   setState(() {
     panbase64 = base64Encode(bytes);
   });

   if(checkregicer == "null"){

   }else{

     networkImageToBase642();
   }


  }

  Future<String> networkImageToBase642() async {

    var url = new Uri.http("test.vastwebindia.com", "$checkregicer");
    http.Response response = await http.get(url);
    final bytes = response.bodyBytes;

    setState(() {
      regibase64 = base64Encode(bytes);
    });


  }

  _launchURL() async {
    const url = 'https://www.irctc.co.in/nget/train-search';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retailerinfo();
  }

  void viewpandialog() {
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
                        Container(
                            width: MediaQuery.of(context).size.width/1.5,
                            child: Text("Pancard Pic", style: TextStyle(fontSize: 18,color: TextColor),overflow: TextOverflow.ellipsis,)),
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
                      child: Image(
                        width: 290,
                        height: 200,
                        fit: BoxFit.fill,
                        image: NetworkImage("https://test.vastwebindia.com/" + checkPanPath1),)

                    ),

                  ],
                ),
              ),

            ),
          );
        });
  }

  void viewregisdialog() {
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
                        Container(
                            width: MediaQuery.of(context).size.width/1.5,
                            child: Text("Register Certificate", style: TextStyle(fontSize: 18,color: TextColor),overflow: TextOverflow.ellipsis,)),
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
                        child: Image(
                          width: 290,
                          height: 200,
                          fit: BoxFit.fill,
                          image: NetworkImage("https://test.vastwebindia.com/" + checkregicer),)

                    ),

                  ],
                ),
              ),

            ),
          );
        });
  }

  bool statuss = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: AppBarWidget(
        title: Row(
          children: [
            Expanded(child: Text("IRCTC".toUpperCase(),textAlign: TextAlign.center,style: TextStyle(color: Colors.white),)),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Visibility(
                  visible: statuss,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: PrimaryColor.withOpacity(0.8),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 0, left: 0, bottom: 10, right: 0),
                              decoration: BoxDecoration(),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1, color: TextColor,),
                                          borderRadius: const BorderRadius.all(const Radius.circular(50.0),),
                                          color: TextColor),
                                      child: Image.asset('assets/pngImages/train.png', width: 40,
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text("Add Passanger Details",
                              style: TextStyle(
                                color: TextColor,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20),
                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  TextFormField(
                                    buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
                                    keyboardType: TextInputType.text,
                                    controller: _firstname,
                                    readOnly: true,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      isDense: true,
                                      isCollapsed: true,
                                      contentPadding: EdgeInsets.fromLTRB(15, 16, 8, 16),
                                      labelText: "First Name",
                                      labelStyle: TextStyle(color: PrimaryColor),
                                      hintStyle: TextStyle(color: PrimaryColor),
                                    ),
                                    cursorColor: Colors.black,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(height: 15,),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  TextFormField(
                                    buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
                                    keyboardType: TextInputType.text,
                                    controller: _lastname,
                                    readOnly: true,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      isDense: true,
                                      isCollapsed: true,
                                      contentPadding: EdgeInsets.fromLTRB(15, 16, 8, 16),
                                      labelText: "Last Name",
                                      labelStyle: TextStyle(color: PrimaryColor),
                                      hintStyle: TextStyle(color: PrimaryColor),
                                    ),
                                    cursorColor: Colors.black,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(height: 15,),

                                ],
                              ),
                            ),


                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  TextFormField(
                                    buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
                                    keyboardType: TextInputType.number,
                                    controller: _mobilenum,
                                    readOnly: true,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      isDense: true,
                                      isCollapsed: true,
                                      contentPadding: EdgeInsets.fromLTRB(15, 16, 8, 16),
                                      labelText: "Mobile Number",
                                      labelStyle: TextStyle(color: PrimaryColor),
                                      hintStyle: TextStyle(color: PrimaryColor),
                                    ),
                                    maxLength: 10,
                                    cursorColor: Colors.black,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(height: 15,),

                                ],
                              ),
                            ),


                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  TextFormField(
                                    buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
                                    keyboardType: TextInputType.text,
                                    controller: _emailid,
                                    readOnly: true,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      isDense: true,
                                      isCollapsed: true,
                                      contentPadding: EdgeInsets.fromLTRB(15, 16, 8, 16),
                                      labelText: "Email Id",
                                      labelStyle: TextStyle(color: PrimaryColor),
                                      hintStyle: TextStyle(color: PrimaryColor),
                                    ),
                                    cursorColor: Colors.black,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(height: 15,),

                                ],
                              ),
                            ),


                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  TextFormField(
                                    buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
                                    keyboardType: TextInputType.text,
                                    controller: _address,
                                    readOnly: true,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      isDense: true,
                                      isCollapsed: true,
                                      contentPadding: EdgeInsets.fromLTRB(15, 16, 8, 16),
                                      labelText: "Address",
                                      labelStyle: TextStyle(color: PrimaryColor),
                                      hintStyle: TextStyle(color: PrimaryColor),
                                    ),
                                    cursorColor: Colors.black,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(height: 15,),

                                ],
                              ),
                            ),


                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  TextFormField(
                                    buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
                                    keyboardType: TextInputType.text,
                                    controller: _country,
                                    readOnly: true,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      isDense: true,
                                      isCollapsed: true,
                                      contentPadding: EdgeInsets.fromLTRB(15, 16, 8, 16),
                                      labelText: "Country",
                                      labelStyle: TextStyle(color: PrimaryColor),
                                      hintStyle: TextStyle(color: PrimaryColor),
                                    ),
                                    cursorColor: Colors.black,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(height: 15,),

                                ],
                              ),
                            ),


                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  TextFormField(
                                    buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
                                    keyboardType: TextInputType.text,
                                    controller: _state,
                                    readOnly: true,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      isDense: true,
                                      isCollapsed: true,
                                      contentPadding: EdgeInsets.fromLTRB(15, 16, 8, 16),
                                      labelText: "State",
                                      labelStyle: TextStyle(color: PrimaryColor),
                                      hintStyle: TextStyle(color: PrimaryColor),
                                    ),
                                    cursorColor: Colors.black,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(height: 15,),

                                ],
                              ),
                            ),


                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  TextFormField(
                                    buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
                                    keyboardType: TextInputType.text,
                                    controller: _city,
                                    readOnly: true,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      isDense: true,
                                      isCollapsed: true,
                                      contentPadding: EdgeInsets.fromLTRB(15, 16, 8, 16),
                                      labelText: "City",
                                      labelStyle: TextStyle(color: PrimaryColor),
                                      hintStyle: TextStyle(color: PrimaryColor),
                                    ),
                                    cursorColor: Colors.black,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(height: 15,),

                                ],
                              ),
                            ),


                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  TextFormField(
                                    buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
                                    keyboardType: TextInputType.text,
                                    controller: _firmname,
                                    readOnly: true,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      isDense: true,
                                      isCollapsed: true,
                                      contentPadding: EdgeInsets.fromLTRB(15, 16, 8, 16),
                                      labelText: "Firm Name",
                                      labelStyle: TextStyle(color: PrimaryColor),
                                      hintStyle: TextStyle(color: PrimaryColor),
                                    ),
                                    cursorColor: Colors.black,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(height: 15,),

                                ],
                              ),
                            ),


                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  TextFormField(
                                    buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
                                    keyboardType: TextInputType.text,
                                    controller: _charge,
                                    readOnly: true,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      isDense: true,
                                      isCollapsed: true,
                                      contentPadding: EdgeInsets.fromLTRB(15, 16, 8, 16),
                                      labelText: "Charge",
                                      labelStyle: TextStyle(color: PrimaryColor),
                                      hintStyle: TextStyle(color: PrimaryColor),
                                    ),
                                    cursorColor: Colors.black,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(height: 15,),

                                ],
                              ),
                            ),


                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  TextFormField(
                                    buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
                                    keyboardType: TextInputType.text,
                                    controller: _pannumber,
                                    readOnly: true,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      isDense: true,
                                      isCollapsed: true,
                                      contentPadding: EdgeInsets.fromLTRB(15, 16, 8, 16),
                                      labelText: "Pan Card Number",
                                      labelStyle: TextStyle(color: PrimaryColor),
                                      hintStyle: TextStyle(color: PrimaryColor),
                                    ),
                                    cursorColor: Colors.black,
                                    maxLength: 10,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(height: 15,),
                                ],
                              ),
                            ),


                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        decoration: BoxDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: TextColor,
                                      border: Border.all(
                                        color: PrimaryColor.withOpacity(0.3),
                                      ),),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Pancard Image",style: TextStyle(fontSize: 14,),textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: 20,
                                              width: 45,
                                              margin: EdgeInsets.only(top: 2),
                                              child: FlatButton(
                                                color: SecondaryColor.withOpacity(0.4),
                                                shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.3),),
                                                padding: EdgeInsets.all(0),
                                                onPressed: () {
                                                  setState(() {

                                                    viewpandialog();
                                                  });



                                                },
                                                child:Text(getTranslated(context, 'View'),style: TextStyle(fontSize: 10,),),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: TextColor,
                                      border: Border.all(
                                        color: PrimaryColor.withOpacity(0.3),
                                      ),),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Register Cert..",style: TextStyle(fontSize: 14,),textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: 20,
                                              width: 45,
                                              margin: EdgeInsets.only(top: 2),
                                              child: FlatButton(
                                                color: SecondaryColor.withOpacity(0.4),
                                                shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.3),),
                                                padding: EdgeInsets.all(0),
                                                onPressed: () {
                                                  setState(() {

                                                    viewregisdialog();

                                                  });
                                                },
                                                child:Text(getTranslated(context, 'View'),style: TextStyle(fontSize: 10,),),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  TextFormField(
                                    buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
                                    keyboardType: TextInputType.number,
                                    controller: _pincode,
                                    readOnly: true,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      isDense: true,
                                      isCollapsed: true,
                                      contentPadding: EdgeInsets.fromLTRB(15, 16, 8, 16),
                                      labelText: "Pin Code",
                                      labelStyle: TextStyle(color: PrimaryColor),
                                      hintStyle: TextStyle(color: PrimaryColor),
                                    ),
                                    cursorColor: Colors.black,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(height: 15,),

                                ],
                              ),
                            ),


                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  TextFormField(
                                    buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
                                    keyboardType: TextInputType.text,
                                    controller: _gstnum,
                                    readOnly: true,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      isDense: true,
                                      isCollapsed: true,
                                      contentPadding: EdgeInsets.fromLTRB(15, 16, 8, 16),
                                      labelText: "GST Number",
                                      labelStyle: TextStyle(color: PrimaryColor),
                                      hintStyle: TextStyle(color: PrimaryColor),
                                    ),
                                    cursorColor: Colors.black,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(height: 15,),

                                ],
                              ),
                            ),


                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  TextFormField(
                                    buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
                                    keyboardType: TextInputType.number,
                                    controller: _secondarynum,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      isDense: true,
                                      isCollapsed: true,
                                      contentPadding: EdgeInsets.fromLTRB(15, 16, 8, 16),
                                      labelText: "Secondary Number",
                                      labelStyle: TextStyle(color: PrimaryColor),
                                      hintStyle: TextStyle(color: PrimaryColor),
                                    ),
                                    cursorColor: Colors.black,
                                    maxLength: 10,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(height: 15,),

                                ],
                              ),
                            ),


                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  TextFormField(
                                    buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
                                    keyboardType: TextInputType.text,
                                    controller: _secondaryemail,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: PrimaryColor)),
                                      isDense: true,
                                      isCollapsed: true,
                                      contentPadding: EdgeInsets.fromLTRB(15, 16, 8, 16),
                                      labelText: "Secondary Email",
                                      labelStyle: TextStyle(color: PrimaryColor),
                                      hintStyle: TextStyle(color: PrimaryColor),
                                    ),
                                    cursorColor: Colors.black,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(height: 15,),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      MainButtonSecodn(
                          onPressed: btnclick == false ? null : ()async{
                            FocusScopeNode currentFocus = FocusScope.of(context);
                            currentFocus.unfocus();
                            setState(() {
                              _isloading = true;
                              btnclick = false;
                            });
                            submitinfo(_secondarynum.text, _secondaryemail.text, panbase64, regibase64);
                          },
                          color: SecondaryColor,
                          btnText:Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: _isloading ? Center(child: SizedBox(
                                    height: 20,
                                    child: LinearProgressIndicator(backgroundColor: PrimaryColor,valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
                                  ),) : Text("Submit",textAlign: TextAlign.center,style: TextStyle(color: TextColor),)
                              ),
                            ],
                          )
                      )
                    ],
                  ),
                  replacement: Visibility(
                    visible: status == "Pending" ? true : false,
                    child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color:PrimaryColor.withOpacity(0.9),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  Container(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 1,
                                        ),
                                        Icon(Icons.pending_sharp,color: Colors.yellow,size: 100,),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(status,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),),
                                        MainButton(
                                          style: TextStyle(color: Colors.white),
                                          color: SecondaryColor,
                                          onPressed: (){

                                            checkstatus(idnoo);
                                          },
                                          btnText: "Check Status",
                                        ),
                                        SizedBox(height: 10,),
                                      ],
                                    ),
                                  ),


                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20,right: 20),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(child: Text("Registration Date:-")),
                                      Expanded(child: Text(regdate,textAlign: TextAlign.end,)),
                                    ],
                                  ),


                                  SizedBox(height: 8,),
                                  Container(height: 1,decoration: BoxDecoration(color: PrimaryColor.withOpacity(0.3)),),
                                  SizedBox(height: 8,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(child: Text("Registration Amount:-")),
                                      Expanded(child: Text(regamnt,textAlign: TextAlign.end,)),
                                    ],
                                  ),
                                  SizedBox(height: 8,),
                                  Container(height: 1,decoration: BoxDecoration(color: PrimaryColor.withOpacity(0.3)),),
                                  SizedBox(height: 8,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(child: Text("User Name:-")),
                                      Expanded(child: Text(regname,textAlign: TextAlign.end,)),
                                    ],
                                  ),
                                  SizedBox(height: 8,),
                                  Container(height: 1,decoration: BoxDecoration(color: PrimaryColor.withOpacity(0.3)),),
                                  SizedBox(height: 8,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(child: Text("Next Renewal Date:-")),
                                      Expanded(child: Text(expdate,textAlign: TextAlign.end,)),
                                    ],
                                  ),
                                  SizedBox(height: 8,),
                                  Container(height: 1,decoration: BoxDecoration(color: PrimaryColor.withOpacity(0.3)),),
                                  SizedBox(height: 8,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(child: Text("Registred Mobile Number:-")),
                                      Expanded(child: Text(regmobi,textAlign: TextAlign.end,)),
                                    ],
                                  ),
                                  SizedBox(height: 8,),
                                  Container(height: 1,decoration: BoxDecoration(color: PrimaryColor.withOpacity(0.3)),),
                                  SizedBox(height: 8,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(child: Text("Reg Email Id:-")),
                                      Expanded(child: Text(regemail,textAlign: TextAlign.end,)),
                                    ],
                                  ),
                                ],
                              ),
                            )

                          ],
                        )
                    ),
                    replacement: Center(
                        child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(

                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [

                                      Container(
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 1,
                                            ),
                                            Icon(Icons.check_circle_outline,color: Colors.green,size: 100,),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(status,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.green),),
                                            SizedBox(height: 10,),
                                          ],
                                        ),
                                      ),


                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  color: Colors.black,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20,right: 20),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(child: Text("Registration Date:-")),
                                          Expanded(child: Text(regdate,textAlign: TextAlign.end,)),
                                        ],
                                      ),


                                      SizedBox(height: 8,),
                                      Container(height: 1,decoration: BoxDecoration(color: PrimaryColor.withOpacity(0.3)),),
                                      SizedBox(height: 8,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(child: Text("Registration Amount:-")),
                                          Expanded(child: Text(regamnt,textAlign: TextAlign.end,)),
                                        ],
                                      ),
                                      SizedBox(height: 8,),
                                      Container(height: 1,decoration: BoxDecoration(color: PrimaryColor.withOpacity(0.3)),),
                                      SizedBox(height: 8,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(child: Text("User Name:-")),
                                          Expanded(child: Text(regname,textAlign: TextAlign.end,)),
                                        ],
                                      ),
                                      SizedBox(height: 8,),
                                      Container(height: 1,decoration: BoxDecoration(color: PrimaryColor.withOpacity(0.3)),),
                                      SizedBox(height: 8,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(child: Text("Next Renewal Date:-")),
                                          Expanded(child: Text(expdate,textAlign: TextAlign.end,)),
                                        ],
                                      ),
                                      SizedBox(height: 8,),
                                      Container(height: 1,decoration: BoxDecoration(color: PrimaryColor.withOpacity(0.3)),),
                                      SizedBox(height: 8,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(child: Text("Registred Mobile Number:-")),
                                          Expanded(child: Text(regmobi,textAlign: TextAlign.end,)),
                                        ],
                                      ),
                                      SizedBox(height: 8,),
                                      Container(height: 1,decoration: BoxDecoration(color: PrimaryColor.withOpacity(0.3)),),
                                      SizedBox(height: 8,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(child: Text("Reg Email Id:-")),
                                          Expanded(child: Text(regemail,textAlign: TextAlign.end,)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                MainButton(
                                  style: TextStyle(color: Colors.white),
                                  color: SecondaryColor,
                                  onPressed: (){

                                    _launchURL();
                                  },
                                  btnText: "Book Tickets",
                                ),
                              ],
                            )))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
