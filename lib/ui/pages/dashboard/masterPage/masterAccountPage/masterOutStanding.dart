import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../masterMainPage.dart';
import 'package:http/http.dart'as http;

class MasterOutStanding extends StatefulWidget {
  const MasterOutStanding({Key key}) : super(key: key);

  @override
  _MasterOutStandingState createState() => _MasterOutStandingState();
}

class _MasterOutStandingState extends State<MasterOutStanding> {

  List masterInfoReport = [];

  List retailer = [];

  String retailerCredit = "";
  String masterCredit = "";
  String adminCredit = "";
  String creditValue = "";
  bool retailerVisible = true;
  bool listVisible = true;
  bool textVisible = false;



  String retailerName = "Select Retailer Name";
  String retailerId = "";

  List creditList = ["Retailer's Outstanding","My Credit From Master","My Credit From Admin"];

  String frmDate = "";
  String toDate = "";

  DateTime selectedDate = DateTime.now();
 DateTime selectedDate2 = DateTime.now();


  Future<void> masterOutstandingReport() async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url =
    new Uri.http("api.vastwebindia.com", "/api/master/Show_Dealer_outstandingreport");
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
      var dataa = data["Report"];

      setState(() {

        masterInfoReport = dataa;

      });

    } else {
      throw Exception('Failed to load themes');
    }
  }


  TextEditingController _textController = TextEditingController();
  ScrollController _controllerList = new ScrollController();
  ScrollController listSlide = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    masterOutstandingReport();


  }


  String receive = "Retailer's Outstanding";


  @override
  Widget build(BuildContext context) {
    return SimpleAppBarWidget(
      title: Align(
          alignment:  Alignment(-.4, 0),
          child: Text(getTranslated(context, 'OutStanding'),style: TextStyle(color: TextColor),textAlign: TextAlign.center,)),
      body: SingleChildScrollView(
        child: Container(
          child: Container(
            color: TextColor,
            child: StickyHeader(
              header: Container(
                color: PrimaryColor.withOpacity(0.8),
                margin: EdgeInsets.only(bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    SizedBox(height: 15,)

                  ],
                ),
              ),
              content: Column(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      masterInfoReport.length == 0 ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(getTranslated(context, 'No Data') ,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                        ],
                      ): ListView.builder(
                          controller: _controllerList,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount:masterInfoReport.length,
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
                                        offset: Offset(.0, .0), // shadow direction: bottom right
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
                                            margin: EdgeInsets.only(bottom: 5),
                                            padding: EdgeInsets.only(bottom: 5),
                                            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                            child:Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(getTranslated(context, 'FirmName'),style: TextStyle(fontSize: 10,),),
                                                        Text (masterInfoReport[index]["FarmName"] == null ? "....." :masterInfoReport[index]["FarmName"],style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                      ]),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text (getTranslated(context, 'Date'),style: TextStyle(fontSize: 10,),),
                                                        Text (masterInfoReport[index]["date_dlm"] == null ? "0 0 0" :masterInfoReport[index]["date_dlm"],style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,),),
                                                      ]),
                                                ),

                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(getTranslated(context, 'Post Balance') ,style: TextStyle(fontSize: 10),),
                                                      Text("\u{20B9} " + masterInfoReport[index]["dealer_postbal"].toString() == null ? "": "\u{20B9} " + masterInfoReport[index]["dealer_postbal"].toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border(left: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1)),),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text(getTranslated(context, 'Credit'),style: TextStyle(fontSize: 10),),
                                                      Text("\u{20B9} " + masterInfoReport[index]["cr"].toString() == null ? "": "\u{20B9} " + masterInfoReport[index]["cr"].toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border(left: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1)),),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text(getTranslated(context, 'Type') ,style: TextStyle(fontSize: 10),),
                                                      Text(masterInfoReport[index]["bal_type"].toString() == null ? "":  masterInfoReport[index]["bal_type"].toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
                                                    ],
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          )
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


                ],

              ),
            ),
          ),
        ),
      ),
    );
  }
}
