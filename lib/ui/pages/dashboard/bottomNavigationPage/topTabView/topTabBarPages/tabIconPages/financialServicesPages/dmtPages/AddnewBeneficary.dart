import 'package:cool_alert/cool_alert.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/IntroSliderPages/AppSignUpButton.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/dmtPages/registerSender.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class Addnewbeneficiary extends StatefulWidget {
  const Addnewbeneficiary({Key key}) : super(key: key);

  @override
  _AddnewbeneficiaryState createState() => _AddnewbeneficiaryState();
}

class _AddnewbeneficiaryState extends State<Addnewbeneficiary> {

  String bankhint = "Select Your Bank";
  String ifschint = "IFSC Code";
  bool _isloading = false;
  List Banklist = [];
  var sendnum,remmid;
  bool verifybtn = true;
  bool reverifybtn = false;
  bool addaccbtn = false;
  bool ifsccodr = false;
  bool btnclick = false;
  bool banklistttt = false;
  bool accnovis = false;
  bool verfybtnnn = false;
  var unqid,androidid;
  String orgifsc;
  bool _validate = false;


  Future<void> banklist(String accnum) async {

    final prefs = await SharedPreferences.getInstance();
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/Money/api/Money/MasterIfsc", {
      "AccountNo": accnum,
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
          content: Text(getTranslated(context, 'Data Not Found'),style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);

      });
    });

    print(response);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var datalist = data["data"];

      setState(() {
        Banklist = datalist;
        sendnum = prefs.getString("sendnum");
        remmid = prefs.getString("remidd");
      });
    } else {
      throw Exception('Failed');
    }
  }

  Future<void> addbeneficiary(String name, String accno, String ifsc, String sendnum, String remid) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/Money/api/Money/AddNewRecipient", {
      "Name": name,
      "AccountNo": accno,
      "IFSC":ifsc,
      "Mobile": "",
      "SenderNo": sendnum,
      "remitterid": remid,
      "ifscoriginal": orgifsc,
    });
    final http.Response response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
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
      var result = data["RESULT"];
      var msz = data["ADDINFO"];

      if(result == "0"){


        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: getTranslated(context, 'Beneficiary Add Successfully'),
          title: getTranslated(context, 'Success'),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => RegisterSenderPage(),
                transitionDuration: Duration(seconds: 0),
              ),);
          },
        );

      }else{


        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: msz,
          title: result,
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
  }

  Future<void> bankresponse(String bankname) async {


    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/Money/api/Money/GetBankDown", {
      "bankname": bankname,
    });
    final http.Response response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
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
      var data = json.decode(response.body);
      var result = data["RESULT"];
      var addinfo = data["ADDINFO"];

      if(result == "0"){

        verifyaccount(sendnum, ifsccontroler.text, accnocont.text, bankhint, unqid, androidid);

      }else{

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: addinfo,
          title: result,
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
  }

  Future<void> verifyaccount(String number, String ifsc, String accno, String bankname, String uniqueid, String imei) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");
    var userid = await storage.read(key: "userId");

    var url = new Uri.http("api.vastwebindia.com", "/Money/api/Money/mmmn2", {
      "mb": number,
      "iff": ifsc,
      "cd":"",
      "bno": accno,
      "mal": userid,
      "sk": uniqueid,
      "pi": imei,
      "kk": "RJUPM12131",
      "bankName": bankname,
      "kyc": "",
      "uniqueid":uniqid
    });
    final http.Response response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 30), onTimeout: (){
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
      var result = data["RESULT"];
      var addinfo = data["ADDINFO"];

      if(result == "0"){

        var bename = data["ADDINFO"]["data"]["benename"];
        var verify = data["ADDINFO"]["data"]["verification_status"];
        var local = data["ADDINFO"]["Local"];

        if(verify == "VERIFIED"){

          setState(() {
            verfybtnnn = true;
          });

        }else{
          setState(() {
            verfybtnnn = false;
          });

        }

        if(local == "Local"){

          setState(() {
            reverifybtn = true;
            verifybtn = false;
            addaccbtn = false;
          });

        }else{

          setState(() {
            namecontroller.text = bename;
            _isloading = false;
            verifybtn = false;
            addaccbtn = true;
          });

         /* showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomDialog(
                  buttonText:getTranslated(context, 'ok'),
                  color: Colors.green,
                  description: "Account Verify Successfully",
                  title: getTranslated(context, 'Success'),
                  icon: Icons.check_circle,
                  onpress: (){
                    setState(() {
                      _isloading = false;
                      verifybtn = false;
                      addaccbtn = true;
                    });
                    Navigator.of(context).pop();
                    },
                );

              });*/
        }




      }else{

        setState(() {
          _isloading = false;
        });

        var msz = addinfo["status"];

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: msz,
          title: getTranslated(context, 'Failed'),
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
  }

  Future<void> reverifyaccount(String number, String ifsc, String accno, String bankname, String uniqueid, String imei) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");
    var userid = await storage.read(key: "userId");

    var url = new Uri.http("api.vastwebindia.com", "/Money/api/Money/mmmn2Again", {
      "mb": number,
      "iff": ifsc,
      "cd":"",
      "bno": accno,
      "mal": userid,
      "sk": uniqueid,
      "pi": imei,
      "kk": "RJUPM12131",
      "bankName": bankname,
      "kyc": "",
      "uniqueid":uniqid
    });
    final http.Response response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 30), onTimeout: (){
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
      var result = data["RESULT"];
      var addinfo = data["ADDINFO"];



      if(result == "0"){

        var bename = data["ADDINFO"]["data"]["benename"];
        var local = data["ADDINFO"]["Local"];


          setState(() {
            namecontroller.text = bename;
          });

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: "Account Verify Successfully",
          title: getTranslated(context, 'Success'),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            setState(() {
              _isloading = false;
              verifybtn = false;
              addaccbtn = true;
              verfybtnnn = false;
              reverifybtn = false;
            });
            Navigator.of(context).pop();
          },
        );





      }else{

        var msz = addinfo["status"];

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: msz,
          title: result,
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
  }


  TextEditingController _textController = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController accnocont = TextEditingController();
  TextEditingController reaccnocont = TextEditingController();
  TextEditingController ifsccontroler = TextEditingController();
  ScrollController listSlide = ScrollController();

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
                                              bankhint = Banklist[index]["bank_name"];
                                              ifsccontroler.text = Banklist[index]["branch_ifsc"];
                                              orgifsc = Banklist[index]["branch_ifsc"];
                                              ifsccodr = true;
                                              btnclick = true;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(Banklist[index]["bank_name"],textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(height: 1,color: PrimaryColor,margin: EdgeInsets.only(top: 0,bottom: 0),)
                                ],
                              );
                            } else if (Banklist[index]["bank_name"]
                                .toLowerCase()
                                .contains(_textController.text) || Banklist[index]["bank_name"]
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
                                              bankhint = Banklist[index]["bank_name"];
                                              ifsccontroler.text = Banklist[index]["branch_ifsc"];
                                              orgifsc = Banklist[index]["branch_ifsc"];
                                              ifsccodr = true;
                                              btnclick = true;
                                            });
                                            _textController.clear();
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(Banklist[index]["bank_name"],textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
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
                        ),
                      ),
                    )
                ),
              ),
            );
          });
        });

  }

  String uniqid;

  Future<void> genuniqeid() async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var uri = new Uri.http("api.vastwebindia.com", "/Money/api/data/imps_Generate_Unique_ID");
    final http.Response response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 12), onTimeout: (){

    });

    print(response);

    if (response.statusCode == 200) {

      var data = json.decode(response.body);
      var uqid = data["Message"];

      setState(() {
        uniqid = uqid;
      });

    } else {


      throw Exception('Failed to load data from internet');
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    banklist("1");
    genuniqeid();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: TextColor,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  color: PrimaryColor.withOpacity(0.9),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 10,bottom: 10),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1,color: PrimaryColor),
                          color: PrimaryColor.withOpacity(0.5),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(2),
                            bottomLeft: Radius.circular(2),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_box_sharp,size: 20,color: TextColor,),
                            SizedBox(width: 5,),
                            Text(getTranslated(context, 'Add Beneficiary'),style: TextStyle(color: TextColor,fontWeight: FontWeight.bold,fontSize: 18),),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
                SizedBox(
                  height: 10 ,
                ),
                Container(
                  child: InputTextField(
                    label: getTranslated(context, 'Name'),
                    controller: namecontroller,
                    obscureText: false,
                    iButton: Visibility(
                      visible: verfybtnnn,
                      child: Icon(Icons.check_circle,color: Colors.green,),),
                    labelStyle: TextStyle(
                      color: PrimaryColor,
                    ),
                    borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                    onChange: (String val){

                      setState(() {
                        accnovis = true;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "null";
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  child: InputTextField(

                    label: getTranslated(context, 'Account Number'),
                    checkenable: accnovis,
                    controller: accnocont,
                    keyBordType: TextInputType.number,
                    obscureText: true,
                    labelStyle: TextStyle(
                      color: PrimaryColor,
                    ),
                    borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                    onChange: (String val){

                      if(val.length > 4){

                        setState(() {
                          banklistttt = true;
                        });
                      }else{

                        setState(() {
                          banklistttt = false;
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
                Container(
                  child: InputTextField(

                    label: getTranslated(context, 'Re-Enter Account Number'),
                    checkenable: accnovis,
                    errorText:  _validate ? '' : null,
                    controller: reaccnocont,
                    keyBordType: TextInputType.number,
                    obscureText: false,
                    labelStyle: TextStyle(
                      color: PrimaryColor,
                    ),
                    borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                    onChange: (String val){

                      if(val.length > 4){

                        setState(() {
                          banklistttt = true;
                        });
                      }else{

                        setState(() {
                          banklistttt = false;
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
                SizedBox(height: 10,),
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10),
                  child: OutlineButton(
                    onPressed: banklistttt == false ? null : banklistdialog,
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
                SizedBox(
                  height: 10 ,
                ),
                Container(
                  child: InputTextField(
                    inputFormatter: [ FilteringTextInputFormatter.allow(RegExp("[a-z A-Z 0-9]")),],
                    label: ifschint,
                    controller: ifsccontroler,
                    checkenable: ifsccodr,
                    obscureText: false,
                    labelStyle: TextStyle(
                      color: PrimaryColor,
                    ),
                    borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                    onChange: (String val){
                      ifsccontroler.value = TextEditingValue(
                          text: val.toUpperCase(),
                          selection: ifsccontroler.selection);

                      if(val.length > 4){

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
                Visibility(
                  visible: addaccbtn,
                  child: MainButtonSecodn(
                    onPressed: btnclick == false ? null : (){


                      if(accnocont.text == reaccnocont.text) {
                        setState(() {
                          _isloading = true;
                          _validate = false;
                        });

                        addbeneficiary(namecontroller.text, accnocont.text,
                            ifsccontroler.text, sendnum, remmid);
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
                            ),) : Text(getTranslated(context, 'Save Account'),style: TextStyle(color: TextColor),textAlign: TextAlign.center,)
                        ),
                      ],
                    )
                ),),
                Visibility(
                    visible: verifybtn,
                    child: MainButtonSecodn(
                        onPressed:btnclick == false ? null : ()async{

                            if(accnocont.text == reaccnocont.text) {
                              setState(() {
                                _isloading = true;
                                _validate = false;
                              });

                              var uuid = Uuid();
                              unqid = uuid.v1().substring(0, 16);

                              DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                              AndroidDeviceInfo androidDeviceInfo = await deviceInfo
                                  .androidInfo;

                              androidid = androidDeviceInfo.androidId;
                              bankresponse(bankhint);
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
                                ),) : Text(getTranslated(context, 'Verify Account'),style: TextStyle(color: TextColor),textAlign: TextAlign.center,)
                            ),
                          ],
                        )
                    ),),
                Visibility(
                  visible: reverifybtn,
                  child: MainButtonSecodn(
                      onPressed:btnclick == false ? null : ()async{



                          setState(() {
                            _isloading = true;
                          });

                          var uuid = Uuid();
                          unqid = uuid.v1().substring(0,16);

                          DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                          AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;

                          androidid = androidDeviceInfo.androidId;

                          reverifyaccount(sendnum, ifsccontroler.text, accnocont.text, bankhint, unqid, androidid);



                        },



                      color: SecondaryColor,
                      btnText:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: _isloading ? Center(child: SizedBox(
                                height: 20,
                                child: LinearProgressIndicator(backgroundColor: PrimaryColor,valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
                              ),) : Text(getTranslated(context, 'Re-Verify Account'),style: TextStyle(color: TextColor),textAlign: TextAlign.center,)
                          ),
                        ],
                      )
                  ),),
                SizedBox(height: 10,),
                Container(
                  margin: EdgeInsets.only(right: 15,left: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BackButtons1(
                        btnText: getTranslated(context, 'back'),
                        onPressed: (){
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) => RegisterSenderPage(),
                              transitionDuration: Duration(seconds: 0),
                            ),);
                        },
                      ),
                      Visibility(
                        visible: verifybtn,
                        child: TextButtons(
                          onPressed: ()async{

                            setState(() {
                              verifybtn = false;
                              addaccbtn = true;
                              reverifybtn = false;
                            });

                          },
                          textButtonStyle: TextStyle(color: SecondaryColor,fontSize: 14),
                          buttonText: getTranslated(context, 'Skip Verify'),
                          textButtonText:"" ,
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}
