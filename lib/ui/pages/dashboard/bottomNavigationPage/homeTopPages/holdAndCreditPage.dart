import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;

import '../../dashboard.dart';

class HoldAndCreditPage extends StatefulWidget {
  const HoldAndCreditPage({Key key}) : super(key: key);

  @override
  _HoldAndCreditPageState createState() => _HoldAndCreditPageState();
}

class _HoldAndCreditPageState extends State<HoldAndCreditPage> {

  double posBalance ;
  double mainBalance;
  double creditBalance;
  double holdBalance;
  double adminCreditBalance;
  double dealerBalance;

  Future<void> allBalanceShow() async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var uri =
    new Uri.http("api.vastwebindia.com", "/Retailer/api/data/Show_ALL_balanceremRem", {


    });


    final http.Response response = await http.get(
      uri,
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
      var dataa1 = dataa["data"];
      mainBalance = dataa1[0]["remainbal"];
      posBalance =  dataa1[0]["posremain"];
      creditBalance = dataa1[0]["totalCurrentcr"];
      holdBalance = dataa1[0]["tholdamount"];
      adminCreditBalance = dataa1[0]["admincr"];
      dealerBalance = dataa1[0]["dealer"];


      setState(() {
        posBalance;
        mainBalance;
        creditBalance;
        holdBalance;
        adminCreditBalance;
        dealerBalance;
      });

    } else {
      throw Exception('Failed to load themes');
    }


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allBalanceShow();

  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Container(
              color: TextColor,
              child: StickyHeader(
                  header: Container(
                    color: TextColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          color: PrimaryColor,
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 5),
                            child: Container(
                              child: Stack(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            child: Text(
                                              getTranslated(context, 'My Current Credit'),
                                              style: TextStyle(
                                                  fontSize: 18, color: TextColor),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                              top: 5,
                                            ),
                                            child: creditBalance == null ? DoteLoaderWhiteColor():Text(
                                              "\u{20B9}" + creditBalance.toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 50,
                                                  color: TextColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    child: Container(
                                        width: 80,alignment: Alignment.centerLeft,
                                        child: BackButton(color:SecondaryColor,)
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: PrimaryColor.withOpacity(0.8),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 8, left: 20, right: 20, bottom: 8),
                                  child: Column(
                                    children: [
                                      Text(
                                        getTranslated(context, 'Company Credit'),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: TextColor, fontSize: 12),
                                      ),
                                      adminCreditBalance == null ? DoteLoaderWhiteColor():Text(
                                        "\u{20B9}" + adminCreditBalance.toString(),
                                        style: TextStyle(
                                            color: TextColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 35,
                                width: 1,
                                color: TextColor,
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 8, left: 20, right: 20, bottom: 8),
                                  child: Column(
                                    children: [
                                      Text(
                                        getTranslated(context, 'Distributor Credit'),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 12, color: TextColor),
                                      ),
                                      dealerBalance == null ? DoteLoaderWhiteColor():Text(
                                        "\u{20B9}" +dealerBalance.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: TextColor,
                                            fontSize: 16),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  content: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 35),
                        child: Center(
                          child: Icon(Icons.motion_photos_pause_sharp,size: 80,),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              getTranslated(context, 'Total Hold Amount'),
                              style: TextStyle(fontWeight: FontWeight.normal,fontSize: 16),),
                            holdBalance == null ? DoteLoader():Text(" \u{20B9}" +holdBalance.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child:HoldAndCreditList(),
                      ),
                    ],
                  )
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class HoldAndCreditList extends StatefulWidget {
  const HoldAndCreditList({Key key}) : super(key: key);

  @override
  _HoldAndCreditListState createState() => _HoldAndCreditListState();
}

ScrollController _controllerList = new ScrollController();



class _HoldAndCreditListState extends State<HoldAndCreditList> {

  List holdList = [];

  Future<void> holdreport() async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var uri = new Uri.http("api.vastwebindia.com", "/MICROATM/api/data/Micro_Atm_hold_Rem_Report", {
    });


    final http.Response response = await http.get(
      uri,
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
      var report = dataa["data"];

      setState(() {
        holdList = report;
      });

    } else {
      throw Exception('Failed to load themes');
    }

    setState(() {
      holdreport();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    holdreport();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: _controllerList,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount:holdList.length,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 25,
                                      width: 25,
                                      child: CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          child:Image.asset("assets/pngImages/creditCard.png",width: 25,height: 25,)
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.only(top: 4),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              getTranslated(context, 'Card Type'),
                                              softWrap: true,
                                              style: TextStyle(fontSize: 12),
                                              textAlign: TextAlign.left,
                                            ),
                                            SizedBox(height: 1,),
                                            holdList[index]["card_payment_type"].toString().length <1 ? DoteLoader():Text(
                                               holdList[index]["card_payment_type"],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 2,
                              height: 28,
                              child: Container(
                                width: 2,
                                color: Colors.black12,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Text(
                                    getTranslated(context, 'Amount').toUpperCase(),style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,softWrap: true,),
                                    SizedBox(height: 1,),
                                    holdList[index]["amount"].toString().length <1 ? DoteLoader():Text(holdList[index]["amount"].toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 2,
                              height: 25,
                              child: Container(
                                width: 2,
                                color: Colors.black12,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                    getTranslated(context, 'Commission').toUpperCase(),style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,),
                                    SizedBox(height: 1,),
                                    holdList[index]["Retailer_comm"].toString().length <1 ? DoteLoader():Text(holdList[index]["Retailer_comm"].toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          child:Column(
                            children: [
                              CustomerInfo1(
                                firstText: getTranslated(context, 'Description'),
                                secondText: holdList[index]["response_description"].length <1 ? "......":holdList[index]["response_description"],
                              ),
                              Container(
                                height: 1,
                                color: PrimaryColor.withOpacity(0.1),
                              ),
                              CustomerInfo1(
                                firstText:getTranslated(context, 'Date'),
                                secondText: holdList[index]["transtime"].length <1 ? "......":holdList[index]["transtime"],
                              ),
                              Container(
                                height: 1,
                                color: PrimaryColor.withOpacity(0.1),
                              ),
                              CustomerInfo1(
                                firstText: getTranslated(context, 'Bank RRN'),
                                secondText: holdList[index]["rrn"] .length <1 ? "......":holdList[index]["rrn"],
                              ),
                              Container(
                                height: 1,
                                color: PrimaryColor.withOpacity(0.1),
                              ),

                            ],
                          ),
                        ),

                        Container(
                          height: 1,
                          color: PrimaryColor.withOpacity(0.1),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 4),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            getTranslated(context, 'Pre')+
                                            " \u{20B9}",
                                            softWrap: true,
                                            style: TextStyle(fontSize: 12),
                                            textAlign: TextAlign.left,
                                          ),
                                          SizedBox(height: 1,),
                                          holdList[index]["retailer_remain_pre"].toString().length <1 ? DoteLoader():Text(
                                            "\u{20B9} " + holdList[index]["retailer_remain_pre"].toString(),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 2,
                              height: 28,
                              child: Container(
                                width: 2,
                                color: Colors.black12,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Text(getTranslated(context, 'Post')+
                                      " \u{20B9}",style: TextStyle(fontSize: 12),),
                                    SizedBox(height: 1,),
                                    holdList[index]["retailer_remain_post"].toString().length <1 ? DoteLoader():Text("\u{20B9} " +holdList[index]["retailer_remain_post"].toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 2,
                              height: 25,
                              child: Container(
                                width: 2,
                                color: Colors.black12,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(getTranslated(context, 'Type')
                                      ,style: TextStyle(fontSize: 12),),
                                    SizedBox(height: 1,),
                                    holdList[index]["card_payment_type"].toString().length <1 ? DoteLoader():Text(holdList[index]["card_payment_type"].toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 2,
                              height: 25,
                              child: Container(
                                width: 2,
                                color: Colors.black12,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(getTranslated(context, 'Status')
                                      ,style: TextStyle(fontSize: 12),),
                                    SizedBox(height: 1,),
                                    holdList[index]["status"].toString().length <1 ? DoteLoader():Text(holdList[index]["status"].toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          );

        }
    );
  }
}



class ReportList extends StatefulWidget {
  final List<String> items;
  final Widget image,anyWidget;
  final String type, typeCard,amount;
  const ReportList({Key key, @required this.items, this.image, this.type, this.typeCard, this.anyWidget, this.amount}) : super(key: key);

  @override
  _ReportListState createState() => _ReportListState();
}

class _ReportListState extends State<ReportList> {
  ScrollController _controllerList = new ScrollController();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: _controllerList,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: 10,
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
                margin: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 0),
                child: Container(
                  margin: EdgeInsets.only(left: 0.5, right: 0.5,top: 0.5,bottom: 0.5),
                  child: Container(
                    color: TextColor.withOpacity(0.5),
                    padding: EdgeInsets.only(top: 5, bottom: 0, left: 5, right: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        height: 25,
                                        width: 25,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          child: widget.image,
                                        )
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Flexible(
                                      fit: FlexFit.loose,
                                      child: Container(
                                        margin: EdgeInsets.only(top: 4),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              widget.type,
                                              softWrap: true,
                                              style: TextStyle(fontSize: 12),
                                              overflow: TextOverflow.clip,
                                              maxLines: 10,
                                              textWidthBasis: TextWidthBasis.longestLine,
                                              textScaleFactor: 1,
                                            ),
                                            Text(
                                              widget.typeCard,
                                              softWrap: true,
                                              overflow: TextOverflow.clip,
                                              maxLines: 10,
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                              textWidthBasis: TextWidthBasis.longestLine,
                                              textScaleFactor: 1,
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 2,
                              height: 28,
                              child: Container(
                                width: 2,
                                color: Colors.black12,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Text(getTranslated(context, 'AMOUNT'),style: TextStyle(fontSize: 12),),
                                    Text(widget.amount,style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 2,
                              height: 25,
                              child: Container(
                                width: 2,
                                color: Colors.black12,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Column(
                                  children: [
                                    Text(getTranslated(context, 'AMOUNT'),style: TextStyle(fontSize: 12),),
                                    Text(widget.amount,style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: widget.anyWidget,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          );

        }
    );
  }
}

class CustomerInfo1 extends StatelessWidget {
  final String firstText, secondText;

  const CustomerInfo1({
    Key key,
    this.firstText,
    this.secondText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 3, bottom: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(firstText),
              Expanded(
                  child: Text(secondText,
                      style: TextStyle(fontSize: 14,),
                      textAlign: TextAlign.right))
            ],
          ),
        ),

      ],
    );
  }
}

