import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/CommanWidget/buttons.dart';
import 'dart:convert';

import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';


class BusbookingHistoryPage extends StatefulWidget {
  const BusbookingHistoryPage({Key key}) : super(key: key);

  @override
  _BusbookingHistoryPageState createState() => _BusbookingHistoryPageState();
}

class _BusbookingHistoryPageState extends State<BusbookingHistoryPage> {
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

  String pnr;
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

  Future<void> BusHistory(String pgrind , String fromdate, String todate,String status) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    try{

      var uri =
      new Uri.http("api.vastwebindia.com", "/BUS/api/app/Bus/BusBookingReport", {
        "pageindex": pgrind,
        "pagesize": "500",
        "txt_frm_date": fromdate,
        "txt_to_date": todate,
        "ddl_status": status,
      });
      final http.Response response = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // ignore: missing_return
      ).timeout(Duration(seconds: 15), onTimeout: (){
        setState(() {
          _isloading = false;

        });
      });

      print(response);

      if (response.statusCode == 200) {
        _isloading = false;
        var data = json.decode(response.body);
        var datalist = data["Content"]["ADDINFO"]["Data"];

        if(data.length < 20){

          setState(() {
            present = 0;
            perPage = datalist.length;
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
          originalItems = datalist;
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
    BusHistory(pageIndex.toString(), frmDate, toDate,"ALL");
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
                alignment:  Alignment(-.4, 0),
                child: Text("Bus Booking History",style: TextStyle(color: TextColor),textAlign: TextAlign.center,)),
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
                                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: TextColor)),
                                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: TextColor)),
                                            errorBorder: OutlineInputBorder(borderSide: BorderSide(width: 1,color: TextColor)),
                                            border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: TextColor)),
                                            isDense: true,
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
                                                    isDense: true,
                                                    isCollapsed: true,
                                                    contentPadding: EdgeInsets.fromLTRB(8, 12, 8, 12),
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
                                              border: Border.all(width: 2,color: SecondaryColor),
                                              borderRadius: BorderRadius.circular(3)
                                            ),
                                            margin: EdgeInsets.only(left: 5),
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
                                              margin: EdgeInsets.only(left: 5),
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
                                          BusHistory(pageIndex.toString(), frmDate, toDate, statuss);


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
                            title: Container(
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
                              margin:
                              EdgeInsets.only(left: 0, right: 0, top: 6, bottom: 0),
                              padding: EdgeInsets.all(1.0),

                              child: Container(
                                color:Colors.white.withOpacity(0.5),
                                padding: EdgeInsets.all(4),

                                child: Column(
                                  children: [

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
                                                    Container(
                                                      height: 30,
                                                      width: 30,
                                                      alignment: Alignment.center,

                                                      child: CircleAvatar(
                                                          backgroundColor: Colors.transparent,
                                                          child: Image.asset('assets/pngImages/bus.png')
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
                                                              items[index]["BusOptName"],
                                                              style: TextStyle(fontSize: 12),
                                                              textAlign: TextAlign.left,
                                                            ),
                                                            SizedBox(height: 1,),
                                                            Text(
                                                              items[index]["PNR"].toString(),
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
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        items[index]["Status"] == "SUCCESS" ? Icon(Icons.check_circle,color: Colors.green,size: 14,) : items[index]["Status"] == "Proccessed" ? Icon(Icons.watch_later,color: Colors.yellow[800],size: 16,) : items[index]["Status"] == "FAILED" ? Icon(Icons.cancel,color: Colors.red,size: 16,) : Icon(Icons.refresh,color: Colors.deepOrangeAccent,size: 16,),

                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 3),
                                                          child: Text(items[index]["Status"],style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 1,),
                                                    Text("\u{20B9} "+items[index]["FareAmount"].toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
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
                                                              items[index]["PassengerName"],
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
                                                    Text("Bus ID".toUpperCase(),style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,),
                                                    SizedBox(height: 1,),
                                                    Text("\u{20B9} " + items[index]["BusId"].toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
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
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            Text("Boarding Location".toUpperCase(),style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,),
                                                            SizedBox(height: 1,),
                                                            Text(items[index]["BoardingLocation"],style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
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
                                                    Text("Droping Location".toUpperCase(),style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,),
                                                    SizedBox(height: 1,),
                                                    Text(items[index]["DropingLocation"],style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 0.0),
                                      child: Container(
                                        margin: EdgeInsets.only(top: 5),
                                        color:Colors.white.withOpacity(0.5),
                                        padding: EdgeInsets.only(bottom: 4,top: 4,left: 2,right: 2),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(getTranslated(context, 'Date') , style: TextStyle(fontSize: 16),),
                                            Text(
                                              items[index]["dateOfJourney"],
                                              style: TextStyle(fontSize: 16),
                                              textAlign: TextAlign.end,
                                            ),
                                          ],
                                        ),
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
                                                            children: [
                                                              Text(
                                                                getTranslated(context, 'Trace ID'),
                                                                style: TextStyle(fontSize: 12),
                                                                overflow: TextOverflow.ellipsis,softWrap: true,textAlign: TextAlign.right,),
                                                              SizedBox(height: 1,),
                                                              Text(items[index]["TraceId"].toString(),textAlign: TextAlign.right,)
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
                                                                getTranslated(context, 'Email Id').toUpperCase(),
                                                                style: TextStyle(fontSize: 12),
                                                                overflow: TextOverflow.ellipsis,softWrap: true,textAlign: TextAlign.right,),
                                                              SizedBox(height: 1,),
                                                              Text(items[index]["Email"],textAlign: TextAlign.right,)
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
                                                              Text("\u{20B9} " + items[index]["RemPre"].toString(),textAlign: TextAlign.right,)
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
                                                              Text("\u{20B9} " + items[index]["RemPost"].toString(),textAlign: TextAlign.right,)
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
                                                  /*Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          alignment: Alignment.centerLeft,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(getTranslated(context, 'GST'),textAlign: TextAlign.left,style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                              SizedBox(height: 1,),
                                                              Text("\u{20B9} " + items[index]["RemGst"].toString(),textAlign: TextAlign.right,)
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
                                                              Text(getTranslated(context, 'TDS'),style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                              SizedBox(height: 1,),
                                                              Text("\u{20B9} "+items[index]["RemTDS"].toString(),textAlign: TextAlign.right,)
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      *//*SizedBox(
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
                                                              Text(getTranslated(context, 'My Earn') + "\u{20B9}",style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                              SizedBox(height: 1,),
                                                              Text("\u{20B9} " + "",textAlign: TextAlign.right,)
                                                            ],
                                                          ),
                                                        ),
                                                      ),
*//*
                                                    ],
                                                  ),*/
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
