import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/ui/pages/login/login.dart';
import 'dashboard.dart';


class aadhrpanverify extends StatefulWidget {
  final String aadharcard,pancard;
  const aadhrpanverify({Key key, this.aadharcard, this.pancard}) : super(key: key);

  @override
  _aadhrpanverifyState createState() => _aadhrpanverifyState();
}

class _aadhrpanverifyState extends State<aadhrpanverify> {


  TextEditingController mobileotp1 = TextEditingController();
  TextEditingController mobileotp2 = TextEditingController();
  TextEditingController mobileotp3 = TextEditingController();
  TextEditingController mobileotp4 = TextEditingController();
  TextEditingController mobileotp5 = TextEditingController();
  TextEditingController mobileotp6 = TextEditingController();
  TextEditingController aadharnumer = TextEditingController();


  bool _isloading = false;
  String txnid,clientid;

  Future<void> sendotpaadhar() async {

    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/Retailer/api/data/AadharVerificationOtpSent",{
      "aadhar":aadharnumer.text
    });
    final http.Response response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 15), onTimeout: (){

    });

    print(response);

    if (response.statusCode == 200) {

      setState(() {
        _isloading = false;
      });
      var dataa = json.decode(response.body);
      var dataa1 = dataa["data"];
      var status = dataa["Status"];


      if(status == true){


        setState(() {
          clientid = dataa["clientId"];
          txnid = dataa["txnid"];
          otpvisioff = false;
        });


      }else{

        var msz = dataa["Message"];


        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(msz,style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar2);
      }



    } else {
      throw Exception('Failed to load themes');
    }


  }

  Future<void> verifyotpaadhar(String otp) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/Retailer/api/data/AadharVerificationOtpVerify",{
      "client_id":clientid,
      "otp":otp,
      "txnid":txnid,
      "aadhar":aadharnumer.text
    });
    final http.Response response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 15), onTimeout: (){

    });

    print(response);

    if (response.statusCode == 200) {

      setState(() {
        _isloading=false;
      });
      var dataa = json.decode(response.body);
      var dataa1 = dataa["data"];
      var status = dataa["Status"];

      if(status == true){


        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: "Aadhar Verification Done",
          title: "Success",
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Dashboard()));
          },
        );

      }else{

        var msz = dataa["Message"];

        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(msz.toString(),style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar2);
      }


    } else {
      throw Exception('Failed to load themes');
    }


  }

  var aadhardivide;

  void adddata(){

    if(widget.aadharcard != "null"){

      setState(() {
        aadharnumer.text = widget.aadharcard;
      });

    }


    var buffer = new StringBuffer();
    for (int i = 0; i < widget.aadharcard.length; i++) {
      buffer.write(widget.aadharcard[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != widget.aadharcard.length) {
        buffer.write(' '); // Replace this with anything you want to put after each 4 numbers
      }
    }

    setState(() {
      aadhardivide = buffer.toString();
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    adddata();
  }

  bool otpvisioff = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10,top: 15,bottom: 15),
                  decoration: BoxDecoration(
                    color: PrimaryColor.withOpacity(0.9),
                  ),
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: TextColor,
                            ),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(100),
                            ),
                            color: TextColor
                        ),
                        child: Icon(Icons.report_gmailerrorred_outlined,color: Colors.orange,size: 90,),
                      ),
                      SizedBox(height: 10,),
                      Text("Aadhaar e-Verification Due !",style: TextStyle(color: TextColor,fontSize: 22,fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      Container(
                        child: Text("Note:- Dear Business Partner Your Aadhaar e Verification is due. For business purpose we need instant verification. Click to verify now if you want to stay with us.",
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              color: Colors.orange,
                              fontSize: 12
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),

                Visibility(
                  visible: otpvisioff,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top:10,bottom: 0,),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: widget.aadharcard == "null" || widget.aadharcard == "" ? false: true,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Your Register Aadhaar Number",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),textAlign: TextAlign.left,),
                                  Container(
                                      margin: EdgeInsets.only(top: 5),
                                      padding: EdgeInsets.only(top: 5,bottom: 5,left: 10,right: 10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 1,color: PrimaryColor,
                                          ),
                                          borderRadius:BorderRadius.circular(5)
                                      ),
                                      child: Text(
                                        aadhardivide,
                                        style: TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold
                                        ),)),
                                ],
                              ),
                              replacement: InputTextField(
                                controller: aadharnumer,
                                keyBordType: TextInputType.number,
                                maxLength: 12,
                                labelStyle: TextStyle(color: PrimaryColor),
                                label: "Enter Your Register Aadhaar Number",
                                obscureText: false,
                              ),
                            ),

                          ],
                        ),
                      )
                    ],
                  ),
                  replacement: Container(
                    padding: EdgeInsets.only(bottom: 10,left: 10,right: 10,),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Please Enter 6 Digit (OTP) One Time Password",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),

                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "You have received one time password to your (UIDAI) Aadhaar registered mobile number.",
                            style: TextStyle(
                              fontSize: 10,),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(right: 6, top: 8, bottom: 8),
                              decoration: BoxDecoration(
                                  color: SecondaryColor.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(2),
                                  border: Border.all(
                                    color: SecondaryColor.withOpacity(0.4),
                                  )
                              ),
                              child:Container(
                                height: 40,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(child: TextField(
                                      controller: mobileotp1,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      maxLength: 1,
                                      cursorColor: PrimaryColor,
                                      cursorHeight: 20,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(top: 5,),
                                        hintText: "-",
                                        counterText: '',
                                        hintStyle: TextStyle(color: Colors.black, fontSize: 20.0),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),width: 1.5,),
                                            borderRadius: BorderRadius.circular(2)
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),width: 1,),
                                          borderRadius: BorderRadius.circular(3),

                                        ),

                                      ),
                                      onChanged: (value){
                                        if(value.length == 1){
                                          FocusScope.of(context).nextFocus();
                                        }
                                        else if(value.length == 0){
                                          FocusScope.of(context).previousFocus();
                                        }
                                      },
                                    )),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(child: TextField(
                                      textAlign: TextAlign.center,
                                      controller: mobileotp2,
                                      keyboardType: TextInputType.number,
                                      maxLength: 1,
                                      cursorColor: PrimaryColor,
                                      cursorHeight: 20,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(top: 5,),
                                        hintText: "-",
                                        counterText: '',
                                        hintStyle: TextStyle(color: Colors.black, fontSize: 20.0),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),width: 1.5),
                                            borderRadius: BorderRadius.circular(2)
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),width: 1),
                                          borderRadius: BorderRadius.circular(3),

                                        ),

                                      ),
                                      onChanged: (value){
                                        if(value.length == 1){
                                          FocusScope.of(context).nextFocus();
                                        }
                                        else if(value.length == 0){
                                          FocusScope.of(context).previousFocus();
                                        }
                                      },
                                    )),
                                    SizedBox(width: 8),
                                    Expanded(child: TextField(
                                      textAlign: TextAlign.center,
                                      controller: mobileotp3,
                                      keyboardType: TextInputType.number,
                                      maxLength: 1,
                                      cursorColor: PrimaryColor,
                                      cursorHeight: 20,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(top: 5,),
                                        hintText: "-",
                                        counterText: '',
                                        hintStyle: TextStyle(color: Colors.black, fontSize: 20.0),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),width: 1.5),
                                            borderRadius: BorderRadius.circular(2)
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),width: 1),
                                          borderRadius: BorderRadius.circular(3),

                                        ),

                                      ),
                                      onChanged: (value){
                                        if(value.length == 1){
                                          FocusScope.of(context).nextFocus();
                                        }
                                        else if(value.length == 0){
                                          FocusScope.of(context).previousFocus();
                                        }
                                      },
                                    )),
                                    SizedBox(width: 8),
                                    Expanded(child: TextField(
                                      textAlign: TextAlign.center,
                                      controller: mobileotp4,
                                      keyboardType: TextInputType.number,
                                      maxLength: 1,
                                      cursorColor: PrimaryColor,
                                      cursorHeight: 20,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(top: 5,),
                                        hintText: "-",
                                        counterText: '',
                                        hintStyle: TextStyle(color: Colors.black, fontSize: 20.0),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),width: 1.5),
                                            borderRadius: BorderRadius.circular(2)
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),width: 1),
                                          borderRadius: BorderRadius.circular(3),

                                        ),

                                      ),
                                      onChanged: (value){
                                        if(value.length == 1){
                                          FocusScope.of(context).nextFocus();
                                        }
                                        else if(value.length == 0){
                                          FocusScope.of(context).previousFocus();
                                        }
                                      },
                                    )),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(child: TextField(
                                      controller: mobileotp5,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      maxLength: 1,
                                      cursorColor: PrimaryColor,
                                      cursorHeight: 20,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(top: 5,),
                                        hintText: "-",
                                        counterText: '',
                                        hintStyle: TextStyle(color: Colors.black, fontSize: 20.0),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),width: 1.5),
                                            borderRadius: BorderRadius.circular(2)
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),width: 1),
                                          borderRadius: BorderRadius.circular(3),

                                        ),

                                      ),
                                      onChanged: (value){
                                        if(value.length == 1){
                                          FocusScope.of(context).nextFocus();
                                        }
                                        else if(value.length == 0){
                                          FocusScope.of(context).previousFocus();
                                        }
                                      },
                                    )),
                                    SizedBox(width: 8),
                                    Expanded(child: TextField(
                                      textAlign: TextAlign.center,
                                      controller: mobileotp6,
                                      keyboardType: TextInputType.number,
                                      maxLength: 1,
                                      cursorColor: PrimaryColor,
                                      cursorHeight: 20,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(top: 5,),
                                        hintText: "-",
                                        counterText: '',
                                        hintStyle: TextStyle(color: Colors.black, fontSize: 20.0),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),width: 1.5),
                                            borderRadius: BorderRadius.circular(2)
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: PrimaryColor.withOpacity(0.4),width: 1),
                                          borderRadius: BorderRadius.circular(3),

                                        ),

                                      ),
                                    )),
                                  ],
                                ),
                              )
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "OTP Not Receive ",
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 3,bottom: 3,left: 5,right: 5,),
                                decoration: BoxDecoration(
                                    color: SecondaryColor,
                                    borderRadius: BorderRadius.circular(3)
                                ),
                                child: GestureDetector(
                                    onTap: (){},
                                    child: Text(" Resend",style: TextStyle(color: Colors.white,fontSize: 10,fontWeight: FontWeight.bold),)),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: otpvisioff,
                  child: Column(
                    children: [
                      MainButtonSecodn(
                        color: SecondaryColor,
                        onPressed: () {
                          int aadharnum = aadharnumer.text.length;
                          if(aadharnum < 12){
                            final snackBar2 = SnackBar(
                              backgroundColor: Colors.red[900],
                              content: Text("Enter Valid Aadhar Number.",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar2);

                          }else{

                            setState(() {
                              _isloading = true;
                            });

                            sendotpaadhar();
                          }

                        },
                        btnText:_isloading
                            ? Center(
                          child: SizedBox(
                            height: 20,
                            child: LinearProgressIndicator(
                              backgroundColor: PrimaryColor,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            ),
                          ),
                        )
                            :Text("Verify Now",
                          style: TextStyle(
                            color: TextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20,left: 5),
                        child: GestureDetector(
                          onTap: (){

                            final storage = new FlutterSecureStorage();
                            storage.deleteAll();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            );

                          },
                          child: Row(
                            children: [
                              Icon(Icons.arrow_back,color: Colors.black,),
                              Text("Logout",style: TextStyle(fontSize: 16),)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  replacement: Column(
                    children: [
                      MainButtonSecodn(
                        color: SecondaryColor,
                        onPressed: () {

                          if(mobileotp4.text == ""){

                            final snackBar2 = SnackBar(
                              backgroundColor: Colors.red[900],
                              content: Text("Enter Valid OTP.",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar2);

                          }else{

                            String otpp = mobileotp1.text+mobileotp2.text+mobileotp3.text+mobileotp4.text+mobileotp5.text+mobileotp6.text;
                            setState(() {
                              _isloading = true;
                            });

                            verifyotpaadhar(otpp);
                          }




                        },
                        btnText:  _isloading
                            ? Center(
                          child: SizedBox(
                            height: 20,
                            child: LinearProgressIndicator(
                              backgroundColor: SecondaryColor,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            ),
                          ),
                        )
                            : Text("Submit OTP",
                          style: TextStyle(
                            color: TextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10,left: 5),
                        child:GestureDetector(
                          onTap: (){
                            setState(() {
                              otpvisioff = true;
                              _isloading = false;
                              mobileotp1.clear();
                              mobileotp2.clear();
                              mobileotp3.clear();
                              mobileotp4.clear();
                              mobileotp5.clear();
                              mobileotp6.clear();
                            });
                          },
                          child: Row(
                            children: [
                              Icon(Icons.arrow_back,color: Colors.black,),
                              Text("Back",style: TextStyle(fontSize: 16),)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
