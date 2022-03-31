import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:http/http.dart' as http;

class RetailerAddMoney extends StatefulWidget {
  const RetailerAddMoney({Key key}) : super(key: key);

  @override
  _RetailerAddMoneyState createState() => _RetailerAddMoneyState();
}

class _RetailerAddMoneyState extends State<RetailerAddMoney> {


  List inforeport = [];

  String frmDate = "";
  String toDate = "";
  String duration = "";
  List<String> imagePaths = [];

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

  Future<void> retailerAddMoneyReport( String frmDate, String toDate) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url =
    new Uri.http("api.vastwebindia.com", "/UPI/api/data/Get_UPI_Transfer_History",{
      "txt_frm_date":frmDate,
      "txt_to_date":toDate,

    });
    final http.Response response = await http.post(
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

  var scr= new GlobalKey();
  static GlobalKey previewContainer = new GlobalKey();
  final _boundaryKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    frmDate = "${selectedDate2.toLocal()}".split(' ')[0];
    toDate = "${selectedDate.toLocal()}".split(' ')[0];
    retailerAddMoneyReport(frmDate,toDate);

   /* image = Image.asset('assets/pngImages/UPI.png', width: 20,);
    image = Image.asset('assets/pngImages/qr-code.png', width: 20,);*/

  }
  ScrollController _controllerList = new ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    /*precacheImage(image.image, context);*/
  }

  /*Image image;*/
  @override
  Widget build(BuildContext context) {

    return RepaintBoundary(

      child: SimpleAppBarWidget(
        title: Align(
            alignment:  Alignment(-.4, 0),
            child: Text(getTranslated(context, 'Add Money') ,style: TextStyle(color: TextColor),textAlign: TextAlign.center,)),
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
                                            padding:const EdgeInsets.all(4.0),
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
                                                  style: TextStyle(fontSize: 14, color: TextColor),
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
                                        retailerAddMoneyReport(frmDate, toDate);


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
                        /*DoteLoader(),*/
                        Text(getTranslated(context, 'No Data') ,style: TextStyle(fontWeight: FontWeight.bold),),
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
                                  color:Colors.white.withOpacity(0.5),
                                  padding: EdgeInsets.only(top: 0, bottom: 0, left: 5, right: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(top: 5, bottom: 5,),
                                        // decoration: BoxDecoration(
                                        //     border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1)))
                                        // ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(right: 5),
                                                  height: 20,
                                                  width: 20,
                                                  child: CircleAvatar(
                                                      backgroundColor: Colors.transparent,
                                                      child:inforeport[index]["Apinm"] == "SELF" ? Image.asset('assets/pngImages/UPI.png', width: 20,):
                                                      Image.asset('assets/pngImages/qr-code.png', width: 20,),
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(getTranslated(context, 'Transition Time') + ": ", softWrap: true, style: TextStyle(fontSize: 9,),),
                                                        Text(inforeport[index]["txndate"] == null ? "" :inforeport[index]["txndate"],overflow: TextOverflow.clip, style: TextStyle(fontSize: 9,),),
                                                      ],
                                                    ),
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(inforeport[index]["Apinm"] == "SELF" ?getTranslated(context, 'BY UPI') : getTranslated(context, 'By QR'),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: SecondaryColor,),),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [

                                                    Text(inforeport[index]["PayerName"],style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
                                                    Row(

                                                      children: [
                                                        Text(getTranslated(context, 'Amount'),style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text("\u{20B9} " + inforeport[index]["amt"].toString() == null ? "" :inforeport[index]["amt"].toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 3, bottom: 3,),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                alignment: Alignment.centerLeft,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    RichText(text: TextSpan(children: <InlineSpan>[
                                                      TextSpan(text: getTranslated(context, 'Pre Bal') +": ", style: TextStyle(fontSize: 12,color: Colors.black87)),
                                                      TextSpan(text: "\u{20B9}", style: TextStyle(fontSize: 12,color: Colors.black87,fontWeight: FontWeight.bold)),
                                                    ]),),
                                                    RichText(text: TextSpan(children: <InlineSpan>[
                                                      TextSpan(text: getTranslated(context, 'Wl') +": ", style: TextStyle(fontSize: 10,color: Colors.black87)),
                                                      TextSpan(text: inforeport[index]["remainpre"].toString() == null ? "" :inforeport[index]["remainpre"].toString(), style: TextStyle(fontSize: 10,color: Colors.black87,fontWeight: FontWeight.bold)),
                                                    ]),),
                                                    /*RichText(text: TextSpan(children: <InlineSpan>[
                                                      TextSpan(text: "Cr: ", style: TextStyle(fontSize: 10,color: Colors.black87)),
                                                      TextSpan(text: "0.00", style: TextStyle(fontSize: 10,color: Colors.black87,fontWeight: FontWeight.bold)),
                                                    ]),),*/
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border(left: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1)),
                                                      right: BorderSide(width: 0.5,color: PrimaryColor.withOpacity(0.1)),)
                                                ),
                                                alignment: Alignment.center,
                                                child: Column(
                                                  children: [
                                                    Text(getTranslated(context, 'Charges'),style: TextStyle(fontSize: 14),),
                                                    Text("\u{20B9} " + inforeport[index]["charge"].toString() == null ? "" :inforeport[index]["charge"].toString() ,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
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
                                                    RichText(text: TextSpan(children: <InlineSpan>[
                                                      TextSpan(text: getTranslated(context, 'Post Bal') + ": ", style: TextStyle(fontSize: 12,color: Colors.black87)),
                                                      TextSpan(text: "\u{20B9}", style: TextStyle(fontSize: 12,color: Colors.black87,fontWeight: FontWeight.bold)),
                                                    ]),),
                                                    RichText(text: TextSpan(children: <InlineSpan>[
                                                      TextSpan(text: getTranslated(context, 'Wl') +": ", style: TextStyle(fontSize: 10,color: Colors.black87)),
                                                      TextSpan(text: inforeport[index]["remainpost"].toString() == null ? "" :inforeport[index]["remainpost"].toString(), style: TextStyle(fontSize: 10,color: Colors.black87,fontWeight: FontWeight.bold)),
                                                    ]),),
                                                    /*RichText(text: TextSpan(children: <InlineSpan>[
                                                      TextSpan(text: "Cr: ", style: TextStyle(fontSize: 10,color: Colors.black87)),
                                                      TextSpan(text: "0.00", style: TextStyle(fontSize: 10,color: Colors.black87,fontWeight: FontWeight.bold)),
                                                    ]),),*/
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border(left: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1)),
                                                      right: BorderSide(width: 0.5,color: PrimaryColor.withOpacity(0.1)),)
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Text(getTranslated(context, 'Status'),style: TextStyle(fontSize: 14),),
                                                    Text("\u{20B9} " + inforeport[index]["status"].toString() == null ? "" :inforeport[index]["status"].toString() ,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)
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
      ),// Your Widgets to be captured.
    );


  }
}

mixin _controllerList {
}
