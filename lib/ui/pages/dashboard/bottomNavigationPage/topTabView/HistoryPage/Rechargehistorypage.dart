import 'dart:convert';
import 'dart:typed_data';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/Sharehistory.dart';




class Rechargehistory extends StatefulWidget {
  const Rechargehistory({Key key}) : super(key: key);

  @override
  _RechargehistoryState createState() => _RechargehistoryState();
}

class _RechargehistoryState extends State<Rechargehistory> {
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

  List items2 = [];

  int id = 1;
  bool idpr = false;
  String statuss = "ALL";

  bool upiconvis = false;
  bool downiconvis = true;

  bool filtervisi = false;
  var userid;
  String idno;

  String disputemsz = "";

  DateTime selectedDate = DateTime.now();
  DateTime selectedDate2 = DateTime.now();

  TextEditingController _rechanumber = TextEditingController();
  TextEditingController disposecomm = TextEditingController();

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

  Future<void> rechargehistory(String pgrind ,String retailerid, String fromdate, String todate, String role, String rechargenum,String status, String optname) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    try{

      var uri =
      new Uri.http("api.vastwebindia.com", "/Recharge/api/data/rem_rch_report", {
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

  Future<void> disputeservice(String id, String comment) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url =
    new Uri.http("api.vastwebindia.com", "/Retailer/api/data/dispute",{
      "id":id,
      "comment":comment,

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
      disputemsz = data["Message"];

      setState(() {
        disputeresiondialog2();
      });

    } else {
      throw Exception('Failed to load themes');
    }
  }

  Future<void> heavyRequest(String optName,String optNumber) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/Recharge/api/data/DTH_Heavy_request", {
      "optname": optName,
      "mobileno":optNumber,
    });
    final http.Response response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 10), onTimeout: () {});

    print(response);

    if (response.statusCode == 200) {
      String data = json.decode(response.body);
      String alfa = data.replaceAll('"', '');

      if (alfa == "OK") {
        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: "Heavy Request Success!!",
          title: "OK",
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: () => Navigator.of(context).pop(),

        );
      } else {

        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: "Heavy Request Failed!!",
          title: "NOT OK",
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.red,
          onConfirmBtnTap: (){
            Navigator.of(context).pop();},
        );
      }




      setState(() {

      });
    } else {
      throw Exception('Failed');
    }
  }

  bool _validate = false;

  void disputeresiondialog(){
    showDialog(
        barrierDismissible: false,
        context: context,
        useSafeArea: true,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setStatee){
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
                            margin: EdgeInsets.only(bottom: 8,left: 8,right: 8),
                            color: PrimaryColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text("Dispute Request",
                                    style: TextStyle(color: TextColor,fontSize: 20),
                                    textAlign: TextAlign.left,
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
                  content: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 10,),
                          InputTextField(
                            controller: disposecomm,
                            errorText: _validate ? '' : null,
                            hint: getTranslated(context, 'Enter Dispute Reason'),
                            label: getTranslated(context, 'Enter Dispute Reason'),
                            obscureText: false,
                          ),
                          Text(getTranslated(context, 'Dispute Reason is Required'),style: TextStyle(color: Colors.red),),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              alignment: Alignment.centerRight,
                              width: MediaQuery.of(context).size.width,
                              child: MainButton(
                                color: SecondaryColor,
                                btnText:getTranslated(context, 'Submit'),
                                style: TextStyle(color: TextColor),
                                onPressed: (){

                                  if(disposecomm.text == ""){

                                    setState(() {
                                      _validate = true;
                                    });
                                  }else{

                                    disposecomm.clear();

                                    disputeservice(idno,disposecomm.text);
                                    Navigator.of(context).pop();
                                  }

                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
              ),
            );
          });
        });

  }

  void disputeresiondialog2(){
    showDialog(
        barrierDismissible: false,
        context: context,
        useSafeArea: true,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setStatee){
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
                            margin: EdgeInsets.only(bottom: 8,left: 8,right: 8),
                            color: PrimaryColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text("Dispute Alert",
                                    style: TextStyle(color: TextColor,fontSize: 20),
                                    textAlign: TextAlign.left,
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
                  content: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 10,),
                          Icon(Icons.warning_rounded,color: Colors.red,size: 80,),
                          Container(
                             margin: EdgeInsets.only(left: 5,right: 5),
                              child: Text("Your Dispute Request Already in Queue",style: TextStyle(color: Colors.red),)),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              alignment: Alignment.centerRight,
                              width: MediaQuery.of(context).size.width,
                              child: MainButton(
                                color: SecondaryColor,
                                btnText:"Close",
                                style: TextStyle(color: TextColor),
                                onPressed: (){

                                  Navigator.of(context).pop();

                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
              ),
            );
          });
        });

  }

  Future<void> trackrefrechargehistory(String frmdate, String todate, String number, String idno) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");
    var userid = await storage.read(key: "userId");

    try{

      var uri =
      new Uri.http("api.vastwebindia.com", "/Recharge/api/data/rem_rch_report", {
        "pageindex": "1",
        "pagesize": "500",
        "retailerid": userid,
        "fromdate": frmdate,
        "todate": todate,
        "role": "Retailer",
        "rechargeNo": number,
        "status": "ALL",
        "OperatorName": "ALL",
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

      });

      print(response);

      if (response.statusCode == 200) {

        var data = json.decode(response.body);


        for(int i =0 ; i <data.length; i++){

          var datalist = data[i]["Idno"].toString();
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
                                    Text("Consumer Number",style: TextStyle(fontSize: 9,color: Colors.white),),
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
      child: Container(
          margin: EdgeInsets.only(left: 8,right: 8),
          child: ListView.builder(
              controller: _controllerList,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              itemCount: items2.length,
              itemBuilder: (BuildContext context, int index) {

                DateTime tempDate1 = DateTime.parse(items2[index]["Reqesttime"].toString());
                String dattee = DateFormat.yMMMd().add_jm().format(tempDate1);

                return Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    border: Border.all(width: .5, color:items2[index]["Status"] == "SUCCESS" ? Colors.green : items2[index]["Status"] == "FAILED" ? Colors.red : items2[index]["Status"] == "PENDING" ? Colors.orange : Colors.deepPurple),
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
                    color:Colors.white.withOpacity(0.4),
                    child: Column(
                      children: [
                        Container(
                          child: Container(
                            child: Container(
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
                                                  child:Image.asset("assets/pngImages/mobile-phone.png",width: 25,height: 25,)
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
                                                      items2[index]["Operator_name"].toString().toUpperCase(),
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),
                                                    ),
                                                    SizedBox(height: 1,),
                                                    Text(items2[index]["Recharge_number"].toString(),textAlign: TextAlign.right,)
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

                                                  Container(
                                                    margin: EdgeInsets.only(right: 5),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text(items2[index]["Status"].toString().toUpperCase(),style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis),
                                                        Text(" \u{20B9} " + items2[index]["Recharge_amount"].toString(),textAlign: TextAlign.right,)
                                                      ],
                                                    ),
                                                  ),
                                                  items2[index]["Status"] == "SUCCESS" ? Icon(Icons.check_circle,color: Colors.green,size: 32,) : items2[index]["Status"] == "PENDING" ? Icon(Icons.watch_later,color: Colors.yellow[800],size: 32,) :items2[index]["Status"] == "FAILED" ?Icon(Icons.cancel,color: Colors.red,size: 32,) : Container(child: Icon(Icons.replay_circle_filled,color: Colors.deepPurple,size: 32,)),
                                                ],
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 0,bottom: 8),
                                    height: 10,
                                    color: items2[index]["Status"] == "SUCCESS" ? Colors.green : items2[index]["Status"] == "FAILED" ? Colors.red : items2[index]["Status"] == "PENDING" ? Colors.orange : Colors.deepPurple,
                                    child: Center(
                                        child: items2[index]["Status"] == "SUCCESS" ? Text("R e c h a r g e     A m o u n t    P a i d    S u c c e s s f u l l y",style: TextStyle(fontSize: 8,color: Colors.white)) : items2[index]["Status"] == "PENDING" ? Text("Y o u r   R e c h a r g e   i n  Q u e u e   o r   P e n d i n g ",style: TextStyle(fontSize: 8,color: Colors.white)): items2[index]["Status"] == "FAILED" ? Text("Y  o  u r    R  e  c  h  a  r  g  e    i  s    F  a  i  l  e  d ",style: TextStyle(fontSize: 8,color: Colors.white)) :Text("T r a n s a c t i o n    A m o u n t    S u c c e s s f u l l y    R e f u n d e d",style: TextStyle(fontSize: 8,color: Colors.white),)),
                                  ),
                                  Row(
                                    crossAxisAlignment:CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(getTranslated(context, 'Date & Time'),textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),),
                                              SizedBox(height: 3,),
                                              Text(dattee,textAlign: TextAlign.right,),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Column(
                                          children: [
                                            Container(
                                                margin: EdgeInsets.only(right: 0),
                                                child: Text(getTranslated(context, 'My Earn'),textAlign: TextAlign.right,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),)),
                                            SizedBox(height: 3,),
                                            Container(
                                                margin: EdgeInsets.only(right: 0),
                                                child: Text("\u{20B9} " +items2[index]["Commision"].toString(),textAlign: TextAlign.right,)),
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
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 0,bottom: 8),
                              height: .5,
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
                                                          style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),
                                                          overflow: TextOverflow.ellipsis,softWrap: true,textAlign: TextAlign.left,),
                                                        SizedBox(height: 2,),
                                                        SelectableText(
                                                          items2[index]["Idno"].toString(),textAlign: TextAlign.right,
                                                        )
                                                        //Text(items2[index]["Request_ID"].toString(),textAlign: TextAlign.right,)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    alignment: Alignment.centerRight,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          getTranslated(context, 'Operator ID'),
                                                          style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),
                                                          overflow: TextOverflow.ellipsis,softWrap: true,textAlign: TextAlign.right,),
                                                        SizedBox(height: 2,),
                                                        items2[index]["Operatorid"] != "" ? SelectableText(items2[index]["Operatorid"].toString(),textAlign: TextAlign.right,) : items2[index]["Status"] == "PENDING" ? Text("Request Pending"): items2[index]["Status"] == "SUCCESS" ? Text("Manually Success") : Text("Amount Refunded")
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 5,bottom: 8),
                                              height: .5,
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
                                                        Text(getTranslated(context, 'Pre Balance'),textAlign: TextAlign.left,style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                        SizedBox(height: 1,),
                                                        Text("\u{20B9} " + items2[index]["RemainPre"].toString(),textAlign: TextAlign.right,)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: .5,
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
                                                        items2[index]["Creditamount"] == 0.0 ? Text(getTranslated(context, 'Debit') + "\u{20B9}",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,softWrap: true,) : Text("Credit \u{20B9}".toUpperCase(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                        SizedBox(height: 2,),
                                                        items2[index]["Creditamount"] == 0.0 ? Text("\u{20B9} "+items2[index]["Debitamount"].toString(),textAlign: TextAlign.right,) : Text("\u{20B9} "+items2[index]["Creditamount"].toString(),textAlign: TextAlign.right,)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: .5,
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
                                                        Text(getTranslated(context, 'Post Balance') ,style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                        SizedBox(height: 1,),
                                                        Text("\u{20B9} " + items2[index]["RemainPost"].toString(),textAlign: TextAlign.center,)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                             height: 8,
                                           ),
                                            Visibility(
                                              visible:items2[index]["Status"] == "FAILED" ? true :false,
                                              child: Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  height: 25,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        primary: SecondaryColor
                                                    ),
                                                    onPressed: (){

                                                      String optar = items2[index]["Operator_name"].toString();
                                                      String date = items2[index]["Reqesttime"].toString();
                                                      String status = items2[index]["Status"].toString();
                                                      String amount = items2[index]["Recharge_amount"].toString();
                                                      String number = items2[index]["Recharge_number"].toString();
                                                      String trnsid = items2[index]["Idno"].toString();
                                                      String optid = items2[index]["Operatorid"].toString();

                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => Printdata(Number: number,operator: optar,status: status,date: date,trnsid: trnsid,amount: amount,optid: optid,)));
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
                                            )
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
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
          )
      )
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

  bool loadervis = true;

  void retid() async{

    final storage = new FlutterSecureStorage();
    userid = await storage.read(key: "userId");
    rechargehistory(pageIndex.toString(),userid, frmDate, toDate, "Retailer", "ALL", "ALL", "ALL");
  }
  bool isExpand=false;
  bool loadersho = false;

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
          body: Column(
            children: [
              Container(
                color: TextColor,
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
                                      decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.white), borderRadius: BorderRadius.circular(3)),
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
                                  margin: EdgeInsets.only(left: 5,right: 5),
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
                                  margin: EdgeInsets.only(left: 2,right: 4),
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
                                  margin: EdgeInsets.only(right: 0,left: 0),
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
                                        toDate  = "${selectedDate.toLocal()}".split(' ')[0];

                                        originalItems.clear();
                                        items.clear();
                                        rechargehistory(pageIndex.toString(),userid, frmDate, toDate, "Retailer", _rechanumber.text, statuss, "ALL");

                                      },
                                    ),
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
                      child:originalItems.length == 0 ? Container(
                        margin: EdgeInsets.only(top: 200,left: 10,right: 10),
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
                        ),
                      ):
                      Container(
                        margin: EdgeInsets.only(left: 8,right: 8),
                        child: ListView.builder(
                          controller: _controllerList,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          itemCount: (present <= originalItems.length) ? items.length + 1 : items.length,
                          itemBuilder: (BuildContext context, int index) {

                            if ((index == items.length )) {
                              return originalItems.length > 20 ? Container(
                                margin: EdgeInsets.only(left: 0,right: 0,top: 20),
                                color: SecondaryColor,
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
                              ) :Container(
                                child: Text(""),
                              );
                            } else {

                              DateTime tempDate1 = DateTime.parse(items[index]["Reqesttime"].toString());
                              String dattee = DateFormat.yMMMd().add_jm().format(tempDate1);

                              String dattee2 = DateFormat.yMd().format(tempDate1);


                              return Container(
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: .5,
                                      color:items[index]["Status"] == "SUCCESS" ? Colors.green : items[index]["Status"] == "FAILED" ? Colors.red : items[index]["Status"] == "PENDING" ? Colors.orange : Colors.deepPurple),
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
                                  color:Colors.white.withOpacity(0.4),
                                  child: ExpansionTile(
                                    childrenPadding: EdgeInsets.zero,
                                    tilePadding: EdgeInsets.zero,
                                    onExpansionChanged: (value){
                                      setState(() {
                                        isExpand=value;
                                      });

                                    },
                                    textColor: Colors.black,
                                    title: Container(
                                      child: Container(
                                        child: Container(
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
                                                              child:Image.asset("assets/pngImages/mobile-phone.png",width: 25,height: 25,)
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
                                                                  items[index]["Operator_name"].toString().toUpperCase(),
                                                                  overflow: TextOverflow.ellipsis,
                                                                  maxLines: 1,
                                                                  textAlign: TextAlign.left,
                                                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),
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

                                                              Container(
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                  children: [
                                                                    Text(items[index]["Status"].toString().toUpperCase(),style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis),
                                                                    Text(" \u{20B9} " + items[index]["Recharge_amount"].toString(),textAlign: TextAlign.right,)
                                                                  ],
                                                                ),
                                                              ),
                                                              items[index]["Status"] == "SUCCESS" ? Icon(Icons.check_circle,color: Colors.green,size: 32,) : items[index]["Status"] == "PENDING" ? Icon(Icons.watch_later,color: Colors.yellow[800],size: 32,) :items[index]["Status"] == "FAILED" ?Icon(Icons.cancel,color: Colors.red,size: 32,) : Container(child: Icon(Icons.replay_circle_filled,color: Colors.deepPurple,size: 32,)),


                                                            ],
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 0,bottom: 8),
                                                height: 10,
                                                color: items[index]["Status"] == "SUCCESS" ? Colors.green : items[index]["Status"] == "FAILED" ? Colors.red : items[index]["Status"] == "PENDING" ? Colors.orange : Colors.deepPurple,
                                                child: Center(
                                                    child: items[index]["Status"] == "SUCCESS" ? Text("R e c h a r g e     A m o u n t    P a i d    S u c c e s s f u l l y",style: TextStyle(fontSize: 8,color: Colors.white)) : items[index]["Status"] == "PENDING" ? Text("Y o u r   R e c h a r g e   i n  Q u e u e   o r   P e n d i n g ",style: TextStyle(fontSize: 8,color: Colors.white)): items[index]["Status"] == "FAILED" ? Text("Y  o  u r    R  e  c  h  a  r  g  e    i  s    F  a  i  l  e  d ",style: TextStyle(fontSize: 8,color: Colors.white)) :Text("T r a n s a c t i o n    A m o u n t    S u c c e s s f u l l y    R e f u n d e d",style: TextStyle(fontSize: 8,color: Colors.white),)),
                                              ),
                                              Row(
                                                crossAxisAlignment:CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(getTranslated(context, 'Date & Time'),textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),),
                                                          SizedBox(height: 3,),
                                                          Text(dattee,textAlign: TextAlign.right,),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                            margin: EdgeInsets.only(right: 0),
                                                            child: Text(getTranslated(context, 'My Earn'),textAlign: TextAlign.right,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),)),
                                                        SizedBox(height: 3,),
                                                        Container(
                                                            margin: EdgeInsets.only(right: 0),
                                                            child: Text("\u{20B9} " +items[index]["Commision"].toString(),textAlign: TextAlign.right,)),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 7,
                                                  ),
                                                  Column(
                                                    children: [
                                                      Container(
                                                          height: 18,
                                                          width: 18,
                                                          decoration: BoxDecoration(
                                                              color: SecondaryColor,
                                                              shape: BoxShape.circle
                                                          ),
                                                          padding: EdgeInsets.only(right: 0),
                                                          margin: EdgeInsets.only(left: 3,right: 0,top: 0,bottom: 5),
                                                          child:Icon(Icons.arrow_drop_down_sharp,
                                                            color: Colors.white,size: 18,)
                                                      ),

                                                      Container(
                                                        padding: EdgeInsets.only(left: 5,right: 5),
                                                        decoration: BoxDecoration(
                                                            color: SecondaryColor,
                                                            borderRadius: BorderRadius.circular(40)
                                                        ),
                                                        child: Text("More",style: TextStyle(color: Colors.white,fontSize: 8),),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 7,
                                                  ),
                                                  Visibility(
                                                    visible: items[index]["Status"] == "FAILED" ? true : items[index]["Status"] == "PENDING" ? false : items[index]["Status"] == "SUCCESS" ? false : true,
                                                    child: items[index]["Status"] == "FAILED" ? GestureDetector(
                                                      onTap: (){


                                                        setState(() {
                                                          items2.clear();
                                                        });

                                                        DateTime selectedDate2 = DateTime.now().subtract(const Duration(days: 30));

                                                        frmDate = "${selectedDate2.toLocal()}".split(' ')[0];
                                                        toDate = "${selectedDate.toLocal()}".split(' ')[0];


                                                        String numberr = items[index]["Recharge_number"].toString();
                                                        String idno = items[index]["Idno"].toString();

                                                        trackrefrechargehistory(dattee2,toDate,numberr,idno);

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

                                                        String numberr = items[index]["Recharge_number"].toString();
                                                        String idno = items[index]["Status"].toString();


                                                        trackrefrechargehistory(dattee2,toDate,numberr,idno.replaceFirst("Rf-", ""));

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

                                                        String optar = items[index]["Operator_name"].toString();
                                                        String date = items[index]["Reqesttime"].toString();
                                                        String status = items[index]["Status"].toString();
                                                        String amount = items[index]["Recharge_amount"].toString();
                                                        String number = items[index]["Recharge_number"].toString();
                                                        String trnsid = items[index]["Idno"].toString();
                                                        String optid = items[index]["Operatorid"].toString();

                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => Printdata(Number: number,operator: optar,status: status,date: date,trnsid: trnsid,amount: amount,optid: optid,)));
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                              child: Icon(Icons.share,size: 20,)
                                                          ),
                                                          SizedBox(
                                                            height: 3,
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
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 0,bottom: 8),
                                            height: .5,
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
                                                                        style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),
                                                                        overflow: TextOverflow.ellipsis,softWrap: true,textAlign: TextAlign.left,),
                                                                      SizedBox(height: 2,),
                                                                      SelectableText(
                                                                        items[index]["Idno"].toString(),textAlign: TextAlign.right,
                                                                      )
                                                                      //Text(items[index]["Request_ID"].toString(),textAlign: TextAlign.right,)
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Container(
                                                                  alignment: Alignment.centerRight,
                                                                  child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                                    children: [
                                                                      Text(
                                                                        getTranslated(context, 'Operator ID'),
                                                                        style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),
                                                                        overflow: TextOverflow.ellipsis,softWrap: true,textAlign: TextAlign.right,),
                                                                      SizedBox(height: 2,),
                                                                      items[index]["Operatorid"] != "" ? SelectableText(items[index]["Operatorid"].toString(),textAlign: TextAlign.right,) : items[index]["Status"] == "PENDING" ? Text("Request Pending"): items[index]["Status"] == "SUCCESS" ? Text("Manually Success") : Text("Amount Refunded")
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets.only(top: 5,bottom: 8),
                                                            height: .5,
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
                                                                      Text(getTranslated(context, 'Pre Balance'),textAlign: TextAlign.left,style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                                      SizedBox(height: 1,),
                                                                      Text("\u{20B9} " + items[index]["RemainPre"].toString(),textAlign: TextAlign.right,)
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: .5,
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
                                                                      items[index]["Creditamount"] == 0.0 ? Text(getTranslated(context, 'Debit') + "\u{20B9}",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,softWrap: true,) : Text("Credit \u{20B9}".toUpperCase(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                                      SizedBox(height: 2,),
                                                                      items[index]["Creditamount"] == 0.0 ? Text("\u{20B9} "+items[index]["Debitamount"].toString(),textAlign: TextAlign.right,) : Text("\u{20B9} "+items[index]["Creditamount"].toString(),textAlign: TextAlign.right,)
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: .5,
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
                                                                      Text(getTranslated(context, 'Post Balance') ,style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                                      SizedBox(height: 1,),
                                                                      Text("\u{20B9} " + items[index]["RemainPost"].toString(),textAlign: TextAlign.center,)
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              items[index]["Status"] == "SUCCESS" ? Expanded(
                                                                child: Container(
                                                                  alignment: Alignment.centerRight,
                                                                  child: Column(
                                                                    children: [
                                                                      Container(
                                                                          height: 35,
                                                                          width: 68,
                                                                          padding: EdgeInsets.all(2),
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.orange,
                                                                              border: Border.all(
                                                                                  width: 0.5,
                                                                                  color: Colors.yellow
                                                                              )
                                                                          ),
                                                                          child: GestureDetector(
                                                                            onTap: (){

                                                                              idno = items[index]["Idno"].toString();
                                                                              disputeresiondialog();
                                                                            },
                                                                            child: Row(
                                                                              children: [
                                                                                Icon(Icons.gavel_rounded,color: Colors.white,),
                                                                                Expanded(
                                                                                    child: Text("DISPUTE Complain", style: TextStyle(fontSize: 8,color: TextColor),textAlign: TextAlign.center,)),
                                                                              ],
                                                                            ),
                                                                          )
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ) : Text(""),
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
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            ],
          )
        ),
      ),
    );

  }



}
