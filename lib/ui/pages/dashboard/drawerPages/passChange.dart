import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:http/http.dart'as http;
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/login/login.dart';

class PasswordChange extends StatefulWidget {
  const PasswordChange({Key key}) : super(key: key);

  @override
  _PasswordChangeState createState() => _PasswordChangeState();
}

class _PasswordChangeState extends State<PasswordChange> {

  bool _isloading = false;
  bool btnclick = false;
  bool _validate = false;

  TextEditingController oldPass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  TextEditingController confirmPass = TextEditingController();


  Future<void>changePass(String old1,String new1, String confirm1) async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var url = new Uri.http("api.vastwebindia.com", "/api/Account/ChangePassword");
    Map map = {
      "OldPassword":old1,
      "NewPassword":new1,
      "ConfirmPassword":confirm1,
    };

    String body = json.encode(map);

    final http.Response response = await http.post(
      url,
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      },
      body: body,
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

      _isloading = false;

      CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.success,
          text: getTranslated(context, 'Change Password SuccessFully'),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
          }
      );


    } else {
      _isloading = false;

      CoolAlert.show(
        backgroundColor: PrimaryColor.withOpacity(0.6),
        context: context,
        type: CoolAlertType.error,
        text: getTranslated(context, 'Something Went Wrong'),
        confirmBtnText: 'OK',
        confirmBtnColor: Colors.red,
        onConfirmBtnTap: (){
          setState(() {

            _isloading = false;

          });
          Navigator.of(context).pop();
        },
      );

      throw Exception('Failed to load themes');
    }


  }

  bool test = true;



  @override
  Widget build(BuildContext context) {


    return Container(
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: PrimaryColor.withOpacity(0.2),
      ),
      child: Container(
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  InputTextField(
                    controller: oldPass,
                    label: getTranslated(context, 'Old Password'),
                    obscureText: false,
                    labelStyle: TextStyle(
                      color: PrimaryColor,
                    ),
                    borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                    onChange: (String value) {
                    },
                  ),
                  InputTextField(
                    controller: newPass,
                    label: getTranslated(context, 'New Password'),
                    obscureText: false,
                    errorText: _validate  ? "false":null,
                    labelStyle: TextStyle(
                      color: PrimaryColor,
                    ),
                    borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                    onChange: (String value) {
                      setState(() {
                        if(confirmPass.text != newPass.text){
                          setState(() {
                            _validate = true;
                          });
                        }
                        else{
                          setState(() {
                            _validate=false;
                          });

                        }
                      });


                    },
                  ),
                  InputTextField(
                    controller: confirmPass,
                    label: getTranslated(context, 'Confirm Password'),
                    obscureText: false,
                    errorText: _validate ? "false": null,
                    labelStyle: TextStyle(
                      color: PrimaryColor,
                    ),

                    borderSide: BorderSide(width: 2, style: BorderStyle.solid),

                    onChange: (String value) {
                      setState(() {
                        if(confirmPass.text != newPass.text){
                          setState(() {
                            _validate = true;
                            test = false;
                          });
                        }
                        else{
                          setState(() {
                            _validate=false;
                            test = true;
                          });

                        }
                      });


                    },



                  ),
                ],
              ),
            ),
            Row(children: [
              Expanded(
                child: MainButtonSecodn(
                    onPressed:test ? () {

                      String enteramnt = newPass.text;
                      String reenteramntt = confirmPass.text;

                      if(enteramnt == reenteramntt){

                        setState(() {
                          _isloading = true;

                          changePass(oldPass.text, newPass.text, confirmPass.text);
                        });


                      }


                    }:null,
                    color:test ? SecondaryColor : SecondaryColor.withOpacity(0.8),
                    btnText:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: _isloading ? Center(child: SizedBox(
                              height: 20,
                              child: LinearProgressIndicator(backgroundColor: PrimaryColor,valueColor: AlwaysStoppedAnimation<Color>(TextColor),),
                            ),) :
                            Text(getTranslated(context, 'Submit'),textAlign: TextAlign.center,style: TextStyle(color: TextColor),)
                        ),
                      ],
                    )
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
