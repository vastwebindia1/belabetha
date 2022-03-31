import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart'as http;
import 'package:encrypt/encrypt.dart'as encrypt;
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/masterPage/masterMainPage.dart';
import 'package:uuid/uuid.dart';

class MasterRequestAdmin extends StatefulWidget {

  final adminamount ;
  const MasterRequestAdmin({Key key, this.adminamount}) : super(key: key);

  @override
  _MasterRequestAdminState createState() => _MasterRequestAdminState();
}

class _MasterRequestAdminState extends State<MasterRequestAdmin> {


  List paymentMode = ["Cash","Credit","Branch/Cms Deposit","Online Transfer","Wallet"];
  List paymenttype = ["NEFT","IMPS","RTGS","UPI","Same Bank"];
  List masterBankname;
  List masterwallet;

  String masterwallet1 = "Select Wallet";
  String masterwalletno;

  String masterBank1 = "Select Admin Bank";
  String masterBankAcc;

  List districtlist;
  String _myState;
  String _mydis;
  String dropdownValue = "sikandr";
  int _value = 1;
  String paymentMode1 = "Select Payment Mode";
  String paymentType1 = "Payment Type";

  TextEditingController collectionController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController utrController = TextEditingController();
  TextEditingController accountController = TextEditingController();
  TextEditingController walletController = TextEditingController();
  TextEditingController bankController = TextEditingController();
  TextEditingController depositslipcontroller = TextEditingController();
  TextEditingController transactioncontroller = TextEditingController();
  TextEditingController walletbankController = TextEditingController();




  int _ratingController;

  bool paymentOptions = false;
  bool paymentslip = false;
  bool paymentcollection = true;
  bool paymentcomment = true;
  bool paymentutr = false;
  bool paymentaccount = false;
  bool paymentbank = false;
  bool paymentwallet = false;
  bool paymentbank1 = false;
  bool paymenttrasaction = false;
  bool paymentwalletbank = false;

  bool _isloading = false;
  bool btnclick = true;

  String roll = "Admin";
  String roll1 = "master";


  Future<void> adminMasterBankList() async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url = new Uri.http("api.vastwebindia.com", "/api/data/AdminBankList");
    final http.Response response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
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
      var databind1 = json.decode(response.body);
      var adminacc = databind1["adminbankllist"];
      var adminwallet = databind1["adminwalletlist"];

