import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'dart:convert';

import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/Shareaepshistory.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';


class Aepshistorypage extends StatefulWidget {
  const Aepshistorypage({Key key}) : super(key: key);

  @override
  _AepshistorypageState createState() => _AepshistorypageState();
}

class _AepshistorypageState extends State<Aepshistorypage> {
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

  int id = 1;
  bool idpr = false;
  String statuss = "ALL";
  String paymode = "ALL";

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
        firstDate: DateTime(1980),
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

  Future<void> Aepshistory(String pgrind ,String retailerid, String fromdate, String todate,String status, String trantypr, String number) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    try{

      var uri =
      new Uri.http("api.vastwebindia.com", "/AEPS/api/data/Retailer_Aeps_Report", {
        "pageindex": pgrind,
        "pagesize": "500",
        "userid": retailerid,
        "txt_frm_date": fromdate,
        "txt_to_date": todate,
        "ddl_status": status,
        "amount":"",
        "BankId":"",
        "aadhar": "",
        "Type":trantypr,
        "userserch_acc_mob":number
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
    userid = await storage.read(key: "userId");
    Aepshistory(pageIndex.toString(),userid, frmDate, toDate, "ALL","ALL","ALL");
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
                child: Text(
                  getTranslated(context, 'Aeps History'),
                  style: TextStyle(
                      color: TextColor
                  ),
                  textAlign: TextAlign.center,),
            ),
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
                                            border:OutlineInputBorder(borderSide: BorderSide(width: 1,color: TextColor)),
                                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: TextColor)),
                                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: TextColor)),
                                            contentPadding: EdgeInsets.only(top: 8,bottom: 8,left: 10),
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

                                                margin: EdgeInsets.only(left: 0),
                                                padding: EdgeInsets.only(top: 10, left: 0, right: 0),
                                                child: DropdownButtonFormField<String>(
                                                  dropdownColor: PrimaryColor,
                                                  iconEnabledColor: TextColor,
                                                  decoration: InputDecoration(
                                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: TextColor)),
                                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: TextColor)),
                                                    errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: TextColor)),
                                                    border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: TextColor)),
                                                    labelText: getTranslated(context, 'Select Status'),
                                                    isDense: true,
                                                    isCollapsed: true,
                                                    hintStyle: TextStyle(color: TextColor),
                                                    labelStyle: TextStyle(color: TextColor),
                                                    contentPadding: EdgeInsets.fromLTRB(8, 10, 8, 10),
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
                                            SizedBox(width: 10,),
                                            Expanded(
                                                child: Container(
                                                  padding: EdgeInsets.only(top: 10, left: 0, right: 0),
                                                  child: DropdownButtonFormField<String>(
                                                    dropdownColor: PrimaryColor,
                                                    isExpanded: true,
                                                    iconEnabledColor: TextColor,
                                                    decoration: InputDecoration(
                                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: TextColor)),
                                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: TextColor)),
                                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: TextColor)),
                                                      border: OutlineInputBorder(),
                                                      labelText:getTranslated(context, 'Service Mode'),
                                                      isCollapsed: true,
                                                      isDense: false,
                                                      labelStyle: TextStyle(color: TextColor),
                                                      contentPadding: EdgeInsets.fromLTRB(8, 10, 8, 10),
                                                    ),
                                                    items:["All","Cash Widthdraw","Aadhar Pay","Mini StateMent","Balance"].map((item) {
                                                      return DropdownMenuItem(
                                                        child: Text(item,style: TextStyle(color: TextColor),),
                                                        value: item,
                                                      );
                                                    })?.toList() ??
                                                        [],
                                                    onChanged: (String val) {

                                                      if(val == "All"){

                                                        setState(() {
                                                          paymode = "ALL";
                                                        });

                                                      }else if(val == "Cash Widthdraw"){

                                                        setState(() {
                                                          paymode = "Cash Widthdraw";
                                                        });

                                                      }else if(val == "Mini StateMent"){

                                                        setState(() {
                                                          paymode = "Mini StateMent";
                                                        });
                                                      }else if(val == "Aadhar Pay"){

                                                        setState(() {
                                                          paymode = "Aadhar Pay";
                                                        });
                                                      }else if(val == "Balance"){

                                                        setState(() {
                                                          paymode = "Balance";
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
                                padding: EdgeInsets.only(top: 10,bottom: 8),
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
                                      decoration: BoxDecoration(

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
                                      margin: EdgeInsets.only(left: 3,right: 3),
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
                                            color: SecondaryColor
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
                                          toDate  = "${selectedDate.toLocal()}".split(' ')[0];

                                          originalItems.clear();
                                          items.clear();

                                          if(_rechanumber.text == ""){
                                            _rechanumber.text = "ALL";
                                          }

                                          Aepshistory(pageIndex.toString(),userid, frmDate, toDate, statuss,paymode,_rechanumber.text);

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
                  ):Column(
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

                            DateTime tempDate1 = DateTime.parse(items[index]["Reqesttime"].toString());
                            String dattee = DateFormat.yMMMd().add_jm().format(tempDate1);

                            return  Container(
                              margin: EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                border: Border.all(width: .5, color:items[index]["Status"] == "Done" ? Colors.green : items[index]["Status"] == "Failed" ? Colors.red : items[index]["Status"] == "Pending" ? Colors.orange :items[index]["Status"] == "M_Failed"? Colors.red : items[index]["Status"] == "M_Success"? Colors.cyan: Colors.brown),
                                boxShadow: [
                                  BoxShadow(
                                    color: PrimaryColor.withOpacity(0.08),
                                    blurRadius: .5,
                                    spreadRadius: 1,
                                    offset: Offset(0.0, .0), // shadow direction: bottom right
                                  )
                                ],
                              ),
                              child: ExpansionTile(
                                tilePadding: EdgeInsets.zero,
                                childrenPadding: EdgeInsets.zero,
                                textColor: Colors.black,
                                title: Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        transform: Matrix4.translationValues(0.0, -2.0, 0.0),
                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: Padding(
                                          padding:EdgeInsets.only(top: 0.0),
                                          child: Row(
                                            children:[
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(bottom: 5),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children:[
                                                      Container(
                                                        height: 30,
                                                        width: 30,
                                                        child: CircleAvatar(
                                                            backgroundColor: Colors.transparent,
                                                            child:items[index]["TYPE"] == "Balance" ?
                                                            Image.asset('assets/pngImages/Check-Bal.png')
                                                                :items[index]["TransactionType"] == "Aadhar Pay" ?
                                                            Image.asset('assets/pngImages/Aadhaar-Pay.png')
                                                                :items[index]["TYPE"] == "Mini StateMent" ?
                                                            Image.asset('assets/pngImages/Mini-ststment.png')
                                                                :Image.asset("assets/pngImages/Aeps.png")
                                                        ),

                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Flexible(
                                                        child: Container(
                                                          margin: EdgeInsets.only(top: 4),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                items[index]["BankName"] == "" ? getTranslated(context, 'No Name'):items[index]["BankName"],
                                                                style: TextStyle(fontSize: 12),
                                                                textAlign: TextAlign.left,
                                                              ),
                                                              SizedBox(height: 1,),
                                                              Container(
                                                                width: 200,
                                                                child: Text(
                                                                  items[index]["BankId"] == null ? "....." : items[index]["BankId"],
                                                                  textAlign: TextAlign.left,
                                                                  maxLines: 1,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: TextStyle(fontSize: 14),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        items[index]["Status"] == "Done" ? Icon(Icons.check_circle,color: Colors.green,size: 14,) : items[index]["Status"] == "M_Pending" ? Icon(Icons.watch_later,color: Colors.yellow[800],size: 16,) :items[index]["Status"] == "Failed" ?Icon(Icons.cancel,color: Colors.red,size: 16,) : items[index]["Status"] == "M_Failed" ?Icon(Icons.cancel,color: Colors.red,size: 16,) : items[index]["Status"] == "M_Success" ? Icon(Icons.check_circle,color: Colors.red,size: 16,)  :Image.asset('assets/pngImages/balanceinq.png', height:16,width: 16,),
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 3),
                                                          child: Text(items[index]["Status"] == "Done" ? "Success" : items[index]["Status"] == "Balance" ? "Balance Enquiry" : items[index]["Status"] == "M_Success" ? "Success" : items[index]["Status"] == "M_Failed" ? "Failed" : items[index]["Status"],style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 1,),
                                                    Text("\u{20B9} "+items[index]["Amount"].toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 0,bottom: 3),
                                        height: 1,
                                        color: PrimaryColor.withOpacity(0.1),
                                      ),
                                      Container(
                                        transform: Matrix4.translationValues(0.0, -2.0, 0.0),
                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 0.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(bottom: 5),
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
                                                                getTranslated(context, 'Mobile No'),
                                                                softWrap: true,
                                                                style: TextStyle(fontSize: 12),
                                                                textAlign: TextAlign.left,
                                                              ),
                                                              SizedBox(height: 1,),
                                                              Text(
                                                                items[index]["Mobile"],
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
                                              Expanded(
                                                child: Container(
                                                  alignment: Alignment.centerRight,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text("Consumer Aadhar",style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,),
                                                      SizedBox(height: 1,),
                                                      Text(items[index]["AccountHolderAadhar"],style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(left: 2,right: 2,top: 2,bottom: 1),
                                          decoration: BoxDecoration(
                                              color: items[index]["Status"] == "Done" ? Colors.green : items[index]["Status"] == "Failed" ? Colors.red : items[index]["Status"] == "Pending" ? Colors.orange : items[index]["Status"] == "M_Success" ? Colors.cyan : items[index]["Status"] == "M_Failed" ? Colors.red :Colors.brown,

                                          ),
                                          child: Center(
                                              child: items[index]["Status"] == "Done" ? Text("T r a n s a c t i o n     A m o u n t    P a i d    S u c c e s s f u l l y",style: TextStyle(fontSize: 8,color: Colors.white)) : items[index]["Status"] == "Pending" ? Text("Y o u r   T r a n s a c t i o n   i n  Q u e u e   o r   P e n d i n g ",style: TextStyle(fontSize: 8,color: Colors.white)): items[index]["Status"] == "Failed" ? Text("Y  o  u r    T r a n s a c t i o n    i  s    F  a  i  l  e  d ",style: TextStyle(fontSize: 8,color: Colors.white)) : items[index]["Status"] == "M_Success" ? Text("M i n i  -  S t a t e m e n t  C h e c k e d  S u c c e s s f u l l y ",style: TextStyle(fontSize: 8,color: Colors.white)) : items[index]["Status"] == "Balance" ? Text("B a l a n c e   E n q u i r y ",style: TextStyle(fontSize: 8,color: Colors.white)) :items[index]["Status"] == "M_Failed" ? Text("M i n i  -  S t a t e m e n t  C h e c k e d  F a i l e d ",style: TextStyle(fontSize: 8,color: Colors.white)) :Text(""))),
                                      SizedBox(
                                        height: 10,
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
                                            Container(
                                              margin: EdgeInsets.only(left: 20),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Transaction Mode",
                                                    style:TextStyle(fontSize: 11,fontWeight: FontWeight.bold,),textAlign: TextAlign.right,
                                                  ),
                                                  Text(
                                                    items[index]["TYPE"] + " By " + items[index]["TransactionType"],
                                                    style:TextStyle(fontSize: 14),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: (){

                                                String date =  items[index]["Reqesttime"].toString();
                                                String status =  items[index]["Status"];
                                                String amount = items[index]["Amount"].toString();
                                                String number = items[index]["Mobile"].toString();
                                                String trnsid = items[index]["MerchantTxnId"].toString();
                                                String txntype = items[index]["TYPE"];
                                                String aadhar = items[index]["AccountHolderAadhar"].toString();
                                                String bnkname = items[index]["BankName"];
                                                String accnum = items[index]["BankId"].toString();

                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => Printaepsdata(Number: number,status: status,date: date,trnsid: trnsid,amount: amount,txntype: txntype,accno: accnum,aadharnum: aadhar,bnkname: bnkname,)));

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
                                          ],
                                        ),
                                      ),
                                    ],
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
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child:Column(
                                                children: [
                                                  Container(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [

                                                        Text(
                                                          getTranslated(context, 'TXN ID'),
                                                          style: TextStyle(fontSize: 16),
                                                        ),

                                                        Expanded(
                                                          child: Container(
                                                            margin: EdgeInsets.only(left: 10),
                                                            child: Text(
                                                              items[index]["MerchantTxnId"],
                                                              style: TextStyle(fontSize: 16),
                                                              textAlign: TextAlign.left,
                                                              overflow: TextOverflow.clip,
                                                            ),
                                                          ),
                                                        ),

                                                      ],
                                                    ),
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
                                                              Text("Pos Pre" + " \u{20B9} ",textAlign: TextAlign.left,style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                              SizedBox(height: 1,),
                                                              Text(items[index]["REM_Remain_Pre"].toString(),textAlign: TextAlign.right,)
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
                                                              Text("Net Amt" + " \u{20B9}" ,style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                              SizedBox(height: 1,),
                                                              Text(items[index]["Total"].toString(),textAlign: TextAlign.right,)
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
                                                              Text("Earn" + " \u{20B9}" ,style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                              SizedBox(height: 1,),
                                                              Text(items[index]["Rem_Income"].toString(),textAlign: TextAlign.right,)
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
                                                              Text("Cr / Dr" + " \u{20B9}" ,style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                              SizedBox(height: 1,),
                                                              Text(items[index]["CR"].toString(),textAlign: TextAlign.right,)
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
                                                              Text("Pos Post" + " \u{20B9}",style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                              SizedBox(height: 1,),
                                                              Text(items[index]["REM_Remain_Post"].toString(),textAlign: TextAlign.right,)
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
                                    ],
                                  ),
                                ],
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
      ),
    );

  }


}
