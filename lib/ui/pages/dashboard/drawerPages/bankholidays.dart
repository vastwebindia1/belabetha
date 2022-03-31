import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:http/http.dart'as http;
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';


class BankHolidays extends StatefulWidget {
  @override
  _BankHolidaysState createState() => _BankHolidaysState();
}

class _BankHolidaysState extends State<BankHolidays> {

  String holidayName = "";
  String holidayDate  = "";
  String holidayTime = "";
  String date = "";

  List holidayBank = [];


  Future<void> bankHoliday() async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url = new Uri.http("api.vastwebindia.com", "/Common/api/inform/Holidaysetting");
    final http.Response response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response);

    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);



      holidayTime = dataa[0]["HolidayDate"];

      DateTime tempDate1 = DateTime.parse(holidayTime);


      for(var i = 0; i<dataa.length; i++){
        holidayTime = dataa[i]["HolidayDate"];

        DateTime tempDate1 = DateTime.parse(holidayTime);
        var gg = DateFormat.yMMMMd().format(tempDate1);
        dataa[i]["HolidayDate"] = gg;

        setState(() {

          dataa[i]["HolidayDate"] = gg;

        });


      }




      setState(() {

        holidayBank = dataa;

      });



    } else {
      throw Exception('Failed to load themes');
    }


  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bankHoliday();

  }


  ScrollController listScroll = ScrollController();

  @override

  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: SingleChildScrollView(
          child:Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 15,bottom: 15,),
                decoration: BoxDecoration(
                  color:PrimaryColor.withOpacity(0.9),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
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
                                margin: EdgeInsets.only(top: 0),
                                child: IconButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: Icon(Icons.arrow_back,color: SecondaryColor,),

                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 90),
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: TextColor,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(50.0),
                                    ),
                                    color: TextColor
                                ),
                                child: Icon(Icons.domain_disabled
                                  ,color: SecondaryColor,size: 60,),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text(getTranslated(context, 'Upcoming Bank Holidays'),style: TextStyle(color: TextColor,fontSize: 18,),),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 20,),
              ListView.builder(
                controller: listScroll,
                itemCount: holidayBank.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
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
                                    padding: EdgeInsets.only(top:0,bottom: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.event_busy_sharp,size: 35,color: PrimaryColor,),
                                                  SizedBox(width: 5,),
                                                  Text(holidayBank[index]["HolidayDate"].toString() == null ?"20 November 2021":holidayBank[index]["HolidayDate"].toString(),style: TextStyle(color: PrimaryColor,fontSize: 32,fontWeight: FontWeight.bold),),
                                                ],
                                              ),
                                              SizedBox(height: 5,),
                                              Text(holidayBank[index]["HolidayName"].toString() == null ? "Sunday" : holidayBank[index]["HolidayName"].toString() ,style: TextStyle(color: SecondaryColor,fontSize: 20,fontWeight: FontWeight.bold),),
                                            ],
                                          ),
                                        ),
                                        // Expanded(
                                        //   child: Column(
                                        //     crossAxisAlignment: CrossAxisAlignment.start,
                                        //     children: [
                                        //       // Text("Day",style: TextStyle(color: SecondaryColor,fontSize: 24,fontWeight: FontWeight.bold),),
                                        //       Text("Sunday",style: TextStyle(color: SecondaryColor,fontSize: 30,fontWeight: FontWeight.bold),),
                                        //
                                        //     ],
                                        //   ),
                                        // )
                                      ],
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15,),

                    ],
                  );
                },
              )



            ],
          ),


        ),
      ),
    );

  }
}
