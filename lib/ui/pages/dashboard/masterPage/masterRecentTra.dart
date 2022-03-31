import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart'as http;
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';

import '../dashboard.dart';

class MasterRecentTra extends StatefulWidget {
  const MasterRecentTra({Key key}) : super(key: key);

  @override
  _MasterRecentTraState createState() => _MasterRecentTraState();
}

class _MasterRecentTraState extends State<MasterRecentTra> {


  String topEntry = "";

  List dealerDetails = [];
  List dealerFullDetails = [];

  Future<void> masterRecentHistory( String top ) async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var url = new Uri.http("api.vastwebindia.com", "/api/data/_Recent_Transaction",
        {
          "topentry" : top,

        });
    final http.Response response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response);

    if (response.statusCode == 200) {
      var dataa1 = json.decode(response.body);

      setState(() {

        dealerDetails = dataa1;

      });


    } else {
      throw Exception('Failed to load themes');
    }


  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    topEntry = "0";

    masterRecentHistory(topEntry,);
  }




  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          dealerDetails.length == 0 ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // DoteLoader(),
              // Text("Oops...".toUpperCase(),style: TextStyle(fontSize: 14,),),
              Text(getTranslated(context, 'No Data') .toUpperCase(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            ],
          ):
          ListView.builder(
              itemCount: dealerDetails.length,
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
                      margin: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 0),
                      child: Container(
                        margin: EdgeInsets.only(left: 0.5,right: 0.5,
                            top: 0.5,bottom: 0.5),
                        child: Container(
                          color:Colors.white.withOpacity(0.5),
                          padding: EdgeInsets.only(top: 0, bottom: 0, left: 5, right: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 3,bottom: 3),
                                decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 25,
                                          width: 25,
                                          child: CircleAvatar(
                                              backgroundColor: Colors.transparent,
                                              child:dealerDetails[index]["tbl1"]["Operator_type"] == "MicroATM" ?
                                              Image.asset("assets/pngImages/Pos.png",width: 25,height: 25,)
                                                  :dealerDetails[index]["tbl1"]["Operator_type"] == "Housing Society" ?
                                              Image.asset("assets/pngImages/Society.png",width: 25,height: 25,)
                                                  :dealerDetails[index]["tbl1"]["Operator_type"] == "Aadharpay" ?
                                              Image.asset("assets/pngImages/Aadhaar-Pay.png",width: 25,height: 25,)
                                                  :dealerDetails[index]["tbl1"]["Operator_type"] == "AEPS" ?
                                              Image.asset("assets/pngImages/Aeps.png",width: 25,height: 25,)
                                                  :dealerDetails[index]["tbl1"]["Operator_type"] == "LPG Gas" ?
                                              Image.asset("assets/pngImages/gas-tank.png",width: 25,height: 25,)
                                                  :dealerDetails[index]["tbl1"]["Operator_type"] == "PrePaid" ?
                                              Image.asset("assets/pngImages/mobile-phone.png",width: 25,height: 25,)
                                                  :dealerDetails[index]["tbl1"]["Operator_type"] == "Subscription" ?
                                              Image.asset("assets/pngImages/subscribe.png",width: 25,height: 25,)
                                                  :dealerDetails[index]["tbl1"]["Operator_type"] == "DTH" ?
                                              Image.asset("assets/pngImages/DTH.png",width: 25,height: 25,)
                                                  :dealerDetails[index]["tbl1"]["Operator_type"] == "Flight" ?
                                              Image.asset("assets/pngImages/Flight.png",width: 25,height: 25,)
                                                  :dealerDetails[index]["tbl1"]["Operator_type"] == "PAN" ?
                                              Image.asset("assets/pngImages/penCard.png",width: 25,height: 25,)
                                                  :dealerDetails[index]["tbl1"]["Operator_type"] == "Electricity" ?
                                              Image.asset("assets/pngImages/Electricity.png",width: 25,height: 25,)
                                                  :dealerDetails[index]["tbl1"]["Operator_type"] == "Fastag" ?
                                              Image.asset("assets/pngImages/toll-road.png",width: 25,height: 25,)
                                                  :dealerDetails[index]["tbl1"]["Operator_type"] == "Hotel" ?
                                              Image.asset("assets/pngImages/hotel.png",width: 25,height: 25,)
                                                  :dealerDetails[index]["tbl1"]["Operator_type"] == "Money" ?
                                              Image.asset("assets/pngImages/money-transfer.png",width: 25,height: 25,)
                                                  :dealerDetails[index]["tbl1"]["Operator_type"] == "DTH" ?
                                              Image.asset("assets/pngImages/DTH.png",width: 25,height: 25,)
                                                  :dealerDetails[index]["tbl1"]["Operator_type"] == "PostPaid" ?
                                              Image.asset("assets/pngImages/mobile-phone.png",width: 25,height: 25,)
                                                  :dealerDetails[index]["tbl1"]["Operator_type"] == "Security" ?
                                              Image.asset("assets/pngImages/antivirus.png",width: 25,height: 25,)
                                                  :dealerDetails[index]["tbl1"]["Operator_type"] == "DigitalVoucher" ?
                                              Image.asset("assets/pngImages/voucher.png",width: 25,height: 25,)
                                                  :Image.asset("assets/pngImages/UPI.png",width: 25,height: 25,)
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  getTranslated(context, 'Date') +" : ",
                                                  softWrap: true,
                                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
                                                ),
                                                Text(
                                                  dealerDetails[index]["tbl1"]["Date"],
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: TextStyle(fontSize: 10),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  getTranslated(context, 'Type') +" : ",
                                                  softWrap: true,
                                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
                                                  textAlign: TextAlign.left,
                                                ),
                                                SizedBox(height: 1,),
                                                Text(
                                                  dealerDetails[index]["tbl1"]["Operator_type"],
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: TextStyle(fontSize: 10),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(getTranslated(context, 'Amount'),style: TextStyle(fontSize: 12,),overflow: TextOverflow.ellipsis,softWrap: true,),
                                        Text("\u{20B9}" + dealerDetails[index]["tbl1"]["Amount"].toString(),style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 3,bottom: 3),
                                decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getTranslated(context, 'Description') + ": ",
                                      softWrap: true,
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(height: 1,),
                                    Text(
                                      dealerDetails[index]["tbl1"]["Description"],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(fontSize: 12),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 3,bottom: 3),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              getTranslated(context, 'Pre Bal'),
                                              style: TextStyle(fontSize: 10),
                                            ),
                                            Text(
                                              "\u{20B9}" + dealerDetails[index]["tbl1"]["UserPre"].toString(),
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(border: Border(left: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(getTranslated(context, 'Post Bal'),style: TextStyle(fontSize: 10),),
                                            Text("\u{20B9}" +dealerDetails[index]["tbl1"]["UserPost"].toString(),style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),)
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(border: Border(left: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                        child: Column(
                                          crossAxisAlignment: dealerDetails[index]["tbl1"]["Cr"] == 0.00 && dealerDetails[index]["tbl1"]["Dr"] == 0.00  ?CrossAxisAlignment.end :CrossAxisAlignment.center,
                                          children: [
                                            Text(getTranslated(context, 'Commission'),style: TextStyle(fontSize: 10),),
                                            Text("\u{20B9}" + dealerDetails[index]["tbl1"]["Comm"].toString(),style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),)
                                          ],
                                        ),
                                      ),
                                    ),
                                    dealerDetails[index]["tbl1"]["Cr"] == 0.00 && dealerDetails[index]["tbl1"]["Dr"] == 0.00 ?
                                    Text("") : Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(border: Border(left: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            dealerDetails[index]["tbl1"]["Dr"] == 0.00 ? Text(getTranslated(context, 'Credit'), style: TextStyle(fontSize: 10),) : Text(getTranslated(context, 'Debit'),style: TextStyle(fontSize: 10),),
                                            dealerDetails[index]["tbl1"]["Dr"] ==  0.00 ?Text("\u{20B9}" + dealerDetails[index]["tbl1"]["Cr"].toString() , style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),) : Text("\u{20B9}" + dealerDetails[index]["tbl1"]["Dr"].toString() , style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),)
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
                      ),
                    ),
                  ],
                );

              }),
        ],
      ),
    );
  }
}
