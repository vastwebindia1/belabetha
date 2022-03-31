import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/IntroSliderPages/AppSignUpButton.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/login/join.dart';
import 'package:myapp/ui/pages/login/login.dart';
import 'package:http/http.dart' as http;
import 'package:sms_autofill/sms_autofill.dart';


class AppLoginButton extends StatefulWidget {
  const AppLoginButton({Key key}) : super(key: key);

  @override
  _AppLoginButtonState createState() => _AppLoginButtonState();
}

class _AppLoginButtonState extends State<AppLoginButton> {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            // ignore: deprecated_member_use
            child: MainButton(btnText: getTranslated(context, 'Login'),color: SecondaryColor,
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));

            },),
          ),
          Container(
            padding: EdgeInsets.only(left: 20,right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Version 1.0.0",
                  style: TextStyle(color: TextColor),),
                TextButtons(
                  onPressed:  () {
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => JoinPage()));
                  },
                  textButtonText:getTranslated(context, 'notaccount'),
                  buttonText: getTranslated(context, 'Sign Up'),
                  textButtonStyle: TextStyle(
                    color: TextColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          )

        ],
      ),
    );
  }
}
