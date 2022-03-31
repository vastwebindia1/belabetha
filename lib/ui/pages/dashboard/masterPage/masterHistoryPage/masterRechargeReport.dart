import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:http/http.dart'as http;


class MasterRechargeReport extends StatefulWidget {
  const MasterRechargeReport({Key key}) : super(key: key);

  @override
  _MasterRechargeReportState createState() => _MasterRechargeReportState();
}

class _MasterRechargeReportState extends State<MasterRechargeReport> {



  String frmDate = "";
  String toDate = "";
  bool _isloading = false;
  int get count => rechhislist.length;

  List rechhislist = [];

  List<int> list = [];

  int present = 0;
  int perPage;
  int pageIndex = 1;
  List originalItems = [];
  List items = [];

  int id = 1;
  bool idpr = false;
  String statuss = "ALL";

  bool upiconvis = false;
  bool downiconvis = true;

  bool filtervisi = false;
  var userid;

  DateTime selectedDate = DateTime.now();
 DateTime selectedDate2 = DateTime.now();

  TextEditingController _rechanumber = TextEditingController();

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
              child:Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Container(
                      child: child,
                    ),
                  ),
                ],
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
              child:Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Container(
                      child: child,
                    ),
                  ),
                ],
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

  Future<void> masterRechargeHistory(String pgrind ,String retailerid, String fromdate, String todate, String role, String rechargenum,String status, String optname) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    try{

      var uri =
      new Uri.http("api.vastwebindia.com", "/api/data/Master_rem_rch_report", {
        "pageindex": pgrind,
        "pagesize": "500",
        "retailerid": retailerid,
        "fromdate": fromdate,
        "todate": todate,
        "role": role,
        "rechargeNo": rechargenum,
        "status": status,
        "OperatorName": optname,
        "portno":"ALL",
      });
      final http.Response response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // ignore: missing_return
      ).timeout(Duration(seconds: 15), onTimeout: (){
        setState(() {

          _isloading = false;

          final snackBar2 = SnackBar(
            backgroundColor: Colors.greenAccent,
            content: Text(getTranslated(context, 'Data Not Found'),style: TextStyle(color: Colors.black),textAlign: TextAlign.center),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar2);

        });
      });

      print(response);

      if (response.statusCode == 200) {
        _isloading = false;
        var data = json.decode(response.body);

        if(data.length < 20){

          setState(() {
            present = 0;
            perPage = data.length;
          });
        }else{

          if(status == "FAILED" || status == "SUCCESS" || status == "PENDING" || status == "ALL"){

            setState(() {
              present = 0;
              perPage = 20;
            });

          }else{

            setState(() {
              perPage = 20;
            });
          }
        }

        print(perPage);

        setState(() {
          originalItems = data;
          items.addAll(originalItems.getRange(present, present + perPage));
          present = present + perPage;
        });


      } else {
        _isloading = false;
        throw Exception('Failed');
      }


    }catch(e){

      print(e);
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    frmDate = "${selectedDate2.toLocal()}".split(' ')[0];
    toDate = "${selectedDate.toLocal()}".split(' ')[0];

    retid();

  }

  void retid() async{

    final storage = new FlutterSecureStorage();
    /*userid = await storage.read(key: "userId");*/
    userid = "ALL";

    masterRechargeHistory(pageIndex.toString(),userid, frmDate, toDate, "Dealer", "ALL", "ALL", "ALL");

  }

  ScrollController _controllerList = new ScrollController();




  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: TextColor,
          appBar: AppBar(
            leading: IconButton(onPressed: () => Navigator.of(context).pop(),icon: Icon(Icons.arrow_back,color: TextColor,),),
            title: Align(
                alignment:  Alignment(-.3, 0),
                child: Text(getTranslated(context, 'Recharge History'),style: TextStyle(color: TextColor),textAlign: TextAlign.center,)),
            elevation: 0,
            toolbarHeight: 39,
            leadingWidth: 60,
            backgroundColor: PrimaryColor,
          ),
          body: SingleChildScrollView(
            child: Container(
              child: Container(
                color: TextColor,
                child: StickyHeader(
                  overlapHeaders: false,
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
                              Visibility(
                                  visible:filtervisi,
                                  child: Container(
                                    color: PrimaryColor.withOpacity(0.8),
                                    padding: EdgeInsets.only(top: 5,bottom: 2), child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)
                                            )
                                        ),
                                        child: TextFormField(
                                          buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
                                          keyboardType: TextInputType.number,
                                          controller: _rechanumber,
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: TextColor)),
                                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: TextColor)),
                                            errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: TextColor)),
                                            border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: TextColor)),
                                            isDense: true,
                                            isCollapsed: true,
                                            contentPadding: EdgeInsets.fromLTRB(8, 14, 8, 14),
                                            labelText: getTranslated(context, 'Search By Consumer Number'),
                                            labelStyle: TextStyle(color: TextColor),
                                          ),
                                          maxLength: 10,
                                          cursorColor: TextColor,
                                          style: TextStyle(color: TextColor),
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Container(
                                        margin: EdgeInsets.only(left: 10,right: 10,top: 5),
                                        padding: EdgeInsets.only(top: 0, left: 0, right: 0),
                                        child: DropdownButtonFormField<String>(
                                          dropdownColor: PrimaryColor,
                                          iconEnabledColor: TextColor,
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: TextColor)),
                                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: TextColor)),
                                            errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: TextColor)),
                                            border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: TextColor)),
                                            isDense: true,
                                            isCollapsed: true,
                                            contentPadding: EdgeInsets.fromLTRB(8, 10, 8, 10),
                                            labelText: getTranslated(context, 'Select Status'),
                                            hintStyle: TextStyle(color: TextColor),
                                            labelStyle: TextStyle(color: TextColor),
                                          ),

                                          items:["ALL","Success","Pending","Failed",].map((item) {
                                            return new DropdownMenuItem(
                                              child: Text(item,style: TextStyle(color: TextColor),),
                                              value: item,

                                            );
                                          })?.toList() ??
                                              [],
                                          onChanged: (String val) {

                                            if(val == "ALL"){

                                              setState(() {
                                                statuss = "ALL";
                                              });

                                            }else if(val == "Success"){

                                              setState(() {
                                                statuss = "SUCCESS";
                                              });

                                            }else if(val == "Pending"){

                                              setState(() {
                                                statuss = "PENDING";
                                              });
                                            }else if(val == "Failed"){

                                              setState(() {
                                                statuss = "FAILED";
                                              });
                                            }


                                          },
                                        ),
                                      ),

                                    ],
                                  ),
                                  )),
                              Container(
                                color: PrimaryColor.withOpacity(0.8),
                                padding: EdgeInsets.only(top: 5,bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    Visibility(
                                      visible: downiconvis,
                                      child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              border: Border.all(width: 2,color: SecondaryColor),
                                              borderRadius: BorderRadius.circular(3)
                                          ),
                                          margin: EdgeInsets.only(left: 6),
                                          child: TextButton(

                                            onPressed: (){
                                              setState(() {
                                                filtervisi = true;
                                                upiconvis = true;
                                                downiconvis = false;
                                              });

                                            },
                                            child: Image.asset('assets/pngImages/downicon2.png',color: SecondaryColor,width: 30,),
                                          )
                                      ),
                                      replacement:Visibility(
                                          visible: upiconvis,
                                          child: Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  border: Border.all(width: 2,color: SecondaryColor),
                                                  borderRadius: BorderRadius.circular(3)
                                              ),
                                              margin: EdgeInsets.only(left: 6),
                                              child: TextButton(
                                                  onPressed: (){

                                                    setState(() {
                                                      filtervisi = false;
                                                      upiconvis = false;
                                                      _rechanumber.clear();
                                                      statuss = "ALL";
                                                      downiconvis = true;
                                                    });



                                                  },
                                                  child:Transform.rotate(
                                                    angle:3.15,
                                                    child: Image.asset('assets/pngImages/downicon2.png',color: SecondaryColor,width: 30,),
                                                  )
                                                /*Image.asset(
                                                'assets/pngImages/upicon2.png',
                                                color: TextColor,),*/
                                              )
                                          )),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(

                                          borderRadius: BorderRadius.circular(3),
                                          border: Border.all(
                                            color: TextColor,
                                          )
                                      ),
                                      margin: EdgeInsets.only(left: 8,right: 5),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 2,left: 3,right: 8,bottom: 2),
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
                                      margin: EdgeInsets.only(left: 5,right: 5),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3),
                                          border: Border.all(
                                            color: TextColor,
                                          )
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 2,left: 3,right: 8,bottom: 2),
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
                                      margin: EdgeInsets.only(right: 5,left: 0),
                                      height: 40,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3),
                                          border: Border.all(
                                            color: SecondaryColor,
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
                                        onPressed: () async{

                                          frmDate = "${selectedDate2.toLocal()}".split(' ')[0];
                                          toDate = "${selectedDate.toLocal()}".split(' ')[0];

                                          originalItems.clear();
                                          items.clear();
                                          masterRechargeHistory(pageIndex.toString(),userid, frmDate, toDate, "Dealer", _rechanumber.text, statuss, "ALL");


                                        },
                                      ),

                                    ),
                                    SizedBox(height: 5,)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                  content: originalItems.length == 0 ? Container(
                    margin: EdgeInsets.only(top: 20,left: 10,right: 10),
                    child: Center(
                      child: Text(getTranslated(context, 'No Data') ,style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),),
                    ),
                  ):Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListView.builder(
                        controller: _controllerList,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(left: 8,right: 8),
                        scrollDirection: Axis.vertical,
                        itemCount: (present <= originalItems.length) ? items.length + 1 : items.length,
                        itemBuilder: (BuildContext context, int index) {
                          return (index == items.length ) ?
                          originalItems.length > 20 ? Container(
                            child: MainButton(
                             btnText: getTranslated(context, 'Load More'),
                              color: SecondaryColor,
                              onPressed: () {
                                setState(() {
                                  if((present + perPage )> originalItems.length) {
                                    items.addAll(originalItems.getRange(present, originalItems.length));
                                  } else {
                                    items.addAll(
                                        originalItems.getRange(present, present + perPage));
                                  }
                                  present = present + perPage;
                                });
                              },
                            ),
                          ) : Container(
                            child: Text(""),
                          )
                              :
                          ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            childrenPadding: EdgeInsets.zero,
                            textColor: Colors.black,
                            title: Column(
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
                                  margin: EdgeInsets.only(top: 8),
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
                                              Container(
                                                width: 150,
                                                margin: EdgeInsets.only(bottom: 5),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: 25,
                                                      width: 25,
                                                      child: CircleAvatar(
                                                          backgroundColor: Colors.transparent,
                                                          child:items[index]["operator_type"] == "MicroATM" ?
                                                          Image.asset("assets/pngImages/Pos.png",width: 25,height: 25,)
                                                              :items[index]["operator_type"] == "Housing Society" ?
                                                          Image.asset("assets/pngImages/Society.png",width: 25,height: 25,)
                                                              :items[index]["operator_type"] == "Aadharpay" ?
                                                          Image.asset("assets/pngImages/Aadhaar-Pay.png",width: 25,height: 25,)
                                                              :items[index]["operator_type"] == "AEPS" ?
                                                          Image.asset("assets/pngImages/Aeps.png",width: 25,height: 25,)
                                                              :items[index]["operator_type"] == "Gas" ?
                                                          Image.asset("assets/pngImages/gas-tank.png",width: 25,height: 25,)
                                                              :items[index]["operator_type"] == "PrePaid" ?
                                                          Image.asset("assets/pngImages/mobile-phone.png",width: 25,height: 25,)
                                                              :items[index]["operator_type"] == "PostPaid" ?
                                                          Image.asset("assets/pngImages/mobile-phone.png",width: 25,height: 25,)
                                                              :items[index]["operator_type"] == "Subscription" ?
                                                          Image.asset("assets/pngImages/subscribe.png",width: 25,height: 25,)
                                                              :items[index]["operator_type"] == "DTH" ?
                                                          Image.asset("assets/pngImages/DTH.png",width: 25,height: 25,)
                                                              :items[index]["operator_type"] == "Flight" ?
                                                          Image.asset("assets/pngImages/Flight.png",width: 25,height: 25,)
                                                              :items[index]["operator_type"] == "PAN" ?
                                                          Image.asset("assets/pngImages/penCard.png",width: 25,height: 25,)
                                                              :items[index]["operator_type"] == "Electricity" ?
                                                          Image.asset("assets/pngImages/Electricity.png",width: 25,height: 25,)
                                                              :items[index]["operator_type"] == "Fastag" ?
                                                          Image.asset("assets/pngImages/toll-road.png",width: 25,height: 25,)
                                                              :items[index]["operator_type"] == "Hotel" ?
                                                          Image.asset("assets/pngImages/hotel.png",width: 25,height: 25,)
                                                              :items[index]["operator_type"] == "Money" ?
                                                          Image.asset("assets/pngImages/money-transfer.png",width: 25,height: 25,)
                                                              :items[index]["operator_type"] == "DTH" ?
                                                          Image.asset("assets/pngImages/gas-tank.png",width: 25,height: 25,)
                                                              :items[index]["operator_type"] == "LPG Gas" ?
                                                          Image.asset("assets/pngImages/insurance.png",width: 25,height: 25,)
                                                              :items[index]["operator_type"] == "Insurance" ?
                                                          Image.asset("assets/pngImages/subscribe.png",width: 25,height: 25,)
                                                              :items[index]["operator_type"] == "Subscription" ?
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
                                                              items[index]["Operator_name"],
                                                              overflow: TextOverflow.ellipsis,
                                                              maxLines: 1,
                                                              textAlign: TextAlign.left,
                                                            ),
                                                            SizedBox(height: 1,),
                                                            Text(items[index]["Recharge_number"].toString(),textAlign: TextAlign.right,)
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  alignment: Alignment.centerRight,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          items[index]["Status"] == "SUCCESS" ? Icon(Icons.check_circle,color: Colors.green,size: 14,) : items[index]["Status"] == "PENDING" ? Icon(Icons.watch_later,color: Colors.yellow[800],size: 16,) :items[index]["Status"] == "FAILED" ?Icon(Icons.cancel,color: Colors.red,size: 16,) : Image.asset('assets/pngImages/Check-Bal.png', height:16,width: 16,),

                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 3),
                                                            child: Text(items[index]["Status"],style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 1,),
                                                      Text(getTranslated(context, 'Amount') +"\u{20B9} " + items[index]["Recharge_amount"].toString(),textAlign: TextAlign.right,)
                                                    ],
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 0,bottom: 8),
                                            height: 1,
                                            color: PrimaryColor.withOpacity(0.1),
                                          ),
                                          Row(
                                            crossAxisAlignment:CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(getTranslated(context, 'Date') + items[index]["Reqesttime"].toString(),textAlign: TextAlign.right,),

                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.centerRight,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(getTranslated(context, 'My Earn') + " \u{20B9} " +items[index]["Commision"].toString(),textAlign: TextAlign.right,),
                                                    Icon(Icons.arrow_drop_down_sharp)
                                                  ],
                                                ),
                                              ),


                                            ],
                                          ),


                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            children: [
                              Column(
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
                                    margin: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
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
                                              child:Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          alignment: Alignment.centerLeft,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                getTranslated(context, 'Requst ID'),
                                                                style: TextStyle(fontSize: 12),
                                                                overflow: TextOverflow.ellipsis,softWrap: true,textAlign: TextAlign.left,),
                                                              SizedBox(height: 1,),
                                                              Text(items[index]["Request_ID"].toString(),textAlign: TextAlign.right,)
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          alignment: Alignment.centerRight,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                            children: [
                                                              Text(
                                                                getTranslated(context, 'Operator ID'),
                                                                style: TextStyle(fontSize: 12),
                                                                overflow: TextOverflow.ellipsis,softWrap: true,textAlign: TextAlign.right,),
                                                              SizedBox(height: 1,),
                                                              Text(items[index]["Operatorid"].toString(),textAlign: TextAlign.right,)
                                                            ],
                                                          ),
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(top: 0,bottom: 8),
                                                    height: 1,
                                                    color: PrimaryColor.withOpacity(0.1),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          alignment: Alignment.centerLeft,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(getTranslated(context, 'Pre Balance'),textAlign: TextAlign.left,style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                              SizedBox(height: 1,),
                                                              Text("\u{20B9} " + items[index]["RemainPre"].toString(),textAlign: TextAlign.right,)
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
                                                              items[index]["Creditamount"] == 0.0 ? Text(getTranslated(context, 'Debit') + "\u{20B9}",style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,softWrap: true,) : Text("Credit \u{20B9}".toUpperCase(),style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                              SizedBox(height: 1,),
                                                              items[index]["Creditamount"] == 0.0 ? Text("\u{20B9} "+items[index]["Debitamount"].toString(),textAlign: TextAlign.right,) : Text("\u{20B9} "+items[index]["Creditamount"].toString(),textAlign: TextAlign.right,)
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
                                                          alignment: Alignment.centerRight,
                                                          child: Column(
                                                            children: [
                                                              Text(getTranslated(context, 'Post Balance') ,style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                              SizedBox(height: 1,),
                                                              Text("\u{20B9} " + items[index]["RemainPost"].toString(),textAlign: TextAlign.right,)
                                                            ],
                                                          ),
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                ],
                                              ),
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
                                    height: 5,
                                  )
                                ],
                              ),
                            ],


                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


