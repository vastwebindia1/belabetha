import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/dthRechargePage.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:http/http.dart' as http;

import '../../dashboard.dart';
import 'holdAndCreditPage.dart';

class RecentHistory extends StatefulWidget {
  const RecentHistory({Key key}) : super(key: key);

  @override
  _RecentHistoryState createState() => _RecentHistoryState();
}

class _RecentHistoryState extends State<RecentHistory> {

  int selectedIndex = 0;
  static List _widgetOptions = [
    Top10WidgetShow(),
    Top50WidgetShow(),
    Top100WidgetShow(),
  ];
  bool firstTap = true;
  bool secondTap = false;
  bool thirdTap = false;

  void changeLay(int number) {
    if (number == 1) {
      setState(() {
        firstTap = true;
        secondTap = false;
        thirdTap = false;
        selectedIndex = 0;
      });
    } else if (number == 2) {
      setState(() {
        secondTap = true;
        firstTap = false;
        thirdTap=false;
        selectedIndex = 1;
      });
    } else if (number == 3) {
      setState(() {
        thirdTap = true;
        secondTap = false;
        firstTap = false;
        selectedIndex = 2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle tabTextStyle= TextStyle(fontSize: 14,color: TextColor);
    TextStyle tabTextStyle2= TextStyle(fontSize: 14,color: TextColor);
    return AppBarWidget(
      title:Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: TextColor
              ),
              height: 25,
              width: 25,
              child: Icon(Icons.update,color: PrimaryColor,size: 23,),
            ),
            SizedBox(width: 8,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTranslated(context, 'Selected Info'),
                  style: TextStyle (
                      color: TextColor,
                      fontSize: 8,
                      fontWeight: FontWeight.bold
                  ),),
                SizedBox(height: 1,),
                Text(getTranslated(context, 'Recent history'),
                  style: TextStyle(color: TextColor,fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ],
        ),
      ),
      /*CenterAppbarTitle(
        svgImage: 'assets/pngImages/wallet.svg',
        topText: getTranslated(context, 'Selected Info'),
        selectedItemName: "Recent History",
      ),*/
      body: Container(
        color: PrimaryColor,
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: StickyHeader(
              header: Container(
                color: PrimaryColor,
                child: Container(
                  color: TextColor.withOpacity(0.1),
                  padding: EdgeInsets.only(bottom: 15,top: 0),
                  child: Container(
                    height: 40,
                    margin: EdgeInsets.only(left: 10,right: 10,top: 15),
                    padding: EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:firstTap ? SecondaryColor: TextColor,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                              color: thirdTap ? Colors.transparent : secondTap ? Colors.transparent : SecondaryColor,
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
                                    getTranslated(context, 'Top').toUpperCase()+
                                    " 10".toUpperCase(),
                                    style: tabTextStyle2,
                                  ),
                                ],
                              ):Text(
                                getTranslated(context, 'Top').toUpperCase()+
                                " 10".toUpperCase(),
                                style: tabTextStyle,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15,),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:secondTap ? SecondaryColor: TextColor,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                              color:thirdTap ? Colors.transparent : firstTap ? Colors.transparent : SecondaryColor,
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
                                    getTranslated(context, 'Top').toUpperCase()+
                                    " 50".toUpperCase(),
                                    style: tabTextStyle2,
                                  ),
                                ],
                              ): Text(getTranslated(context, 'Top').toUpperCase()+
                                  " 50".toUpperCase(),
                                  style: tabTextStyle
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15,),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:thirdTap ? SecondaryColor: TextColor,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                              color:firstTap ? Colors.transparent : secondTap ? Colors.transparent : SecondaryColor,
                            ),
                            child: FlatButton(
                              shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                changeLay(3);
                              },
                              child: thirdTap ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle,size: 18,color: TextColor,),
                                  SizedBox(width: 2,),
                                  Text(
                                    getTranslated(context, 'Top').toUpperCase()+
                                    " 100".toUpperCase(),
                                    style: tabTextStyle2,
                                  ),
                                ],
                              ):Text(
                                getTranslated(context, 'Top').toUpperCase()+
                                " 100".toUpperCase(),
                                style:tabTextStyle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              content: Container(
                color: TextColor,
                child: Container(
                  padding: EdgeInsets.only(top: 15),
                  child:Center(
                    child:  _widgetOptions.elementAt(selectedIndex),
                  )
                ),
              )
          ),
        ),
      ),
    );
  }
}


/*==================TOP10Show============================*/
class Top10WidgetShow extends StatefulWidget {
  final int countItem;
  const Top10WidgetShow({Key key, this.countItem,}) : super(key: key);

