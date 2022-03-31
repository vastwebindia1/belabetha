import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/dthRechargePage.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;

import '../../dashboard.dart';

class ToSelf extends StatefulWidget {
  const ToSelf({Key key}) : super(key: key);

  @override
  _ToSelfState createState() => _ToSelfState();
}

bool viewVisible = true;
bool viewVisible1 = false;

class _ToSelfState extends State<ToSelf> {
  void showWidget() {
    setState(() {
      viewVisible = true;
      viewVisible1 = false;
    });
  }

  void hideWidget() {
    setState(() {
      viewVisible = false;
      viewVisible1 = true;
    });
  }

  String btnTextChange = "IMPS";

  void changeText() {
    setState(() {
      if (btnTextChange == 'IMPS') {
        btnTextChange = 'NEFT';
      } else if (btnTextChange =='NEFT') {
        btnTextChange = 'IMPS';
      }
    });
  }

  ScrollController controller = ScrollController();

  TextEditingController amountController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController amountController1 = TextEditingController();

  List charges = [];
  double posBalance;

  double mainBalance;
  double creditBalance;
  double holdBalance;
  double adminCreditBalance;
  double dealerBalance;
  String transid = "";

  bool _isloading = false;

  bool errorText = false;

  String bankname = "";
  String bankacc = "";
  String bankifse = "";

