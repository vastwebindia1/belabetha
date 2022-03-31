import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/DealerMainPage.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart'as http;
import 'package:encrypt/encrypt.dart' as encrypt;

class FundTransferRetailer extends StatefulWidget {
  const FundTransferRetailer({Key key}) : super(key: key);

  @override
  _FundTransferRetailerState createState() => _FundTransferRetailerState();
}

class _FundTransferRetailerState extends State<FundTransferRetailer> {

  List paymentMode = ["Cash","Credit","Branch/Cms Deposit","Online Transfer","Wallet","Charge Back"];
  List paymenttype = ["NEFT","IMPS","RTGS","UPI","Same Bank"];
  List dealerBankname;
  List dealerwallet;

  String dealerwallet1 = "Select Wallet";
  String dealerwalletno;

  String dealerbank1 = "Select Dealer Bank";
  String dealerbankacc;

  List districtlist;
  String _myState;
  String _mydis;
  String dropdownValue = "sikandr";
  int _value = 1;
  String paymentMode1 = "Select Payment Mode";
  String paymentType1 = "Payment Type";
  bool _validate = false;
  ScrollController listSlide = ScrollController();
  TextEditingController _textController = TextEditingController();

  TextEditingController amountController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController collectionController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController utrController = TextEditingController();
  TextEditingController accountController = TextEditingController();
  TextEditingController walletController = TextEditingController();
  TextEditingController bankController = TextEditingController();
  TextEditingController depositslipcontroller = TextEditingController();
  TextEditingController transactioncontroller = TextEditingController();
  TextEditingController walletbankController = TextEditingController();
  TextEditingController subjectController = TextEditingController();

  TextEditingController otpcontroller = TextEditingController();

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
  bool paymentSubject = false;

  bool chargebackbtn = false;