  @override
  _Top10WidgetShowState createState() => _Top10WidgetShowState();
}
class _Top10WidgetShowState extends State<Top10WidgetShow> {

  List recentTenList = [];

  bool tenVisible = false;



  Future<void> recentTen(String amount) async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");
    String token = a;
    var uri = new Uri.http("api.vastwebindia.com", "/Retailer/api/data/_Recent_Transaction", {
      "topentry": amount,
    });
    final http.Response response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print(response);

    if (response.statusCode == 200) {
      var data1 = json.decode(response.body);
      setState(() {
        recentTenList = data1;
      });
    }
    else {
      throw Exception('Failed to load data from internet');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String alfa = "10";
    recentTen(alfa);
  }


   bool tttF = false;

  @override
  Widget build(BuildContext context) {

        setState(() {
          if(recentTenList.length == 0){
            tttF = true;
          }
          else{
            setState(() {
              tttF = false;
            });
          }
        });


    return tttF ? Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Center(
          child: DoteLoader(),),
      ],
    )
          :ListView.builder(
           controller: _controllerList,
           shrinkWrap: true,
           scrollDirection: Axis.vertical,
           itemCount:recentTenList.length == null ? 1 : recentTenList.length,
           itemBuilder: (BuildContext context, int index) {
           return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: .5,
                    color: recentTenList[index]["Dr"] == 0.00 ? Colors.green : Colors.red.withOpacity(0.5)
                  ),
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
                  margin: EdgeInsets.only(left: 0.5,right: 0.5, top: 0.5,bottom: 0.5),
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
                                          child:recentTenList[index]["Operator_type"] == "MicroATM" ?
                                          Image.asset("assets/pngImages/Pos.png",width: 25,height: 25,)
                                            :recentTenList[index]["Operator_type"] == "Housing Society" ?
                                          Image.asset("assets/pngImages/Society.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "Aadharpay" ?
                                          Image.asset("assets/pngImages/Aadhaar-Pay.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "AEPS" ?
                                          Image.asset("assets/pngImages/Aeps.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "LPG Gas" ?
                                          Image.asset("assets/pngImages/gas-tank.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "PrePaid" ?
                                          Image.asset("assets/pngImages/mobile-phone.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "Subscription" ?
                                          Image.asset("assets/pngImages/subscribe.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "DTH" ?
                                          Image.asset("assets/pngImages/DTH.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "Flight" ?
                                          Image.asset("assets/pngImages/Flight.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "PAN" ?
                                          Image.asset("assets/pngImages/penCard.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "Electricity" ?
                                          Image.asset("assets/pngImages/Electricity.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "Fastag" ?
                                          Image.asset("assets/pngImages/toll-road.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "Hotel" ?
                                          Image.asset("assets/pngImages/hotel.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "Money" ?
                                          Image.asset("assets/pngImages/money-transfer.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "DTH" ?
                                          Image.asset("assets/pngImages/DTH.png",width: 25,height: 25,)
                                              :Image.asset("assets/pngImages/UPI.png",width: 25,height: 25,)
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
                                              getTranslated(context, 'Type').toUpperCase(),
                                              softWrap: true,
                                              style: TextStyle(fontSize: 12),
                                              textAlign: TextAlign.left,
                                            ),
                                            SizedBox(height: 1,),
                                            Text(
                                              recentTenList[index]["Operator_type"],
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
                              width: 1,
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
                                    Text(getTranslated(context, 'Amount'),style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,softWrap: true,),
                                    SizedBox(height: 1,),
                                    Text(recentTenList[index]["Amount"].toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 1,
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
                                    Text(recentTenList[index]["Operator_type"] == "Money" ? "Charge" :getTranslated(context, 'Commission'),style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,),
                                    SizedBox(height: 1,),
                                    Text(recentTenList[index]["Comm"].toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
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
                                firstText:getTranslated(context, 'Description'),
                                secondText: recentTenList[index]["Description"],
                              ),
                              Container(
                                height: 0.5,
                                color: PrimaryColor.withOpacity(0.1),
                              ),
                              Container(
                                child: CustomerInfo1(
                                  firstText:getTranslated(context, 'Date'),
                                  secondText: recentTenList[index]["Date"],
                                ),
                              ),


                            ],
                          ),
                        ),
                        Container(
                          height: 3,
                          color: recentTenList[index]["Dr"] == 0.00 ? Colors.green : Colors.red,
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
                                            "\u{20B9}",
                                            softWrap: true,
                                            style: TextStyle(fontSize: 12),
                                            textAlign: TextAlign.left,
                                          ),
                                          SizedBox(height: 1,),
                                          Text(
                                            "\u{20B9} " + recentTenList[index]["UserPre"].toString(),
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
                              width: 1,
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
                                    Text("\u{20B9} " +recentTenList[index]["UserPost"].toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 1,
                              height: 25,
                              child: Container(
                                width: 2,
                                color: Colors.black12,
                              ),
                            ),
                            recentTenList[index]["Cr"] == 0.00 && recentTenList[index]["Dr"] == 0.00 ?
                             Text("") : Expanded(
                                child: Container(
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    recentTenList[index]["Dr"] == 0.00 ? Text(getTranslated(context, 'Credit')+
                                      " \u{20B9}".toUpperCase(), style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,softWrap: true,) : Text(getTranslated(context, 'Debit') + " \u{20B9}".toUpperCase(),style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,softWrap: true,),
                                    SizedBox(height: 1,),
                                    recentTenList[index]["Dr"] ==  0.00 ?Text("\u{20B9} " + recentTenList[index]["Cr"].toString() , style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,) : Text("\u{20B9} " + recentTenList[index]["Dr"].toString() , style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
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
                height: 1,
              )
            ],
          );

        }
    );
  }
}
/*===================TOP50Show=================================*/
class Top50WidgetShow extends StatefulWidget {
  const Top50WidgetShow({Key key}) : super(key: key);

  @override
  _Top50WidgetShowState createState() => _Top50WidgetShowState();
}
ScrollController _controllerList = new ScrollController();
class _Top50WidgetShowState extends State<Top50WidgetShow> {



  List recentTenList = [];



  Future<void> recentFifty(String amount) async {


    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var uri = new Uri.http("api.vastwebindia.com", "/Retailer/api/data/_Recent_Transaction", {
      "topentry": amount,



    });
    final http.Response response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print(response);

    if (response.statusCode == 200) {



      var data1 = json.decode(response.body);

      setState(() {
        recentTenList = data1;

      });


    }


    else {



      throw Exception('Failed to load data from internet');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    String alfa = "50";
    recentFifty(alfa);

  }


bool tttF = false;

  @override
  Widget build(BuildContext context) {
    setState(() {
      if(recentTenList.length == 0){
        tttF=true;
      }
      else{
        tttF = false;
      }
    });
    return tttF ? Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Center(
          child: DoteLoader(),),
      ],
    ):
    ListView.builder(
        controller: _controllerList,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount:recentTenList.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      width: .5,
                      color: recentTenList[index]["Dr"] == 0.00 ? Colors.green : Colors.red.withOpacity(0.5)
                  ),
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
                                          child:recentTenList[index]["Operator_type"] == "MicroATM" ?
                                          Image.asset("assets/pngImages/Pos.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "Housing Society" ?
                                          Image.asset("assets/pngImages/Society.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "Aadharpay" ?
                                          Image.asset("assets/pngImages/Aadhaar-Pay.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "AEPS" ?
                                          Image.asset("assets/pngImages/Aeps.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "LPG Gas" ?
                                          Image.asset("assets/pngImages/gas-tank.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "PrePaid" ?
                                          Image.asset("assets/pngImages/mobile-phone.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "Subscription" ?
                                          Image.asset("assets/pngImages/subscribe.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "DTH" ?
                                          Image.asset("assets/pngImages/DTH.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "Flight" ?
                                          Image.asset("assets/pngImages/Flight.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "PAN" ?
                                          Image.asset("assets/pngImages/penCard.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "Electricity" ?
                                          Image.asset("assets/pngImages/Electricity.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "Fastag" ?
                                          Image.asset("assets/pngImages/toll-road.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "Hotel" ?
                                          Image.asset("assets/pngImages/hotel.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "Money" ?
                                          Image.asset("assets/pngImages/money-transfer.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "DTH" ?
                                          Image.asset("assets/pngImages/DTH.png",width: 25,height: 25,)
                                              :Image.asset("assets/pngImages/UPI.png",width: 25,height: 25,)
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
                                              getTranslated(context, 'Type'),
                                              softWrap: true,
                                              style: TextStyle(fontSize: 12),
                                              textAlign: TextAlign.left,
                                            ),
                                            SizedBox(height: 1,),
                                            Text(
                                              recentTenList[index]["Operator_type"],
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
                              width: 1,
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
                                    getTranslated(context, 'Amount'),style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,softWrap: true,),
                                    SizedBox(height: 1,),
                                    Text(recentTenList[index]["Amount"].toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 1,
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
                                    getTranslated(context, 'Commission'),style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,),
                                    SizedBox(height: 1,),
                                    Text(recentTenList[index]["Comm"].toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
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
                                secondText: recentTenList[index]["Description"],
                              ),
                              Container(
                                height: 1,
                                color: PrimaryColor.withOpacity(0.1),
                              ),
                              CustomerInfo1(
                                firstText: getTranslated(context, 'Date'),
                                secondText: recentTenList[index]["Date"],
                              ),


                            ],
                          ),
                        ),

                        Container(
                          height: 3,
                          color: recentTenList[index]["Dr"] == 0.00 ? Colors.green : Colors.red,
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
                                          Text(
                                            "\u{20B9} " + recentTenList[index]["UserPre"].toString(),
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
                              width: 1,
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
                                      getTranslated(context, 'Post')+
                                      " \u{20B9}",style: TextStyle(fontSize: 12),),
                                    SizedBox(height: 1,),
                                    Text("\u{20B9} " +recentTenList[index]["UserPost"].toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 1,
                              height: 25,
                              child: Container(
                                width: 2,
                                color: Colors.black12,
                              ),
                            ),
                      recentTenList[index]["Cr"] == 0.00 && recentTenList[index]["Dr"] == 0.00 ?
                         Text("") : Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          recentTenList[index]["Dr"] == 0.00 ? Text(
                          getTranslated(context, 'Credit')+
                            " \u{20B9}".toUpperCase(), style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,softWrap: true,) : Text(getTranslated(context, 'Debit')+
                            " \u{20B9}".toUpperCase(),style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,softWrap: true,),
                          /* Text("DR \u{20B9}",style: TextStyle(fontSize: 12),),*/
                          SizedBox(height: 1,),
                          recentTenList[index]["Dr"] ==  0.00 ?Text("\u{20B9} " + recentTenList[index]["Cr"].toString() , style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,) : Text("\u{20B9} " + recentTenList[index]["Dr"].toString() , style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
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
                height: 1,
              )
            ],
          );

        }
    );
  }
}
/*=====================TOP100Show=========================================*/
class Top100WidgetShow extends StatefulWidget {
  const Top100WidgetShow({Key key}) : super(key: key);

  @override
  _Top100WidgetShowState createState() => _Top100WidgetShowState();
}
class _Top100WidgetShowState extends State<Top100WidgetShow> {


  List recentTenList = [];



  Future<void> recentHundred(String amount) async {


    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var uri = new Uri.http("api.vastwebindia.com", "/Retailer/api/data/_Recent_Transaction", {
      "topentry": amount,



    });
    final http.Response response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print(response);

    if (response.statusCode == 200) {



      var data1 = json.decode(response.body);

      setState(() {
        recentTenList = data1;

      });


    }


    else {



      throw Exception('Failed to load data from internet');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    String alfa = "100";
    recentHundred(alfa);

  }

bool tttF = false;

  @override
  Widget build(BuildContext context) {
    setState(() {
      if(recentTenList.length == 0){
        tttF=true;
      }
      else{
        tttF = false;
      }
    });
    return tttF ? Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Center(
          child: DoteLoader(),),
      ],
    ): ListView.builder(
        controller: _controllerList,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount:recentTenList.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      width: .5,
                      color: recentTenList[index]["Dr"] == 0.00 ? Colors.green : Colors.red.withOpacity(0.5)
                  ),
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
                                          child:recentTenList[index]["Operator_type"] == "MicroATM" ?
                                          Image.asset("assets/pngImages/Pos.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "Housing Society" ?
                                          Image.asset("assets/pngImages/Society.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "Aadharpay" ?
                                          Image.asset("assets/pngImages/Aadhaar-Pay.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "AEPS" ?
                                          Image.asset("assets/pngImages/Aeps.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "LPG Gas" ?
                                          Image.asset("assets/pngImages/gas-tank.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "PrePaid" ?
                                          Image.asset("assets/pngImages/mobile-phone.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "Subscription" ?
                                          Image.asset("assets/pngImages/subscribe.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "DTH" ?
                                          Image.asset("assets/pngImages/DTH.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "Flight" ?
                                          Image.asset("assets/pngImages/Flight.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "PAN" ?
                                          Image.asset("assets/pngImages/penCard.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "Electricity" ?
                                          Image.asset("assets/pngImages/Electricity.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "Fastag" ?
                                          Image.asset("assets/pngImages/toll-road.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "Hotel" ?
                                          Image.asset("assets/pngImages/hotel.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "Money" ?
                                          Image.asset("assets/pngImages/money-transfer.png",width: 25,height: 25,)
                                              :recentTenList[index]["Operator_type"] == "DTH" ?
                                          Image.asset("assets/pngImages/DTH.png",width: 25,height: 25,)
                                              :Image.asset("assets/pngImages/UPI.png",width: 25,height: 25,)
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
                                              getTranslated(context, 'Type'),
                                              softWrap: true,
                                              style: TextStyle(fontSize: 12),
                                              textAlign: TextAlign.left,
                                            ),
                                            SizedBox(height: 1,),
                                            Text(
                                              recentTenList[index]["Operator_type"],
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
                              width: 1,
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
                                    getTranslated(context, 'Amount'),style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,softWrap: true,),
                                    SizedBox(height: 1,),
                                    Text(recentTenList[index]["Amount"].toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 1,
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
                                    getTranslated(context, 'Commission'),style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,),
                                    SizedBox(height: 1,),
                                    Text(recentTenList[index]["Comm"].toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
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
                                secondText: recentTenList[index]["Description"],
                              ),
                              Container(
                                height: 1,
                                color: PrimaryColor.withOpacity(0.1),
                              ),
                              CustomerInfo1(
                                firstText: getTranslated(context, 'Date'),
                                secondText: recentTenList[index]["Date"],
                              ),

                            ],
                          ),
                        ),

                        Container(
                          height: 3,
                          color: recentTenList[index]["Dr"] == 0.00 ? Colors.green : Colors.red,
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
                                          Text(
                                            "\u{20B9} " + recentTenList[index]["UserPre"].toString(),
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
                              width: 1,
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
                                      getTranslated(context, 'Post')+
                                      " \u{20B9}",style: TextStyle(fontSize: 12),),
                                    SizedBox(height: 1,),
                                    Text("\u{20B9} " +recentTenList[index]["UserPost"].toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 1,
                              height: 25,
                              child: Container(
                                width: 2,
                                color: Colors.black12,
                              ),
                            ),
                            recentTenList[index]["Cr"] == 0.00 && recentTenList[index]["Dr"] == 0.00 ?
                            Text("") : Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    recentTenList[index]["Dr"] == 0.00 ? Text(
                                    getTranslated(context, 'Credit')+
                                      " \u{20B9}".toUpperCase(), style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,softWrap: true,) : Text(getTranslated(context, 'Debit')+" \u{20B9}".toUpperCase(),style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,softWrap: true,),
                                    /* Text("DR \u{20B9}",style: TextStyle(fontSize: 12),),*/
                                    SizedBox(height: 1,),
                                    recentTenList[index]["Dr"] ==  0.00 ?Text("\u{20B9} " + recentTenList[index]["Cr"].toString() , style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,) : Text("\u{20B9} " + recentTenList[index]["Dr"].toString() , style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
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
                height: 1,
              )
            ],
          );

        }
    );
  }
}
/*==================================================*/



/*TOP 10 TR....List*/
class Top10 extends StatefulWidget {
  final List<String> items;
  final int itemCount;
  final double itemExtend;
  final Widget image,anyWidget ,textWidget;
  final String type, typeCard,amount,amount1;
  const Top10({Key key, @required this.items, this.image, this.type, this.typeCard, this.anyWidget, this.amount, this.itemCount, this.amount1, this.itemExtend, this.textWidget,}) : super(key: key);

  @override
  _Top10State createState() => _Top10State();
}
class _Top10State extends State<Top10> {
  ScrollController _controllerList = new ScrollController();





  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          controller: _controllerList,
          shrinkWrap: true,
          itemExtent:widget.itemExtend ,
          scrollDirection: Axis.vertical,
          itemCount:widget.itemCount,
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
                    margin: EdgeInsets.only(left: 0.5,right: 0.5, top: 0.5,bottom: 0.5),
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
                                            child: widget.image,
                                          )
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Flexible(

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
                                              SizedBox(height: 1,),
                                              widget.textWidget,
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
                                        getTranslated(context, 'AMOUNT')
                                        ,style: TextStyle(fontSize: 12),),
                                      SizedBox(height: 1,),
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
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        getTranslated(context, 'AMOUNT')
                                        ,style: TextStyle(fontSize: 12),),
                                      SizedBox(height: 1,),
                                      Text(widget.amount1,style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
                                    ],
                                  ),
                                ),
                              )
                            ],
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
      ),
    );
  }
}
