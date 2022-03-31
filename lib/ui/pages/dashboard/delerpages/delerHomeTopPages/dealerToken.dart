import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/DealerMainPage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/BroadbandPage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/dmtPages/moneyTransfer.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:myapp/ui/pages/dashboard/delerpages/DealerDashboard.dart';
import 'package:myapp/ui/pages/dashboard/delerpages/delerHomeTopPages/dealerUsedToken.dart';
import 'package:myapp/ui/pages/dashboard/delerpages/delerHomeTopPages/purchaseToken.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:http/http.dart'as http;
import 'package:encrypt/encrypt.dart' as encrypt;


class DealerToken extends StatefulWidget {
  const DealerToken({Key key}) : super(key: key);

  @override
  _DealerTokenState createState() => _DealerTokenState();
}

class _DealerTokenState extends State<DealerToken> {


  String remainToken= "";

  TextEditingController tokenController = TextEditingController();

  Future<void> dealeruserdetails() async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var url = new Uri.http("api.vastwebindia.com", "/Common/api/inform/Get_User_Information");
    final http.Response response = await http.get(url,
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
      var dataa = json.decode(response.body);
      var data = dataa["data"];
       remainToken = data["creationtoken"].toString();


       setState(() {

         remainToken;

       });

    } else {
      throw Exception('Failed to load themes');
    }

    setState(() {

    });
  }


  Future<void> purchaseToken(String delTok) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url = new Uri.http("api.vastwebindia.com", "/api/Dealer/token_Purchase_Dealer",{
      "tokenCount":delTok,
    });


    http.Response response = await http.post(url,
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token"
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
      var  status = data["success"];


      if (status == "Token Debited Successfully.") {
        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: status,
          title: getTranslated(context, 'Success'),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => DealermaninDashboard()));
          },
        );
      } else {
        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: status,
          title: getTranslated(context, 'Failed'),
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.red,
          onConfirmBtnTap: (){
            setState(() {});
            Navigator.of(context).pop();
          },
        );
      }
    } else {

      throw Exception('Failed');
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dealeruserdetails();
  }


  int selectedIndex = 0;
  static List<StatefulWidget> _widgetOptions = [
    PurchaseTokenDealer(),
    DealerUsedToken(),
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
  
  TextStyle tabTextStyle= TextStyle(fontSize: 14,color: TextColor);
  TextStyle tabTextStyle2= TextStyle(fontSize: 14,color: TextColor);
  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(color: TextColor, fontSize: 16);
    TextStyle labelStyle = TextStyle(
      color: PrimaryColor,
      fontSize: 14,
    );
    Color color = PrimaryColor;
    return SimpleAppBarWidget(
      title: LeftAppBar(
        topText: getTranslated(context, 'Purchase Use Token'),
        selectedItemName: getTranslated(context, 'Now Remain'),
        sellName: remainToken.toString(),
      ),

      body: SingleChildScrollView(
        child: StickyHeader(
        header: Container(
          color: PrimaryColor.withOpacity(0.8),
          child: Column(
            children: [
              Container(
                clipBehavior: Clip.none,
                margin: EdgeInsets.only(
                    left: 10, right: 10, top: 10, bottom: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: tokenController,
                        maxLength: 10,
                        buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
                        inputFormatters: [ FilteringTextInputFormatter.allow(RegExp("[0-9]")),],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 1, color: SecondaryColor),
                            borderRadius: BorderRadius.circular(0),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 1, color: SecondaryColor),
                            borderRadius: BorderRadius.circular(0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 1, color: SecondaryColor),
                            borderRadius: BorderRadius.circular(0),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 1, color: SecondaryColor),
                            borderRadius: BorderRadius.circular(0),
                          ),
                          contentPadding: EdgeInsets.only(
                              left: 10,
                              right: 16,
                              top: 14.5,
                              bottom: 14.5),
                          hintText: getTranslated(context, 'Enter Token'),
                          labelStyle: labelStyle,
                          fillColor:TextColor,
                          hintStyle: labelStyle,
                        ),
                        style: TextStyle(
                          color: PrimaryColor,
                          fontSize: 18,
                        ),
                        onChanged: (value){
                          setState(() {
                            if(value.length > 9){
                              setState(() {
                                if (onTap == true) {
                                  setState(() {

                                  });
                                }
                              });
                            }
                            else if(value.length < 11){
                              setState(() {
                                if (onTap1 == true) {
                                  setState(() {
                                    onTap1 = false;
                                    onTap = true;
                                  });
                                }
                              });
                            }
                          });

                        },
                      ),
                    ),
                    Container(
                      width: 150,
                        margin: EdgeInsets.only(
                          right: 2,
                          top: 1,
                          bottom: 1,
                        ),
                        decoration: BoxDecoration(
                          border:
                          Border.all(width: 1, color: SecondaryColor),
                          color: SecondaryColor,
                        ),
                        child: TextButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide(
                                      width: 0,
                                      color: Colors.transparent)),
                            ),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.zero),
                          ),
                          child: onTap1
                              ? Visibility(
                            visible: onTap1,
                            maintainSize: false,
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                valueColor:
                                AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                                strokeWidth: 2,
                              ),
                            ),
                          )
                              : Visibility(
                            visible: onTap,
                            maintainSize: false,
                            child: Text(
                              getTranslated(context, 'Go To Purchase'),
                              style: TextStyle(color: TextColor),
                            ),
                          ),
                          onPressed: () {
                            setState(() {

                              if (onTap == true) {

                                purchaseToken(tokenController.text);

                              }
                            });
                          },
                        )),
                  ],
                ),
              ),

              Container(
                child: Container(
                  color: TextColor,
                  padding: EdgeInsets.only(bottom: 0,top: 0),
                  child: Container(
                    height: 40,
                    margin: EdgeInsets.only(left: 0,right: 0,top: 0),
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
                              borderRadius: BorderRadius.all(Radius.circular(0)),
                              color: secondTap ? PrimaryColor.withOpacity(0.8) : PrimaryColor.withOpacity(0.9),
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
                                  Icon(Icons.check_circle,size: 18,color: TextColor,),
                                  SizedBox(width: 2,),
                                  Text(
                                    getTranslated(context, 'Purchased Token'),
                                    style: tabTextStyle2,
                                  ),
                                ],
                              ):Text(
                                getTranslated(context, 'Purchased Token'),
                                style: tabTextStyle,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 0,),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:secondTap ? PrimaryColor: PrimaryColor,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(0)),
                              color:firstTap ? PrimaryColor.withOpacity(0.8): PrimaryColor.withOpacity(0.9),
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
                                  Icon(Icons.check_circle,size: 18,color: TextColor,),
                                  SizedBox(width: 2,),
                                  Text(
                                    getTranslated(context, 'Used Token'),
                                    style: tabTextStyle2,
                                  ),
                                ],
                              ): Text(getTranslated(context, 'Used Token'),
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
            ],
          ),
        ),



        content: Container(
          color: TextColor,
          child: Container(
            padding: EdgeInsets.only(top: 0),
            child: _widgetOptions.elementAt(selectedIndex),
          ),
        )
    ),
      ),

    );
  }
}
