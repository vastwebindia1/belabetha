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
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/UPI/upisenderlist.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/dmtPages/registerSender.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class Addnewupid extends StatefulWidget {
  const Addnewupid({Key key}) : super(key: key);

  @override
  _AddnewupidState createState() => _AddnewupidState();
}

class _AddnewupidState extends State<Addnewupid> {

  String bankhint = "Select Your Bank";
  String ifschint = "IFSC Code";
  bool _isloading = false;
  List Banklist = [];
  var sendnum,remmid;
  bool verifybtn = false;
  bool reverifybtn = false;
  bool addaccbtn = true;
  bool ifsccodr = false;
  bool btnclick = false;
  bool banklistttt = false;
  bool accnovis = false;
  bool verfybtnnn = false;
  var unqid,androidid;

  bool _validate = false;


  Future<void> addbeneficiary(String sendnum, String upiid, String name) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/UPI/api/UPI/RegisterBeneficiary", {
      "senderno": sendnum,
      "account": upiid,
      "benname":name,
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
      _isloading = false;
      var data = json.decode(response.body);
      var result = data["RESULT"];
      var msz = data["ADDINFO"];

      if(result == "0"){

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: getTranslated(context, 'UPI ID Add Successfully'),
          title: getTranslated(context, 'Success'),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Upisenderlist()));
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

  TextEditingController _textController = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController vpaidcont = TextEditingController();
  TextEditingController reaccnocont = TextEditingController();
  TextEditingController ifsccontroler = TextEditingController();
  ScrollController listSlide = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
                              Text("ADD VPA ID",style: TextStyle(color: TextColor,fontWeight: FontWeight.bold,fontSize: 18),),
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
                      label: "Enter VPA ID",
                      controller: vpaidcont,
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
                      label: "Enter Name",
                      controller: namecontroller,
                      keyBordType: TextInputType.text,
                      obscureText: false,
                      labelStyle: TextStyle(
                        color: PrimaryColor,
                      ),
                      borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                      onChange: (String val){

                      },

                    ),
                  ),
                  Visibility(
                    visible: addaccbtn,
                    child: MainButtonSecodn(
                        onPressed:() async{

                          if(vpaidcont.text == "" || !vpaidcont.text.contains("@")){

                            final snackBar2 = SnackBar(
                              backgroundColor: Colors.red[900],
                              content: Text("Enter Valid UPI ID",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(snackBar2);

                          }else if(namecontroller.text == ""){

                            final snackBar2 = SnackBar(
                              backgroundColor: Colors.red[900],
                              content: Text("Enter Name",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(snackBar2);

                          }else{

                            final prefs = await SharedPreferences.getInstance();
                            sendnum = prefs.getString("sendnum");

                            addbeneficiary(sendnum, vpaidcont.text, namecontroller.text);

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
                                ),) : Text("Add VPAID",style: TextStyle(color: TextColor),textAlign: TextAlign.center,)
                            ),
                          ],
                        )
                    ),),
                  Visibility(
                    visible: verifybtn,
                    child: MainButtonSecodn(
                        onPressed:btnclick == false ? null : ()async{


                        },
                        color: SecondaryColor,
                        btnText:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: _isloading ? Center(child: SizedBox(
                                  height: 20,
                                  child: LinearProgressIndicator(backgroundColor: PrimaryColor,valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
                                ),) : Text("Verify VPA ID",style: TextStyle(color: TextColor),textAlign: TextAlign.center,)
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
                        BackButtons(
                          btnText: getTranslated(context, 'back'),
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
