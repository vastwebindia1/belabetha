import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:http/http.dart'as http;

class RetailerOperatorCommision extends StatefulWidget {
  const RetailerOperatorCommision({Key key}) : super(key: key);

  @override
  _RetailerOperatorCommisionState createState() => _RetailerOperatorCommisionState();
}

class _RetailerOperatorCommisionState extends State<RetailerOperatorCommision> {


  List operatorInfoList = [];
  String receive = "Select Operator";
  String fff;
  List operatorList = ["Prepaid","Utility","Money","Pancard","Aeps &Aadhar Services","MPOS","FLIGHT","HOTEL","BUS","MICROATMCASH","VM30PURCHASE"];
  String frmDate = "";
  String toDate = "";
  String retailerId = "ALL";
  bool masterVisible = true;
  bool adminVisible = false;
  String digitalToken = "";
  String digitalCommision = "";
  String physicalToekn = "";
  String physivalCommision = "";
  bool moneyVisible = false;
  bool aepsVisible = false;
  bool panCardVisible = false;

  bool prepaidtrue = true;


  Future<void> retailerOperatorCommision(String operator) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url =
    new Uri.http("api.vastwebindia.com", "/Retailer/api/data/RetailerOpertorByCommission",{
      "ddltype":operator,

    });
    final http.Response response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    print(response);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      if(receive == "Pancard"){

        digitalToken = data[0]["TokenValueDigital"].toString();
        digitalCommision = data[0]["Commission"].toString();
        physicalToekn = data[1]["TokenValuePhysical"].toString();
        physivalCommision = data[1]["Commission"].toString();

        setState(() {

          digitalCommision;
          digitalToken;
          physivalCommision;
          physicalToekn;
        });


      }else {

        setState(() {

          operatorInfoList = data;


        });


      }





    } else {
      throw Exception('Failed to load themes');
    }
  }

  Future<void> retailerOperatorCommisionheader() async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url =
    new Uri.http("api.vastwebindia.com", "/Retailer/api/data/RetailerOpertorByCommission",{
      "ddltype":"Header",

    });
    final http.Response response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    print(response);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        range1 = data[0]["Header1"];
        range2 = data[0]["Header2"];
        range3 = data[0]["Header3"];
      });


    } else {
      throw Exception('Failed to load themes');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retailerOperatorCommisionheader();
    receive = "Prepaid";
    retailerOperatorCommision(receive);
  }

  TextEditingController _textController = TextEditingController();
  ScrollController listSlide = ScrollController();
  void operatorCommisiondialog(){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState){
            return Container(
              color: Colors.black.withOpacity(0.8),
              child: AlertDialog(
                buttonPadding: EdgeInsets.all(0),
                titlePadding: EdgeInsets.all(0),
                contentPadding: EdgeInsets.only(left: 10,right: 10),
                title: Container(
                  color:PrimaryColor.withOpacity(0.8),
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(getTranslated(context, 'Select Category'),
                          style: TextStyle(color: TextColor,fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                content: Container(// Change as per your requirement
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Container(
                      child: ListView.builder(
                        padding: EdgeInsets.all(0),
                        shrinkWrap: true,
                        controller: listSlide,
                        itemCount: operatorList.length,
                        itemBuilder: (context,  index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(left: 10,right: 10),
                                  decoration: BoxDecoration(border: Border(bottom: (BorderSide(width: 1,color: PrimaryColor.withOpacity(0.5))))),
                                  child: TextButton(
                                    style: ButtonStyle(
                                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                                      shadowColor: MaterialStateProperty.all(Colors.transparent),
                                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                      padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        receive = operatorList[index] == null ?"":operatorList[index];

                                        if(receive == "Aeps &Aadhar Services") {

                                          fff = "AEPS";

                                        }else{

                                          if(receive == "Prepaid"){

                                            prepaidtrue = true;
                                            fff = receive;
                                          }else{

                                            prepaidtrue = false;
                                            fff = receive;

                                          }


                                        }

                                        retailerOperatorCommision(fff);});
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(operatorList[index],
                                        style: TextStyle(color: PrimaryColor),),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),),
                  ),
                ),
              ),
            );
          });
        });

  }
  ScrollController listScroll = ScrollController();

  String range1 = "0";
  String range2 = "0";
  String range3 = "300 To Above";


  @override
  Widget build(BuildContext context) {
    return SimpleAppBarWidget(
      title: Align(
          alignment:  Alignment(-.4, 0),
          child: Text(getTranslated(context, 'Operator Commission'),style: TextStyle(color: TextColor),textAlign: TextAlign.center,)),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            color: PrimaryColor.withOpacity(0.8),
            margin: EdgeInsets.only(bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 45,
                  margin: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                  child: OutlineButton(
                    shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(4) ),
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    clipBehavior: Clip.none,
                    autofocus: false,
                    color:Colors.transparent ,
                    highlightColor:Colors.transparent ,
                    highlightedBorderColor: PrimaryColor,
                    focusColor:PrimaryColor ,
                    padding: EdgeInsets.only(top: 0,bottom: 0,left: 10,right: 10),
                    borderSide: BorderSide(width: 1,color: TextColor),
                    onPressed: operatorCommisiondialog,
                    child: Container(
                      child: Row(
                        children: [
                          Expanded(child: Text(receive,style: TextStyle(color: TextColor,fontWeight: FontWeight.normal,fontSize: 16),)),
                          SizedBox(width: 20,child: Icon(Icons.arrow_drop_down,color: TextColor,),)
                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
          SingleChildScrollView(
            child: Container(
              child: Container(
                color: TextColor,
                child: Column(
                  children: [
                    receive == "Money"?
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          color: PrimaryColor.withOpacity(0.8),
                          padding: EdgeInsets.only(left: 15,right: 15,top: 7,bottom: 7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(child: Text(getTranslated(context, 'Up vs To'),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: TextColor),textAlign: TextAlign.start,)),
                              Expanded(child: Text(getTranslated(context, 'Commission') +"\u{20B9}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: TextColor),textAlign: TextAlign.end,)),
                            ],
                          ),
                        ),
                        operatorInfoList.length == 0 ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(getTranslated(context, 'No Data') ,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                          ],
                        ): ListView.builder(
                            controller: listScroll,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount:operatorInfoList.length,
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
                                        padding: EdgeInsets.only(top: 0, bottom: 0, left: 5, right: 5),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(getTranslated(context, 'Verify Commission'),overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(fontSize: 12,),
                                                              ),
                                                              Text("\u{20B9} " + operatorInfoList[index]["VerifyComm"].toString() == null ? "": "\u{20B9} " + operatorInfoList[index]["VerifyComm"].toString(),
                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                          decoration: BoxDecoration(color: TextColor,border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("100 To 1000",overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(fontSize: 12,),
                                                              ),
                                                              Text("\u{20B9} " + operatorInfoList[index]["comm_1000"].toString() == null ? "":  "\u{20B9} " + operatorInfoList[index]["comm_1000"].toString(),
                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("1001 To 2000",overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(fontSize: 12,),
                                                              ),
                                                              Text("\u{20B9} " + operatorInfoList[index]["comm_2000"].toString() == null ? "":  "\u{20B9} " + operatorInfoList[index]["comm_2000"].toString(),
                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                          decoration: BoxDecoration(color: TextColor,border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("2001 To 3000",overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(fontSize: 12,),
                                                              ),
                                                              Text("\u{20B9} " + operatorInfoList[index]["comm_3000"].toString() == null ? "":  "\u{20B9} " + operatorInfoList[index]["comm_3000"].toString(),
                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("3001 To 4000",overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(fontSize: 12,),
                                                              ),
                                                              Text("\u{20B9} " + operatorInfoList[index]["comm_4000"].toString() == null ? "":  "\u{20B9} " + operatorInfoList[index]["comm_4000"].toString(),
                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                          decoration: BoxDecoration(color: TextColor,border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("4001 To 5000",overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(fontSize: 12,),
                                                              ),
                                                              Text("\u{20B9} " + operatorInfoList[index]["comm_5000"].toString() == null ? "":  "\u{20B9} " + operatorInfoList[index]["comm_5000"].toString(),
                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("5001 To 6000",overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(fontSize: 12,),
                                                              ),
                                                              Text("\u{20B9} " + operatorInfoList[index]["comm_6000"].toString() == null ? "":  "\u{20B9} " + operatorInfoList[index]["comm_6000"].toString(),
                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                          decoration: BoxDecoration(color: TextColor,border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("6001 To 7000",overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(fontSize: 12,),
                                                              ),
                                                              Text("\u{20B9} " + operatorInfoList[index]["comm_7000"].toString() == null ? "":  "\u{20B9} " + operatorInfoList[index]["comm_7000"].toString(),
                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("7001 To 8000",overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(fontSize: 12,),
                                                              ),
                                                              Text("\u{20B9} " + operatorInfoList[index]["comm_8000"].toString() == null ? "":  "\u{20B9} " + operatorInfoList[index]["comm_8000"].toString(),
                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                          decoration: BoxDecoration(color: TextColor,border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("8001 To 9000",overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(fontSize: 12,),
                                                              ),
                                                              Text("\u{20B9} " + operatorInfoList[index]["comm_9000"].toString() == null ? "":  "\u{20B9} " + operatorInfoList[index]["comm_9000"].toString(),
                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("9001 To 10000",overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(fontSize: 12,),
                                                              ),
                                                              Text("\u{20B9} " + operatorInfoList[index]["comm_10000"].toString() == null ? "":  "\u{20B9} " + operatorInfoList[index]["comm_10000"].toString(),
                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                          decoration: BoxDecoration(color: TextColor,border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("10001 To 11000",overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(fontSize: 12,),
                                                              ),
                                                              Text("\u{20B9} " + operatorInfoList[index]["comm_11000"].toString() == null ? "":  "\u{20B9} " + operatorInfoList[index]["comm_11000"].toString(),
                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("11001 To 12000",overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(fontSize: 12,),
                                                              ),
                                                              Text("\u{20B9} " + operatorInfoList[index]["comm_12000"].toString() == null ? "":  "\u{20B9} " + operatorInfoList[index]["comm_12000"].toString(),
                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                          decoration: BoxDecoration(color: TextColor,border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("12001 To 13000",overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(fontSize: 12,),
                                                              ),
                                                              Text("\u{20B9} " + operatorInfoList[index]["comm_13000"].toString() == null ? "":  "\u{20B9} " + operatorInfoList[index]["comm_13000"].toString(),
                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("13001 To 14000",overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(fontSize: 12,),
                                                              ),
                                                              Text("\u{20B9} " + operatorInfoList[index]["comm_14000"].toString() == null ? "":  "\u{20B9} " + operatorInfoList[index]["comm_14000"].toString(),
                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                          decoration: BoxDecoration(color: TextColor,border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("14001 To 15000",overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(fontSize: 12,),
                                                              ),
                                                              Text("\u{20B9} " + operatorInfoList[index]["comm_15000"].toString() == null ? "":  "\u{20B9} " + operatorInfoList[index]["comm_15000"].toString(),
                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("15001 To 16000",overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(fontSize: 12,),
                                                              ),
                                                              Text("\u{20B9} " + operatorInfoList[index]["comm_16000"].toString() == null ? "":  "\u{20B9} " + operatorInfoList[index]["comm_16000"].toString(),
                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                          decoration: BoxDecoration(color: TextColor,border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("16001 To 17000",overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(fontSize: 12,),
                                                              ),
                                                              Text("\u{20B9} " + operatorInfoList[index]["comm_17000"].toString() == null ? "":  "\u{20B9} " + operatorInfoList[index]["comm_17000"].toString(),
                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("17001 To 18000",overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(fontSize: 12,),
                                                              ),
                                                              Text("\u{20B9} " + operatorInfoList[index]["comm_18000"].toString() == null ? "":  "\u{20B9} " + operatorInfoList[index]["comm_18000"].toString(),
                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                          decoration: BoxDecoration(color: TextColor,border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("18001 To 19000",overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(fontSize: 12,),
                                                              ),
                                                              Text("\u{20B9} " + operatorInfoList[index]["comm_19000"].toString() == null ? "":  "\u{20B9} " + operatorInfoList[index]["comm_19000"].toString(),
                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("19001 To 20000",overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(fontSize: 12,),
                                                              ),
                                                              Text("\u{20B9} " + operatorInfoList[index]["comm_20000"].toString() == null ? "":  "\u{20B9} " + operatorInfoList[index]["comm_20000"].toString(),
                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                          decoration: BoxDecoration(color: TextColor,border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("20001 To 21000",overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(fontSize: 12,),
                                                              ),
                                                              Text("\u{20B9} " + operatorInfoList[index]["comm_21000"].toString() == null ? "":  "\u{20B9} " + operatorInfoList[index]["comm_21000"].toString(),
                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("21001 To 22000",overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(fontSize: 12,),
                                                              ),
                                                              Text("\u{20B9} " + operatorInfoList[index]["comm_22000"].toString() == null ? "":  "\u{20B9} " + operatorInfoList[index]["comm_22000"].toString(),
                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                          decoration: BoxDecoration(color: TextColor,border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("22001 To 23000",overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(fontSize: 12,),
                                                              ),
                                                              Text("\u{20B9} " + operatorInfoList[index]["comm_23000"].toString() == null ? "":  "\u{20B9} " + operatorInfoList[index]["comm_23000"].toString(),
                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("23001 To 24000",overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(fontSize: 12,),
                                                              ),
                                                              Text("\u{20B9} " + operatorInfoList[index]["comm_24000"].toString() == null ? "":  "\u{20B9} " + operatorInfoList[index]["comm_24000"].toString(),
                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                          decoration: BoxDecoration(color: TextColor,border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text("24001 To 25000",overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(fontSize: 12,),
                                                              ),
                                                              Text("\u{20B9} " + operatorInfoList[index]["comm_25000"].toString() == null ? "":  "\u{20B9} " + operatorInfoList[index]["comm_25000"].toString(),
                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
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
                    ):
                    fff == "AEPS" ?
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        operatorInfoList.length == 0 ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(getTranslated(context, 'No Data') ,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                          ],
                        ): ListView.builder(
                            controller: listScroll,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount:operatorInfoList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
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
                                              padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(getTranslated(context, 'Mini Statement Commercial') +":- ",style: TextStyle(fontSize: 16,),),
                                                  Text(operatorInfoList[index]["ministatement"].toString() == null ? "":  operatorInfoList[index]["ministatement"].toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,),),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
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
                                              padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(getTranslated(context, 'Aadhaar Pay Commercial') +":- ",style: TextStyle(fontSize: 16,),),
                                                  Text(operatorInfoList[index]["aadharpay"].toString() == null ? "": operatorInfoList[index]["aadharpay"].toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,),),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
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
                                                  Container(padding: EdgeInsets.only(bottom: 5),child: Text(getTranslated(context, 'AEPS Commercial') +":- ",style: TextStyle(fontSize: 16,),)),
                                                  Container(
                                                    padding: EdgeInsets.only(top: 2,bottom: 2),
                                                    decoration: BoxDecoration(border: Border(top: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                            width: 100,
                                                            padding: EdgeInsets.only(top: 3,bottom: 3,right: 5),
                                                            decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                            child: Text(getTranslated(context, 'Amount Range'),style: TextStyle(fontSize: 14,),)),
                                                        Container(
                                                          child: Expanded(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Text(getTranslated(context, 'My Sharing'),style: TextStyle(fontSize: 12,),),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                  children: [
                                                                    Expanded(
                                                                        child: Container(
                                                                            alignment: Alignment.center,
                                                                            decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Text("(%)",style: TextStyle(fontSize: 11,),),
                                                                              ],
                                                                            )
                                                                        )),
                                                                    Expanded(
                                                                        child: Container(
                                                                            alignment: Alignment.center,
                                                                            decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Text("(\u{20B9})",style: TextStyle(fontSize: 11,),),
                                                                              ],
                                                                            )
                                                                        )),
                                                                    Expanded(
                                                                        child: Container(
                                                                            alignment: Alignment.center,
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Text(getTranslated(context, 'Max') +" (\u{20B9})",style: TextStyle(fontSize: 11,),),
                                                                              ],
                                                                            )
                                                                        )),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(top: 3,bottom: 3),
                                                    decoration: BoxDecoration(border: Border(top: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                            width: 100,
                                                            decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                            child: Text("500 To 999",style: TextStyle(fontSize: 12,),)),
                                                        Container(
                                                          child: Expanded(
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                    child: Container(
                                                                      alignment: Alignment.center,
                                                                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          operatorInfoList[index]["Type_500_999"] == "%" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):Icon(Icons.check_circle,color: Colors.transparent,size: 12,) ,
                                                                          Text(operatorInfoList[index]["per_500_999"].toString(),
                                                                            style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )),
                                                                Expanded(
                                                                    child: Container(
                                                                      alignment: Alignment.center,
                                                                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          operatorInfoList[index]["Type_500_999"] == "(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                          Text(operatorInfoList[index]["rs_500_999"].toString(),
                                                                            style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )),
                                                                Expanded(
                                                                    child: Container(
                                                                      alignment: Alignment.center,
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          operatorInfoList[index]["Type_500_999"] == "Max(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                          Text(operatorInfoList[index]["maxrs_500_999"].toString(),
                                                                            style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(top: 3,bottom: 3),
                                                    decoration: BoxDecoration(border: Border(top: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                            width: 100,
                                                            decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                            child: Text("1000 To 1499",style: TextStyle(fontSize: 12,),)),
                                                        Container(
                                                          child: Expanded(
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                    child: Container(
                                                                      alignment: Alignment.center,
                                                                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          operatorInfoList[index]["Type_1000_1499"] == "%" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                          Text(operatorInfoList[index]["per_1000_1499"].toString(),
                                                                            style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )),
                                                                Expanded(
                                                                    child: Container(
                                                                      alignment: Alignment.center,
                                                                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          operatorInfoList[index]["Type_1000_1499"] == "(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                          Text(operatorInfoList[index]["rs_1000_1499"].toString(),
                                                                            style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )),
                                                                Expanded(
                                                                    child: Container(
                                                                      alignment: Alignment.center,
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          operatorInfoList[index]["Type_1000_1499"] == "Max(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                          Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                          Text(operatorInfoList[index]["maxrs_1000_1499"].toString(),
                                                                            style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(top: 3,bottom: 3),
                                                    decoration: BoxDecoration(border: Border(top: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                            width: 100,
                                                            decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                            child: Text("1500 To 1999",style: TextStyle(fontSize: 12,),)),
                                                        Container(
                                                          child: Expanded(
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                    child: Container(
                                                                      alignment: Alignment.center,
                                                                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          operatorInfoList[index]["Type_1500_1999"] == "%" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                          Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                          Text(operatorInfoList[index]["per_1500_1999"].toString(),
                                                                            style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )),
                                                                Expanded(
                                                                    child: Container(
                                                                      alignment: Alignment.center,
                                                                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          operatorInfoList[index]["Type_1500_1999"] == "(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                          Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                          Text(operatorInfoList[index]["rs_1500_1999"].toString(),
                                                                            style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )),
                                                                Expanded(
                                                                    child: Container(
                                                                      alignment: Alignment.center,
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          operatorInfoList[index]["Type_1500_1999"] == "Max(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                          Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                          Text(operatorInfoList[index]["maxrs_1500_1999"].toString(),
                                                                            style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(top: 3,bottom: 3),
                                                    decoration: BoxDecoration(border: Border(top: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                            width: 100,
                                                            decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                            child: Text("2000 To 2499",style: TextStyle(fontSize: 12,),)),
                                                        Container(
                                                          child: Expanded(
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                    child: Container(
                                                                      alignment: Alignment.center,
                                                                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          operatorInfoList[index]["Type_2000_2499"] == "%" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                          Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                          Text(operatorInfoList[index]["per_2000_2499"].toString(),
                                                                            style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )),
                                                                Expanded(
                                                                    child: Container(
                                                                      alignment: Alignment.center,
                                                                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          operatorInfoList[index]["Type_2000_2499"] ==  "(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                          Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                          Text(operatorInfoList[index]["rs_2000_2499"].toString(),
                                                                            style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )),
                                                                Expanded(
                                                                    child: Container(
                                                                      alignment: Alignment.center,
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          operatorInfoList[index]["Type_2000_2499"] == "Max(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                          Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                          Text(operatorInfoList[index]["maxrs_2000_2499"].toString(),
                                                                            style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(top: 3,bottom: 3),
                                                    decoration: BoxDecoration(border: Border(top: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                            width: 100,
                                                            decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                            child: Text("2500 To 2999",style: TextStyle(fontSize: 12,),)),
                                                        Container(
                                                          child: Expanded(
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                    child: Container(
                                                                      alignment: Alignment.center,
                                                                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          operatorInfoList[index]["Type_2500_2999"] == "%" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                          Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                          Text(operatorInfoList[index]["per_2500_2999"].toString(),
                                                                            style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )),
                                                                Expanded(
                                                                    child: Container(
                                                                      alignment: Alignment.center,
                                                                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          operatorInfoList[index]["Type_2500_2999"] == "(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                          Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                          Text(operatorInfoList[index]["rs_2500_2999"].toString(),
                                                                            style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )),
                                                                Expanded(
                                                                    child: Container(
                                                                      alignment: Alignment.center,
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          operatorInfoList[index]["Type_2500_2999"] == "Max(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                          Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                          Text(operatorInfoList[index]["maxrs_2500_2999"].toString(),
                                                                            style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(top: 3,bottom: 3),
                                                    decoration: BoxDecoration(border: Border(top: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                            width: 100,
                                                            decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                            child: Text("3000 To 3499",style: TextStyle(fontSize: 12,),)),
                                                        Container(
                                                          child: Expanded(
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                    child: Container(
                                                                      alignment: Alignment.center,
                                                                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          operatorInfoList[index]["Type_3000_3499"] == "%" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                          Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                          Text(operatorInfoList[index]["per_3000_3499"].toString(),
                                                                            style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )),
                                                                Expanded(
                                                                    child: Container(
                                                                      alignment: Alignment.center,
                                                                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          operatorInfoList[index]["Type_3000_3499"] == "(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                          Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                          Text(operatorInfoList[index]["rs_3000_3499"].toString(),
                                                                            style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )),
                                                                Expanded(
                                                                    child: Container(
                                                                      alignment: Alignment.center,
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          operatorInfoList[index]["Type_3000_3499"] == "Max(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                          Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                          Text(operatorInfoList[index]["maxrs_3000_3499"].toString(),
                                                                            style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(top: 3,bottom: 3),
                                                    decoration: BoxDecoration(border: Border(top: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                            width: 100,
                                                            decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                            child: Text("3500 To 5000",style: TextStyle(fontSize: 12,),)),
                                                        Container(
                                                          child: Expanded(
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                    child: Container(
                                                                      alignment: Alignment.center,
                                                                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          operatorInfoList[index]["Type_3500_5000"] == "%" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                          Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                          Text(operatorInfoList[index]["per_3500_5000"].toString(),
                                                                            style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )),
                                                                Expanded(
                                                                    child: Container(
                                                                      alignment: Alignment.center,
                                                                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          operatorInfoList[index]["Type_3500_5000"] == "(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                          Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                          Text(operatorInfoList[index]["rs_3500_5000"].toString(),
                                                                            style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )),
                                                                Expanded(
                                                                    child: Container(
                                                                      alignment: Alignment.center,
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          operatorInfoList[index]["Type_3500_5000"] == "Max(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                          Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                          Text(operatorInfoList[index]["maxrs_3500_5000"].toString(),
                                                                            style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(top: 3,bottom: 3),
                                                    decoration: BoxDecoration(border: Border(top: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                            width: 100,
                                                            decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                            child: Text("5001 To 10000",style: TextStyle(fontSize: 12,),)),
                                                        Container(
                                                          child: Expanded(
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                    child: Container(
                                                                      alignment: Alignment.center,
                                                                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          operatorInfoList[index]["Type_5001_10000"] == "%" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                          Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                          Text(operatorInfoList[index]["per_5001_10000"].toString(),
                                                                            style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )),
                                                                Expanded(
                                                                    child: Container(
                                                                      alignment: Alignment.center,
                                                                      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          operatorInfoList[index]["Type_5001_10000"] == "(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                          Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                          Text(operatorInfoList[index]["rs_5001_10000"].toString(),
                                                                            style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )),
                                                                Expanded(
                                                                    child: Container(
                                                                      alignment: Alignment.center,
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          operatorInfoList[index]["Type_5001_10000"] == "Max(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                          Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                          Text(operatorInfoList[index]["maxrs_5001_10000"].toString(),
                                                                            style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );

                            }
                        ),
                      ],
                    ):
                    receive == "Pancard"?
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(getTranslated(context, 'Token Value Digital')+digitalToken,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),textAlign: TextAlign.start,)),
                            Expanded(child: Text(digitalCommision,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),textAlign: TextAlign.end,)),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(child: Text(getTranslated(context, 'Token Value physical')+physicalToekn,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),textAlign: TextAlign.start,)),
                            Expanded(child: Text(physivalCommision,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),textAlign: TextAlign.end,)),
                          ],
                        )
                      ],
                    ):
                    receive == "MPOS"?
                    Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              color: PrimaryColor.withOpacity(0.8),
                              padding: EdgeInsets.only(left: 15,right: 15,top: 7,bottom: 7),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(child: Text(getTranslated(context, 'Particulars'),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: TextColor),textAlign: TextAlign.start,)),
                                  Expanded(child: Text(getTranslated(context, 'Commission') +"\u{20B9}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: TextColor),textAlign: TextAlign.end,)),
                                ],
                              ),
                            ),
                            operatorInfoList.length == 0 ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(getTranslated(context, 'No Data') ,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                              ],
                            ): ListView.builder(
                                controller: listScroll,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount:operatorInfoList.length,
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
                                            padding: EdgeInsets.only(top: 0, bottom: 0, left: 5, right: 5),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                              decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(getTranslated(context, 'MaxCash Commission'),overflow: TextOverflow.ellipsis,
                                                                    style: TextStyle(fontSize: 12,),
                                                                  ),
                                                                  Text("\u{20B9} " + operatorInfoList[index]["maxcashcomm"].toString() == null ? "": "\u{20B9} " + operatorInfoList[index]["maxcashcomm"].toString(),
                                                                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                              decoration: BoxDecoration(color: TextColor,border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(getTranslated(context, 'CashWithdraw'),overflow: TextOverflow.ellipsis,
                                                                    style: TextStyle(fontSize: 12,),
                                                                  ),
                                                                  Text("\u{20B9} " + operatorInfoList[index]["CashWithdraw"].toString() == null ? "":  "\u{20B9} " + operatorInfoList[index]["CashWithdraw"].toString(),
                                                                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                              decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(getTranslated(context, 'SalesDebitUpto2000'),overflow: TextOverflow.ellipsis,
                                                                    style: TextStyle(fontSize: 12,),
                                                                  ),
                                                                  Text("\u{20B9} " + operatorInfoList[index]["Salesdebitupto2000"].toString() == null ? "":  "\u{20B9} " + operatorInfoList[index]["Salesdebitupto2000"].toString(),
                                                                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                              decoration: BoxDecoration(color: TextColor,border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(getTranslated(context, 'SalesDebitAbove2000'),overflow: TextOverflow.ellipsis,
                                                                    style: TextStyle(fontSize: 12,),
                                                                  ),
                                                                  Text("\u{20B9} " + operatorInfoList[index]["Salesdebitabove2000"].toString() == null ? "":  "\u{20B9} " + operatorInfoList[index]["Salesdebitabove2000"].toString(),
                                                                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                              decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(getTranslated(context, 'SalesCreditNormal'),overflow: TextOverflow.ellipsis,
                                                                    style: TextStyle(fontSize: 12,),
                                                                  ),
                                                                  Text("\u{20B9} " + operatorInfoList[index]["SalescreditNormal"].toString() == null ? "":  "\u{20B9} " + operatorInfoList[index]["SalescreditNormal"].toString(),
                                                                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                              decoration: BoxDecoration(color: TextColor,border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                 Text(getTranslated(context, 'SalesCreditGrocery'),overflow: TextOverflow.ellipsis,
                                                                    style: TextStyle(fontSize: 12,),
                                                                  ),
                                                                  Text("\u{20B9} " + operatorInfoList[index]["Salescreditgrocery"].toString() == null ? "":  "\u{20B9} " + operatorInfoList[index]["Salescreditgrocery"].toString(),
                                                                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                              decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(getTranslated(context, 'SalesCreditEduandInsu'),overflow: TextOverflow.ellipsis,
                                                                    style: TextStyle(fontSize: 12,),
                                                                  ),
                                                                  Text("\u{20B9} " + operatorInfoList[index]["SalescreditEduandInsu"].toString() == null ? "":  "\u{20B9} " + operatorInfoList[index]["SalescreditEduandInsu"].toString(),
                                                                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                                ],
                                                              ),
                                                            ),

                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
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
                        ):
                    receive == "FLIGHT"?
                    Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              color: PrimaryColor.withOpacity(0.8),
                              padding: EdgeInsets.only(left: 15,right: 15,top: 7,bottom: 7),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(child: Text(getTranslated(context, 'Particulars'),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: TextColor),textAlign: TextAlign.start,)),
                                  Expanded(child: Text(getTranslated(context, 'Commission') +"(%)",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: TextColor),textAlign: TextAlign.end,)),
                                ],
                              ),
                            ),
                            operatorInfoList.length == 0 ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(getTranslated(context, 'No Data') ,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                              ],
                            ): ListView.builder(
                                controller: listScroll,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount:operatorInfoList.length,
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
                                            padding: EdgeInsets.only(top: 0, bottom: 0, left: 5, right: 5),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                              decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  operatorInfoList[index]["IsDomestic"] == true ?Text(getTranslated(context, 'Domestic'),overflow: TextOverflow.ellipsis,
                                                                    style: TextStyle(fontSize: 12,),
                                                                  ):Text(getTranslated(context, 'International'),overflow: TextOverflow.ellipsis,
                                                                    style: TextStyle(fontSize: 12,),
                                                                  ),
                                                                  Text("\u{20B9} " + operatorInfoList[index]["marginPercentage"].toString() == null ? "": "\u{20B9} " + operatorInfoList[index]["marginPercentage"].toString(),
                                                                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                                ],
                                                              ),
                                                            ),


                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
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
                        ):
                    receive == "HOTEL"?
                    Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              color: PrimaryColor.withOpacity(0.8),
                              padding: EdgeInsets.only(left: 15,right: 15,top: 7,bottom: 7),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(child: Text(getTranslated(context, 'Particulars'),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: TextColor),textAlign: TextAlign.start,)),
                                  Expanded(child: Text(getTranslated(context, 'Commission') +"(%)",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: TextColor),textAlign: TextAlign.end,)),
                                ],
                              ),
                            ),
                            operatorInfoList.length == 0 ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(getTranslated(context, 'No Data') ,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                              ],
                            ): ListView.builder(
                                controller: listScroll,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount:operatorInfoList.length,
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
                                            padding: EdgeInsets.only(top: 0, bottom: 0, left: 5, right: 5),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                              decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  operatorInfoList[index]["IsDomestic"] == true ?Text(getTranslated(context, 'Domestic'),overflow: TextOverflow.ellipsis,
                                                                    style: TextStyle(fontSize: 12,),
                                                                  ):Text(getTranslated(context, 'International'),overflow: TextOverflow.ellipsis,
                                                                    style: TextStyle(fontSize: 12,),
                                                                  ),
                                                                  Text("\u{20B9} " + operatorInfoList[index]["marginPercentage"].toString() == null ? "": "\u{20B9} " + operatorInfoList[index]["marginPercentage"].toString(),
                                                                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                                ],
                                                              ),
                                                            ),


                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
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
                        ):
                    receive == "MICROATMCASH"?
                    Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            operatorInfoList.length == 0 ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(getTranslated(context, 'No Data') ,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                              ],
                            ): ListView.builder(
                                controller: listScroll,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount:operatorInfoList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
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
                                                      Container(padding: EdgeInsets.only(bottom: 5),child: Text("Micro ATM Commercial :- ",style: TextStyle(fontSize: 16,),)),
                                                      Container(
                                                        padding: EdgeInsets.only(top: 2,bottom: 2),
                                                        decoration: BoxDecoration(border: Border(top: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                                width: 100,
                                                                padding: EdgeInsets.only(top: 3,bottom: 3,right: 5),
                                                                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                child: Text(getTranslated(context, 'Amount Range'),style: TextStyle(fontSize: 14,),)),
                                                            Container(
                                                              child: Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text(getTranslated(context, 'My Sharing'),style: TextStyle(fontSize: 12,),),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                      children: [
                                                                        Expanded(
                                                                            child: Container(
                                                                                alignment: Alignment.center,
                                                                                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Text("(%)",style: TextStyle(fontSize: 11,),),
                                                                                  ],
                                                                                )
                                                                            )),
                                                                        Expanded(
                                                                            child: Container(
                                                                                alignment: Alignment.center,
                                                                                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Text("(\u{20B9})",style: TextStyle(fontSize: 11,),),
                                                                                  ],
                                                                                )
                                                                            )),
                                                                        Expanded(
                                                                            child: Container(
                                                                                alignment: Alignment.center,
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Text(getTranslated(context, 'Max') +" (\u{20B9})",style: TextStyle(fontSize: 11,),textAlign: TextAlign.center,),
                                                                                  ],
                                                                                )
                                                                            )),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.only(top: 3,bottom: 3),
                                                        decoration: BoxDecoration(border: Border(top: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                                width: 100,
                                                                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                child: Text(" Cash 0 To 1000",style: TextStyle(fontSize: 12,),)),
                                                            Container(
                                                              child: Expanded(
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                        child: Container(
                                                                          alignment: Alignment.center,
                                                                          decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              operatorInfoList[index]["cash_0_1000_Type"] == "%" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):Icon(Icons.check_circle,color: Colors.transparent,size: 12,) ,
                                                                              Text(operatorInfoList[index]["cash_0_1000_per"].toString(),
                                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    Expanded(
                                                                        child: Container(
                                                                          alignment: Alignment.center,
                                                                          decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              operatorInfoList[index]["cash_0_1000_Type"] == "(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                              Text(operatorInfoList[index]["cash_0_1000_rs"].toString(),
                                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    Expanded(
                                                                        child: Container(
                                                                          alignment: Alignment.center,
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              operatorInfoList[index]["cash_0_1000_Type"] == "Max(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                              Text(operatorInfoList[index]["cash_0_1000_maxrs"].toString(),
                                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.only(top: 3,bottom: 3),
                                                        decoration: BoxDecoration(border: Border(top: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                                width: 100,
                                                                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                child: Text("Cash 1001 To 2000",style: TextStyle(fontSize: 12,),)),
                                                            Container(
                                                              child: Expanded(
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                        child: Container(
                                                                          alignment: Alignment.center,
                                                                          decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              operatorInfoList[index]["cash_1001_2000_Type"] == "%" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                              Text(operatorInfoList[index]["cash_1001_2000_per"].toString(),
                                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    Expanded(
                                                                        child: Container(
                                                                          alignment: Alignment.center,
                                                                          decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              operatorInfoList[index]["cash_1001_2000_Type"] == "(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                              Text(operatorInfoList[index]["cash_1001_2000_rs"].toString(),
                                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    Expanded(
                                                                        child: Container(
                                                                          alignment: Alignment.center,
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              operatorInfoList[index]["cash_1001_2000_Type"] == "Max(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                              Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                              Text(operatorInfoList[index]["cash_1001_2000_maxrs"].toString(),
                                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.only(top: 3,bottom: 3),
                                                        decoration: BoxDecoration(border: Border(top: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                                width: 100,
                                                                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                child: Text("500 To 999 ",style: TextStyle(fontSize: 12,),)),
                                                            Container(
                                                              child: Expanded(
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                        child: Container(
                                                                          alignment: Alignment.center,
                                                                          decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              operatorInfoList[index]["Type_500_999"] == "%" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                              Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                              Text(operatorInfoList[index]["per_500_999"].toString(),
                                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    Expanded(
                                                                        child: Container(
                                                                          alignment: Alignment.center,
                                                                          decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              operatorInfoList[index]["Type_500_999"] == "(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                              Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                              Text(operatorInfoList[index]["rs_500_999"].toString(),
                                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    Expanded(
                                                                        child: Container(
                                                                          alignment: Alignment.center,
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              operatorInfoList[index]["Type_500_999"] == "Max(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                              Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                              Text(operatorInfoList[index]["maxrs_500_999"].toString(),
                                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.only(top: 3,bottom: 3),
                                                        decoration: BoxDecoration(border: Border(top: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                                width: 100,
                                                                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                child: Text("1000 To 1499",style: TextStyle(fontSize: 12,),)),
                                                            Container(
                                                              child: Expanded(
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                        child: Container(
                                                                          alignment: Alignment.center,
                                                                          decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              operatorInfoList[index]["Type_1000_1499"] == "%" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                              Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                              Text(operatorInfoList[index]["per_1000_1499"].toString(),
                                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    Expanded(
                                                                        child: Container(
                                                                          alignment: Alignment.center,
                                                                          decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              operatorInfoList[index]["Type_1000_1499"] ==  "(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                              Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                              Text(operatorInfoList[index]["rs_1000_1499"].toString(),
                                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    Expanded(
                                                                        child: Container(
                                                                          alignment: Alignment.center,
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              operatorInfoList[index]["Type_1000_1499"] == "Max(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                              Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                              Text(operatorInfoList[index]["maxrs_1000_1499"].toString(),
                                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.only(top: 3,bottom: 3),
                                                        decoration: BoxDecoration(border: Border(top: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                                width: 100,
                                                                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                child: Text("1500 To 1999",style: TextStyle(fontSize: 12,),)),
                                                            Container(
                                                              child: Expanded(
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                        child: Container(
                                                                          alignment: Alignment.center,
                                                                          decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              operatorInfoList[index]["Type_1500_1999"] == "%" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                              Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                              Text(operatorInfoList[index]["per_1500_1999"].toString(),
                                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    Expanded(
                                                                        child: Container(
                                                                          alignment: Alignment.center,
                                                                          decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              operatorInfoList[index]["Type_1500_1999"] == "(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                              Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                              Text(operatorInfoList[index]["rs_1500_1999"].toString(),
                                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    Expanded(
                                                                        child: Container(
                                                                          alignment: Alignment.center,
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              operatorInfoList[index]["Type_1500_1999"] == "Max(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                              Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                              Text(operatorInfoList[index]["maxrs_1500_1999"].toString(),
                                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.only(top: 3,bottom: 3),
                                                        decoration: BoxDecoration(border: Border(top: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                                width: 100,
                                                                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                child: Text("2000 To 2499",style: TextStyle(fontSize: 12,),)),
                                                            Container(
                                                              child: Expanded(
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                        child: Container(
                                                                          alignment: Alignment.center,
                                                                          decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              operatorInfoList[index]["Type_2000_2499"] == "%" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                              Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                              Text(operatorInfoList[index]["per_2000_2499"].toString(),
                                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    Expanded(
                                                                        child: Container(
                                                                          alignment: Alignment.center,
                                                                          decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              operatorInfoList[index]["Type_2000_2499"] == "(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                              Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                              Text(operatorInfoList[index]["rs_2000_2499"].toString(),
                                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    Expanded(
                                                                        child: Container(
                                                                          alignment: Alignment.center,
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              operatorInfoList[index]["Type_2000_2499"] == "Max(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                              Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                              Text(operatorInfoList[index]["maxrs_2000_2499"].toString(),
                                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.only(top: 3,bottom: 3),
                                                        decoration: BoxDecoration(border: Border(top: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                                width: 100,
                                                                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                child: Text("2500 To 2999",style: TextStyle(fontSize: 12,),)),
                                                            Container(
                                                              child: Expanded(
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                        child: Container(
                                                                          alignment: Alignment.center,
                                                                          decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              operatorInfoList[index]["Type_2500_2999"] == "%" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                              Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                              Text(operatorInfoList[index]["per_2500_2999"].toString(),
                                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    Expanded(
                                                                        child: Container(
                                                                          alignment: Alignment.center,
                                                                          decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              operatorInfoList[index]["Type_2500_2999"] == "(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                              Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                              Text(operatorInfoList[index]["rs_2500_2999"].toString(),
                                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    Expanded(
                                                                        child: Container(
                                                                          alignment: Alignment.center,
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              operatorInfoList[index]["Type_2500_2999"] == "Max(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                              Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                              Text(operatorInfoList[index]["maxrs_2500_2999"].toString(),
                                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.only(top: 3,bottom: 3),
                                                        decoration: BoxDecoration(border: Border(top: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                                width: 100,
                                                                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                child: Text("3000 To 3499",style: TextStyle(fontSize: 12,),)),
                                                            Container(
                                                              child: Expanded(
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                        child: Container(
                                                                          alignment: Alignment.center,
                                                                          decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              operatorInfoList[index]["Type_3000_3499"] == "%" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                              Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                              Text(operatorInfoList[index]["per_3000_3499"].toString(),
                                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    Expanded(
                                                                        child: Container(
                                                                          alignment: Alignment.center,
                                                                          decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              operatorInfoList[index]["Type_3000_3499"] == "(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                              Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                              Text(operatorInfoList[index]["rs_3000_3499"].toString(),
                                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    Expanded(
                                                                        child: Container(
                                                                          alignment: Alignment.center,
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              operatorInfoList[index]["Type_3000_3499"] == "Max(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                              Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                              Text(operatorInfoList[index]["maxrs_3000_3499"].toString(),
                                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.only(top: 3,bottom: 3),
                                                        decoration: BoxDecoration(border: Border(top: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                                width: 100,
                                                                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                child: Text("3500 To 5000",style: TextStyle(fontSize: 12,),)),
                                                            Container(
                                                              child: Expanded(
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                        child: Container(
                                                                          alignment: Alignment.center,
                                                                          decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              operatorInfoList[index]["Type_3500_5000"] == "%" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                              Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                              Text(operatorInfoList[index]["per_3500_5000"].toString(),
                                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    Expanded(
                                                                        child: Container(
                                                                          alignment: Alignment.center,
                                                                          decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              operatorInfoList[index]["Type_3500_5000"] == "(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                              Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                              Text(operatorInfoList[index]["rs_3500_5000"].toString(),
                                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    Expanded(
                                                                        child: Container(
                                                                          alignment: Alignment.center,
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              operatorInfoList[index]["Type_3500_5000"] == "Max(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                              Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                              Text(operatorInfoList[index]["maxrs_3500_5000"].toString(),
                                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.only(top: 3,bottom: 3),
                                                        decoration: BoxDecoration(border: Border(top: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                                width: 100,
                                                                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                child: Text("5001 To 10000",style: TextStyle(fontSize: 12,),)),
                                                            Container(
                                                              child: Expanded(
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                        child: Container(
                                                                          alignment: Alignment.center,
                                                                          decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              operatorInfoList[index]["Type_5001_10000"] == "%" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                              Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                              Text(operatorInfoList[index]["per_5001_10000"].toString(),
                                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    Expanded(
                                                                        child: Container(
                                                                          alignment: Alignment.center,
                                                                          decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              operatorInfoList[index]["Type_5001_10000"] == "(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                              Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                              Text(operatorInfoList[index]["rs_5001_10000"].toString(),
                                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    Expanded(
                                                                        child: Container(
                                                                          alignment: Alignment.center,
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              operatorInfoList[index]["Type_5001_10000"] == "Max(???)" ?Icon(Icons.check_circle,color: Colors.green,size: 12,):
                                                                              Icon(Icons.check_circle,color: Colors.transparent,size: 12,),
                                                                              Text(operatorInfoList[index]["maxrs_5001_10000"].toString(),
                                                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );

                                }
                            ),
                          ],
                        ):
                    receive == "VM30PURCHASE"?
                    Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            operatorInfoList.length == 0 ?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(getTranslated(context, 'No Data') ,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                              ],
                            ):
                            ListView.builder(
                                controller: listScroll,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount:operatorInfoList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
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
                                                      Container(padding: EdgeInsets.only(bottom: 5),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(getTranslated(context, 'Card Name'),style: TextStyle(fontSize: 12,),),
                                                                  Text(operatorInfoList[index]["cardname"],style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                                ],
                                                              ),
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Text(getTranslated(context, 'Card Category'),style: TextStyle(fontSize: 12,),),
                                                                  Text(operatorInfoList[index]["cardcategorytype"],style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                                ],
                                                              ),
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                children: [
                                                                  Text(getTranslated(context, 'Card Type'),style: TextStyle(fontSize: 12,),),
                                                                  Text(operatorInfoList[index]["cardtype"],style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                                                ],
                                                              ),
                                                            ],
                                                          )),
                                                      Container(
                                                        padding: EdgeInsets.only(top: 2,bottom: 2),
                                                        decoration: BoxDecoration(border: Border(top: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              child: Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text(getTranslated(context, 'Amount Range'),style: TextStyle(fontSize: 12,),),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                      children: [
                                                                        Expanded(
                                                                            child: Container(
                                                                                alignment: Alignment.center,
                                                                                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Container(width: 60,child: Text(getTranslated(context, 'Min Value'),style: TextStyle(fontSize: 10,),overflow: TextOverflow.ellipsis,)),
                                                                                  ],
                                                                                )
                                                                            )),
                                                                        Expanded(
                                                                            child: Container(
                                                                                alignment: Alignment.center,
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Container(width: 60,child: Text(getTranslated(context, 'Max Value'),style: TextStyle(fontSize: 10,),overflow: TextOverflow.ellipsis,)),
                                                                                  ],
                                                                                )
                                                                            )),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                      children: [
                                                                        Expanded(
                                                                            child: Container(
                                                                                alignment: Alignment.center,
                                                                                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Text("\u{20B9} " +
                                                                                      operatorInfoList[index]["minvalue"].toString(),style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
                                                                                  ],
                                                                                )
                                                                            )),
                                                                        Expanded(
                                                                            child: Container(
                                                                                alignment: Alignment.center,
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Text("\u{20B9} "+operatorInfoList[index]["maxvalue"].toString(),style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
                                                                                  ],
                                                                                )
                                                                            )),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(height: 40,width: 1,child: Container(color: PrimaryColor.withOpacity(0.3),),),
                                                            Container(
                                                              child: Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text(getTranslated(context, 'Charges'),style: TextStyle(fontSize: 12,),),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                      children: [
                                                                        Expanded(
                                                                            child: Container(
                                                                                alignment: Alignment.center,
                                                                                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Text("Charge Type",style: TextStyle(fontSize: 10,),),
                                                                                  ],
                                                                                )
                                                                            )),
                                                                        Expanded(
                                                                            child: Container(
                                                                                alignment: Alignment.center,
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Text(getTranslated(context, 'Charge'),style: TextStyle(fontSize: 10,),),
                                                                                  ],
                                                                                )
                                                                            )),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                      children: [
                                                                        Expanded(
                                                                            child: Container(
                                                                                alignment: Alignment.center,
                                                                                decoration: BoxDecoration(border: Border(right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.3)))),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    operatorInfoList[index]["chargetype"] == "Per" ?Text("(%)",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),):
                                                                                    Text("(???)",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
                                                                                  ],
                                                                                )
                                                                            )),
                                                                        Expanded(
                                                                            child: Container(
                                                                                alignment: Alignment.center,
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Text(operatorInfoList[index]["charge"].toString(),
                                                                                      style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
                                                                                  ],
                                                                                )
                                                                            )),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }
                            ),
                          ],
                        ):
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 0,right: 0),
                        child:Column(
                          children: [
                        Container(
                          padding: EdgeInsets.only(left: 0,right: 0,top: 0,bottom: 0),
                          decoration: BoxDecoration(
                            color: PrimaryColor.withOpacity(0.8),
                            border: Border(left: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.5)),
                                right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.5))),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(right: 7,left: 7),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: Container(
                                            padding: EdgeInsets.only(left: 0,),
                                            alignment: Alignment.centerLeft,
                                            child: Text(getTranslated(context, 'Operator') ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: TextColor),textAlign: TextAlign.center,))),

                                    Container(
                                      width: 80,
                                        padding: EdgeInsets.only(top: 5,bottom: 5,),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border(left: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.5)),
                                              right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.5))),
                                        ),
                                        child: Text("Code" ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: TextColor),textAlign: TextAlign.center,)),
                                    Expanded(
                                        child: Container(
                                            child: Text("Commision By Range",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: TextColor),textAlign: TextAlign.right,))),
                                  ],
                                ),
                              ),
                              Container(
                                height: 1,
                                color:PrimaryColor.withOpacity(0.5),
                              ),
                              Visibility(
                                  visible: prepaidtrue ? true:false,
                                  child: Container(
                                    padding: EdgeInsets.only(right: 7,left: 7),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Container(
                                                child: Text("Prepaid/Postpaid" ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10,color: TextColor),textAlign: TextAlign.left,))),
                                        Container(
                                            width: 80,
                                            padding: EdgeInsets.only(top: 5,bottom: 5,),
                                            decoration: BoxDecoration(
                                              border: Border(left: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.5)),
                                                  right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.5))),
                                            ),
                                            child: Text("By Operator" ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10,color: TextColor),textAlign: TextAlign.center,)),

                                        Expanded(

                                          child: Container(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                      child: Text("${range1}",style: TextStyle(color: Colors.white,fontSize: 10),textAlign: TextAlign.center,)),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border(left: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.5)),
                                                            right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.5))),
                                                      ),
                                                      child: Text("${range2}",style: TextStyle(color: Colors.white,fontSize: 10),textAlign: TextAlign.center,)),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                      child: Text("${range3}",style: TextStyle(color: Colors.white,fontSize: 10),textAlign: TextAlign.center,)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),)
                            ],
                          ),
                        ),
                        operatorInfoList.length == 0 ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(getTranslated(context, 'No Data') ,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                          ],
                        ):
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: PrimaryColor.withOpacity(0.1),width: 1),
                            boxShadow: [BoxShadow(color: PrimaryColor.withOpacity(0.08), blurRadius: .5, spreadRadius: 1, offset: Offset(.0, .0),)],
                          ),
                          padding: EdgeInsets.only(left: 0,right: 0,top: 0,bottom: 0),
                          margin: EdgeInsets.only(left: 0,right: 0,top: 0,bottom: 10),
                          child: ListView.builder(
                              controller: listScroll,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount:operatorInfoList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(right: 7,left: 7),
                                      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1)))),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                operatorInfoList[index]["OperatorName"].toString() == null ? "": operatorInfoList[index]["OperatorName"].toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 80,
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.only(top: 3,bottom: 3),
                                            decoration: BoxDecoration(
                                              border: Border(left: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1)),
                                                  right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1))),
                                            ),
                                            child: Text(operatorInfoList[index]["OperatorCode"].toString() == null ? "":  operatorInfoList[index]["OperatorCode"].toString(),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                          ),

                                          Visibility(
                                            visible: prepaidtrue ? true : false,
                                            child: Expanded(
                                              child: Container(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        alignment: Alignment.center,
                                                        child: Text(operatorInfoList[index]["Commission"].toString() == null ? "":  operatorInfoList[index]["Commission"].toString(),
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(color: Colors.black45,fontSize: 12,fontWeight: FontWeight.bold),),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        padding: EdgeInsets.only(top: 3,bottom: 3),
                                                        decoration: BoxDecoration(
                                                          border: Border(left: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1)),
                                                              right: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1))),
                                                        ),
                                                        alignment: Alignment.center,
                                                        child: Text(operatorInfoList[index]["Commission1"].toString() == null ? "":  operatorInfoList[index]["Commission1"].toString(),
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(color: PrimaryColor,fontSize: 12,fontWeight: FontWeight.bold),),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        alignment: Alignment.center,
                                                        child: Text(operatorInfoList[index]["Commission2"].toString() == null ? "":  operatorInfoList[index]["Commission2"].toString(),
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(color: Colors.black45,fontSize: 12,fontWeight: FontWeight.bold),),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            replacement: Expanded(
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: Text("\u{20B9} " + operatorInfoList[index]["Commission"].toString() == null ? "": "\u{20B9} " + operatorInfoList[index]["Commission"].toString(),
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }
                          ),
                        ),
                      ],
                    ),
                          ),
                      ],
                    ),
                    SizedBox(height: 10,),
                  ],
                ),
              ),
            ),
          ),
        ],),
      ),
    );
  }
}
