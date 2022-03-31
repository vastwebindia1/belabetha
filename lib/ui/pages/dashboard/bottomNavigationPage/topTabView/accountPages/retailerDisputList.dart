import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/homeTopPages/holdAndCreditPage.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:http/http.dart'as http;

class RetailerDisputList extends StatefulWidget {
  const RetailerDisputList({Key key}) : super(key: key);

  @override
  _RetailerDisputListState createState() => _RetailerDisputListState();
}

class _RetailerDisputListState extends State<RetailerDisputList> {

  List inforeport = [];

  String frmDate = "";
  String toDate = "";

  DateTime selectedDate = DateTime.now();
 DateTime selectedDate2 = DateTime.now();


  Future<void> _selectDate(BuildContext context) async {

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        builder: (context, child) {
          return Theme(
              data: ThemeData.light().copyWith(
                primaryColor:SecondaryColor,
                accentColor: SecondaryColor,
                colorScheme: ColorScheme.light(
                  primary:SecondaryColor,
                  onSurface: Colors.white,
                  surface: Colors.white,

                ),
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                      borderSide:BorderSide(width: 1,color: TextColor)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide:BorderSide(width: 1,color: TextColor)
                  ),
                  hintStyle: TextStyle(
                    color: TextColor,
                  ),
                ),
                textTheme: TextTheme(

                ),
                hintColor:SecondaryColor ,
                buttonTheme: ButtonThemeData(
                  textTheme: ButtonTextTheme.primary,
                ),
                dialogBackgroundColor:PrimaryColor,
              ),
              // This will change to dark theme.
              child:Container(
                    child: Padding(
                         padding: const EdgeInsets.only(top: 50.0),
                               child: Container(
                                         child: child,
                                          ),
                                   ),
                            )
          );
        },
        firstDate: DateTime(1980),
        lastDate: DateTime(2050));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> _selectDate2(BuildContext context) async {

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate2,
        builder: (context, child) {
          return Theme(
              data: ThemeData.light().copyWith(
                primaryColor:SecondaryColor,
                accentColor: SecondaryColor,
                colorScheme: ColorScheme.light(
                  primary:SecondaryColor,
                  onSurface: Colors.white,
                  surface: Colors.white,

                ),
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                      borderSide:BorderSide(width: 1,color: TextColor)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide:BorderSide(width: 1,color: TextColor)
                  ),
                  hintStyle: TextStyle(
                    color: TextColor,
                  ),
                ),
                textTheme: TextTheme(

                ),
                hintColor:SecondaryColor ,
                buttonTheme: ButtonThemeData(
                  textTheme: ButtonTextTheme.primary,
                ),
                dialogBackgroundColor:PrimaryColor,
              ),
              // This will change to dark theme.
              child:Container(
                    child: Padding(
                         padding: const EdgeInsets.only(top: 50.0),
                               child: Container(
                                         child: child,
                                          ),
                                   ),
                            )
          );
        },
        firstDate: DateTime(1980),
        lastDate: DateTime(2050));
    if (picked != null && picked != selectedDate2)
      setState(() {
        selectedDate2 = picked;

      });
  }




  Future<void> retailerDisputeReport( String frmDate, String toDate) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url =
    new Uri.http("api.vastwebindia.com", "/Retailer/api/data/disputelist",{
      "fromdate":frmDate,
      "todate":toDate,

    });
    final http.Response response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
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
      var data = json.decode(response.body);

      setState(() {

        inforeport = data;


      });

    } else {
      throw Exception('Failed to load themes');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    frmDate = "${selectedDate2.toLocal()}".split(' ')[0];
    toDate = "${selectedDate.toLocal()}".split(' ')[0];

    retailerDisputeReport(frmDate,toDate);
  }


  ScrollController _controllerList = new ScrollController();



  @override
  Widget build(BuildContext context) {
    return SimpleAppBarWidget(
      title: Align(
          alignment:  Alignment(-.4, 0),
          child: Text(getTranslated(context, 'Dispute Report'),style: TextStyle(color: TextColor),textAlign: TextAlign.center,)),
      body: SingleChildScrollView(
        child: Container(
          child: Container(
            color: TextColor,
            child: StickyHeader(
              header: Container(
                color: TextColor,
                margin: EdgeInsets.only(bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: PrimaryColor.withOpacity(0.8),
                            padding: EdgeInsets.only(top: 5,bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      border: Border.all(
                                        color: PrimaryColor,
                                      )
                                  ),
                                  margin: EdgeInsets.only(left: 10,right: 2),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 2,left: 10,right: 17,bottom: 2),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Icon(Icons.calendar_today_outlined,size: 25,color: TextColor,),
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            _selectDate2(context);
                                          },
                                          child:Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                getTranslated(context, 'From Date'),
                                                style: TextStyle(
                                                    fontSize: 10, color: TextColor),
                                              ),
                                              Text(
                                                "${selectedDate2.toLocal()}".split(' ')[0],
                                                style: TextStyle(
                                                    fontSize: 14, color: TextColor),

                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 2,right: 3),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      border: Border.all(
                                        color: PrimaryColor,
                                      )
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 2,left: 10,right: 17,bottom: 2),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Icon(Icons.calendar_today_outlined,size: 25,color: TextColor,),
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            _selectDate(context);
                                          },
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                getTranslated(context, 'To Date'),
                                                style: TextStyle(
                                                    fontSize: 10, color: TextColor),
                                              ),
                                              Text(
                                                "${selectedDate.toLocal()}".split(' ')[0],
                                                style: TextStyle(
                                                    fontSize: 14, color: TextColor),

                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  height: 40,
                                  width: 55,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      border: Border.all(
                                        color: PrimaryColor,
                                      ),
                                      color: SecondaryColor
                                  ),
                                  alignment: Alignment.center,
                                  child:IconButton(
                                    icon: Icon(
                                      Icons.search,
                                    ),
                                    iconSize: 25,
                                    color: TextColor,
                                    splashColor: Colors.purple,
                                    onPressed: () {

                                      frmDate = "${selectedDate2.toLocal()}".split(' ')[0];
                                      toDate = "${selectedDate.toLocal()}".split(' ')[0];
                                      retailerDisputeReport(frmDate, toDate);


                                    },
                                  ),

                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  inforeport.length == 0 ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DoteLoader(),
                    ],
                  ): ListView.builder(
                      controller: _controllerList,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount:inforeport.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: PrimaryColor.withOpacity(0.08),
                                    blurRadius: .5,
                                    spreadRadius: 1,
                                    offset:
                                    Offset(.0, .0), // shadow direction: bottom right
                                  )
                                ],
                              ),
                              margin: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 10),
                              child: Container(
                                margin: EdgeInsets.only(left: 0.5,right: 0.5,
                                    top: 0.5,bottom: 0.5),
                                child: Container(
                                  color:Colors.white.withOpacity(0.5),
                                  padding: EdgeInsets.only(top: 5, bottom: 0, left: 5, right: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child:Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text ("Recharge No.",style: TextStyle(fontSize: 10,),),
                                                Text (inforeport[index]["Rechargeno"] == "" ? "..." :inforeport[index]["Rechargeno"],style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,),),
                                              ],),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text ("Response Time",style: TextStyle(fontSize: 10,),),
                                                Text (inforeport[index]["Responsetime"] == null ? "0 0 0" :inforeport[index]["Responsetime"],style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,),),
                                              ],),

                                          ],
                                        ),
                                      ),
                                      Container(padding: EdgeInsets.only(top: 0.5,bottom: 0.5,),margin: EdgeInsets.only(top: 2,bottom: 2,),),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Amount",
                                                    softWrap: true,
                                                    style: TextStyle(fontSize: 10),
                                                  ),
                                                  Text(
                                                    "\u{20B9} " + inforeport[index]["Amount"].toString(),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  border: Border(left: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1)),
                                                      right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1),))
                                              ),
                                              child: Column(
                                                children: [
                                                  Text("Operator",style: TextStyle(fontSize: 10),),
                                                  Text(inforeport[index]["opt"] == null ?"..." :inforeport[index]["opt"],style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text("Status",style: TextStyle(fontSize: 10),),
                                                  Text(inforeport[index]["Status"] ==null ? "..." : inforeport[index]["Status"],style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)
                                                ],
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Response",
                                              softWrap: true,
                                              style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              inforeport[index]["Response"].toString(),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            )
                          ],
                        );

                      }
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