  bool _isloading = false;
  bool btnclick = true;

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
                            paymentSubject = false;

                          } else if (paymentMode1 == "Credit") {

                            paymentcomment = true;
                            paymentcollection = false;
                            paymentslip = false;
                            paymentbank = false;
                            paymentaccount = false;
                            paymentOptions = false;
                            paymentutr = false;
                            paymentwalletbank = false;
                            paymentwallet = false;
                            paymenttrasaction = false;
                            paymentSubject = false;

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
                            paymentSubject = false;

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
                            paymentSubject = false;

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
                            paymentSubject = false;

                          }else if(paymentMode1 == "Charge Back"){

                            paymentcomment = true;
                            paymentcollection = false;
                            paymentslip = false;
                            paymentbank = false;
                            paymentaccount = false;
                            paymentOptions = false;
                            paymentutr = false;
                            paymentwalletbank = false;
                            paymentwallet = false;
                            paymenttrasaction = false;
                            paymentSubject = true;

                          }else{

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

  void dealerbankdialog() {
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
                  'Select Distributer Bank',
                  style: TextStyle(color: TextColor, fontSize: 22),
                ),
              ),
              content: Container(
                // Change as per your requirement
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                  itemCount: dealerBankname.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      visualDensity: VisualDensity(vertical: 0, horizontal: 0),
                      isThreeLine: false,
                      contentPadding: EdgeInsets.all(0),
                      minVerticalPadding: 2,
                      horizontalTitleGap: 0,
                      onTap: () {

                        setState(() {
                          dealerbank1 = dealerBankname[index]["banknm"];
                          dealerbankacc = dealerBankname[index]["acno"];

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
                              dealerBankname[index]["banknm"],
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

  void dealerwalletdialog() {
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
                child: ListView.builder(
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                  itemCount: dealerwallet.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      visualDensity: VisualDensity(vertical: 0, horizontal: 0),
                      isThreeLine: false,
                      contentPadding: EdgeInsets.all(0),
                      minVerticalPadding: 2,
                      horizontalTitleGap: 0,
                      onTap: () {

                        setState(() {
                          dealerwallet1 = dealerwallet[index]["walletname"];
                          dealerwalletno = dealerwallet[index]["walletno"];

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
                              dealerwallet[index]["walletname"],
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

  Future<void> adminDealerBankList() async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url = new Uri.http("api.vastwebindia.com", "/api/data/DealerBankList");
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
      var dataa = json.decode(response.body);
      var data1 = dataa["DealerBankwalletlist"];
      var databind = data1["bindALLWallet"];
      var databind1 = databind["channel"];
      var distributerwallet = databind1["dealerbanklist"];
      var distributerbank = databind1["DealerWalletlist"];

      setState(() {
        dealerBankname = distributerbank;
        dealerwallet = distributerwallet;


      });



    } else {
      throw Exception('Failed to load themes');
    }



  }

  Future<void> chargebacksendotp(String retailerid) async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url = new Uri.http("api.vastwebindia.com", "/api/data/ChargebackSendOTP",{
      "retailermobile": retailerid
    });
    final http.Response response = await http.post(
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
      var dataa = json.decode(response.body);
      print(dataa);


      if(dataa == "Success"){


        final snackBar2 = SnackBar(
          backgroundColor: Colors.greenAccent,
          content: Text("Send OTP Successfully to Retailer Number..",style: TextStyle(color: Colors.black),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);

        setState(() {
          chargebackbtn = true;
        });
      }else{

        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(dataa,style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);

      }




    } else {
      throw Exception('Failed to load themes');
    }



  }

  Future<void> chargebackverifyotp(String otp) async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url = new Uri.http("api.vastwebindia.com", "/api/data/CheckOTPChargeback",{
      "otps": otp
    });
    final http.Response response = await http.post(
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
      var dataa = json.decode(response.body);
      print(dataa);


      if(dataa == "Success"){

        setState(() {
          inputVisible = false;
          textVisible = true;
          chargebackbtn = false;
        });
        generateUniqueId();

      }else{

        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(dataa,style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);


      }


    } else {
      throw Exception('Failed to load themes');
    }



  }

  Future<void> fundTransferRetailer(String alfa1,String mode2,String type2, String collection2,
      String comment2, String deposit2, String utrno2, String account2, String walletno2,
      String bank2,String transaction2, String subject1,String mdWallet2,String mdSettelment2,
      String mdCreditDetails2,String userId2,String pinNo2,String transId2, String key, String vi) async {

     final storage = new FlutterSecureStorage();
     var a = await storage.read(key: "accessToken");

    String token = a;
    var url = new Uri.http("api.vastwebindia.com", "/api/data/jlklkj");

    Map map = {
      "hdMDDLM": userId2,
      "hdPaymentMode": mode2,
      "hdPaymentAmount": alfa1,
      "hdMDDepositeSlipNo": deposit2,
      "hdMDTransferType": type2,
      "hdMDcollection": collection2,
      "hdMDComments": comment2,
      "hdMDaccountno": account2,
      "hdMDutrno": utrno2,
      "hdMDwallet": mdWallet2,
      "hdMDwalletno": walletno2,
      "hdMDtransationno":transaction2,
      "hdMDsettelment": mdSettelment2,
      "hdMDCreditDetail": mdCreditDetails2,
      "hdMDsubject": subject1,
      "hdMDBank": bank2,
      "txtcode": pinNo2,
      "transferid": transId2,
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
        btnclick = true;
        _isloading = false;
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
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => DealermaninDashboard()));
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

  List retailer = [];

  String retailerName = "Select Retailer Name";
  String retailerId = "";
  String retailerFirm = "";
  String retailerAmount = "";
  String trasactionId = "";
  String retailerCredit = "";
  String mobilenum;
  String newAmount = "";
  bool inputVisible = true;
  bool textVisible = false;

  void retailerListdialog(){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setStatee){
            return Container(
              color: Colors.black.withOpacity(0.8),
              child: AlertDialog(
                buttonPadding: EdgeInsets.all(0),
                titlePadding: EdgeInsets.all(0),
                contentPadding: EdgeInsets.only(left: 10,right: 10),
                title: Container(
                  child: Column(
                    children: [
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
                                child: Text(getTranslated(context, 'Select Retailer'),
                                  style: TextStyle(color: TextColor,fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),

                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 8,bottom: 8,left: 10,right: 10),
                        color: PrimaryColor.withOpacity(0.9),
                        child: TextField(
                          onChanged: (value) {
                            setStatee(() {

                            });
                          },
                          controller: _textController,
                          decoration: InputDecoration(
                            labelText:getTranslated(context, 'Search'),
                            hintText:getTranslated(context, 'Search'),
                            labelStyle: TextStyle(color: TextColor),
                            hintStyle: TextStyle(color: TextColor),
                            contentPadding: EdgeInsets.only(left: 25),
                            suffixIcon:Icon(Icons.search,color: TextColor,) ,
                            border: OutlineInputBorder(
                                gapPadding: 1,
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(width: 1,color: TextColor)
                            ),
                            enabledBorder: OutlineInputBorder(
                                gapPadding: 1,
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(width: 1,color: TextColor)
                            ),
                            focusedBorder:  OutlineInputBorder(
                                gapPadding: 1,
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(width: 1,color: TextColor)
                            ),
                          ),
                          style: TextStyle(color: TextColor,fontSize: 20),
                          cursorColor: TextColor,
                          cursorHeight: 20,
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
                          itemCount: retailer.length,
                          itemBuilder: (context,  index) {
                            if (_textController.text.isEmpty) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      style: ButtonStyle(
                                        overlayColor: MaterialStateProperty.all(Colors.transparent) ,
                                        shadowColor: MaterialStateProperty.all(Colors.transparent),
                                        backgroundColor:MaterialStateProperty.all(Colors.transparent) ,
                                        padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                                      ),
                                      onPressed: (){

                                        setState(() {

                                          retailerName = retailer[index]["Name"];
                                          retailerId  =  retailer[index]["UserID"];
                                          retailerFirm = retailer[index]["firmName"];
                                          retailerAmount = retailer[index]["RemainAmt"].toString();
                                          retailerCredit = retailer[index]["currentcr"].toString();
                                          mobilenum = retailer[index]["Mobile"].toString();
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(top: 5),
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(getTranslated(context, 'name')  + ":" + retailer[index]["Name"].toString().toUpperCase(),textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                            Text( getTranslated(context, 'FirmName') +" : " + retailer[index]["firmName"].toString().toUpperCase(),textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                            Text(getTranslated(context, 'Current Amount') +" : " + retailer[index]["RemainAmt"].toString(),textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                            Text("Mobile" +" : " + retailer[index]["Mobile"].toString(),textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                            Container(margin: EdgeInsets.only(top: 5),height: 1,color: PrimaryColor,)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else if (retailer[index]["Name"].toLowerCase().contains(_textController.text) || retailer[index]["Name"].toUpperCase().contains(_textController.text)) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          style: ButtonStyle(
                                            padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                                          ),
                                          onPressed: (){

                                            setState(() {

                                              retailerName = retailer[index]["Name"];
                                              retailerId  =  retailer[index]["UserID"];
                                              retailerFirm = retailer[index]["firmName"];
                                              retailerAmount = retailer[index]["RemainAmt"].toString();
                                              retailerCredit = retailer[index]["currentcr"].toString();
                                              mobilenum = retailer[index]["Mobile"].toString();
                                            });
                                            _textController.clear();
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(getTranslated(context, 'name')  + ":" + retailer[index]["Name"].toString().toUpperCase(),textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                                Text( getTranslated(context, 'FirmName') +" : " + retailer[index]["firmName"].toString().toUpperCase(),textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                                Text(getTranslated(context, 'Current Amount') +" : " + retailer[index]["RemainAmt"].toString(),textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                                Text("Mobile" +" : " + retailer[index]["Mobile"].toString(),textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                                Container(margin: EdgeInsets.only(top: 5),height: 1,color: PrimaryColor,)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(height: 1,color: PrimaryColor,margin: EdgeInsets.only(top: 0,bottom: 0),)
                                ],
                              );
                            }
                            else if (retailer[index]["firmName"].toLowerCase().contains(_textController.text) || retailer[index]["firmName"].toUpperCase().contains(_textController.text)) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          style: ButtonStyle(
                                            padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                                          ),
                                          onPressed: (){

                                            setState(() {

                                              retailerName = retailer[index]["Name"];
                                              retailerId  =  retailer[index]["UserID"];
                                              retailerFirm = retailer[index]["firmName"];
                                              retailerAmount = retailer[index]["RemainAmt"].toString();
                                              retailerCredit = retailer[index]["currentcr"].toString();
                                              mobilenum = retailer[index]["Mobile"].toString();
                                            });
                                            _textController.clear();
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(getTranslated(context, 'name')  + ":" + retailer[index]["Name"].toString().toUpperCase(),textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                                Text( getTranslated(context, 'FirmName') +" : " + retailer[index]["firmName"].toString().toUpperCase(),textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                                Text(getTranslated(context, 'Current Amount') +" : " + retailer[index]["RemainAmt"].toString(),textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                                Text("Mobile" +" : " + retailer[index]["Mobile"].toString(),textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                                Container(margin: EdgeInsets.only(top: 5),height: 1,color: PrimaryColor,)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(height: 1,color: PrimaryColor,margin: EdgeInsets.only(top: 0,bottom: 0),)
                                ],
                              );
                            }
                            else if (retailer[index]["Mobile"].contains(_textController.text) || retailer[index]["Mobile"].contains(_textController.text)) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          style: ButtonStyle(
                                            padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                                          ),
                                          onPressed: (){

                                            setState(() {

                                              retailerName = retailer[index]["Name"];
                                              retailerId  =  retailer[index]["UserID"];
                                              retailerFirm = retailer[index]["firmName"];
                                              retailerAmount = retailer[index]["RemainAmt"].toString();
                                              retailerCredit = retailer[index]["currentcr"].toString();
                                              mobilenum = retailer[index]["Mobile"].toString();

                                            });
                                            _textController.clear();
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(getTranslated(context, 'name')  + ":" + retailer[index]["Name"].toString().toUpperCase(),textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                                Text( getTranslated(context, 'FirmName') +" : " + retailer[index]["firmName"].toString().toUpperCase(),textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                                Text(getTranslated(context, 'Current Amount') +" : " + retailer[index]["RemainAmt"].toString(),textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                                Text("Mobile" +" : " + retailer[index]["Mobile"].toString(),textAlign: TextAlign.left,style: TextStyle(color: PrimaryColor),),
                                                Container(margin: EdgeInsets.only(top: 5),height: 1,color: PrimaryColor,)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(height: 1,color: PrimaryColor,margin: EdgeInsets.only(top: 0,bottom: 0),)
                                ],
                              );
                            }else {
                              return Container(
                              );
                            }

                          },
                        ),),
                    )
                ),
              ),
            );
          });
        });

  }

  Future<void> retailerList() async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var url = new Uri.http("api.vastwebindia.com", "/api/data/retailer_list");
    final http.Response response = await http.post(
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
      var dataa1 = json.decode(response.body);


      setState(() {
        retailer = dataa1;

      });


    } else {
      throw Exception('Failed to load themes');
    }


  }

  Future<void> generateUniqueId() async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var url = new Uri.http("api.vastwebindia.com", "/api/data/dlm_to_Rem_Generate_Unique_ID");
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
      var dataa1 = json.decode(response.body);
      var result = dataa1["Response"];
      trasactionId = dataa1["Message"];

      setState(() {

        trasactionId;

      });


    } else {
      throw Exception('Failed to load themes');
    }


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retailerList();
    adminDealerBankList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TextColor,
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Visibility(
                visible: inputVisible,
                child: Container(
                  margin: EdgeInsets.only(left: 0, right: 0),
                  child: Column(
                    children: [
                      /*select Option=============*/
                      SizedBox(
                        height: 10,
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
                          onPressed: retailerListdialog,
                          child: Container(
                            child: Row(
                              children: [
                                Expanded(child: Text(retailerName,style: TextStyle(color: PrimaryColor,fontWeight: FontWeight.normal,fontSize: 16),)),
                                SizedBox(width: 20,child: Icon(Icons.arrow_drop_down,color: PrimaryColor,),)
                              ],
                            ),
                          ),
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
                            onPressed: dealerwalletdialog,
                            child: Container(
                              child: Row(
                                children: [
                                  Expanded(child: Text(dealerwallet1,style: TextStyle(color: PrimaryColor,fontWeight: FontWeight.normal),)),
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
                            label: dealerwalletno,
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
                            onPressed: dealerbankdialog,
                            child: Container(
                              child: Row(
                                children: [
                                  Expanded(child: Text(dealerbank1 == null ? "" : dealerbank1,style: TextStyle(color: PrimaryColor,fontWeight: FontWeight.normal),)),
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
                            label: dealerbankacc,
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

                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: InputTextField(
                          controller: amountController,
                          label: getTranslated(context, 'Enter Amount'),
                          obscureText: false,
                          labelStyle: TextStyle(
                            color: PrimaryColor
                            ,
                          ),
                          borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                          onChange: (String value) {
                          },
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
                            errorText:  _validate ? '' : null,
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
                        visible: paymentSubject,
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          child: InputTextField(
                            controller: subjectController,
                            label: getTranslated(context, 'Subject Reason'),
                            errorText:  _validate ? '' : null,
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
                            errorText:  _validate ? '' : null,
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
                        visible: chargebackbtn,
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          child: InputTextField(
                            controller: otpcontroller,
                            label: "Enter OTP",
                            errorText:  _validate ? '' : null,
                            obscureText: false,
                            labelStyle: TextStyle(
                              color: PrimaryColor,
                            ),
                            keyBordType: TextInputType.number,
                            borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                            onChange: (String value) {

                            },

                          ),
                        ),
                      ),

                      Visibility(
                        visible: chargebackbtn,
                        child: MainButtonSecodn(

                            onPressed:  () {

                              if(otpcontroller.text == ""){

                                final snackBar2 = SnackBar(
                                  backgroundColor: Colors.red[900],
                                  content: Text("Please Enter Valid Otp!!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                                );

                                ScaffoldMessenger.of(context).showSnackBar(snackBar2);

                              }else{

                                chargebackverifyotp(otpcontroller.text);

                              }
                            },
                            color: SecondaryColor,
                            btnText:Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child:_isloading ? Center(child: SizedBox(
                                      height: 20,
                                      child: LinearProgressIndicator(backgroundColor: PrimaryColor,valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
                                    ),) :
                                    Text("Submit OTP",style: TextStyle(color: TextColor),textAlign: TextAlign.center,)
                                ),
                              ],
                            )
                        ),
                        replacement: MainButtonSecodn(

                            onPressed:  () {
                              if(paymentMode1 == "Cash"){

                                if (collectionController.text == ""){
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


                                }else{

                                  setState(() {
                                    inputVisible = false;
                                    textVisible = true;
                                  });

                                  generateUniqueId();

                                }

                              }

                              if(paymentMode1 == "Credit"){

                                if(commentController.text == ""){

                                  final snackBar2 = SnackBar(
                                    backgroundColor: Colors.red[900],
                                    content: Text(getTranslated(context, 'Please Enter Comment') + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(snackBar2);


                                }else{

                                  setState(() {
                                    inputVisible = false;
                                    textVisible = true;
                                  });

                                  generateUniqueId();

                                }

                              }

                              if(paymentMode1 == "Charge Back"){

                                if (subjectController.text == ""){

                                  final snackBar2 = SnackBar(
                                    backgroundColor: Colors.red[900],
                                    content: Text(getTranslated(context, 'Please Enter Subject') + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(snackBar2);


                                }else if(commentController.text == ""){

                                  final snackBar2 = SnackBar(
                                    backgroundColor: Colors.red[900],
                                    content: Text(getTranslated(context, 'Please Enter Comment') + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(snackBar2);


                                }else{


                                  chargebacksendotp(retailerId);


                                }

                              }

                              if(paymentMode1 == "Branch/Cms Deposit"){

                                if (depositslipcontroller.text == ""){

                                  final snackBar2 = SnackBar(
                                    backgroundColor: Colors.red[900],
                                    content: Text(getTranslated(context, 'Please Enter Deposit No') + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(snackBar2);


                                }else if(commentController.text == ""){

                                  final snackBar2 = SnackBar(
                                    backgroundColor: Colors.red[900],
                                    content: Text(getTranslated(context, 'Please Enter Comment') + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(snackBar2);


                                }else{

                                  setState(() {
                                    inputVisible = false;
                                    textVisible = true;
                                  });

                                  generateUniqueId();

                                }

                              }

                              if(paymentMode1 == "Wallet"){

                                if (transactioncontroller.text == ""){

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


                                }else{

                                  setState(() {
                                    inputVisible = false;
                                    textVisible = true;
                                  });

                                  generateUniqueId();

                                }

                              }

                              if(paymentMode1 == "Online Transfer"){

                                setState(() {
                                  inputVisible = false;
                                  textVisible = true;
                                });

                                generateUniqueId();


                              }



                            },
                            color: SecondaryColor,
                            btnText:Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child:_isloading ? Center(child: SizedBox(
                                      height: 20,
                                      child: LinearProgressIndicator(backgroundColor: PrimaryColor,valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
                                    ),) :
                                    Text(getTranslated(context, 'Submit'),style: TextStyle(color: TextColor),textAlign: TextAlign.center,)
                                ),
                              ],
                            )
                        ),
                      )


                    ],
                  ),
                ),
              ),

              Visibility(
                visible: textVisible,
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(

                            )
                        ),
                        child: Row(

                          children: [
                            Expanded(
                              child: Text(getTranslated(context, 'Trasaction ID'),style: TextStyle(fontSize: 14,),
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Text(trasactionId == null ? "" :trasactionId,style: TextStyle(fontSize: 12,),
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(

                            )
                        ),
                        child: Row(

                          children: [
                            Expanded(
                              child: Text(getTranslated(context, 'Payment Type'),style: TextStyle(fontSize: 14,),
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Text(paymentMode1,style: TextStyle(fontSize: 12,),
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(

                            )
                        ),
                        child: Row(

                          children: [
                            Expanded(
                              child: Text(getTranslated(context, 'Order Amount'),style: TextStyle(fontSize: 14,),
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Text("\u{20B9}" + amountController.text,style: TextStyle(fontSize: 12,),
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(

                            )
                        ),
                        child: Row(

                          children: [
                            Expanded(
                              child: Text(getTranslated(context, 'Old Credit'),style: TextStyle(fontSize: 14,),
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Text("\u{20B9}" + retailerCredit == null ? "" : "\u{20B9}" + retailerCredit,style: TextStyle(fontSize: 12,),
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(

                            )
                        ),
                        child: Row(

                          children: [
                            Expanded(
                              child: Text(getTranslated(context, 'Net Transfer'),style: TextStyle(fontSize: 14,),
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Text("\u{20B9}" + amountController.text,style: TextStyle(fontSize: 12,),
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(

                            )
                        ),
                        child: Row(

                          children: [
                            Expanded(
                              child: Text(getTranslated(context, 'Retailer Current Bal'),style: TextStyle(fontSize: 14,),
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Text( "\u{20B9}" + retailerAmount == null ? "" : "\u{20B9}" +retailerAmount,style: TextStyle(fontSize: 12,),
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 50,
                        child:InputTextField(
                          keyBordType: TextInputType.number,
                          controller: pinController,
                          label: getTranslated(context, 'Enter Trans Pin'),
                          obscureText: false,
                          labelStyle: TextStyle(
                            color: PrimaryColor,
                          ),
                          borderSide: BorderSide(width: 2, style: BorderStyle.solid),
                          onChange: (String value) {

                          },
                        ),

                      ),
                      SizedBox(
                        height: 5,
                      ),

                      MainButtonSecodn(
                          onPressed:btnclick == false ? null : () {

                            setState(() {
                              _isloading = true;
                              btnclick = false;
                            });

                            if(paymentMode1 == "Cash"){

                              fundTransferEncription(paymentMode1, collectionController.text,
                                  commentController.text,retailerId,pinController.text,trasactionId);

                            }else if (paymentMode1 == "Credit"){

                              fundTransfercreditEncription(paymentMode1,
                                  commentController.text, retailerId,pinController.text,trasactionId);

                            }
                            else if(paymentMode1 == "Charge Back") {

                              fundTransferBackEncription(paymentMode1, subjectController.text,
                                  commentController.text,retailerId,pinController.text,trasactionId);


                            }
                            else if (paymentMode1 == "Branch/Cms Deposit") {

                              fundTransferBranchEncription(paymentMode1,dealerbank1,dealerbankacc,depositslipcontroller.text,
                                  commentController.text, retailerId, pinController.text,trasactionId);

                            } else if(paymentMode1 == "Online Transfer") {

                              fundTransferOnlineEncription(paymentMode1,dealerbank1,paymentType1,utrController.text,dealerbankacc, retailerId, pinController.text,trasactionId);

                            }else if (paymentMode1 == "Wallet") {

                              fundTransferWalletEncription(paymentMode1,dealerwallet1,dealerwalletno,transactioncontroller.text,commentController.text,retailerId, pinController.text,trasactionId);

                            }
                          },
                          color: SecondaryColor,
                          btnText:Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child:_isloading ? Center(child: SizedBox(
                                    height: 20,
                                    child: LinearProgressIndicator(backgroundColor: PrimaryColor,valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
                                  ),) :
                                  Text(getTranslated(context, 'Confirm Transfer'),style: TextStyle(color: TextColor),textAlign: TextAlign.center,)
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


            ],
          ),





        ),
      ),

    );
  }

  void fundTransferEncription(String mode,String collection, String comment,String userId,String pinNo,String transId) async{


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
    final encrypted12 =encrypter.encrypt(userId, iv: iv);
    final encrypted13 =encrypter.encrypt(pinNo, iv: iv);
    final encrypted14 =encrypter.encrypt(transId, iv: iv);


    String mode1 = encrypted1.base64;
    String collection1 = encrypted3.base64;
    String comment1 = encrypted4.base64;
    String userId1 = encrypted12.base64;
    String pinNo1 = encrypted13.base64;
    String transId1 = encrypted14.base64;


    String alfa = amountController.text;
    String type1 = "";
    String deposit1 = "";
    String utrno1 = "";
    String account1 = "";
    String walletno1 = "";
    String bank1 = "";
    String transaction1 = "";
    String subject = "";
    String mdWallet = "";
    String mdSettelment = "";
    String mdCreditDetails = "";


    fundTransferRetailer(alfa, mode1,type1,collection1,comment1,deposit1,utrno1,
        account1,walletno1,bank1,transaction1,subject,mdWallet,mdSettelment,
        mdCreditDetails,userId1,pinNo1,transId1,keyencoded,viencoded);

  }

  void fundTransfercreditEncription(String mode, String comment,String userId,String pinNo,String transId) async{


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
    final encrypted4 =encrypter.encrypt(comment, iv: iv);
    final encrypted12 =encrypter.encrypt(userId, iv: iv);
    final encrypted13 =encrypter.encrypt(pinNo, iv: iv);
    final encrypted14 =encrypter.encrypt(transId, iv: iv);


    String mode1 = encrypted1.base64;
    String comment1 = encrypted4.base64;
    String userId1 = encrypted12.base64;
    String pinNo1 = encrypted13.base64;
    String transId1 = encrypted14.base64;


    String alfa = amountController.text;
    String type1 = "";
    String deposit1 = "";
    String utrno1 = "";
    String account1 = "";
    String walletno1 = "";
    String bank1 = "";
    String transaction1 = "";
    String subject = "";
    String mdWallet = "";
    String mdSettelment = "";
    String mdCreditDetails = "";
    String collection1 = "";

    fundTransferRetailer(alfa, mode1,type1,collection1,comment1,deposit1,utrno1,
        account1,walletno1,bank1,transaction1,subject,mdWallet,mdSettelment,
        mdCreditDetails,userId1,pinNo1,transId1,keyencoded,viencoded);

  }

  void fundTransferBackEncription(String mode,String subject2, String comment,String userId,String pinNo,String transId) async{


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
    final encrypted3 =encrypter.encrypt(subject2, iv: iv);
    final encrypted4 =encrypter.encrypt(comment, iv: iv);
    final encrypted12 =encrypter.encrypt(userId, iv: iv);
    final encrypted13 =encrypter.encrypt(pinNo, iv: iv);
    final encrypted14 =encrypter.encrypt(transId, iv: iv);


    String mode1 = encrypted1.base64;
    String subject = encrypted3.base64;
    String comment1 = encrypted4.base64;
    String userId1 = encrypted12.base64;
    String pinNo1 = encrypted13.base64;
    String transId1 = encrypted14.base64;


    String alfa = amountController.text;
    String type1 = "";
    String deposit1 = "";
    String utrno1 = "";
    String account1 = "";
    String walletno1 = "";
    String bank1 = "";
    String transaction1 = "";
    String collection1 = "";
    String mdWallet = "";
    String mdSettelment = "";
    String mdCreditDetails = "";


    fundTransferRetailer(alfa, mode1,type1,subject,comment1,deposit1,utrno1,
        account1,walletno1,bank1,transaction1,subject,mdWallet,mdSettelment,
        mdCreditDetails,userId1,pinNo1,transId1,keyencoded,viencoded);

  }

  void fundTransferBranchEncription(String mode,String bank,String account, String deposit, String comment,String userId,String pinNo,String transId) async{


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
    final encrypted6 =encrypter.encrypt(userId, iv: iv);
    final encrypted7 =encrypter.encrypt(pinNo, iv: iv);
    final encrypted14 =encrypter.encrypt(transId, iv: iv);



    String mode1 = encrypted1.base64;
    String bank1 = encrypted2.base64;
    String account1 = encrypted3.base64;
    String deposit1 = encrypted4.base64;
    String comment1 = encrypted5.base64;
    String userId1 = encrypted6.base64;
    String pinNo1 = encrypted7.base64;
    String transId1 = encrypted14.base64;

    String alfa = amountController.text;

    String type1 = "";
    String collection1 = "";
    String utrno1 = "";
    String walletno1 = "";
    String transaction1 = "";
    String walletbank1 = "";
    String subject = "";
    String mdWallet = "";
    String mdSettelment = "";
    String mdCreditDetails = "";



    fundTransferRetailer(alfa, mode1,type1,collection1,comment1,deposit1,utrno1,
        account1,walletno1,bank1,transaction1,subject,mdWallet,mdSettelment,
        mdCreditDetails,userId1,pinNo1,transId1,keyencoded,viencoded);

  }

  void fundTransferOnlineEncription(String mode,String bank, String type,String utrno , String account,String userId,String pinNo,String transId ) async{


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
    final encrypted6 =encrypter.encrypt(userId, iv: iv);
    final encrypted7 =encrypter.encrypt(pinNo, iv: iv);
    final encrypted14 =encrypter.encrypt(transId, iv: iv);



    String mode1 = encrypted1.base64;
    String bank1 = encrypted2.base64;
    String type1 = encrypted3.base64;
    String utrno1 = encrypted4.base64;
    String account1 = encrypted5.base64;
    String userId1 = encrypted6.base64;
    String pinNo1 = encrypted7.base64;
    String transId1 = encrypted14.base64;

    String alfa = amountController.text;

    String deposit1 = "";
    String walletno1 = "";
    String transaction1 = "";
    String walletbank1 = "";
    String collection1 = "";
    String comment1 = "";
    String subject = "";
    String mdWallet = "";
    String mdSettelment = "";
    String mdCreditDetails = "";



    fundTransferRetailer(alfa, mode1,type1,collection1,comment1,deposit1,utrno1,
        account1,walletno1,bank1,transaction1,subject,mdWallet,mdSettelment,
        mdCreditDetails,userId1,pinNo1,transId1,keyencoded,viencoded);

  }

  void fundTransferWalletEncription(String mode,String walletbank, String walletno,String transaction,String comment,String userId,String pinNo,String transId) async{



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
    final encrypted6 =encrypter.encrypt(userId, iv: iv);
    final encrypted7 =encrypter.encrypt(pinNo, iv: iv);
    final encrypted14 =encrypter.encrypt(transId, iv: iv);




    String mode1 = encrypted1.base64;
    String walletbank1 = encrypted2.base64;
    String walletno1 = encrypted3.base64;
    String transaction1 = encrypted4.base64;
    String comment1 = encrypted5.base64;
    String userId1 = encrypted6.base64;
    String pinNo1 = encrypted7.base64;
    String transId1 = encrypted14.base64;


    String alfa = amountController.text;

    String type1 = "";
    String deposit1 = "";
    String utrno1 = "";
    String account1 = "";
    String bank1 = "";
    String collection1 = "";
    String subject = "";
    String mdWallet = "";
    String mdSettelment = "";
    String mdCreditDetails = "";


    fundTransferRetailer(alfa, mode1,type1,collection1,comment1,deposit1,utrno1,
        account1,walletno1,bank1,transaction1,subject,mdWallet,mdSettelment,
        mdCreditDetails,userId1,pinNo1,transId1,keyencoded,viencoded);

  }

}

