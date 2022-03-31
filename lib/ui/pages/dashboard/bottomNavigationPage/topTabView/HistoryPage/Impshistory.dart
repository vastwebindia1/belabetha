import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/Shareimpshistory.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';


class Impshistorypage extends StatefulWidget {
  const Impshistorypage({Key key}) : super(key: key);

  @override
  _ImpshistorypageState createState() => _ImpshistorypageState();
}

class _ImpshistorypageState extends State<Impshistorypage> {
  String frmDate = "";
  String toDate = "";
  bool _isloading = false;
  int get count => rechhislist.length;

  List rechhislist = [];

  List<int> list = [];

  List statusdorp= ["ALL","Success","Failed"];

  int present = 0;
  int perPage;
  int pageIndex = 1;
  List originalItems = [];
  List items = [];
  List items2 = [];
  int id = 1;
  bool idpr = false;
  String statuss = "ALL";
  String paymode = "ALL";

  bool upiconvis = false;
  bool downiconvis = true;

  bool filtervisi = false;
  var userid;
  bool loadersho = false;
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

  Future<void> Impshistory(String pgrind ,String retailerid, String fromdate, String todate, String role,String status, String trantypr, String sendnum) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    try{

      var uri =
      new Uri.http("api.vastwebindia.com", "/Money/api/Money/GetBeneIMPSReport", {
        "pageindex": pgrind,
        "pagesize": "500",
        "role": role,
        "Id": retailerid,
        "txt_frm_date": fromdate,
        "txt_to_date": todate,
        "status": status,
        "transtype":trantypr,
        "senderno":sendnum,

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

          final snackBar2 = SnackBar(
            backgroundColor: Colors.greenAccent,
            content: Text(getTranslated(context, 'Data Not Found'),style: TextStyle(color: Colors.black),textAlign: TextAlign.center),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar2);

        });
      });

      print(response);

      if (response.statusCode == 200) {
        setState(() {
          loadersho = false;
          _isloading = false;
        });
        var data = json.decode(response.body);

        if(data.length < 20){

          setState(() {
            present = 0;
            perPage = data.length;
          });
        }else{

          if(status == "FAILED" || status == "SUCCESS" || status == "Pending" || status == "ALL"){

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


  Future<void> trackrefrechargehistory(String frmdate, String todate, String number, String idno) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");
    var userid = await storage.read(key: "userId");

    try{

      var uri =
      new Uri.http("api.vastwebindia.com", "/Money/api/Money/GetBeneIMPSReport", {
        "pageindex": "1",
        "pagesize": "500",
        "role": "Retailer",
        "Id": userid,
        "txt_frm_date": frmdate,
        "txt_to_date": todate,
        "status": "ALL",
        "transtype":"ALL",
        "senderno":"",

      });
      final http.Response response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // ignore: missing_return
      ).timeout(Duration(seconds: 15), onTimeout: (){

      });

      print(response);

      if (response.statusCode == 200) {

        var data = json.decode(response.body);


        for(int i =0 ; i <data.length; i++){

          var datalist = data[i]["TransactionId"].toString();
          var statuss = data[i]["Status"].toString();
          print(idno);

          if(datalist == idno || statuss == "Rf-"+idno){

            var listt = data[i];
            items2.add(listt);
          }

        }

        setState(() {
          items2;
        });

        Trackrefundhist(number);


      } else {
        throw Exception('Failed');
      }


    }catch(e){

      print(e);
    }

  }

  void Trackrefundhist(String number){
    showDialog(
        barrierDismissible: false,
        context: context,
        useSafeArea: true,
        builder: (BuildContext context) {
          return Container(
            color: Colors.black.withOpacity(0.8),
            child: AlertDialog(
                buttonPadding: EdgeInsets.all(0),
                titlePadding: EdgeInsets.all(0),
                contentPadding: EdgeInsets.only(left: 5,right: 5),
                title: Container(
                  child: Column(
                    children:  [
                      Container(
                        color:PrimaryColor,
                        padding: EdgeInsets.only(top: 8,),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 8,left: 5,right: 5),
                          color: PrimaryColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Benificary Account",style: TextStyle(fontSize: 9,color: Colors.white),),
                                    Text(number.toString(),
                                      style: TextStyle(color: TextColor,fontSize: 20),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                              CloseButton(
                                color: TextColor,
                              ),
                            ],
                          ),

                        ),
                      ),
                    ],
                  ),
                ),
                content: setupAlertDialoadContainer()
            ),
          );
        });

  }

  Widget setupAlertDialoadContainer() {
    return Container(
        height: 530, // Change as per your requirement
        width: MediaQuery.of(context).size.width, // Change as per your requirement
        child:  SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 8,right: 8),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListView.builder(
                  controller: _controllerList,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  itemCount: (present <= originalItems.length) ? items2.length + 1 : items2.length,
                  itemBuilder: (BuildContext context, int index) {


                    if(index == items2.length){

                      return  originalItems.length > 20 ? Container(
                        margin: EdgeInsets.only(top: 20),
                        color:SecondaryColor,
                        child: FlatButton(
                          child: Text(getTranslated(context, 'Load More'),style: TextStyle(color: TextColor),),
                          onPressed: () {
                            setState(() {
                              if((present + perPage )> originalItems.length) {
                                items2.addAll(originalItems.getRange(present, originalItems.length));
                              } else {
                                items2.addAll(originalItems.getRange(present, present + perPage));
                              }
                              present = present + perPage;
                            });
                          },
                        ),
                      ) : Container(
                        child: Text(""),
                      );
                    }else{


                      DateTime tempDate1 = DateTime.parse(items2[index]["M_Date"].toString());
                      String dattee = DateFormat.yMMMd().add_jm().format(tempDate1);

                      String dattee2 = DateFormat.yMd().format(tempDate1);


                      return Container(
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          border: Border.all(width: .5, color:items2[index]["Status"] == "SUCCESS" ? Colors.green : items2[index]["Status"] == "FAILED" ? Colors.red : items2[index]["Status"] == "Pending" ? Colors.orange : Colors.deepPurple),
                          boxShadow: [
                            BoxShadow(
                              color: PrimaryColor.withOpacity(0.08),
                              blurRadius: .5,
                              spreadRadius: 1,
                              offset: Offset(0.0, .0), // shadow direction: bottom right
                            )
                          ],
                        ),
                        child: Container(
                          child: ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            childrenPadding: EdgeInsets.zero,
                            textColor: Colors.black,
                            title: Container(
                              child: Container(
                                child: Column(
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
                                                  height: 30,
                                                  width: 30,
                                                  alignment: Alignment.center,

                                                  child: CircleAvatar(
                                                      backgroundColor: Colors.transparent,
                                                      child:items2[index]["TransactionType"] == "IMPS_VERIFY" ?
                                                      Image.asset("assets/pngImages/money-transfer.png",width: 25,height: 25,)
                                                          :items2[index]["TransactionType"] == "IMPS" ?
                                                      Image.asset("assets/pngImages/money-transfer.png",width: 25,height: 25,)
                                                          :items2[index]["TransactionType"] == "Wallet" ?
                                                      Image.asset("assets/pngImages/wallet2.png",width: 25,height: 25,)
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
                                                        Visibility(
                                                          visible: items2[index]["BankName"].toString()== ""? true:false,
                                                          child: Text(
                                                            items2[index]["Status"],
                                                            style: TextStyle(fontSize: 12),
                                                            textAlign: TextAlign.left,
                                                          ),
                                                          replacement: Container(
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    child: Expanded(
                                                                      child: Text(
                                                                        items2[index]["BankName"],
                                                                        style: TextStyle(fontSize: 9,fontWeight: FontWeight.bold),
                                                                        textAlign: TextAlign.left,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                          ),
                                                        ),
                                                        SizedBox(height: 1,),
                                                        Text(
                                                          items2[index]["AccountNo"],
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
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(bottom: 5),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Flexible(
                                                  flex: 1,
                                                  child: Container(
                                                    margin: EdgeInsets.only(top: 4),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Visibility(
                                                          visible: items2[index]["BankName"].toString()== ""? false:true,
                                                          child: Container(
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                              children: [
                                                                Text(items2[index]["Status"],style:TextStyle(fontSize: 11,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,textAlign: TextAlign.right,),
                                                              ],
                                                            ),
                                                          ),
                                                          replacement: Container(
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                              children: [
                                                                Text("Refunded",style:TextStyle(fontSize: 11,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,textAlign: TextAlign.right,),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 1,),
                                                        Text("\u{20B9} "+items2[index]["Amount"].toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                items2[index]["Status"] == "SUCCESS" ? Icon(Icons.check_circle,color: Colors.green,size: 40,) : items2[index]["Status"] == "Pending" ? Icon(Icons.watch_later,color: Colors.yellow[800],size: 40,) :items2[index]["Status"] == "FAILED" ? Icon(Icons.cancel_rounded,color: Colors.red,size: 40,):Icon(Icons.replay_circle_filled,color: Colors.deepPurple,size: 40,),


                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(

                                      padding: EdgeInsets.only(left: 2,right: 2,top: 2,bottom: 1),
                                      decoration: BoxDecoration(
                                          color: items2[index]["Status"] == "SUCCESS" ? Colors.green : items2[index]["Status"] == "FAILED" ? Colors.red : items2[index]["Status"] == "Pending" ? Colors.orange : Colors.deepPurple,
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Center(
                                          child: items2[index]["Status"] == "SUCCESS" ? Text("T r a n s a c t i o n     A m o u n t    P a i d    S u c c e s s f u l l y",style: TextStyle(fontSize: 8,color: Colors.white)) : items2[index]["Status"] == "Pending" ? Text("Y o u r   T r a n s a c t i o n   i n  Q u e u e   o r   P e n d i n g ",style: TextStyle(fontSize: 8,color: Colors.white)): items2[index]["Status"] == "FAILED" ? Text("Y  o  u r    T r a n s a c t i o n    i  s    F  a  i  l  e  d ",style: TextStyle(fontSize: 8,color: Colors.white)) :Text("T r a n s a c t i o n    A m o u n t    S u c c e s s f u l l y    R e f u n d e d",style: TextStyle(fontSize: 8,color: Colors.white),)),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Visibility(
                                      visible: items2[index]["Status"] == "SUCCESS" ? true : items2[index]["Status"] == "FAILED" ? true : items2[index]["Status"] == "Pending" ? true : false,
                                      child: Container(
                                        transform: Matrix4.translationValues(0.0, -2.0, 0.0),
                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 0.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Flexible(
                                                        flex: 1,
                                                        child: Container(
                                                          margin: EdgeInsets.only(top: 4),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                "IFS CODE" ,
                                                                softWrap: true,
                                                                style:TextStyle(fontSize: 11,fontWeight: FontWeight.bold),
                                                                textAlign: TextAlign.left,
                                                              ),
                                                              SizedBox(height: 1,),
                                                              Text(
                                                                items2[index]["IFSC"],
                                                                overflow: TextOverflow.ellipsis,
                                                                maxLines: 1,
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
                                              Expanded(
                                                child: Container(
                                                  alignment: Alignment.centerRight,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text("Sender Info",style:TextStyle(fontSize: 11),overflow: TextOverflow.ellipsis,),
                                                      SizedBox(height: 1,),
                                                      Text(items2[index]["Sender"],style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 0,bottom: 3),
                                      height: 1,
                                      color: PrimaryColor.withOpacity(0.1),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 1),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Request Time",
                                                style:TextStyle(fontSize: 11,fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                dattee,
                                                style: TextStyle(fontSize: 14),
                                                textAlign: TextAlign.end,
                                              ),
                                            ],
                                          ),
                                          Visibility(
                                            visible: items2[index]["Status"] == "SUCCESS" ? true : items2[index]["Status"] == "FAILED" ? true : items2[index]["Status"] == "Pending" ? true : false,
                                            child: Container(
                                              margin: EdgeInsets.only(left: 20),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Transaction Mode",
                                                    style:TextStyle(fontSize: 11,fontWeight: FontWeight.bold,),textAlign: TextAlign.right,
                                                  ),
                                                  Text(
                                                    items2[index]["TransactionType"] + " BY " + items2[index]["TransactionDeviceType"].toString().toUpperCase(),
                                                    style:TextStyle(fontSize: 14),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible:  items2[index]["Status"] == "SUCCESS" ? true : items2[index]["Status"] == "FAILED" ? true : items2[index]["Status"] == "Pending" ? true : false,
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 0,bottom: 3),
                                            height: 1,
                                            color: PrimaryColor.withOpacity(0.1),
                                          ),
                                          Container(
                                            child: Container(
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(top: 3,bottom: 5),
                                                      child:Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child: Container(
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text(
                                                                        "Request ID",
                                                                        style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold),
                                                                        overflow: TextOverflow.ellipsis,softWrap: true,textAlign: TextAlign.left,),
                                                                      SizedBox(height: 2,),
                                                                      Text(items2[index]["TransactionId"].toString(),textAlign: TextAlign.right,)
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
                                                                        "Bank RRN",
                                                                        style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold),
                                                                        overflow: TextOverflow.ellipsis,softWrap: true,textAlign: TextAlign.right,),
                                                                      SizedBox(height: 2,),
                                                                      Text(items2[index]["BankRefId"].toString(),textAlign: TextAlign.right,)
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),

                                                            ],
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets.only(top: 5,bottom: 3),
                                                            height: 1,
                                                            color: PrimaryColor.withOpacity(0.1),
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets.only(top: 3,bottom: 3),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Expanded(
                                                                  child: Container(
                                                                    alignment: Alignment.centerLeft,
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(getTranslated(context, 'Pre Balance') + " \u{20B9} ",
                                                                          textAlign: TextAlign.left,
                                                                          style:TextStyle(fontSize: 11,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                                        SizedBox(height: 2,),
                                                                        Text(items2[index]["REM_Remain_Pre"].toString(),textAlign: TextAlign.right,)
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
                                                                        Text(getTranslated(context, 'Debit') + " \u{20B9}",style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                                        SizedBox(height: 2,),
                                                                        Text(items2[index]["Debit"].toString(),textAlign: TextAlign.right,)
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
                                                                    alignment: Alignment.centerRight,
                                                                    child: Column(
                                                                      children: [
                                                                        Text(getTranslated(context, 'Post Balance') + " \u{20B9} ",style:TextStyle(fontSize: 11,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                                        SizedBox(height: 2,),
                                                                        Text(items2[index]["REM_Remain_Post"].toString(),textAlign: TextAlign.right,)
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
                                                                    alignment: Alignment.centerRight,
                                                                    child: Column(
                                                                      children: [
                                                                        Text(getTranslated(context, 'My Earn') + " \u{20B9}",style:TextStyle(fontSize: 11,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                                        SizedBox(height: 2,),
                                                                        items2[index]["Income"] != null ? Text("\u{20B9} " + items2[index]["Income"].toString(),textAlign: TextAlign.right,) : Text("")
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
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: items2[index]["Status"] == "FAILED" ? true : items2[index]["Status"] == "Pending" ? true : false,
                                            child: Container(
                                                width: MediaQuery.of(context).size.width,
                                                height: 25,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      primary: SecondaryColor
                                                  ),
                                                  onPressed: (){

                                                    String date =  items2[index]["M_Date"].toString();
                                                    String status = items2[index]["Status"];
                                                    String amount = items2[index]["Amount"].toString();
                                                    String number = items2[index]["Sender"].toString();
                                                    String trnsid = items2[index]["TransactionId"].toString();
                                                    String txntype = items2[index]["TransactionType"];
                                                    String ifscc = items2[index]["IFSC"].toString();
                                                    String bnkname = items2[index]["BankName"];
                                                    String accnum = items2[index]["AccountNo"].toString();

                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => PrintImpsdata(Number: number,status: status,date: date,trnsid: trnsid,amount: amount,txntype: txntype,accno: accnum,ifsc: ifscc,bnkname: bnkname,)));
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(Icons.share,size: 20,),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text("Share"),
                                                    ],
                                                  ),
                                                )
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),


                            ),
                            children: [

                            ],


                          ),
                        ),
                      );

                    }

                  },
                ),
              ],
            ),
          ),
        ),
    );
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
    userid = await storage.read(key: "userId");
    Impshistory(pageIndex.toString(),userid, frmDate, toDate, "Retailer","ALL","ALL","");
  }

  bool notLaunchUrl = false;



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
                child: Text(getTranslated(context, 'IMPS History'),style: TextStyle(color: TextColor),textAlign: TextAlign.center,)),
            elevation: 0,
            toolbarHeight: 39,
            leadingWidth: 60,
            backgroundColor: PrimaryColor,
          ),
          body: Column(
            children: [
              Container(
                transform: Matrix4.translationValues(0.0, -2.0, 0.0),
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
                                padding: EdgeInsets.only(top: 5,bottom: 2,right: 10,left: 10), child: Column(
                                children: [

                                  Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)
                                      ),
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
                                        labelText: getTranslated(context, 'Search By Sender Acc Number'),
                                        labelStyle: TextStyle(color: TextColor),
                                      ),
                                      maxLength: 10,
                                      cursorColor: TextColor,
                                      style: TextStyle(color: TextColor),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(right: 10,top: 5),
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
                                                    statuss = "Pending";
                                                  });
                                                }else if(val == "Failed"){

                                                  setState(() {
                                                    statuss = "FAILED";
                                                  });
                                                }


                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5,),
                                        Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(top: 5),
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
                                                  labelText:getTranslated(context, 'Select Mode'),
                                                  labelStyle: TextStyle(color: TextColor),
                                                ),
                                                items:["All Transaction","Ac/c Verification","IMPS" ,"NEFT","UPI","Wallet"].map((item) {
                                                  return new DropdownMenuItem(
                                                    child:   Text(item,style: TextStyle(color: TextColor),),
                                                    value: item,
                                                  );
                                                })?.toList() ??
                                                    [],
                                                onChanged: (String val) {

                                                  if(val == "All Transaction"){

                                                    setState(() {
                                                      paymode = "ALL";
                                                    });

                                                  }else if(val == "Ac/c Verification"){

                                                    setState(() {
                                                      paymode = "IMPS_VERIFY";
                                                    });

                                                  }else if(val == "IMPS" ){

                                                    setState(() {
                                                      paymode = getTranslated(context, 'IMPS') ;
                                                    });
                                                  }else if(val == "NEFT"){

                                                    setState(() {
                                                      paymode = "Online";
                                                    });
                                                  }else if(val == "Wallet"){

                                                    setState(() {
                                                      paymode = "Wallet";
                                                    });
                                                  }

                                                },
                                              ),
                                            ))

                                      ],
                                    ),
                                  )
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
                                          border: Border.all(width: 1,color: Colors.white),
                                          borderRadius: BorderRadius.circular(3)
                                      ),
                                      margin: EdgeInsets.only(left: 10),
                                      child: TextButton(

                                        onPressed: (){
                                          setState(() {
                                            filtervisi = true;
                                            upiconvis = true;
                                            downiconvis = false;
                                          });

                                        },
                                        child: Image.asset('assets/pngImages/downicon2.png',color: Colors.white,width: 30,),
                                      )
                                  ),
                                  replacement:Visibility(
                                      visible: upiconvis,
                                      child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              border: Border.all(width: 1,color: Colors.white),
                                              borderRadius: BorderRadius.circular(3)
                                          ),
                                          margin: EdgeInsets.only(left: 10),
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
                                                child: Image.asset('assets/pngImages/downicon2.png',color: Colors.white,width: 30,),
                                              )
                                            /*Image.asset(
                                                    'assets/pngImages/upicon2.png',
                                                    color: TextColor,),*/
                                          )
                                      )),
                                ),
                                Container(
                                  decoration: BoxDecoration (
                                      borderRadius: BorderRadius.circular(3),
                                      border: Border.all(
                                        color: TextColor,
                                      )
                                  ),
                                  margin: EdgeInsets.only(left: 5,right: 4),
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
                                  margin: EdgeInsets.only(left: 2,right: 2),
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
                                  margin: EdgeInsets.only(right: 3,left: 0),
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
                                  child:Visibility(
                                      visible: loadersho,
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
                                      replacement: IconButton(
                                        icon: Icon(
                                          Icons.search,
                                        ),
                                        iconSize: 25,
                                        color: TextColor,
                                        splashColor: Colors.purple,
                                        onPressed: () async{


                                          setState(() {
                                            loadersho =true;
                                          });
                                          frmDate = "${selectedDate2.toLocal()}".split(' ')[0];
                                          toDate = "${selectedDate.toLocal()}".split(' ')[0];

                                          originalItems.clear();
                                          items.clear();
                                          Impshistory(pageIndex.toString(),userid, frmDate, toDate, "Retailer", statuss,paymode,_rechanumber.text);


                                        },
                                      )
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
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    child: Container(
                      color: TextColor,
                      child: originalItems.length == 0 ? Container(
                          margin: EdgeInsets.only(top: 20,left: 10,right: 10),
                          child: Center(
                            child: AnimatedTextKit(
                              isRepeatingAnimation: false,
                              animatedTexts: [

                                TypewriterAnimatedText(
                                  '------',
                                  textStyle: const TextStyle(
                                    fontSize: 52.0,
                                    color: SecondaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  cursor: "",
                                  speed: const Duration(milliseconds: 1000),
                                ),
                                TypewriterAnimatedText(
                                  'No Data Found!',
                                  textStyle: const TextStyle(
                                    fontSize: 32.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  speed: const Duration(milliseconds: 1),
                                ),

                              ],
                            ),
                          )
                      ):
                      Container(
                        margin: EdgeInsets.only(left: 8,right: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ListView.builder(
                              controller: _controllerList,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              itemCount: (present <= originalItems.length) ? items.length + 1 : items.length,
                              itemBuilder: (BuildContext context, int index) {


                                if(index == items.length){

                                  return  originalItems.length > 20 ? Container(
                                    margin: EdgeInsets.only(top: 20),
                                    color:SecondaryColor,
                                    child: FlatButton(
                                      child: Text(getTranslated(context, 'Load More'),style: TextStyle(color: TextColor),),
                                      onPressed: () {
                                        setState(() {
                                          if((present + perPage )> originalItems.length) {
                                            items.addAll(originalItems.getRange(present, originalItems.length));
                                          } else {
                                            items.addAll(originalItems.getRange(present, present + perPage));
                                          }
                                          present = present + perPage;
                                        });
                                      },
                                    ),
                                  ) : Container(
                                    child: Text(""),
                                  );
                                }else{


                                  DateTime tempDate1 = DateTime.parse(items[index]["M_Date"].toString());
                                  String dattee = DateFormat.yMMMd().add_jm().format(tempDate1);

                                  String dattee2 = DateFormat.yMd().format(tempDate1);


                                  return Container(
                                    margin: EdgeInsets.only(top: 10),
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      border: Border.all(width: .5, color:items[index]["Status"] == "SUCCESS" ? Colors.green : items[index]["Status"] == "FAILED" ? Colors.red : items[index]["Status"] == "Pending" ? Colors.orange : Colors.deepPurple),
                                      boxShadow: [
                                        BoxShadow(
                                          color: PrimaryColor.withOpacity(0.08),
                                          blurRadius: .5,
                                          spreadRadius: 1,
                                          offset: Offset(0.0, .0), // shadow direction: bottom right
                                        )
                                      ],
                                    ),
                                    child: Container(
                                      child: ExpansionTile(
                                        tilePadding: EdgeInsets.zero,
                                        childrenPadding: EdgeInsets.zero,
                                        textColor: Colors.black,
                                        title: Container(
                                          child: Container(
                                            child: Column(
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
                                                              height: 30,
                                                              width: 30,
                                                              alignment: Alignment.center,

                                                              child: CircleAvatar(
                                                                  backgroundColor: Colors.transparent,
                                                                  child:items[index]["TransactionType"] == "IMPS_VERIFY" ?
                                                                  Image.asset("assets/pngImages/money-transfer.png",width: 25,height: 25,)
                                                                      :items[index]["TransactionType"] == "IMPS" ?
                                                                  Image.asset("assets/pngImages/money-transfer.png",width: 25,height: 25,)
                                                                      :items[index]["TransactionType"] == "Wallet" ?
                                                                  Image.asset("assets/pngImages/wallet2.png",width: 25,height: 25,)
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
                                                                    Visibility(
                                                                      visible: items[index]["BankName"].toString()== ""? true:false,
                                                                      child: Text(
                                                                        items[index]["Status"],
                                                                        style: TextStyle(fontSize: 12),
                                                                        textAlign: TextAlign.left,
                                                                      ),
                                                                      replacement: Container(
                                                                          child: Row(
                                                                            children: [
                                                                              Container(
                                                                                child: Expanded(
                                                                                  child: Text(
                                                                                    items[index]["BankName"],
                                                                                    style: TextStyle(fontSize: 9,fontWeight: FontWeight.bold),
                                                                                    textAlign: TextAlign.left,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: 1,),
                                                                    Text(
                                                                      items[index]["AccountNo"],
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
                                                    Expanded(
                                                      child: Container(
                                                        margin: EdgeInsets.only(bottom: 5),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            Flexible(
                                                              flex: 1,
                                                              child: Container(
                                                                margin: EdgeInsets.only(top: 4),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                  children: [
                                                                    Visibility(
                                                                      visible: items[index]["BankName"].toString()== ""? false:true,
                                                                      child: Container(
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                                          children: [
                                                                            Text(items[index]["Status"],style:TextStyle(fontSize: 11,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,textAlign: TextAlign.right,),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      replacement: Container(
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                                          children: [
                                                                            Text("Refunded",style:TextStyle(fontSize: 11,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,textAlign: TextAlign.right,),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: 1,),
                                                                    Text("\u{20B9} "+items[index]["Amount"].toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 4,
                                                            ),
                                                            items[index]["Status"] == "SUCCESS" ? Icon(Icons.check_circle,color: Colors.green,size: 40,) : items[index]["Status"] == "Pending" ? Icon(Icons.watch_later,color: Colors.yellow[800],size: 40,) :items[index]["Status"] == "FAILED" ? Icon(Icons.cancel_rounded,color: Colors.red,size: 40,):Icon(Icons.replay_circle_filled,color: Colors.deepPurple,size: 40,),


                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    items[index]["TransactionType"] == "IMPS_VERIFY" ?  Container(
                                                      width: MediaQuery.of(context).size.width * 0.15,
                                                      padding: EdgeInsets.only(left: 2,right: 2,top: 2,bottom: 1),
                                                      decoration: BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius: BorderRadius.circular(5)
                                                      ),
                                                      child: Text("Verified A/C",style: TextStyle(fontSize: 7,color: TextColor),textAlign: TextAlign.center,),
                                                    ) : Container(
                                                      width: MediaQuery.of(context).size.width * 0.15,
                                                      padding: EdgeInsets.only(left: 2,right: 2,top: 2,bottom: 1),
                                                      decoration: BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius: BorderRadius.circular(5)
                                                      ),
                                                      child: Text("Non Verify A/C",style: TextStyle(fontSize: 7,color: TextColor),textAlign: TextAlign.center,),
                                                    ),
                                                    Container(
                                                      width: MediaQuery.of(context).size.width * 0.77,
                                                      padding: EdgeInsets.only(left: 2,right: 2,top: 2,bottom: 1),
                                                      decoration: BoxDecoration(
                                                          color: items[index]["Status"] == "SUCCESS" ? Colors.green : items[index]["Status"] == "FAILED" ? Colors.red : items[index]["Status"] == "Pending" ? Colors.orange : Colors.deepPurple,
                                                          borderRadius: BorderRadius.circular(5)
                                                      ),
                                                      child: Center(
                                                          child: items[index]["Status"] == "SUCCESS" ? Text("T r a n s a c t i o n     A m o u n t    P a i d    S u c c e s s f u l l y",style: TextStyle(fontSize: 8,color: Colors.white)) : items[index]["Status"] == "Pending" ? Text("Y o u r   T r a n s a c t i o n   i n  Q u e u e   o r   P e n d i n g ",style: TextStyle(fontSize: 8,color: Colors.white)): items[index]["Status"] == "FAILED" ? Text("Y  o  u r    T r a n s a c t i o n    i  s    F  a  i  l  e  d ",style: TextStyle(fontSize: 8,color: Colors.white)) :Text("T r a n s a c t i o n    A m o u n t    S u c c e s s f u l l y    R e f u n d e d",style: TextStyle(fontSize: 8,color: Colors.white),)),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                Visibility(
                                                  visible: items[index]["Status"] == "SUCCESS" ? true : items[index]["Status"] == "FAILED" ? true : items[index]["Status"] == "Pending" ? true : false,
                                                  child: Container(
                                                    transform: Matrix4.translationValues(0.0, -2.0, 0.0),
                                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top: 0.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Flexible(
                                                                    flex: 1,
                                                                    child: Container(
                                                                      margin: EdgeInsets.only(top: 4),
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            "IFS CODE" ,
                                                                            softWrap: true,
                                                                            style:TextStyle(fontSize: 11,fontWeight: FontWeight.bold),
                                                                            textAlign: TextAlign.left,
                                                                          ),
                                                                          SizedBox(height: 1,),
                                                                          Text(
                                                                            items[index]["IFSC"],
                                                                            overflow: TextOverflow.ellipsis,
                                                                            maxLines: 1,
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
                                                          Expanded(
                                                            child: Container(
                                                              alignment: Alignment.centerRight,
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                children: [
                                                                  Text("Sender Info",style:TextStyle(fontSize: 11),overflow: TextOverflow.ellipsis,),
                                                                  SizedBox(height: 1,),
                                                                  Text(items[index]["Sender"],style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(top: 0,bottom: 3),
                                                  height: 1,
                                                  color: PrimaryColor.withOpacity(0.1),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(bottom: 1),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Visibility(
                                                        visible: items[index]["Status"] == "FAILED" ? true : items[index]["Status"] == "Pending" ? true : items[index]["Status"] == "SUCCESS" ? true : false,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              "Request Time",
                                                              style:TextStyle(fontSize: 11,fontWeight: FontWeight.bold),
                                                            ),
                                                            SizedBox(
                                                              height: 2,
                                                            ),
                                                            Text(
                                                              dattee,
                                                              style: TextStyle(fontSize: 14),
                                                              textAlign: TextAlign.end,
                                                            ),
                                                          ],
                                                        ),
                                                        replacement: Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              "Refund Time",
                                                              style:TextStyle(fontSize: 11,fontWeight: FontWeight.bold),
                                                            ),
                                                            SizedBox(
                                                              height: 2,
                                                            ),
                                                            Text(
                                                              dattee,
                                                              style: TextStyle(fontSize: 14),
                                                              textAlign: TextAlign.end,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Visibility(
                                                        visible: items[index]["Status"] == "SUCCESS" ? true : items[index]["Status"] == "FAILED" ? true : items[index]["Status"] == "Pending" ? true : false,
                                                        child: Container(
                                                          margin: EdgeInsets.only(left: 20),
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                "Transaction Mode",
                                                                style:TextStyle(fontSize: 11,fontWeight: FontWeight.bold,),textAlign: TextAlign.right,
                                                              ),
                                                              Text(
                                                                items[index]["TransactionType"] + " BY " + items[index]["TransactionDeviceType"].toString().toUpperCase(),
                                                                style:TextStyle(fontSize: 14),
                                                                textAlign: TextAlign.start,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Visibility(
                                                        visible: items[index]["Status"] == "FAILED" ? true : items[index]["Status"] == "Pending" ? false : items[index]["Status"] == "SUCCESS" ? false : true,
                                                        child: items[index]["Status"] == "FAILED" ? GestureDetector(
                                                          onTap: (){


                                                            setState(() {
                                                              items2.clear();
                                                            });

                                                            DateTime selectedDate2 = DateTime.now().subtract(const Duration(days: 30));

                                                            frmDate = "${selectedDate2.toLocal()}".split(' ')[0];
                                                            toDate = "${selectedDate.toLocal()}".split(' ')[0];


                                                            String numberr = items[index]["AccountNo"].toString();
                                                            String idno = items[index]["TransactionId"].toString();

                                                            trackrefrechargehistory(frmDate,toDate,numberr,idno);

                                                            //Navigator.push(context, MaterialPageRoute(builder: (context) => Trackpaymentrefund(frmdt: frmDate,todate: toDate,number: numberr,idno: idno,)));


                                                          },
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                  height: 34,
                                                                  width: 32,
                                                                  padding: EdgeInsets.only(left: 0.5,right: 0.5,top: 2,bottom: 2),
                                                                  decoration: BoxDecoration(
                                                                      color: SecondaryColor,
                                                                      border: Border.all(
                                                                          width: 0.5,
                                                                          color: Colors.red
                                                                      )
                                                                  ),
                                                                  child: Text("TRACK Refund Details",style: TextStyle(color: Colors.white,fontSize: 8),textAlign: TextAlign.center,)
                                                              )
                                                            ],
                                                          ),
                                                        ) : GestureDetector(
                                                          onTap: (){


                                                            setState(() {
                                                              items2.clear();
                                                            });

                                                            DateTime selectedDate2 = DateTime.now().subtract(const Duration(days: 30));

                                                            frmDate = "${selectedDate2.toLocal()}".split(' ')[0];
                                                            toDate = "${selectedDate.toLocal()}".split(' ')[0];

                                                            String numberr = items[index]["AccountNo"].toString();
                                                            String idno = items[index]["Status"].toString();


                                                            trackrefrechargehistory(frmDate,toDate,numberr,idno.replaceFirst("Rf-", ""));

                                                            //Navigator.push(context, MaterialPageRoute(builder: (context) => Trackpaymentrefund(frmdt: frmDate,todate: toDate,number: numberr,idno: idno,)));


                                                          },
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                  height: 34,
                                                                  width: 32,
                                                                  padding: EdgeInsets.only(left: 0.5,right: 0.5,top: 2,bottom: 2),
                                                                  decoration: BoxDecoration(
                                                                      color: SecondaryColor,
                                                                      border: Border.all(
                                                                          width: 0.5,
                                                                          color: Colors.deepPurple
                                                                      )
                                                                  ),
                                                                  child: Text("TRACK FAILED ENTRY",style: TextStyle(color: Colors.white,fontSize: 8),textAlign: TextAlign.center,)
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        replacement: GestureDetector(
                                                          onTap: (){

                                                            String date =  items[index]["M_Date"].toString();
                                                            String status = items[index]["Status"];
                                                            String amount = items[index]["Amount"].toString();
                                                            String number = items[index]["Sender"].toString();
                                                            String trnsid = items[index]["TransactionId"].toString();
                                                            String txntype = items[index]["TransactionType"];
                                                            String ifscc = items[index]["IFSC"].toString();
                                                            String bnkname = items[index]["BankName"];
                                                            String accnum = items[index]["AccountNo"].toString();

                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => PrintImpsdata(Number: number,status: status,date: date,trnsid: trnsid,amount: amount,txntype: txntype,accno: accnum,ifsc: ifscc,bnkname: bnkname,)));
                                                          },
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                  child: Icon(Icons.share,size: 19,)
                                                              ),
                                                              SizedBox(
                                                                height: 1,
                                                              ),
                                                              Container(
                                                                padding: EdgeInsets.only(left: 5,right: 5),
                                                                decoration: BoxDecoration(
                                                                    color: SecondaryColor,
                                                                    borderRadius: BorderRadius.circular(40)
                                                                ),
                                                                child: Text("Share",style: TextStyle(color: Colors.white,fontSize: 8),),
                                                              )
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
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(top: 0,bottom: 3),
                                                height: 1,
                                                color: PrimaryColor.withOpacity(0.1),
                                              ),
                                              Container(
                                                child: Container(
                                                  child: Container(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.only(top: 3,bottom: 0),
                                                          child:Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                    child: Container(
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "Request ID",
                                                                            style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold),
                                                                            overflow: TextOverflow.ellipsis,softWrap: true,textAlign: TextAlign.left,),
                                                                          SizedBox(height: 2,),
                                                                          Text(items[index]["TransactionId"].toString(),textAlign: TextAlign.right,)
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
                                                                            "Bank RRN",
                                                                            style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold),
                                                                            overflow: TextOverflow.ellipsis,softWrap: true,textAlign: TextAlign.right,),
                                                                          SizedBox(height: 2,),
                                                                          items[index]["BankRefId"] != "" ? Text(items[index]["BankRefId"].toString(),textAlign: TextAlign.right,) : Text("NO DATA",style: TextStyle(fontSize: 12),textAlign: TextAlign.right,)
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),

                                                                ],
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets.only(top: 5,bottom: 3),
                                                                height: 1,
                                                                color: PrimaryColor.withOpacity(0.1),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets.only(top: 3,bottom: 3),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Expanded(
                                                                      child: Container(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(getTranslated(context, 'Pre Balance') + " \u{20B9} ",
                                                                              textAlign: TextAlign.left,
                                                                              style:TextStyle(fontSize: 11,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                                            SizedBox(height: 2,),
                                                                            Text(items[index]["REM_Remain_Pre"].toString(),textAlign: TextAlign.right,)
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
                                                                            Text(getTranslated(context, 'Debit') + " \u{20B9}",style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                                            SizedBox(height: 2,),
                                                                            Text(items[index]["Debit"].toString(),textAlign: TextAlign.right,)
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
                                                                        alignment: Alignment.centerRight,
                                                                        child: Column(
                                                                          children: [
                                                                            Text(getTranslated(context, 'Post Balance') + " \u{20B9} ",style:TextStyle(fontSize: 11,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                                            SizedBox(height: 2,),
                                                                            Text(items[index]["REM_Remain_Post"].toString(),textAlign: TextAlign.right,)
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
                                                                        child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                                          children: [
                                                                            Text(getTranslated(context, 'My Earn') + " \u{20B9}",style:TextStyle(fontSize: 11,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,softWrap: true,textAlign: TextAlign.right,),
                                                                            SizedBox(height: 2,),
                                                                            items[index]["Income"] != null ? Text("\u{20B9} " + items[index]["Income"].toString(),textAlign: TextAlign.right,) : Text("NO DATA",style: TextStyle(fontSize: 12),textAlign: TextAlign.right,)
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
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],


                                      ),
                                    ),
                                  );

                                }

                              },
                            ),
                          ],
                        ),
                      ),
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
