import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:http/http.dart'as http;
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'dart:ui' as ui;
import 'package:sticky_headers/sticky_headers/widget.dart';

import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';






class DealerDayBook extends StatefulWidget {
  const DealerDayBook({Key key}) : super(key: key);

  @override
  _DealerDayBookState createState() => _DealerDayBookState();
}

class _DealerDayBookState extends State<DealerDayBook> {



  List inforeport = [];

  String frmDate = "";
  String toDate = "";
  String duration = "";
  String countdays = "";
  /*String count1 = "";
  String integer1 = "";
  int a =1;*/

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


  Future<void> dealerDayBook( String frmDate,String toDate) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url =
    new Uri.http("api.vastwebindia.com", "/api/Dealer/Dealer_Daybook_Report",{
      "txt_frm_date":frmDate,
      "to":toDate,

    });
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
      var report1 = data["Report"];

      for(var i=0;i<report1.length; i++){

        var dayOld = report1["DayBook_Old"];
        var dayLive = report1["DayBookLive"];

        if(dayLive == null){

          setState(() {
            inforeport = dayOld;
          });

        }else{

          setState(() {

            inforeport = dayLive;


          });

        }

      }

    } else {
      throw Exception('Failed to load themes');
    }
  }

  var scr= new GlobalKey();
  static GlobalKey previewContainer = new GlobalKey();
  final _boundaryKey = GlobalKey();

  _onShareData(BuildContext context) async {

    final RenderBox box = context.findRenderObject();

    if (imagePaths.isNotEmpty) {

      await Share.shareFiles(imagePaths,
          text: "",
          subject: "",
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    } else {
      await Share.share("",
          subject: "",
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }
  static GlobalKey _globalKey = GlobalKey();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    image = Image.asset('assets/pngImages/opening_balance.png', width: 15,);
    image1 = Image.asset('assets/pngImages/mobile-phone.png', width: 15,);
    image2 = Image.asset('assets/pngImages/Pos.png', width: 15,);
    image3 = Image.asset('assets/pngImages/Aeps.png', width: 15,);
    image4 = Image.asset('assets/pngImages/money-transfer.png', width: 15,);
    image5 = Image.asset('assets/pngImages/pancard.png', width: 15,);
    image6 = Image.asset('assets/pngImages/refund.png', width: 15,);
    image7 = Image.asset('assets/pngImages/cancel.png', width: 15,);
    image8 = Image.asset('assets/pngImages/close-balance.png', width: 15,);
    image9 = Image.asset('assets/pngImages/compare.png', width: 15,);


    frmDate = "${selectedDate2.toLocal()}".split(' ')[0];
    toDate = "${selectedDate.toLocal()}".split(' ')[0];

    dealerDayBook(frmDate,toDate);
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(image.image, context);
    precacheImage(image1.image, context);
    precacheImage(image2.image, context);
    precacheImage(image3.image, context);
    precacheImage(image4.image, context);
    precacheImage(image5.image, context);
    precacheImage(image6.image, context);
    precacheImage(image7.image, context);
    precacheImage(image8.image, context);
    precacheImage(image9.image, context);
  }

  ScrollController _controllerList = new ScrollController();
  Image image;
  Image image1;
  Image image2;
  Image image3;
  Image image4;
  Image image5;
  Image image6;
  Image image7;
  Image image8;
  Image image9;




  @override
  Widget build(BuildContext context) {
    String pickedFile = imagePaths ==null?"":imagePaths.toString();
    String trimmedFileName = pickedFile.split("/").last;
    return RepaintBoundary(
      key: previewContainer,
      child: Material(
        color: PrimaryColor,
        child: Container(
          color: TextColor.withOpacity(0.5),
          child: SafeArea(
            child: Scaffold(
              backgroundColor: TextColor,
              appBar: AppBar(
                title: Container(margin: EdgeInsets.only(left: 50),
                    child: Text(getTranslated(context, 'Day Book'),style: TextStyle(color: TextColor),textAlign: TextAlign.center,)),
                backgroundColor: PrimaryColor,
                toolbarHeight: 39,
                elevation: 0,
                leading: BackButtonsApBar(),
                leadingWidth: 60,
                actions:[
                  Transform.translate(
                    offset: Offset(5.0, 0.0),
                    child: Container(
                      width: 70,
                      padding: EdgeInsets.only(top: 5,bottom: 5,right: 5),
                      child: FlatButton(
                        color: TextColor,
                        shape:RoundedRectangleBorder(side: BorderSide(
                            color: TextColor,
                            width: 1,
                            style: BorderStyle.solid
                        ),borderRadius: new BorderRadius.circular(2),),
                        padding: EdgeInsets.only(left: 0,right: 0,),
                        onPressed: () async{

                          RenderRepaintBoundary boundary = previewContainer.currentContext.findRenderObject();
                          ui.Image image = await boundary.toImage();
                          final directory = (await getApplicationDocumentsDirectory()).path;
                          ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
                          Uint8List pngBytes = byteData.buffer.asUint8List();
                          print(pngBytes);
                          File imgFile =new File('$directory/ddd.png');
                          imgFile.writeAsBytes(pngBytes);

                          final result = await ImageGallerySaver.saveImage(pngBytes);

                          final imagePicker = ImagePicker();
                          final pickedFile = await imagePicker.getImage(
                            source: ImageSource.gallery,
                          );
                          if (pickedFile != null) {
                            setState(() {
                              imagePaths.add(pickedFile.path);
                            });
                          }

                          _onShareData(context);


                          // captur();

                        },
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.share,color: SecondaryColor,size: 14,),
                            SizedBox(width: 2,),
                            Text(
                              getTranslated(context, 'Share') ,
                              style: TextStyle(fontSize: 12,fontWeight: FontWeight.normal,letterSpacing: -0.5,),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    margin: EdgeInsets.only(top: 8,bottom: 8,left: 4,right: 5),),
                ],
              ),
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
                                              dealerDayBook(frmDate,toDate);

                                              
                                              final difference = (selectedDate.difference(selectedDate2).inDays);
                                              
                                              countdays = difference.toString();
                                              /*integer1 = a.toString();*/


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
                                                  Expanded(
                                                    child: Container(
                                                      child: Row(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                getTranslated(context, 'From Date'), softWrap: true, style: TextStyle(fontSize: 10,),
                                                              ),
                                                              Text(frmDate,overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Text(getTranslated(context, 'Duration') ,style: TextStyle(fontSize: 10,),),
                                                              Text(countdays + "Days",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                            children: [
                                                              Text(getTranslated(context, 'To Date'),style: TextStyle(fontSize: 10,),),
                                                              Text(toDate,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)
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
                                        padding: EdgeInsets.only(top: 0, bottom: 5, left: 5, right: 5),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Visibility(
                                              visible: inforeport[index]["openbal"] == 0.000 ?false:true,
                                              child: Container(
                                                padding: EdgeInsets.only(top: 5, bottom: 5,),
                                                decoration: BoxDecoration(
                                                    border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1)))
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.only(right: 5),
                                                          height: 15,
                                                          width: 15,
                                                          child: CircleAvatar(
                                                              backgroundColor: Colors.transparent,
                                                              child:image
                                                          ),
                                                        ),
                                                        Text (getTranslated(context, 'Opening Balance') ,style: TextStyle(fontSize: 12,),),
                                                      ],
                                                    ),
                                                    Text ("\u{20B9} " + inforeport[index]["openbal"].toString() == "" ? "..." :"\u{20B9} " + inforeport[index]["openbal"].toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,),),

                                                  ],
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: inforeport[index]["RCH"] == 0.0 ? false :true,
                                              child: Container(
                                                padding: EdgeInsets.only(top: 5, bottom: 5,),
                                                decoration: BoxDecoration(
                                                    border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1)))
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.only(right: 5),
                                                          height: 15,
                                                          width: 15,
                                                          child: CircleAvatar(
                                                              backgroundColor: Colors.transparent,
                                                              child:image1
                                                          ),
                                                        ),
                                                        Text (getTranslated(context, 'Recharge') ,style: TextStyle(fontSize: 12,),),
                                                      ],
                                                    ),
                                                    Text ("\u{20B9} " + inforeport[index]["RCH"].toString() == "" ? "..." :"\u{20B9} " +inforeport[index]["RCH"].toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,),),

                                                  ],
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: inforeport[index]["PURCHASE"] == 0.0 ? false:true,
                                              child: Container(
                                                padding: EdgeInsets.only(top: 5, bottom: 5,),
                                                decoration: BoxDecoration(
                                                    border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1)))
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.only(right: 5),
                                                          height: 15,
                                                          width: 15,
                                                          child: CircleAvatar(
                                                              backgroundColor: Colors.transparent,
                                                              child:image2
                                                          ),
                                                        ),
                                                        Text (getTranslated(context, 'Purchase') ,style: TextStyle(fontSize: 12,),),
                                                      ],
                                                    ),
                                                    Text ("\u{20B9} " + inforeport[index]["PURCHASE"].toString() == null ? "0 0 0" : "\u{20B9} " +inforeport[index]["PURCHASE"].toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,),),

                                                  ],
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: inforeport[index]["AEPS"] == 0.0 ? false:true,
                                              child: Container(
                                                padding: EdgeInsets.only(top: 5, bottom: 5,),
                                                decoration: BoxDecoration(
                                                    border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1)))
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.only(right: 5),
                                                          height: 15,
                                                          width: 15,
                                                          child: CircleAvatar(
                                                              backgroundColor: Colors.transparent,
                                                              child:image3
                                                          ),
                                                        ),
                                                        Text (getTranslated(context, 'Aeps') ,style: TextStyle(fontSize: 12,),),
                                                      ],
                                                    ),
                                                    Text ("\u{20B9} " + inforeport[index]["AEPS"].toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,),),

                                                  ],
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: inforeport[index]["IMPS"] == 0.0 ? false:true,
                                              child: Container(
                                                padding: EdgeInsets.only(top: 5, bottom: 5,),
                                                decoration: BoxDecoration(
                                                    border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1)))
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.only(right: 5),
                                                          height: 15,
                                                          width: 15,
                                                          child: CircleAvatar(
                                                              backgroundColor: Colors.transparent,
                                                              child:image4
                                                          ),
                                                        ),
                                                        Text (getTranslated(context, 'IMPS') ,style: TextStyle(fontSize: 12,),),
                                                      ],
                                                    ),
                                                    Text ("\u{20B9} " +inforeport[index]["IMPS"].toString() == null ?"..." :"\u{20B9} " + inforeport[index]["IMPS"].toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,),),

                                                  ],
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: inforeport[index]["PAN"] ==0.0 ?false:true,
                                              child: Container(
                                                padding: EdgeInsets.only(top: 5, bottom: 5,),
                                                decoration: BoxDecoration(
                                                    border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1)))
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.only(right: 5),
                                                          height: 15,
                                                          width: 15,
                                                          child: CircleAvatar(
                                                              backgroundColor: Colors.transparent,
                                                              child:image5
                                                          ),
                                                        ),
                                                        Text(getTranslated(context, 'PAN') ,style: TextStyle(fontSize: 12,),),
                                                      ],
                                                    ),
                                                    Text ("\u{20B9} " + inforeport[index]["PAN"].toString() ==null ? "..." : "\u{20B9} " + inforeport[index]["PAN"].toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,),),

                                                  ],
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: inforeport[index]["OLDDAYREFUND"] == 0.0 ?false:true,
                                              child: Container(
                                                padding: EdgeInsets.only(top: 5, bottom: 5,),
                                                decoration: BoxDecoration(
                                                    border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1)))
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.only(right: 5),
                                                          height: 15,
                                                          width: 15,
                                                          child: CircleAvatar(
                                                              backgroundColor: Colors.transparent,
                                                              child:image6
                                                          ),
                                                        ),
                                                        Text (getTranslated(context, 'Old Day Refund') ,style: TextStyle(fontSize: 12,),),
                                                      ],
                                                    ),
                                                    Text ("\u{20B9} " + inforeport[index]["OLDDAYREFUND"].toString() ==null ? "..." : "\u{20B9} " + inforeport[index]["OLDDAYREFUND"].toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,),),

                                                  ],
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: inforeport[index]["OLDDAYFAILED"] ==0.0 ?false:true,
                                              child: Container(
                                                padding: EdgeInsets.only(top: 5, bottom: 5,),
                                                decoration: BoxDecoration(
                                                    border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1)))
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.only(right: 5),
                                                          height: 15,
                                                          width: 15,
                                                          child: CircleAvatar(
                                                              backgroundColor: Colors.transparent,
                                                              child:image7
                                                          ),
                                                        ),
                                                        Text (getTranslated(context, 'Old Day Failed') ,style: TextStyle(fontSize: 12,),),
                                                      ],
                                                    ),
                                                    Text ("\u{20B9} " + inforeport[index]["OLDDAYFAILED"].toString() ==null ? "..." : "\u{20B9} " + inforeport[index]["OLDDAYFAILED"].toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,),),

                                                  ],
                                                ),
                                              ),
                                            ),

                                            Container(
                                              color:Colors.white.withOpacity(0.5),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(top: 5, bottom: 5,left: 5,right: 5),
                                                    decoration:inforeport[index]["DIFF"] != 0.0 ? BoxDecoration(
                                                        color: Colors.red.withOpacity(0.7)
                                                    ):BoxDecoration(color: Colors.transparent),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets.only(right: 5),
                                                              height: 15,
                                                              width: 15,
                                                              child: CircleAvatar(
                                                                  backgroundColor: Colors.transparent,
                                                                  child:image9
                                                              ),
                                                            ),
                                                            Text (getTranslated(context, 'Other Differance') ,style:  inforeport[index]["DIFF"] != 0.0  ? TextStyle(fontSize: 12,color: TextColor):TextStyle(fontSize: 12,color: PrimaryColor),),
                                                          ],
                                                        ),
                                                        Text ("\u{20B9} " + inforeport[index]["DIFF"].toString() ==null ? "..." : "\u{20B9} " + inforeport[index]["DIFF"].toString(),style: inforeport[index]["DIFF"] != 0.0   ? TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: TextColor):TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: PrimaryColor),),

                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Visibility(
                                              visible: inforeport[index]["closebal"] == 0.0 ? false:true ,
                                              child: Container(
                                                padding: EdgeInsets.only(top: 5, bottom: 5,),
                                                // decoration: BoxDecoration(
                                                //     border: Border(bottom: BorderSide(width: 1,color: PrimaryColor.withOpacity(0.1)))
                                                // ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.only(right: 5),
                                                          height: 15,
                                                          width: 15,
                                                          child: CircleAvatar(
                                                              backgroundColor: Colors.transparent,
                                                              child:image8
                                                          ),
                                                        ),
                                                        Text (getTranslated(context, 'Close balance') ,style: TextStyle(fontSize: 12,),),
                                                      ],
                                                    ),
                                                    Text ("\u{20B9} " + inforeport[index]["closebal"].toString() ==null ? "..." : "\u{20B9} " + inforeport[index]["closebal"].toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,),),

                                                  ],
                                                ),
                                              ),
                                            )
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
            ),
          ),
        ),
      ),
      // Your Widgets to be captured.
    );
  }
}