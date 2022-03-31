import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart'as http;


class CareAndSupport extends StatefulWidget {
  @override
  _CareAndSupportState createState() => _CareAndSupportState();
}
Future<void> _launched;

Future<void> _openUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
class _CareAndSupportState extends State<CareAndSupport> with SingleTickerProviderStateMixin {

  Animation<Color> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation =
    ColorTween(begin: Colors.indigo, end: Colors.lime).animate(controller)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      });

    careSupport();



  }


  List support = [];

  String sun1 = "";
  String sun2 = "";
  String mon1 = "";
  String mon2 = "";
  String tue1 = "";
  String tue2 = "";
  String wed1 = "";
  String wed2 = "";
  String thu1 = "";
  String thu2 = "";
  String fri1 = "";
  String fri2 = "";
  String sat1 = "";
  String sat2 = "";

  String sundayStatus = "";
  String sundayOpen = "";
  String sundayClose = "";
  String day1 = "";

  String mondayStatus = "";
  String mondayOpen = "";
  String mondayClose = "";
  String day2 = "";

  String tuesdayStatus = "";
  String tuesdayOpen = "";
  String tuesdayClose = "";
  String day3 = "";

  String wednesdayStatus = "";
  String wednesdayOpen = "";
  String wednesdayClose = "";
  String day4 = "";

  String thursdayStatus = "";
  String thursdayOpen = "";
  String thursdayClose = "";
  String day5 = "";

  String fridayStatus = "";
  String fridayOpen = "";
  String fridayClose = "";
  String day6 = "";

  String saturdayStatus = "";
  String saturdayOpen = "";
  String saturdayClose = "";
  String day7 = "";

  String careMobile;
  String careEmail;


  Future<void> careSupport() async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url = new Uri.http("api.vastwebindia.com", "/Common/api/Data/Support_Information");
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
      var dataa = json.decode(response.body);
      var customerTime = dataa["customertime"];
      careEmail = dataa["adminemail"];
      careMobile = dataa["adminmobile"];

      sundayStatus = customerTime[0]["status"];
      day1 = customerTime[0]["nameofday"];
      sundayOpen = customerTime[0]["openingtime"];
      sundayClose = customerTime[0]["clossingtime"];
      mondayStatus = customerTime[1]["status"];
      day2 = customerTime[1]["nameofday"];
      mondayOpen = customerTime[1]["openingtime"];
      mondayClose = customerTime[1]["clossingtime"];

      tuesdayStatus = customerTime[2]["status"];
      day3 = customerTime[2]["nameofday"];
      tuesdayOpen = customerTime[2]["openingtime"];
      tuesdayClose = customerTime[2]["clossingtime"];

      wednesdayStatus = customerTime[3]["status"];
      day4 = customerTime[3]["nameofday"];
      wednesdayOpen = customerTime[3]["openingtime"];
      wednesdayClose = customerTime[3]["clossingtime"];

      thursdayStatus = customerTime[4]["status"];
      day5 = customerTime[4]["nameofday"];
      thursdayOpen = customerTime[4]["openingtime"];
      thursdayClose = customerTime[4]["clossingtime"];

      fridayStatus = customerTime[5]["status"];
      day6 = customerTime[5]["nameofday"];
      fridayOpen = customerTime[5]["openingtime"];
      fridayClose = customerTime[5]["clossingtime"];

      saturdayStatus = customerTime[6]["status"];
      day7 = customerTime[6]["nameofday"];
      saturdayOpen = customerTime[6]["openingtime"];
      saturdayClose = customerTime[6]["clossingtime"];





      DateTime tempDate1 = DateTime.parse(sundayOpen);
      sun1 = DateFormat.jm().format(tempDate1);
      DateTime tempDate2 = DateTime.parse(sundayClose);
      sun2 = DateFormat.jm().format(tempDate2);
      DateTime tempDate3 = DateTime.parse(mondayOpen);
      mon1 = DateFormat.jm().format(tempDate3);
      DateTime tempDate4 = DateTime.parse(mondayClose);
      mon2 = DateFormat.jm().format(tempDate4);
      DateTime tempDate5 = DateTime.parse(tuesdayOpen);
      tue1 = DateFormat.jm().format(tempDate5);
      DateTime tempDate6 = DateTime.parse(tuesdayClose);
      tue2 = DateFormat.jm().format(tempDate6);
      DateTime tempDate7 = DateTime.parse(wednesdayOpen);
      wed1 = DateFormat.jm().format(tempDate7);
      DateTime tempDate8 = DateTime.parse(wednesdayClose);
      wed2 = DateFormat.jm().format(tempDate8);
      DateTime tempDate9 = DateTime.parse(thursdayOpen);
      thu1 = DateFormat.jm().format(tempDate9);
      DateTime tempDate10 = DateTime.parse(thursdayClose);
      thu2 = DateFormat.jm().format(tempDate10);
      DateTime tempDate11 = DateTime.parse(fridayOpen);
      fri1 = DateFormat.jm().format(tempDate11);
      DateTime tempDate12 = DateTime.parse(fridayClose);
      fri2 = DateFormat.jm().format(tempDate12);
      DateTime tempDate13 = DateTime.parse(saturdayOpen);
      sat1 = DateFormat.jm().format(tempDate13);
      DateTime tempDate14 = DateTime.parse(saturdayClose);
      sat2 = DateFormat.jm().format(tempDate14);


      setState(()  {

        /*sundayClose;
       sundayOpen;*/
        sundayStatus;
        day1;
        /* mondayClose;
       mondayOpen;*/
        mondayStatus;
        day2;
        /* tuesdayClose;
       tuesdayOpen;*/
        tuesdayStatus;
        day3;
        /*wednesdayClose;
       wednesdayOpen;*/
        wednesdayStatus;
        day4;
        /*thursdayClose;
       thursdayOpen;*/
        thursdayStatus;
        day5;
        /* fridayClose;
       fridayOpen;*/
        fridayStatus;
        day6;
        /*saturdayClose;
       saturdayOpen;*/
        saturdayStatus;
        day7;

        sun1;
        sun2;
        mon1;
        mon2;
        tue2;
        tue1;
        wed1;
        wed2;
        thu1;
        thu2;
        fri1;
        fri2;
        sat1;
        sat2;
        careEmail;
        careMobile;





      });




    } else {
      throw Exception('Failed to load themes');
    }


  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: SingleChildScrollView(
          child:Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color:PrimaryColor.withOpacity(0.9),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 0,left: 0,bottom: 10,right: 0,),
                      decoration: BoxDecoration(
                      ),
                      child:Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 50,
                            margin: EdgeInsets.only(top: 5),
                            child: IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: Icon(Icons.arrow_back,color: SecondaryColor,),

                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(right: 40),
                              child: Icon(Icons.support_agent,color: SecondaryColor,size: 90,),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 2,left: 15,bottom: 2,right: 15,),
                      margin: const EdgeInsets.only(top: 0,left: 30,bottom: 8,right: 30,),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: PrimaryColor,
                        ),
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(50.0),
                        ),
                      ),
                      child:careMobile == null ? Align(alignment: Alignment.center,child: DoteLoaderWhiteColor()): TextButton(
                        style:ButtonStyle(
                            padding: MaterialStateProperty.all(EdgeInsets.zero)
                        ) ,
                        onPressed:(){
                          setState(() {
                            _launched = _openUrl('tel:${careMobile}');
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: TextColor,
                                ),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(50.0),
                                ),
                              ),
                              child: Icon(Icons.call,color: TextColor,size: 20,),
                            ),
                            SizedBox(width: 7,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(left: 5,right: 5,top: 2,bottom: 2),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: PrimaryColor
                                  ),
                                  child: Text(
                                   getTranslated(context, 'Click To Phone Call'),
                                    textScaleFactor:1,
                                    style: TextStyle(
                                      color: TextColor,
                                      fontSize: 8,
                                    ),
                                  ),
                                ),
                                Text(careMobile,
                                  style: TextStyle(
                                    color: TextColor,fontSize: 22,letterSpacing: 2,
                                    shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(1.0, 1.0),
                                        blurRadius: 4.0,
                                        color: PrimaryColor.withOpacity(0.7),
                                      ),
                                      Shadow(
                                        offset: Offset(1.0, 1.0),
                                        blurRadius: 4.0,
                                        color: PrimaryColor.withOpacity(0.7),
                                      ),
                                    ],
                                  ),),
                              ],
                            ),
                          ],
                        ),
                      ),

                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5,),
                      padding: careEmail == null ? EdgeInsets.only(top: 5,left: 10,bottom: 5,right: 10,):EdgeInsets.only(top: 0,left: 12,bottom: 0,right: 5,),
                      width:careEmail == null ? 100: 340,
                      decoration: BoxDecoration(
                        color: SecondaryColor.withOpacity(0.8),
                        border: Border.all(
                          width: 1,
                          color: SecondaryColor.withOpacity(0.7),
                        ),
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(50.0),
                        ),),
                      child:careEmail == null ? Align(
                        alignment: Alignment.center,
                      child: DoteLoaderWhiteColor()): TextButton(
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(EdgeInsets.zero)
                        ),
                        onPressed: (){
                          setState(() {
                            _launched = _openUrl('mailto:${careEmail}');
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: TextColor,
                                ),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(50.0),
                                ),
                              ),
                              child: Icon(Icons.mail_outline,color: TextColor,size: 20,),
                            ),
                            SizedBox(width: 10,),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(left: 5,right: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color:SecondaryColor
                                    ),
                                    child: Text(
                                      getTranslated(context, 'Click To Send email'),
                                      textScaleFactor:1,
                                      style: TextStyle(
                                        color:  Colors.white,
                                        fontSize: 8,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    constraints: BoxConstraints(
                                        maxWidth: 270 // set a correct maxWidth
                                    ),
                                   clipBehavior: Clip.none,
                                    child: Text(careEmail ,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(color: TextColor,fontSize: 20,
                                        shadows: <Shadow>[
                                          Shadow(
                                            offset: Offset(1.0, 1.0),
                                            blurRadius: 4.0,
                                            color: SecondaryColor.withOpacity(0.7),
                                          ),
                                          Shadow(
                                            offset: Offset(1.0, 1.0),
                                            blurRadius: 4.0,
                                            color: SecondaryColor.withOpacity(0.7),
                                          ),
                                        ],
                                      ),),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),


              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.only(
                  left: 10,right: 10,),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: PrimaryColor.withOpacity(0.08),
                      blurRadius: 0,
                      spreadRadius: 1,
                      offset: Offset(.0, .0), // shadow direction: bottom right
                    )
                  ],
                ),
                child: Container(
                  margin: EdgeInsets.only(
                      left: 0.5,right: 0.5,top: 0.5,bottom: 0.5),
                  child: Container(
                    color: TextColor.withOpacity(0.5),
                    padding: EdgeInsets.only(
                        top: 10, bottom: 5, left: 5, right: 5),
                    child: Column(
                      children: [
                        Container(
                            padding: EdgeInsets.only(top:0,bottom: 10),
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: PrimaryColor.withOpacity(0.1),width: 1,))
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(getTranslated(context, 'Support Timing Information'),style: TextStyle(color: SecondaryColor,fontWeight: FontWeight.bold,fontSize: 18),),
                              ],
                            )
                        ),
                        Container(
                          padding: EdgeInsets.only(top:10,bottom: 10),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: PrimaryColor.withOpacity(0.1),width: 1,))
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              careMobile == null ? Align(alignment: Alignment.centerRight,child: DoteLoader()): Text(day2,style: TextStyle(fontSize: 16),),
                              careMobile == null ? Align(alignment: Alignment.centerRight,child: DoteLoader()): Text(mondayStatus == "N" ? "Office Close": mon1 +" To " +mon2,style: TextStyle(fontSize: 16),textAlign: TextAlign.right,),],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top:10,bottom: 10),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: PrimaryColor.withOpacity(0.1),width: 1,))
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              careMobile == null ? Align(alignment: Alignment.centerRight,child: DoteLoader()): Text(day3,style: TextStyle(fontSize: 16),),
                              careMobile == null ? Align(alignment: Alignment.centerRight,child: DoteLoader()): Text(tuesdayStatus == "N" ? "Office Close": tue1 + " To " + tue2,style: TextStyle(fontSize: 16),textAlign: TextAlign.right,),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top:10,bottom: 10),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: PrimaryColor.withOpacity(0.1),width: 1,))
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              careMobile == null ? Align(alignment: Alignment.centerRight,child: DoteLoader()): Text(day4,style: TextStyle(fontSize: 16),),
                              careMobile == null ? Align(alignment: Alignment.centerRight,child: DoteLoader()): Text(wednesdayStatus == "N" ? "Office Close" :wed1 +" To " + wed2,style: TextStyle(fontSize: 16),textAlign: TextAlign.right,),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top:10,bottom: 10),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: PrimaryColor.withOpacity(0.1),width: 1,))
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              careMobile == null ? Align(alignment: Alignment.centerRight,child: DoteLoader()): Text(day5,style: TextStyle(fontSize: 16),),
                              careMobile == null ? Align(alignment: Alignment.centerRight,child: DoteLoader()): Text(thursdayStatus == "N" ? "Office Close" :thu1 +" To " + thu2,style: TextStyle(fontSize: 16),textAlign: TextAlign.right,),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top:10,bottom: 10),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: PrimaryColor.withOpacity(0.1),width: 1,))
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              careMobile == null ? Align(alignment: Alignment.centerRight,child: DoteLoader()): Text(day6,style: TextStyle(fontSize: 16),),
                              careMobile == null ? Align(alignment: Alignment.centerRight,child: DoteLoader()): Text(fridayStatus == "N" ? "Office Close" :fri1 +" To " + fri2,style: TextStyle(fontSize: 16),textAlign: TextAlign.right,),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top:10,bottom: 10),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: PrimaryColor.withOpacity(0.1),width: 1,))
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              careMobile == null ? Align(alignment: Alignment.centerRight,child: DoteLoader()): Text(day7,style: TextStyle(fontSize: 16),),
                              careMobile == null ? Align(alignment: Alignment.centerRight,child: DoteLoader()): Text(saturdayStatus == "N" ? "Office Close": sat1 +" To " + sat2,style: TextStyle(fontSize: 16),textAlign: TextAlign.right,)
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top:10,bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              careMobile == null ? Align(alignment: Alignment.centerRight,child: DoteLoader()): Text(day1,style: TextStyle(fontSize: 16),),
                              careMobile == null ? Align(alignment: Alignment.centerRight,child: DoteLoader()): Text(sundayStatus == "N" ? "Office Close": sun1 + " To " + sun2,style: TextStyle(fontSize: 16),textAlign: TextAlign.right,)
                            ],
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
      ),
    );

  }
}
