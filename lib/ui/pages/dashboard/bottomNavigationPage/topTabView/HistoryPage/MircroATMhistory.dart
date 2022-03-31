import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/Sharematmhistory.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';


class MATMhistorypage extends StatefulWidget {
  const MATMhistorypage({Key key}) : super(key: key);

  @override
  _MATMhistorypageState createState() => _MATMhistorypageState();
}

class _MATMhistorypageState extends State<MATMhistorypage> {
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

  String bankrrn = "";

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

  Future<void> Matmhistory(String pgrind ,String retailerid, String fromdate, String todate, String role,String status, String trantypr, String sendnum) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    try{

      var uri =
      new Uri.http("api.vastwebindia.com", "/MICROATM/api/data/MIcroAtmReport", {
        "ddl_status": status,
        "txt_frm_date": fromdate,
        "txt_to_date": todate


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

        });
      });

      print(response);

      if (response.statusCode == 200) {
        _isloading = false;
        var dataa = json.decode(response.body);
        var data = dataa["Message"];

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
    Matmhistory(pageIndex.toString(),userid, frmDate, toDate, "Retailer","ALL","ALL","");
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
                child: Text(getTranslated(context, 'm-ATM History'),style: TextStyle(color: TextColor),textAlign: TextAlign.center,)),
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

                                                margin: EdgeInsets.only(left: 0,right: 10,top: 5),
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
                                                  margin: EdgeInsets.only(left: 0,right: 0,top: 5),
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
                                                      labelText:getTranslated(context, 'Service Mode'),
                                                      labelStyle: TextStyle(color: TextColor),
                                                    ),
                                                    items:["All","Microatm","Cash & Pos","Purchase","Balance Check"].map((item) {
                                                      return new DropdownMenuItem(
                                                        child:   Text(item,style: TextStyle(color: TextColor),),
                                                        value: item,
                                                      );
                                                    })?.toList() ??
                                                        [],
                                                    onChanged: (String val) {

                                                      if(val == "All"){

                                                        setState(() {
                                                          paymode = "ALL";
                                                        });

                                                      }else if(val == "Microatm"){

                                                        setState(() {
                                                          paymode = "microatm";
                                                        });

                                                      }else if(val == "Cash & Pos"){

                                                        setState(() {
                                                          paymode = "cash";
                                                        });
                                                      }else if(val == "Purchase"){

                                                        setState(() {
                                                          paymode = "purchase";
                                                        });
                                                      }else if(val == "Balance Check"){

                                                        setState(() {
                                                          paymode = "balance";
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
                                          Matmhistory(pageIndex.toString(),userid, frmDate, toDate, "Retailer", statuss,paymode,_rechanumber.text);


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
                    child: Container(
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
                    ),
                  ): Column(
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

                            DateTime tempDate1 = DateTime.parse(items[index]["transtime"].toString());
                            String dattee = DateFormat.yMMMd().add_jm().format(tempDate1);
                            return Container(
                              margin: EdgeInsets.only(top: 5,left: 5,right: 5,bottom: 5),
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                border: Border.all(width: .5, color:items[index]["status"] == "success" || items[index]["status"] == "Success" ? Colors.green : items[index]["status"] == "failed" || items[index]["status"] == "Failed" ? Colors.red : items[index]["status"] == "Pending" ? Colors.orange : Colors.deepPurple),
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
                                title: Column(
                                  children: [
                                    Container(
                                      transform: Matrix4.translationValues(0.0, -2.0, 0.0),
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 0.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(bottom: 5),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(top: 4),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          getTranslated(context, 'Firm Name') + " : " + items[index]["Frm_Name"],
                                                          style: TextStyle(fontSize: 12),
                                                          textAlign: TextAlign.left,
                                                        ),
                                                        SizedBox(height: 1,),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            Container(
                                                              child: Text(
                                                                getTranslated(context, 'Txn Type')+ " : ",
                                                                maxLines: 1,
                                                                textAlign: TextAlign.left,
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            ),
                                                            Container(
                                                              child: Text(
                                                                items[index]["transaction_type"],
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                                textAlign: TextAlign.left,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.centerRight,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      items[index]["status"] == "success" || items[index]["status"] == "Success"? Icon(Icons.check_circle,color: Colors.green,size: 14,) : items[index]["status"] == "M_Pending" || items[index]["status"] == "Pending" ? Icon(Icons.watch_later,color: Colors.yellow[800],size: 16,) :items[index]["status"] == "Failed" || items[index]["status"] == "failed" ?Icon(Icons.cancel,color: Colors.red,size: 16,) : Icon(Icons.money,color: Colors.deepOrangeAccent,size: 16,),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 3),
                                                        child: Text(items[index]["status"],style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 1,),
                                                  Text("\u{20B9} "+items[index]["amount"].toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
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
                                            Visibility(
                                              visible: items[index]["rrn"] == null || items[index]["rrn"] == "" ? false :true,
                                              child: Expanded(
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
                                                                getTranslated(context, 'Bank RRN'),
                                                                softWrap: true,
                                                                style: TextStyle(fontSize: 12),
                                                                textAlign: TextAlign.left,
                                                              ),
                                                              SizedBox(height: 1,),
                                                              Text(
                                                                items[index]["rrn"] == "" || items[index]["rrn"] == null? bankrrn: items[index]["rrn"],
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
                                            ),
                                            Visibility(
                                              visible: items[index]["masked_pan"] == null || items[index]["masked_pan"] == "" ? false :true,
                                              child: Expanded(
                                                child: Container(
                                                  alignment: Alignment.centerRight,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text(getTranslated(context, 'Card Number'),style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,),
                                                      SizedBox(height: 1,),
                                                      items[index]["masked_pan"] == null || items[index]["masked_pan"] == "" ? Text("") :Text(items[index]["masked_pan"],style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
                                                    ],
                                                  ),
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
                                          color: items[index]["status"] == "success" || items[index]["status"] == "Success"? Colors.green : items[index]["status"] == "failed" || items[index]["status"] == "Failed" ? Colors.red : items[index]["status"] == "Pending" ? Colors.orange :Colors.deepPurple,
                                        ),
                                        child: Center(
                                            child: items[index]["status"] == "success" || items[index]["status"] == "Success" ? Text("T r a n s a c t i o n     A m o u n t    P a i d    S u c c e s s f u l l y",style: TextStyle(fontSize: 8,color: Colors.white)) : items[index]["status"] == "Pending" ? Text("Y o u r   T r a n s a c t i o n   i n  Q u e u e   o r   P e n d i n g ",style: TextStyle(fontSize: 8,color: Colors.white)): items[index]["status"] == "failed" || items[index]["status"] == "Failed" ? Text("Y  o  u r    T r a n s a c t i o n    i  s    F  a  i  l  e  d ",style: TextStyle(fontSize: 8,color: Colors.white)) :Text(""))),
                                   Container(
                                      margin: EdgeInsets.only(bottom: 1,top: 5),
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
                                            visible: items[index]["transaction_type"] == "" || items[index]["transaction_type"] == null ? false : true,
                                            child: Container(
                                              margin: EdgeInsets.only(left: 20),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Transaction Mode",
                                                    style:TextStyle(fontSize: 11,fontWeight: FontWeight.bold,),textAlign: TextAlign.right,
                                                  ),
                                                  Text(
                                                    items[index]["transaction_type"].toString().toUpperCase(),
                                                    style:TextStyle(fontSize: 14),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: (){

                                              String date =  items[index]["transtime"].toString();
                                              String status =  items[index]["status"];
                                              String amount = items[index]["amount"].toString();
                                              String trnsid = items[index]["transaction_id"].toString();
                                              String txntype = items[index]["transaction_type"];
                                              String crdnum = items[index]["masked_pan"].toString();
                                              String paymth = items[index]["payment_method"];
                                              String accnum = items[index]["rrn"].toString();

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => Printmatmdata(status: status,date: date,trnsid: trnsid,amount: amount,txntype: txntype,accno: accnum,cardnum: crdnum,paymode: paymth,)));

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
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 0,bottom: 3),
                                        height: 1,
                                        color: PrimaryColor.withOpacity(0.1),
                                      ),
                                      Column(
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
                                                              getTranslated(context, 'Transaction ID'),
                                                              style: TextStyle(fontSize: 12),
                                                              overflow: TextOverflow.ellipsis,softWrap: true,textAlign: TextAlign.right,),
                                                            SizedBox(height: 1,),
                                                            Text(items[index]["transaction_id"].toString(),textAlign: TextAlign.right,)
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
                                                              getTranslated(context, 'Payment Mode'),
                                                              style: TextStyle(fontSize: 12),
                                                              overflow: TextOverflow.ellipsis,softWrap: true,textAlign: TextAlign.right,),
                                                            SizedBox(height: 1,),
                                                            Text(items[index]["payment_method"].toString(),textAlign: TextAlign.right,)
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
                                                            Text("\u{20B9} " + items[index]["retailer_remain_pre"].toString(),textAlign: TextAlign.right,)
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
                                                            Text(getTranslated(context, 'Network'),style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                            SizedBox(height: 1,),
                                                            Text(items[index]["network"].toString(),textAlign: TextAlign.right,)
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
                                                            Text("\u{20B9} " + items[index]["retailer_remain_post"].toString(),textAlign: TextAlign.right,)
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
                                                            Text(getTranslated(context, 'GST') + "\u{20B9}",textAlign: TextAlign.left,style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                            SizedBox(height: 1,),
                                                            Text("\u{20B9} " + items[index]["Retailer_gst"].toString(),textAlign: TextAlign.right,)
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
                                                            Text(getTranslated(context, 'TDS'),style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                            SizedBox(height: 1,),
                                                            Text("\u{20B9} " + items[index]["Retailer_tds"].toString(),textAlign: TextAlign.right,)
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
                                                            Text(getTranslated(context, 'My Earn'),style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                            SizedBox(height: 1,),
                                                            Text(items[index]["Retailer_comm"].toString(),textAlign: TextAlign.right,)
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
                                      SizedBox(
                                        height: 5,
                                      )
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
