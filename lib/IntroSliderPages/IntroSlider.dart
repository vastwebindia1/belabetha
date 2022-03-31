import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'AppLogin.dart';
import 'BodyCenterSlider.dart';
import 'Logo.dart';

class IntroSlider extends StatefulWidget {
  @override
  _IntroSliderState createState() => _IntroSliderState();
}

class _IntroSliderState extends State<IntroSlider> {

  DateTime backbuttonpressedTime;

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();

    //Statement 1 Or statement2
    bool backButton = backbuttonpressedTime == null ||
        currentTime.difference(backbuttonpressedTime) > Duration(seconds: 3);

    if (backButton) {
      backbuttonpressedTime = currentTime;
      SnackBar;
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
    SystemNavigator.pop();
  }

  final snackBar = SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Double Click to exit app',style: TextStyle(color: Colors.yellowAccent),),
      ],
    ),
  );
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Material(
        child: SafeArea(
          child: Scaffold(
            backgroundColor: PrimaryColor,
            body: SingleChildScrollView(
              child:Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize:MainAxisSize.max ,
                    children:[
                      Column(
                        children: [
                          SizedBox(height: 20,),
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: CircleAvatar(
                              radius: 0,
                              backgroundColor: TextColor,
                              backgroundImage: AssetImage("assets/aashalogo.png"),
                              /*child: Logo()*/),
                          ),
                          SizedBox(height: 10,),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: BodyCenterSlider(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppLoginButton(),
                        ],
                      )
                    ]
                ),
              )
            )
          ),
        ),
      ),
    );
  }
}