  Future<void> allBalanceShow() async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url = new Uri.http(
        "api.vastwebindia.com", "/Retailer/api/data/Show_ALL_balanceremRem");
    final http.Response response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response);

    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      var dataa1 = dataa["data"];
      mainBalance = dataa1[0]["remainbal"];
      posBalance = dataa1[0]["posremain"];
      creditBalance = dataa1[0]["totalCurrentcr"];
      holdBalance = dataa1[0]["tholdamount"];
      adminCreditBalance = dataa1[0]["admincr"];
      dealerBalance = dataa1[0]["dealer"];

      setState(() {
        posBalance == null ? DoteLoader() : posBalance;

      });
    } else {
      throw Exception('Failed to load themes');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allBalanceShow();
    walletChargesList();
    retailerBankDetails();
  }

  Future<void> retailerBankDetails() async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var url = new Uri.http("api.vastwebindia.com", "/WalletUnload/api/data/ShowbankdetailsforWalletToBank");
    final http.Response response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response);

    if (response.statusCode == 200) {
      var dataa1 = json.decode(response.body);
      var data1 = dataa1["bankdetails"];
      var keyy = dataa1["kkkk"];
      var vii = dataa1["vvvv"];

      var keee = base64.decode(keyy);
      var viii = base64.decode(vii);

      String keySTR = utf8.decode(keee);
      String ivSTR = utf8.decode(viii);

      final key = encrypt.Key.fromUtf8(keySTR);
      final iv = encrypt.IV.fromUtf8(ivSTR);

      final encrypter11 = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));
      final decrypted12 = encrypter11.decrypt(encrypt.Encrypted.fromBase64(data1), iv: iv);

      var dataa2 = json.decode(decrypted12);

      var dataa4 = dataa2["data"];

      bankname = dataa4["bankname"].toString();
      bankacc = dataa4["accno"].toString();
      bankifse = dataa4["bankifsccode"].toString();

      setState(() {
        bankname == null ? "" :bankname;
        bankacc == null ? "" : bankacc;
        bankifse == null ? "" : bankifse;
      });


    } else {
      throw Exception('Failed to load themes');
    }
  }

  void walletChargedialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.black.withOpacity(0.8),
            alignment: Alignment.topLeft,
            child: AlertDialog(
              insetPadding: EdgeInsets.only(right: 5, left: 5,),
              buttonPadding: EdgeInsets.all(0),
              titlePadding: EdgeInsets.all(0),
              contentPadding: EdgeInsets.only(left: 5, right: 5),
              title: Column(
                children: [
                  Container(
                    color: PrimaryColor,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(
                                top: 15, bottom: 15, left: 10, right: 10),
                            child: Text(
                              getTranslated(context, 'Wallet Charges'),
                              style:
                              TextStyle(color: TextColor, fontSize: 22),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            Icons.clear,
                            color: TextColor,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Expanded(
                          child: Text(
                            getTranslated(context, 'min'),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            getTranslated(context, 'max'),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "IMPS \u{20B9}",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            getTranslated(context, 'NEFT')+
                            " \u{20B9}",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              content: Container(
                // Change as per your requirement
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                  itemCount: charges.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 5, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Expanded(
                            child: Text(
                              charges[index]["Min"].toString() == null ? "" :charges[index]["Min"].toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              charges[index]["Max"].toString() == null ? "" :charges[index]["Max"].toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              charges[index]["IMPS"].toString() == null ? "" :  charges[index]["IMPS"].toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              charges[index]["NEFT"].toString() == null ? "" : charges[index]["NEFT"].toString(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        });
  }

  Future<void> walletChargesList() async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url = new Uri.http("api.vastwebindia.com",
        "/WalletUnload/api/data/WalletToBankAmountTransfer");
    final http.Response response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response);

    if (response.statusCode == 200) {
      var data2 = json.decode(response.body);
      var status = data2["status"];
      var response1 = data2["Response"];

      setState(() {
        charges = response1;
      });
    } else {
      throw Exception('Failed to load themes');
    }
  }

  Future<void> walletTransitionId(String amountChek, String amountType) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var uri = new Uri.http("api.vastwebindia.com",
        "/WalletUnload/api/data/GenerateWalletTransectiongenerateid", {
          "Amount": amountChek,
          "Type": amountType,
        });
    final http.Response response = await http.post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      transid = data["transferid"];
      var status = data["sts"];

      setState(() {
        transid;

        walletUnload(
            amountController.text, btnTextChange, transid, pinController.text);
      });
    } else {
      throw Exception('Failed to load data from internet');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: AppBarWidget(
        title: CenterAppbarTitleWithIcon(
          icon: Icon(Icons.replay_circle_filled,color: Colors.white,),
          topText:getTranslated(context, 'Selected Info'),
          selectedItemName: viewVisible1 ? getTranslated(context, 'To Main Wallet') :getTranslated(context, 'To Bank Account') ,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: StickyHeader(
                overlapHeaders: false,
                header: Container(
                  color: TextColor,
                  padding: EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: PrimaryColor.withOpacity(0.04),
                            ),
                            borderRadius: BorderRadius.circular(20),
                            color: PrimaryColor.withOpacity(0.08),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 160,
                                child: Text(
                                  getTranslated(context, 'Available Pos Balance'),
                                  style: TextStyle(fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              posBalance == null
                                  ? DoteLoader()
                                  : Text(
                                "\u{20B9} " + posBalance.toString(),
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showWidget();
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                  top: viewVisible1 ? 7 : 6,
                                  bottom: viewVisible1 ? 8 : 6,
                                  right: viewVisible1 ? 20 : 8,
                                  left: viewVisible1 ? 20 : 8,
                                ),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: SecondaryColor,
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(50))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      viewVisible
                                          ? Icons.check_circle
                                          : Icons.check_circle,
                                      size: viewVisible ? 19 : 0,
                                    ),
                                    SizedBox(
                                      width: viewVisible ? 5 : 0,
                                    ),
                                    Container(
                                      width: 90,
                                      child: Text(
                                          getTranslated(context, 'To Bank Ac').toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: viewVisible
                                                ? FontWeight.bold
                                                : viewVisible1
                                                ? FontWeight.normal
                                                : FontWeight.normal),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                hideWidget();
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                  top: viewVisible ? 7 : 6,
                                  bottom: viewVisible ? 7 : 6,
                                  right: viewVisible ? 18 : 5,
                                  left: viewVisible ? 18 : 5,
                                ),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: SecondaryColor,
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(50))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      viewVisible1
                                          ? Icons.check_circle
                                          : Icons.check_circle,color:SecondaryColor,
                                      size: viewVisible1 ? 19 : 0,
                                    ),
                                    SizedBox(
                                      width: viewVisible1 ? 5 : 0,
                                    ),
                                    Container(
                                      width: 120,
                                      child: Text(
                                          getTranslated(context, 'To Main Wallet').toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: viewVisible1
                                                ? FontWeight.bold
                                                : viewVisible
                                                ? FontWeight.normal
                                                : FontWeight.normal),
                                          overflow: TextOverflow.ellipsis,
                                      ),
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
                content: Column(
                  children: [
                    Visibility(
                      maintainSize: false,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: viewVisible,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            SizedBox(
                              height: 8,
                            ),
                            Visibility(
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: PrimaryColor.withOpacity(
                                                0.08),
                                            blurRadius: 0,
                                            spreadRadius: 1,
                                            offset: Offset(.0,
                                                .0), // shadow direction: bottom right
                                          )
                                        ],
                                      ),
                                      child:bankname.length <1? DoteLoader(): Container(
                                        margin: EdgeInsets.only(
                                            left: 0.5,
                                            right: 0.5,
                                            top: 0.5,
                                            bottom: 0.5),
                                        child: Container(
                                          color:
                                          Colors.white.withOpacity(0.5),
                                          padding: EdgeInsets.only(
                                              top: 10,
                                              bottom: 5,
                                              left: 5,
                                              right: 5),
                                          child: Column(
                                            children: [
                                              CustomerInfo(
                                                firstText:getTranslated(context, 'Bank name'),
                                                secondText: bankname == null ? "": bankname,

                                              ),
                                              CustomerInfo(
                                                firstText:getTranslated(context, 'Account Number'),
                                                secondText: bankacc == null ? "": bankacc,
                                              ),
                                              CustomerInfo(
                                                firstText:getTranslated(context, 'IFSC Code'),
                                                secondText: bankifse == null ? "" : bankifse,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              child: InputTextField(
                                obscureText: false,
                                keyBordType: TextInputType.number,
                                controller: amountController,
                                label: getTranslated(context, 'Enter Amount'),
                                labelStyle: TextStyle(color: PrimaryColor),
                                iButton: SizedBox(
                                    height: 10,
                                    width: 25,
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: 6,
                                            left: 6,
                                            right: 20,
                                            bottom: 10),
                                        /* color: SecondaryColor,*/
                                        child: TextButton(
                                          style: ButtonStyle(
                                            shape:
                                            MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    30),
                                              ),
                                            ),
                                            padding:
                                            MaterialStateProperty.all(
                                                EdgeInsets.zero),
                                          ),
                                          child: Icon(
                                            Icons.info,
                                            color: SecondaryColor,
                                            size: 35,
                                          ),
                                          onPressed: walletChargedialog,
                                        ))),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: OutlineButton(
                                onPressed: changeText,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                                splashColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                clipBehavior: Clip.none,
                                autofocus: false,
                                color: Colors.transparent,
                                highlightColor: Colors.transparent,
                                highlightedBorderColor: PrimaryColor,
                                focusColor: PrimaryColor,
                                disabledBorderColor: PrimaryColor,
                                padding: EdgeInsets.only(
                                    top: 12,
                                    bottom: 12,
                                    left: 10,
                                    right: 10),
                                borderSide: BorderSide(
                                    width: 1, color: PrimaryColor),
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          child: Text(
                                            btnTextChange,
                                            overflow:TextOverflow.ellipsis,
                                            maxLines: 1,
                                            softWrap: true,
                                            style: TextStyle(color: PrimaryColor,fontWeight:FontWeight.normal, fontSize: 18,),
                                          ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(50),
                                            color: PrimaryColor),
                                        child: Icon(
                                          Icons
                                              .swap_horizontal_circle_sharp,
                                          color: TextColor,
                                          size: 30,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              child: InputTextField(
                                controller: pinController,
                                obscureText: false,
                                keyBordType: TextInputType.number,
                                label:getTranslated(context, 'Enter Trans Pin'),
                                labelStyle: TextStyle(color: PrimaryColor),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Visibility(
                                      child: Container(
                                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            padding: EdgeInsets.all(15),
                                            backgroundColor: SecondaryColor,
                                            shadowColor: Colors.transparent,
                                          ),
                                          onPressed: () {

                                            setState(() {
                                              _isloading = true;
                                            });
                                            walletTransitionId(amountController.text, btnTextChange);
                                          },
                                          child:_isloading ? Center(
                                            child: SizedBox(
                                              height: 20,
                                              child: LinearProgressIndicator(
                                                backgroundColor: PrimaryColor, valueColor:
                                                AlwaysStoppedAnimation<
                                                    Color>(
                                                    Colors.white),
                                              ),
                                            ),
                                          ) : Text(
                                            getTranslated(context, 'Submit'),
                                            style: TextStyle(
                                              color: TextColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            /*lsit==========*/
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      maintainSize: false,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: viewVisible1,
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              child: InputTextField(
                                controller: amountController1,
                                obscureText: false,
                                keyBordType: TextInputType.number,
                                labelStyle: TextStyle(color: PrimaryColor),
                                label:getTranslated(context, 'Enter Amount'),
                                onChange: (String val) {
                                  if (val.length > 0) {
                                    setState(() {
                                      errorText = false;
                                    });
                                  }
                                },
                              ),
                            ),
                            Visibility(
                              maintainSize: false,
                              visible: errorText,
                              child: Container(
                                margin: EdgeInsets.only(left: 10, top: 10),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  getTranslated(context, 'Your Pos Blance is Low'),
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.red),
                                ),
                              ),
                            ),
                            /*SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: InputTextField(
                                keyBordType: TextInputType.number,
                                obscureText: false,
                                labelStyle: TextStyle(color: PrimaryColor),
                                label: "Enter pin",
                              ),
                            ),*/
                            /*Buttons*/
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Visibility(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10, top: 10),
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            padding: EdgeInsets.all(15),
                                            backgroundColor: SecondaryColor,
                                            shadowColor: Colors.transparent,
                                          ),
                                          onPressed: () {
                                            var g = amountController1.text;

                                            double dd = double.parse(g);

                                            setState(() {
                                              _isloading = true;

                                              if (dd >= posBalance) {
                                                _isloading = false;

                                                errorText = true;
                                              } else if (dd <= posBalance) {
                                                errorText = false;

                                                _isloading = true;

                                                posWalletUnload(
                                                    amountController1.text);
                                              }
                                            });
                                          },
                                          child: _isloading
                                              ? Center(
                                            child: SizedBox(
                                              height: 20,
                                              child:
                                              LinearProgressIndicator(
                                                backgroundColor:
                                                PrimaryColor,
                                                valueColor:
                                                AlwaysStoppedAnimation<
                                                    Color>(
                                                    Colors.white),
                                              ),
                                            ),
                                          )
                                              : Text(
                                            getTranslated(context, 'Submit'),
                                            style: TextStyle(
                                              color: TextColor,
                                              fontWeight:
                                              FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> walletUnload(String amount, String type, String id, String pin) async {
      final storage = new FlutterSecureStorage();
      var token = await storage.read(key: "accessToken");

      var uri = new Uri.http("api.vastwebindia.com",
        "/WalletUnload/api/data/AddWalletToBankRequest", {
          "Amount": amount,
          "Type": type,
          "transid": id,
          "dmtpin": pin,
        });
    final http.Response response = await http.post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 30), onTimeout: () {
      setState(() {
        _isloading = false;
      });
    });

    print(response);

    if (response.statusCode == 200) {
      _isloading = false;

      var data1 = json.decode(response.body);
      var status = data1["Response"];
      var msz = data1["Message"];

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
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => Dashboard()));},

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

      throw Exception('Failed to load data from internet');
    }
  }

  Future<void> posWalletUnload(String amount1) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var uri = new Uri.http("api.vastwebindia.com", "/MPOS/api/mPos/pos_to_Wallet_TransferAmount", {"amount": amount1,
    });
    final http.Response response = await http.post(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 30), onTimeout: () {
      setState(() {
        _isloading = false;
      });
    });

    print(response);

    if (response.statusCode == 200) {
      _isloading = false;

      var data2 = json.decode(response.body);
      var status = data2["Status"];
      var msz = data2["msg"];

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
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => Dashboard()));
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

      throw Exception('Failed to load data from internet');
    }
  }

}
