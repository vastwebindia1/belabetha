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


class pancardverf extends StatefulWidget {
  final String aadharcard,pancard;
  const pancardverf({Key key, this.aadharcard, this.pancard}) : super(key: key);

  @override
  _pancardverfState createState() => _pancardverfState();
}

class _pancardverfState extends State<pancardverf> {



  TextEditingController aadharnumer = TextEditingController();

  bool _isloading = false;

  Future<void> verifypancard() async {

    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/Retailer/api/data/PanVerification",{
      "pancard":aadharnumer.text
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

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: "Pan Verification Done",
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
          content: Text(msz,style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar2);
      }



    } else {
      throw Exception('Failed to load themes');
    }


  }

  void adddata(){
    if(widget.pancard != "null"){
      setState(() {
        aadharnumer.text = widget.pancard;
      });
    }

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
                      Text("PanCard Verification Due !",style: TextStyle(color: TextColor,fontSize: 22,fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      Container(
                        child: Text("Note:- Dear User Your PanCard Verification is Not Done. So Firtly Enter Your PanCard Number.",
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
                  height: 30,
                ),
                Column(
                  children: [
                    Visibility(
                      visible: widget.aadharcard == "null" || widget.aadharcard == "" ? false: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Your Register Pancard Number",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),textAlign: TextAlign.left,),
                          Container(
                              margin: EdgeInsets.only(top: 5),
                              padding: EdgeInsets.only(top: 5,bottom: 5,left: 45,right: 45),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,color: PrimaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              child: Text(
                                widget.pancard,
                                style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold
                                ),)),
                        ],
                      ),
                      replacement: InputTextField(
                        checkenable: aadharnumer.text == ""? true:false,
                        controller: aadharnumer,
                        keyBordType: TextInputType.text,
                        label: "Enter Your Pan Number",
                        labelStyle: TextStyle(color: Colors.black),
                        maxLength: 10,
                        obscureText: false,

                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                MainButtonSecodn(
                  color: SecondaryColor,
                  onPressed: () {

                    int aadharnum = aadharnumer.text.length;

                    if(aadharnum < 10){

                      final snackBar2 = SnackBar(
                        backgroundColor: Colors.red[900],
                        content: Text("Enter Valid Pancard Number.",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar2);

                    }else{

                      setState(() {
                        _isloading = true;
                      });

                      verifypancard();

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
                      :Text("Submit",
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
          ),
        ),
      ),
    );
  }
}