      setState(() {
        masterBankname = adminacc;
        masterwallet = adminwallet;


      });



    } else {
      throw Exception('Failed to load themes');
    }



  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    adminMasterBankList();
  }


  Future<void> purchaseadmin(String alfa1,String mode2,String type2, String collection2, String comment2, String deposit2, String utrno2, String account2, String walletno2,
      String bank2,String transaction2, String walletbank2,String retailerroll2, String dealerroll2, String key, String vi) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var url = new Uri.http("api.vastwebindia.com", "/Common/api/Data/PurchaseOrder");

    Map map = {
      "payto": dealerroll2,
      "hdPaymentMode": mode2,
      "hdPaymentAmount": alfa1,
      "hdMDDepositeSlipNo": deposit2,
      "hdMDTransferType": type2,
      "hdMDcollection": collection2,
      "hdMDComments": comment2,
      "hdMDBank": bank2 ,
      "hdsupraccno": "",
      "hdMDaccountno": account2,
      "hdMDutrno": utrno2,
      "hdMDwallet": walletbank2,
      "hdMDwalletno": walletno2,
      "hdMDtransationno": transaction2,
      "hdMDsettelment": "",
      "hdMDCreditDetail": "",
      "hdMDsubject": "",
      "ROLE": retailerroll2,
      "value1": key,
      "value2": vi,
    };

    String body = json.encode(map);

    http.Response response = await http.post(url,
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      },
      body: body,

    ).timeout(Duration(seconds: 15), onTimeout: (){
      setState(() {

        _isloading = false;

        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(getTranslated(context, 'Data Not Found'),style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);

      });
    });


    print(response);


    if (response.statusCode == 200) {


      setState(() {
        _isloading = false;
        btnclick = true;
      });

      var data = json.decode(response.body);
      var  status = data["Response"];
      var  msz = data["Message"];

      if (status == "Success") {
        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: msz,
          title: status,
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MasterManinDashboard()));
          },
        );
      } else {
        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: msz,
          title: status,
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.red,
          onConfirmBtnTap: (){
            setState(() {
              _isloading = false;
            });
            Navigator.of(context).pop();
          },
        );
      }
    } else {

      _isloading = false;

      throw Exception('Failed');
    }
  }


  void paymentModedialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.black.withOpacity(0.8),
            alignment: Alignment.topLeft,
            child: AlertDialog(
              /*insetPadding: EdgeInsets.only(right: 122, left: 0,top: 38,),*/
              buttonPadding: EdgeInsets.all(0),
              titlePadding: EdgeInsets.all(0),
              contentPadding: EdgeInsets.only(left: 10, right: 10),
              title: Container(
                margin: EdgeInsets.only(bottom: 8),
                padding:
                EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
                color: PrimaryColor,
                child: Text(
                  'Select Payment Mode',
                  style: TextStyle(color: TextColor, fontSize: 22),
                ),
              ),
              content: Container(
                // Change as per your requirement
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                  itemCount: paymentMode.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      visualDensity: VisualDensity(vertical: 0, horizontal: 0),
                      isThreeLine: false,
                      contentPadding: EdgeInsets.all(0),
                      minVerticalPadding: 2,
                      horizontalTitleGap: 0,
                      onTap: () {

                        setState(() {
                          paymentMode1 = paymentMode[index];

                          if(paymentMode1 == "Cash"){
                            paymentcomment = true;
                            paymentcollection = true;
                            paymentslip = false;
                            paymentbank = false;
                            paymentaccount = false;
                            paymentOptions = false;
                            paymentutr = false;
                            paymentwalletbank = false;
                            paymentwallet = false;
                            paymenttrasaction = false;


                          } else if (paymentMode1 == "Credit") {

                            paymentcomment = true;
                            paymentcollection = true;
                            paymentslip = false;
                            paymentbank = false;
                            paymentaccount = false;
                            paymentOptions = false;
                            paymentutr = false;
                            paymentwalletbank = false;
                            paymentwallet = false;
                            paymenttrasaction = false;


                          }else if (paymentMode1 == "Branch/Cms Deposit"){
                            paymentslip = true;
                            paymentbank = true;
                            paymentaccount = true;
                            paymentcollection = false;
                            paymentcomment = true;
                            paymentutr = false;
                            paymentOptions = false;
                            paymentwalletbank = false;
                            paymentwallet = false;
                            paymenttrasaction = false;


                          }else if (paymentMode1 == "Online Transfer"){

                            paymentbank = true;
                            paymentOptions = true;
                            paymentslip = false;
                            paymentaccount = true;
                            paymentutr = true;
                            paymentcollection = false;
                            paymentcomment = false;
                            paymentwalletbank = false;
                            paymentwallet = false;
                            paymenttrasaction = false;

                          }else if (paymentMode1 == "Wallet"){
                            paymentwalletbank = true;
                            paymentwallet = true;
                            paymentOptions = false;
                            paymenttrasaction = true;
                            paymentcomment = true;
                            paymentcollection = false;
                            paymentaccount = false;
                            paymentutr = false;
                            paymentslip = false;
                            paymentbank = false;

                          }else {

                          }

                        });

                        Navigator.of(context).pop();
                      },
                      title: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              paymentMode[index],
                              textAlign: TextAlign.left,
                            ),
                            Container(
                              height: 1,
                              color: PrimaryColor,
                              margin: EdgeInsets.only(top: 8, bottom: 0),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        });
  }

  void paymenttypedialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.black.withOpacity(0.8),
            alignment: Alignment.topLeft,
            child: AlertDialog(
              /*insetPadding: EdgeInsets.only(right: 122, left: 0,top: 38,),*/
              buttonPadding: EdgeInsets.all(0),
              titlePadding: EdgeInsets.all(0),
              contentPadding: EdgeInsets.only(left: 10, right: 10),
              title: Container(
                margin: EdgeInsets.only(bottom: 8),
                padding:
                EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
                color: PrimaryColor,
                child: Text(
                  'Select Payment Type',
                  style: TextStyle(color: TextColor, fontSize: 22),
                ),
              ),
              content: Container(
                // Change as per your requirement
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                  itemCount: paymenttype.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      visualDensity: VisualDensity(vertical: 0, horizontal: 0),
                      isThreeLine: false,
                      contentPadding: EdgeInsets.all(0),
                      minVerticalPadding: 2,
                      horizontalTitleGap: 0,
                      onTap: () {

                        setState(() {
                          paymentType1 = paymenttype[index];
                        });

                        Navigator.of(context).pop();
                      },
                      title: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              paymenttype[index],
                              textAlign: TextAlign.left,
                            ),
                            Container(
                              height: 1,
                              color: PrimaryColor,
                              margin: EdgeInsets.only(top: 8, bottom: 0),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        });
  }

  void masterbankdialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.black.withOpacity(0.8),
            alignment: Alignment.topLeft,
            child: AlertDialog(
              /*insetPadding: EdgeInsets.only(right: 122, left: 0,top: 38,),*/
              buttonPadding: EdgeInsets.all(0),
              titlePadding: EdgeInsets.all(0),
              contentPadding: EdgeInsets.only(left: 10, right: 10),
              title: Container(
                margin: EdgeInsets.only(bottom: 8),
                padding:
                EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
                color: PrimaryColor,
                child: Text(
                  'Select Admin Bank',
                  style: TextStyle(color: TextColor, fontSize: 22),
                ),
              ),
              content: Container(
                // Change as per your requirement
                width: MediaQuery.of(context).size.width,
                child:masterBankname.length == 0?
                Column(
                  children: [
                    Container(
                      child: Text(getTranslated(context, 'No Data') ,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),

                    )
                  ],
                )
                    :Column(
                  children: [
                    ListView.builder(
                      padding: EdgeInsets.all(0),
                      shrinkWrap: true,
                      itemCount: masterBankname.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          visualDensity: VisualDensity(vertical: 0, horizontal: 0),
                          isThreeLine: false,
                          contentPadding: EdgeInsets.all(0),
                          minVerticalPadding: 2,
                          horizontalTitleGap: 0,
                          onTap: () {

                            setState(() {
                              masterBank1 = masterBankname[index]["banknm"];
                              masterBankAcc = masterBankname[index]["acno"];

                              paymentaccount = true;
                            });

                            Navigator.of(context).pop();
                          },
                          title: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  masterBankname[index]["banknm"],
                                  textAlign: TextAlign.left,
                                ),
                                Container(
                                  height: 1,
                                  color: PrimaryColor,
                                  margin: EdgeInsets.only(top: 8, bottom: 0),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void masterwalletdialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.black.withOpacity(0.8),
            alignment: Alignment.topLeft,
            child: AlertDialog(
              /*insetPadding: EdgeInsets.only(right: 122, left: 0,top: 38,),*/
              buttonPadding: EdgeInsets.all(0),
              titlePadding: EdgeInsets.all(0),
              contentPadding: EdgeInsets.only(left: 10, right: 10),
              title: Container(
                margin: EdgeInsets.only(bottom: 8),
                padding:
                EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
                color: PrimaryColor,
                child: Text(
                  'Select Wallet',
                  style: TextStyle(color: TextColor, fontSize: 22),
                ),
              ),
              content: Container(
                // Change as per your requirement
                width: MediaQuery.of(context).size.width,
                child: masterwallet.length == 0?
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(getTranslated(context, 'No Data') ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                    )
                  ],
                ):Column(
                  children: [
                    ListView.builder(
                      padding: EdgeInsets.all(0),
                      shrinkWrap: true,
                      itemCount: masterwallet.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          visualDensity: VisualDensity(vertical: 0, horizontal: 0),
                          isThreeLine: false,
                          contentPadding: EdgeInsets.all(0),
                          minVerticalPadding: 2,
                          horizontalTitleGap: 0,
                          onTap: () {

                            setState(() {
                              masterwallet1 = masterwallet[index]["walletname"];
                              masterwalletno = masterwallet[index]["walletno"];

                              paymentwallet = true;
                            });

                            Navigator.of(context).pop();
                          },
                          title: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  masterwallet[index]["walletname"],
                                  textAlign: TextAlign.left,
                                ),
                                Container(
                                  height: 1,
                                  color: PrimaryColor,
                                  margin: EdgeInsets.only(top: 8, bottom: 0),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }




  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                /*select Option=============*/
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 60,
                  width: 60,
                  child: Stack(
                    fit: StackFit.loose,
                    alignment: Alignment.center,
                    children: [
                      ConstrainedBox(
                          constraints: BoxConstraints.tightFor(
                            width: 100, height: 100,),
                          child:FlatButton(
                            shape: CircleBorder(
                                side: BorderSide(
                                    width:1,color: Colors.green)),
                            color: Colors.transparent,
                            onPressed: (){

                            },
                            child:Image.asset('assets/pngImages/reqToAdmin.png',height: 35,),
                          )
                      ),
                      Positioned(
                        top: -1,
                        right: -2,
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(100),
                              ),
                              color: TextColor,
                            ),
                            child: Icon(Icons.check_circle,color: Colors.green,)
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(getTranslated(context, 'Request to Admin')),
                      Text("\u{20B9}" + widget.adminamount,style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10,right: 10,top: 20,),
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
                    padding: EdgeInsets.only(top: 16,bottom: 16,left: 10,right: 10),
                    borderSide: BorderSide(width: 1,color: PrimaryColor),
                    onPressed: paymentModedialog,
                    child: Container(
                      child: Row(
                        children: [
                          Expanded(child: Text(paymentMode1,style: TextStyle(color: PrimaryColor,fontWeight: FontWeight.normal),)),
                          SizedBox(width: 20,child: Icon(Icons.arrow_drop_down,color: PrimaryColor,),)
                        ],
                      ),
                    ),
                  ),
                ),

                Visibility(
                  maintainSize: false,
                  visible:paymentOptions ,
                  child: Container(
                    margin: EdgeInsets.only(left: 10,right: 10,top: 20,),
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
                      padding: EdgeInsets.only(top: 16,bottom: 16,left: 10,right: 10),
                      borderSide: BorderSide(width: 1,color: PrimaryColor),
                      onPressed: paymenttypedialog,
                      child: Container(
                        child: Row(
                          children: [
                            Expanded(child: Text(paymentType1,style: TextStyle(color: PrimaryColor,fontWeight: FontWeight.normal),)),
                            SizedBox(width: 20,child: Icon(Icons.arrow_drop_down,color: PrimaryColor,),)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Visibility(
                  maintainSize: false,
                  visible: paymentwalletbank,
                  child: Container(
                    margin: EdgeInsets.only(left: 10,right: 10,top: 20,),
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
                      padding: EdgeInsets.only(top: 16,bottom: 16,left: 10,right: 10),
                      borderSide: BorderSide(width: 1,color: PrimaryColor),
                      onPressed: masterwalletdialog,
                      child: Container(
                        child: Row(
                          children: [
                            Expanded(child: Text(masterwallet1,style: TextStyle(color: PrimaryColor,fontWeight: FontWeight.normal),)),
                            SizedBox(width: 20,child: Icon(Icons.arrow_drop_down,color: PrimaryColor,),)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Visibility(
                  maintainSize: false,
                  visible: paymentwallet,
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: InputTextField(

                      controller: walletController,
                      checkenable:  false,
                      hint:  getTranslated(context, 'Wallet No'),
                      label: masterwalletno,
                      obscureText: false,

                      labelStyle: TextStyle(
                        color: PrimaryColor,
                      ),
                      borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                      onChange: (String value) {

                      },
                    ),
                  ),
                ),

                Visibility(
                  maintainSize: false,
                  visible: paymentbank,
                  child: Container(
                    margin: EdgeInsets.only(left: 10,right: 10,top: 20,),
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
                      padding: EdgeInsets.only(top: 16,bottom: 16,left: 10,right: 10),
                      borderSide: BorderSide(width: 1,color: PrimaryColor),
                      onPressed: masterbankdialog,
                      child: Container(
                        child: Row(
                          children: [
                            Expanded(child: Text(masterBank1,style: TextStyle(color: PrimaryColor,fontWeight: FontWeight.normal),)),
                            SizedBox(width: 20,child: Icon(Icons.arrow_drop_down,color: PrimaryColor,),)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Visibility(
                  maintainSize: false,
                  visible: paymentaccount,
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: InputTextField(
                      controller: accountController,
                      checkenable: false,
                      hint: getTranslated(context, 'Account No'),
                      label: masterBankAcc,
                      obscureText: false,
                      labelStyle: TextStyle(
                        color: PrimaryColor,
                      ),
                      borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                      onChange: (String value) {

                      },
                    ),
                  ),
                ),

                Visibility(
                  maintainSize: false,
                  visible: paymentslip,
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: InputTextField(
                      controller: depositslipcontroller,
                      label: getTranslated(context, 'Deposit Slip No'),
                      obscureText: false,

                      labelStyle: TextStyle(
                        color: PrimaryColor,
                      ),
                      borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                      onChange: (String value) {

                      },
                    ),
                  ),
                ),

                Visibility(
                  maintainSize: false,
                  visible: paymentutr,
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: InputTextField(
                      controller: utrController,
                      label: getTranslated(context, 'UTR NO'),
                      obscureText: false,
                      labelStyle: TextStyle(
                        color: PrimaryColor,
                      ),
                      borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                      onChange: (String value) {

                      },
                    ),
                  ),
                ),

                Visibility(
                  maintainSize: false,
                  visible: paymentbank1,
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: InputTextField(
                      controller: bankController,
                      label: getTranslated(context, 'Bank') ,
                      obscureText: false,
                      labelStyle: TextStyle(
                        color: PrimaryColor,
                      ),
                      borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                      onChange: (String value) {

                      },
                    ),
                  ),
                ),

                Visibility(
                  maintainSize: false,
                  visible: paymenttrasaction,
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: InputTextField(
                      controller: transactioncontroller,
                      label: getTranslated(context, 'transaction No'),
                      obscureText: false,
                      labelStyle: TextStyle(
                        color: PrimaryColor,
                      ),
                      borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                      onChange: (String value) {

                      },
                    ),
                  ),
                ),

                Visibility(
                  maintainSize: false,
                  visible: paymentcollection,
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: InputTextField(
                      controller: collectionController,
                      label: getTranslated(context, 'Collection By'),
                      obscureText: false,
                      labelStyle: TextStyle(
                        color: PrimaryColor,
                      ),
                      borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                      onChange: (String value) {
                      },
                    ),
                  ),
                ),

                Visibility(
                  maintainSize: false,
                  visible: paymentcomment,
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: InputTextField(
                      controller: commentController,
                      label: getTranslated(context, 'Comment'),
                      obscureText: false,
                      labelStyle: TextStyle(
                        color: PrimaryColor,
                      ),
                      borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                      onChange: (String value) {

                      },
                    ),
                  ),
                ),
                MainButtonSecodn(
                    onPressed: btnclick == false ? null : () async{

                      setState(() {

                        _isloading = true;
                      });

                      if(paymentMode1 == "Cash"){

                        if(collectionController.text == ""){

                          final snackBar2 = SnackBar(
                            backgroundColor: Colors.red[900],
                            content: Text(getTranslated(context, 'Please Enter Collection') + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar2);

                        }else if(commentController.text == ""){

                          final snackBar2 = SnackBar(
                            backgroundColor: Colors.red[900],
                            content: Text(getTranslated(context, 'Please Enter Comment') + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar2);

                        }else {

                          requestmaster(paymentMode1, collectionController.text,
                              commentController.text, roll1, roll);

                        }


                      }else if (paymentMode1 == "Credit"){

                        if(collectionController.text == ""){

                          final snackBar2 = SnackBar(
                            backgroundColor: Colors.red[900],
                            content: Text(getTranslated(context, 'Please Enter Collection') + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar2);

                        }else if(commentController.text == ""){

                          final snackBar2 = SnackBar(
                            backgroundColor: Colors.red[900],
                            content: Text(getTranslated(context, 'Please Enter Comment') + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar2);

                        }else {

                          requestmaster(paymentMode1, collectionController.text,
                              commentController.text, roll1, roll);

                        }

                      }else if (paymentMode1 == "Branch/Cms Deposit") {


                        if(depositslipcontroller.text == ""){

                          final snackBar2 = SnackBar(
                            backgroundColor: Colors.red[900],
                            content: Text("Please Enter depositSlip No." + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar2);

                        }else if(commentController.text == ""){

                          final snackBar2 = SnackBar(
                            backgroundColor: Colors.red[900],
                            content: Text(getTranslated(context, 'Please Enter Comment') + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar2);

                        }else {

                          requestmasterbranch(paymentMode1,masterBank1,masterBankAcc,depositslipcontroller.text,
                              commentController.text, roll1, roll);

                        }


                      } else if(paymentMode1 == "Online Transfer") {

                        if(utrController.text == ""){

                          final snackBar2 = SnackBar(
                            backgroundColor: Colors.red[900],
                            content: Text("Please Enter Utr No." + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar2);

                        }else {

                          requestmasterOnline(paymentMode1,masterBank1,paymentType1,utrController.text,masterBankAcc, roll1, roll);

                        }


                      } else if (paymentMode1 == "Wallet") {



                        if(transactioncontroller.text == ""){

                          final snackBar2 = SnackBar(
                            backgroundColor: Colors.red[900],
                            content: Text(getTranslated(context, 'Please Enter Trasaction No') + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar2);

                        }else if(commentController.text == ""){

                          final snackBar2 = SnackBar(
                            backgroundColor: Colors.red[900],
                            content: Text(getTranslated(context, 'Please Enter Comment') + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar2);

                        }else {

                          requestmasterWallet(paymentMode1,masterwallet1,masterwalletno,transactioncontroller.text,commentController.text, roll1, roll);

                        }


                      }


                    },
                    color: SecondaryColor,
                    btnText:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: _isloading ? Center(child: SizedBox(
                              height: 20,
                              child: LinearProgressIndicator(backgroundColor: PrimaryColor,valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
                            ),) :
                            Text(getTranslated(context, 'Submit'),style: TextStyle(color: TextColor),textAlign: TextAlign.center,)
                        )
                      ],
                    )
                ),

                Container(
                  child: Row(
                    children: [
                      BackButtons(
                        btnText: getTranslated(context, 'back'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }



  void requestmaster(String mode,String collection, String comment,String retailerroll,String dealerroll) async{


    var uuid = Uuid();
    var keyst = uuid.v1().substring(0,16);
    var ivstr = uuid.v4().substring(0,16);

    String keySTR = keyst.toString(); //16 byte
    String ivSTR =  ivstr.toString(); //16 byte

    String keyencoded = base64.encode(utf8.encode(keySTR));
    String viencoded = base64.encode(utf8.encode(ivSTR));


    final key = encrypt.Key.fromUtf8(keySTR);
    final iv = encrypt.IV.fromUtf8(ivSTR);

    final encrypter = encrypt.Encrypter(encrypt.AES(key,mode: encrypt.AESMode.cbc,padding: 'PKCS7'));

    final encrypted1 =encrypter.encrypt(mode, iv: iv);
    final encrypted3 =encrypter.encrypt(collection, iv: iv);
    final encrypted4 =encrypter.encrypt(comment, iv: iv);
    final encrypted12 =encrypter.encrypt(retailerroll, iv: iv);
    final encrypted13 =encrypter.encrypt(dealerroll, iv: iv);


    String mode1 = encrypted1.base64;
    String collection1 = encrypted3.base64;
    String comment1 = encrypted4.base64;
    String retailerroll1 = encrypted12.base64;
    String dealerroll1 = encrypted13.base64;

    String alfa = widget.adminamount;

    String type1 = "";
    String deposit1 = "";
    String utrno1 = "";
    String account1 = "";
    String walletno1 = "";
    String bank1 = "";
    String transaction1 = "";
    String walletbank1 = "";



    purchaseadmin(alfa, mode1,type1,collection1,comment1,deposit1,utrno1,account1,walletno1,
        bank1,transaction1,walletbank1,retailerroll1,dealerroll1,keyencoded,viencoded);

  }

  void requestmasterbranch(String mode,String bank,String account, String deposit, String comment,String retailerroll,String dealerroll) async{



    var uuid = Uuid();
    var keyst = uuid.v1().substring(0,16);
    var ivstr = uuid.v4().substring(0,16);

    String keySTR = keyst.toString(); //16 byte
    String ivSTR =  ivstr.toString(); //16 byte

    String keyencoded = base64.encode(utf8.encode(keySTR));
    String viencoded = base64.encode(utf8.encode(ivSTR));


    final key = encrypt.Key.fromUtf8(keySTR);
    final iv = encrypt.IV.fromUtf8(ivSTR);

    final encrypter = encrypt.Encrypter(encrypt.AES(key,mode: encrypt.AESMode.cbc,padding: 'PKCS7'));

    final encrypted1 =encrypter.encrypt(mode, iv: iv);
    final encrypted2 =encrypter.encrypt(bank, iv: iv);
    final encrypted3 =encrypter.encrypt(account, iv: iv);
    final encrypted4 =encrypter.encrypt(deposit, iv: iv);
    final encrypted5 =encrypter.encrypt(comment, iv: iv);
    final encrypted6 =encrypter.encrypt(retailerroll, iv: iv);
    final encrypted7 =encrypter.encrypt(dealerroll, iv: iv);



    String mode1 = encrypted1.base64;
    String bank1 = encrypted2.base64;
    String account1 = encrypted3.base64;
    String deposit1 = encrypted4.base64;
    String comment1 = encrypted5.base64;
    String retailerroll1 = encrypted6.base64;
    String dealerroll1 = encrypted7.base64;


    String alfa = widget.adminamount;

    String type1 = "";
    String collection1 = "";
    String utrno1 = "";
    String walletno1 = "";
    String transaction1 = "";
    String walletbank1 = "";



    purchaseadmin(alfa, mode1,type1,collection1,comment1,deposit1,utrno1,account1,walletno1,
        bank1,transaction1,walletbank1,retailerroll1,dealerroll1,keyencoded,viencoded);

  }

  void requestmasterOnline(String mode,String bank, String type,String utrno , String account,String retailerroll,String dealerroll) async{



    var uuid = Uuid();
    var keyst = uuid.v1().substring(0,16);
    var ivstr = uuid.v4().substring(0,16);

    String keySTR = keyst.toString(); //16 byte
    String ivSTR =  ivstr.toString(); //16 byte

    String keyencoded = base64.encode(utf8.encode(keySTR));
    String viencoded = base64.encode(utf8.encode(ivSTR));


    final key = encrypt.Key.fromUtf8(keySTR);
    final iv = encrypt.IV.fromUtf8(ivSTR);

    final encrypter = encrypt.Encrypter(encrypt.AES(key,mode: encrypt.AESMode.cbc,padding: 'PKCS7'));

    final encrypted1 =encrypter.encrypt(mode, iv: iv);
    final encrypted2 =encrypter.encrypt(bank, iv: iv);
    final encrypted3 =encrypter.encrypt(type, iv: iv);
    final encrypted4 =encrypter.encrypt(utrno, iv: iv);
    final encrypted5 =encrypter.encrypt(account, iv: iv);
    final encrypted6 =encrypter.encrypt(retailerroll, iv: iv);
    final encrypted7 =encrypter.encrypt(dealerroll, iv: iv);



    String mode1 = encrypted1.base64;
    String bank1 = encrypted2.base64;
    String type1 = encrypted3.base64;
    String utrno1 = encrypted4.base64;
    String account1 = encrypted5.base64;
    String retailerroll1 = encrypted6.base64;
    String dealerroll1 = encrypted7.base64;


    String alfa = widget.adminamount;

    String deposit1 = "";
    String walletno1 = "";
    String transaction1 = "";
    String walletbank1 = "";
    String collection1 = "";
    String comment1 = "";



    purchaseadmin(alfa, mode1,type1,collection1,comment1,deposit1,utrno1,account1,walletno1,
        bank1,transaction1,walletbank1,retailerroll1,dealerroll1,keyencoded,viencoded);

  }

  void requestmasterWallet(String mode,String walletbank, String walletno,String transaction,String comment,String retailerroll,String dealerroll) async{



    var uuid = Uuid();
    var keyst = uuid.v1().substring(0,16);
    var ivstr = uuid.v4().substring(0,16);

    String keySTR = keyst.toString(); //16 byte
    String ivSTR =  ivstr.toString(); //16 byte

    String keyencoded = base64.encode(utf8.encode(keySTR));
    String viencoded = base64.encode(utf8.encode(ivSTR));


    final key = encrypt.Key.fromUtf8(keySTR);
    final iv = encrypt.IV.fromUtf8(ivSTR);

    final encrypter = encrypt.Encrypter(encrypt.AES(key,mode: encrypt.AESMode.cbc,padding: 'PKCS7'));

    final encrypted1 =encrypter.encrypt(mode, iv: iv);
    final encrypted2 =encrypter.encrypt(walletbank, iv: iv);
    final encrypted3 =encrypter.encrypt(walletno, iv: iv);
    final encrypted4 =encrypter.encrypt(transaction, iv: iv);
    final encrypted5 =encrypter.encrypt(comment, iv: iv);
    final encrypted6 =encrypter.encrypt(retailerroll, iv: iv);
    final encrypted7 =encrypter.encrypt(dealerroll, iv: iv);



    String mode1 = encrypted1.base64;
    String walletbank1 = encrypted2.base64;
    String walletno1 = encrypted3.base64;
    String transaction1 = encrypted4.base64;
    String comment1 = encrypted5.base64;
    String retailerroll1 = encrypted6.base64;
    String dealerroll1 = encrypted7.base64;



    String alfa = widget.adminamount;

    String type1 = "";
    String deposit1 = "";
    String utrno1 = "";
    String account1 = "";
    String bank1 = "";
    String collection1 = "";


    purchaseadmin(alfa, mode1,type1,collection1,comment1,deposit1,utrno1,account1,walletno1,
        bank1,transaction1,walletbank1,retailerroll1,dealerroll1,keyencoded,viencoded);

  }





}
