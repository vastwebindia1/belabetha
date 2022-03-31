import 'package:flutter/material.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/masterPage/masterRemainToken.dart';
import 'package:myapp/ui/pages/dashboard/masterPage/masterSelTokenList.dart';


class MasterSellToken extends StatefulWidget {
  const MasterSellToken({Key key}) : super(key: key);

  @override
  _MasterSellTokenState createState() => _MasterSellTokenState();
}

class _MasterSellTokenState extends State<MasterSellToken> {
  int selectedIndex = 0;
  static List<StatefulWidget> _widgetOptions = [
    MasterSelTokenList(),
    MasterRemainToken(),
  ];
  bool firstTap = true;
  bool secondTap = false;
  bool onTap = true;
  bool onTap1 = false;

  void changeLay(int number) {
    if (number == 1) {
      setState(() {
        firstTap = true;
        secondTap = false;
        selectedIndex = 0;
      });
    } else if (number == 2) {
      setState(() {
        secondTap = true;
        firstTap = false;
        selectedIndex = 1;
      });
    }
  }

  TextStyle tabTextStyle= TextStyle(fontSize: 14,color: PrimaryColor);
  TextStyle tabTextStyle2= TextStyle(fontSize: 14,color: PrimaryColor);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(
                child: Container(
                  color: TextColor,
                  padding: EdgeInsets.only(bottom: 0,top: 0),
                  child: Container(
                    color:Colors.white.withOpacity(0.5),
                    height: 40,
                    margin: EdgeInsets.only(left: 15,right: 15,top: 5),
                    padding: EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:firstTap ? PrimaryColor: PrimaryColor,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                              color: secondTap ? Colors.transparent : Colors.transparent,
                            ),
                            child: FlatButton(
                              shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                changeLay(1);
                              },
                              child:firstTap ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle,size: 18,color: PrimaryColor,),
                                  SizedBox(width: 2,),
                                  Text(
                                    getTranslated(context, 'Sale Token'),
                                    style: tabTextStyle2,
                                  ),
                                ],
                              ):Text(
                                getTranslated(context, 'Sale Token'),
                                style: tabTextStyle,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5,),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:secondTap ? PrimaryColor: PrimaryColor,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                              color:firstTap ? Colors.transparent: Colors.transparent,
                            ),
                            child: FlatButton(
                              shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                changeLay(2);
                              },
                              child:secondTap ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle,size: 18,color: PrimaryColor,),
                                  SizedBox(width: 2,),
                                  Text(
                                    "Remain Token".toUpperCase(),
                                    style: tabTextStyle2,
                                  ),
                                ],
                              ): Text("Remain Token".toUpperCase(),
                                style: tabTextStyle,
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),

              Container(
                color: TextColor,
                child: Container(
                  padding: EdgeInsets.only(top: 0),
                  child: _widgetOptions.elementAt(selectedIndex),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
