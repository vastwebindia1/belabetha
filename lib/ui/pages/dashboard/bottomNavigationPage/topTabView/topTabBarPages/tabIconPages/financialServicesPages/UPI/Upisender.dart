import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/dthRechargePage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/UPI/upinumberregister.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/UPI/upisenderlist.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../dashboard.dart';
import 'package:http/http.dart' as http;

class UpisenderPage extends StatefulWidget {
  const UpisenderPage({Key key}) : super(key: key);

  @override
  _UpisenderPageState createState() => _UpisenderPageState();
}



class _UpisenderPageState extends State<UpisenderPage> {

  bool onTap = true;
  bool onTap1 = false;
  bool nxtbtn = false;
  List benificiary = [];


  Future<void> checksendernumber(String number) async {


    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");
    final prefs = await SharedPreferences.getInstance();

    var url1 = new Uri.http("api.vastwebindia.com", "/Money/api/Money/GetBeneficiaryList", {
      "sender_number": number,
    });

    final http.Response response = await http.get(
      url1,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 12), onTimeout: (){
      setState(() {
        onTap1 = false;
        onTap = true;
        nxtbtn = true;
      });
    });

    print(response);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var addinfo = data["ADDINFO"];
      var status = addinfo["statuscode"];

      if(status == "TXN"){
        var remmname = addinfo["data"]["remitter"]["name"];
        var consumelimit = addinfo["data"]["remitter"]["consumedlimit"].toString();
        var remainlimit = addinfo["data"]["remitter"]["remaininglimit"].toString();
        var benificiary = addinfo["data"]["beneficiary"];
        var remid = addinfo["data"]["remitter"]["id"];
        prefs.setString('sendnum', number);
        prefs.setString('sendname', remmname);
        prefs.setString('consumelim', consumelimit);
        prefs.setString('remainlim', remainlimit);
        prefs.setString('remidd', remid);
        setState(() {
          sendernum.clear();
          onTap1 = false;
          onTap = true;
        });
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => Upisenderlist(),
            transitionDuration: Duration(seconds: 0),
          ),);


      }else if(status == "RNF"){
        prefs.setString('sendnum', number);
        setState(() {
          sendernum.clear();
          onTap1 = false;
          onTap = true;
        });
        Navigator.push(
          context, MaterialPageRoute(builder: (context) => Upinumberregister()),);

      }





    } else {
      throw Exception('Failed to load themes');
    }


  }

  final TextEditingController sendernum = TextEditingController();

  @override
  Widget build(BuildContext context) {

    TextStyle style = TextStyle(color: TextColor, fontSize: 16);
    TextStyle labelStyle = TextStyle(
      color: PrimaryColor,
      fontSize: 14,
    );
    Color color = PrimaryColor;
    return AppBarWidget1(
      title: CenterAppbarTitleImage(
        svgImage: 'assets/pngImages/UPI.png',
        topText: getTranslated(context, 'Selected Info'),
        selectedItemName:getTranslated(context, 'UPI'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  color: PrimaryColor.withOpacity(0.8),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(getTranslated(context, 'Enter Remitter Registered Number'),
                                  style: style),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        clipBehavior: Clip.none,
                        margin: EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 20),
                        child: Row
                          (
                          children: [
                            Expanded(
                              child: TextFormField(
                                maxLength: 10,
                                controller: sendernum,
                                buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
                                inputFormatters: [ FilteringTextInputFormatter.allow(RegExp("[0-9]")),],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(width: 2, color: color),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(width: 2, color: color),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(width: 2, color: color),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(width: 2, color: color),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  contentPadding: EdgeInsets.only(
                                      left: 10,
                                      right: 16,
                                      top: 14.5,
                                      bottom: 14.5),
                                  hintText: getTranslated(context, 'Enter 10 Digit Mobile Number'),
                                  labelStyle: labelStyle,
                                  fillColor:TextColor,
                                  hintStyle: labelStyle,
                                ),
                                style: TextStyle(
                                  color: PrimaryColor,
                                  fontSize: 18,
                                  letterSpacing: 1.2,
                                ),
                                onChanged: (value){

                                  if(value.length == 10){

                                    FocusScopeNode currentFocus = FocusScope.of(context);
                                    currentFocus.unfocus();

                                    setState(() {
                                      nxtbtn = true;
                                      onTap = false;
                                      onTap1 = true;
                                    });

                                    checksendernumber(sendernum.text);

                                  }else{

                                    setState(() {
                                      nxtbtn = false;
                                      onTap = true;
                                      onTap1 = false;
                                    });
                                  }

                                },
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(
                                  right: 2,
                                  top: 4,
                                  bottom: 4,
                                ),
                                decoration: BoxDecoration(
                                  border:
                                  Border.all(width: 1, color: PrimaryColor),
                                  color: PrimaryColor.withOpacity(0.9),
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
                                  ): Visibility(
                                    visible: onTap,
                                    maintainSize: false,
                                    child: Text(
                                      getTranslated(context, 'Next'),
                                      style: TextStyle(color: TextColor),
                                    ),
                                  ),
                                  onPressed: nxtbtn == false ? null :() {
                                    setState(() {
                                      if (onTap == true) {
                                        onTap1 = true;
                                        checksendernumber(sendernum.text);
                                        onTap1 = false;
                                      }
                                    });
                                  },
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                            height: 1,
                            color: SecondaryColor,
                          )),
                      Text(getTranslated(context, 'Very Important Notice'),
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: SecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.red,
                            ),
                            height: 10,
                            width: 10,
                            margin: EdgeInsets.only(right: 5, top: 5),
                          ),
                          Flexible(
                            child: Text(
                              getTranslated(context, 'first'),
                              style:
                              TextStyle(color: PrimaryColor, fontSize: 15),
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.red,
                            ),
                            height: 10,
                            width: 10,
                            margin: EdgeInsets.only(right: 5, top: 5),
                          ),
                          Flexible(
                            child: Text(
                              getTranslated(context, 'secondNotice'),
                              style:
                              TextStyle(color: PrimaryColor, fontSize: 15),
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.red,
                            ),
                            height: 10,
                            width: 10,
                            margin: EdgeInsets.only(right: 5, top: 5),
                          ),
                          Flexible(
                            child: Text(
                              getTranslated(context, 'thNotice'),
                              style:
                              TextStyle(color: PrimaryColor, fontSize: 15),
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ],
                      ),
                    ],
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
