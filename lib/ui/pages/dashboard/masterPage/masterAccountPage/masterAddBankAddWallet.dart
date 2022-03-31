import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/CommanWidget/dialogBox.dart';
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:http/http.dart' as http;

class MasterAddWalletAddBank extends StatefulWidget {
  const MasterAddWalletAddBank({Key key}) : super(key: key);

  @override
  _MasterAddWalletAddBankState createState() => _MasterAddWalletAddBankState();
}

class _MasterAddWalletAddBankState extends State<MasterAddWalletAddBank> {
  List dealerAccountList = [];
  List dealerWalletList = [];

  String accountId = "";
  String walletId = "";

  bool editbtn = true;
  bool savebtn = false;
  bool editbtn2 = true;
  bool savebtn2 = false;
  TextEditingController bankNameController = TextEditingController();
  TextEditingController ifscCodeController = TextEditingController();
  TextEditingController accHoldername = TextEditingController();
  TextEditingController accNumberController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController acctypeController = TextEditingController();

  TextEditingController walletHolderController = TextEditingController();
  TextEditingController walletNameController = TextEditingController();
  TextEditingController walletNumberController = TextEditingController();

  ScrollController listSlide = ScrollController();

  String name1 = "";
  String firmName1 = "";
  String mobile1 = "";
  String pinCode1 = "";
  String email1 = "";
  String dobDate1 = "";
  String businessType1 = "";
  String businessTypeCode1 = "";

  Future<void> masterAccountWalletInfo() async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url = new Uri.http("api.vastwebindia.com", "/api/data/master_BankInfo");
    final http.Response response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 15), onTimeout: () {
      setState(() {
        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(getTranslated(context, 'Data Not Found'),
              style: TextStyle(color: Colors.yellowAccent),
              textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);
      });
    });

    print(response);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var bankAccount = data["banklist"];
      var bankWallet = data["Walletlis"];

      setState(() {
        dealerAccountList = bankAccount;
        dealerWalletList = bankWallet;
      });
    } else {
      throw Exception('Failed to load themes');
    }
  }

  Future<void> masterAddBankAccount(
      String bankName,
      String branch,
      String ifscCode,
      String accNumber,
      String accType,
      String accHolder,
      String city) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url =
        new Uri.http("api.vastwebindia.com", "/api/data/Add_Master_Bank", {
      "Banknm": bankName,
      "BranchName": branch,
      "ifsccode": ifscCode,
      "accountno": accNumber,
      "accounttype": accType,
      "accountholder": accHolder,
      "City": city,
    });
    final http.Response response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 15), onTimeout: () {
      setState(() {
        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(getTranslated(context, 'Data Not Found'),
              style: TextStyle(color: Colors.yellowAccent),
              textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);
      });
    });

    print(response);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var status = data["status"];

      if (status == "Success") {
        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: getTranslated(context, 'Added success'),
          title: status,
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            Navigator.pop(context);
          },
        );
      } else {
        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: getTranslated(context, 'Not Add'),
          title: status,
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.red,
          onConfirmBtnTap: (){
            Navigator.of(context).pop();

          },
        );
      }
    } else {
      throw Exception('Failed to load themes');
    }
  }

  Future<void> masterAddBankWallet(
    String walletname,
    String walletno,
    String walletHolder,
  ) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url =
        new Uri.http("api.vastwebindia.com", "/api/data/Add_Master_Wallet", {
      "walletnm": walletname,
      "walletno": walletno,
      "walletholdername": walletHolder,
    });
    final http.Response response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 15), onTimeout: () {
      setState(() {
        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(getTranslated(context, 'Data Not Found'),
              style: TextStyle(color: Colors.yellowAccent),
              textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);
      });
    });

    print(response);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var status = data["banklist"];
      var bankWallet = data["Walletlis"];

      if (status == "Success") {
        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: getTranslated(context, 'Added success'),
          title: status,
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => MasterAddWalletAddBank()));
          },
        );
      } else {
        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: getTranslated(context, 'Not Add'),
          title: status,
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.red,
          onConfirmBtnTap: (){
            Navigator.of(context).pop();

          },
        );
      }
    } else {
      throw Exception('Failed to load themes');
    }
  }

  Future<void> masterDeleatWalletAcc(String delete) async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url =
        new Uri.http("api.vastwebindia.com", "/api/data/Delet_master_bank", {
      "id": delete,
    });
    final http.Response response = await http.delete(
      url,
      headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 15), onTimeout: () {
      setState(() {
        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(getTranslated(context, 'Data Not Found'),
              style: TextStyle(color: Colors.yellowAccent),
              textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);
      });
    });

    print(response);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var status = data["status"];

      if (status == "Success") {
        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.7),
          context: context,
          type: CoolAlertType.success,
          text: getTranslated(context, 'DELETE success'),
          title: status,
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: (){
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => MasterAddWalletAddBank()));
          },
        );
      } else {
        CoolAlert.show(
          backgroundColor: PrimaryColor.withOpacity(0.6),
          context: context,
          type: CoolAlertType.error,
          text: getTranslated(context, 'Not Add'),
          title: status,
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.red,
          onConfirmBtnTap: (){
            Navigator.of(context).pop();

          },
        );
      }
    } else {
      throw Exception('Failed to load themes');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    masterAccountWalletInfo();
  }

  bool _validate = false;
  bool _validate1 = false;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SimpleAppBarWidget(
      title: Align(
          alignment: Alignment(-.3, 0),
          child: Text(
            getTranslated(context, 'Add Account & Add Wallet'),
            style: TextStyle(color: TextColor),
            textAlign: TextAlign.center,
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Visibility(
              visible: editbtn,
              child: Container(
                margin:
                    EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: PrimaryColor.withOpacity(0.08),
                      blurRadius: 0,
                      spreadRadius: 1,
                      offset: Offset(.0, .0), // shadow direction: bottom right
                    )
                  ],
                ),
                child: Container(
                  margin: EdgeInsets.only(
                      left: 0.5, right: 0.5, top: 0.5, bottom: 0.5),
                  child: Container(
                    color: TextColor.withOpacity(0.5),
                    padding:
                        EdgeInsets.only(top: 5, bottom: 0, left: 5, right: 5),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 0, bottom: 5),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                            color: PrimaryColor.withOpacity(0.5),
                            width: 3,
                          ))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getTranslated(
                                        context, 'Bank Account Information'),
                                    style: TextStyle(
                                        fontSize: 20, color: SecondaryColor),
                                    textAlign: TextAlign.left,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 26,
                                    width: 60,
                                    margin: EdgeInsets.only(top: 2),
                                    child: FlatButton(
                                      color: SecondaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(0.3),
                                      ),
                                      padding: EdgeInsets.all(0),
                                      onPressed: () {
                                        setState(() {
                                          editbtn = false;
                                          savebtn = true;
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_outlined,
                                            size: 14,
                                            color: TextColor,
                                          ),
                                          Text(
                                            getTranslated(context, 'Add'),
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: TextColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        FutureBuilder(
                          builder: (context, projectSnap) {
                            if (projectSnap.connectionState ==
                                    ConnectionState.none &&
                                projectSnap.hasData == null) {
                              //print('project snapshot data is: ${projectSnap.data}');
                              return Container();
                            }
                            return ListView.builder(
                              controller: listSlide,
                              shrinkWrap: true,
                              itemCount: dealerAccountList.length,
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                return Stack(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                      decoration: BoxDecoration(
                                          color: TextColor,
                                          border: Border.all(
                                            color:
                                                PrimaryColor.withOpacity(0.1),
                                            width: 1,
                                          )),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                              color:
                                                  PrimaryColor.withOpacity(0.1),
                                              width: 1,
                                            ))),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      getTranslated(
                                                          context, 'Bank Name'),
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Text(
                                                      getTranslated(
                                                          context, 'IFSC Code'),
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                      ),
                                                      textAlign:
                                                          TextAlign.right,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: dealerAccountList[
                                                                      index]
                                                                  ["banknm"] ==
                                                              null
                                                          ? DoteLoader()
                                                          : Text(
                                                              dealerAccountList[
                                                                      index]
                                                                  ["banknm"],
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              overflow:
                                                                  TextOverflow
                                                                      .clip,
                                                            ),
                                                    ),
                                                    Expanded(
                                                      child: dealerAccountList[
                                                                          index]
                                                                      [
                                                                      "ifsccode"]
                                                                  .toString() ==
                                                              null
                                                          ? DoteLoader()
                                                          : Text(
                                                              dealerAccountList[
                                                                          index]
                                                                      [
                                                                      "ifsccode"]
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              overflow:
                                                                  TextOverflow
                                                                      .clip,
                                                            ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                              color:
                                                  PrimaryColor.withOpacity(0.1),
                                              width: 1,
                                            ))),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      getTranslated(context,
                                                          'Account Holder Name'),
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Text(
                                                      getTranslated(context,
                                                          'Account No'),
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                      ),
                                                      textAlign:
                                                          TextAlign.right,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: dealerAccountList[
                                                                      index][
                                                                  "holdername"] ==
                                                              null
                                                          ? DoteLoader()
                                                          : Text(
                                                              dealerAccountList[
                                                                      index][
                                                                  "holdername"],
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              overflow:
                                                                  TextOverflow
                                                                      .clip,
                                                            ),
                                                    ),
                                                    Expanded(
                                                      child: dealerAccountList[
                                                                          index]
                                                                      ["acno"]
                                                                  .toString() ==
                                                              null
                                                          ? DoteLoader()
                                                          : Text(
                                                              dealerAccountList[
                                                                          index]
                                                                      ["acno"]
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              overflow:
                                                                  TextOverflow
                                                                      .clip,
                                                            ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                top: 5, bottom: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      getTranslated(
                                                          context, 'Branch'),
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Text(
                                                      getTranslated(context,
                                                          'Account Type'),
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                      ),
                                                      textAlign:
                                                          TextAlign.right,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: dealerAccountList[
                                                                      index]
                                                                  ["address"] ==
                                                              null
                                                          ? DoteLoader()
                                                          : Text(
                                                              dealerAccountList[
                                                                      index]
                                                                  ["address"],
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              overflow:
                                                                  TextOverflow
                                                                      .clip,
                                                            ),
                                                    ),
                                                    Expanded(
                                                      child: dealerAccountList[
                                                                      index]
                                                                  ["actype"] ==
                                                              null
                                                          ? DoteLoader()
                                                          : Text(
                                                              dealerAccountList[
                                                                      index]
                                                                  ["actype"],
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              overflow:
                                                                  TextOverflow
                                                                      .clip,
                                                            ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: -0,
                                      right: -1,
                                      child: GestureDetector(
                                        child: Icon(
                                          Icons.cancel,
                                          size: 16,
                                          color: Colors.red,
                                        ),
                                        onTap: () {
                                          accountId = dealerAccountList[index]
                                                  ["idno"]
                                              .toString();

                                          masterDeleatWalletAcc(accountId);
                                        },
                                      ),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                          future: masterAccountWalletInfo(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: savebtn,
              child: Container(
                margin:
                    EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: PrimaryColor.withOpacity(0.08),
                      blurRadius: 0,
                      spreadRadius: 1,
                      offset: Offset(.0, .0), // shadow direction: bottom right
                    )
                  ],
                ),
                child: Container(
                  margin: EdgeInsets.only(
                      left: 0.5, right: 0.5, top: 0.5, bottom: 0.5),
                  child: Container(
                    color: TextColor.withOpacity(0.5),
                    padding:
                        EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 0, bottom: 5),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                            color: PrimaryColor.withOpacity(0.5),
                            width: 3,
                          ))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getTranslated(context, 'Add Bank Account'),
                                    style: TextStyle(
                                        fontSize: 20, color: SecondaryColor),
                                    textAlign: TextAlign.left,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        height: 26,
                                        width: 45,
                                        margin: EdgeInsets.only(top: 2),
                                        child: FlatButton(
                                          color: SecondaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(0.3),
                                          ),
                                          padding: EdgeInsets.all(0),
                                          onPressed: () {
                                            setState(() {
                                              editbtn = true;
                                              savebtn = false;
                                            });
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              /*Icon(
                                                Icons.save_rounded,
                                                size: 14,
                                                color: TextColor,
                                              ),*/
                                              Text(
                                                getTranslated(context, 'Close'),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: TextColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        height: 26,
                                        width: 45,
                                        margin: EdgeInsets.only(top: 2),
                                        child: FlatButton(
                                          color: SecondaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(0.3),
                                          ),
                                          padding: EdgeInsets.all(0),
                                          onPressed: ()  {
                                                setState(() {
                                                  editbtn = true;
                                                  savebtn = false;
                                                  masterAddBankAccount(bankNameController.text, branchController.text, ifscCodeController.text, accNumberController.text, acctypeController.text, accHoldername.text, cityController.text);
                                                    });
                                                },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              /*Icon(
                                                Icons.save_rounded,
                                                size: 14,
                                                color: TextColor,
                                              ),*/
                                              Text(
                                                getTranslated(context, 'Save'),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: TextColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                            color: PrimaryColor.withOpacity(0.1),
                            width: 1,
                          ))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            child: TextFormField(
                                          onChanged: (String val) {},
                                          controller: bankNameController,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                            labelText: getTranslated(
                                                context, 'Bank Name'),
                                            isCollapsed: true,
                                            errorText: _validate ? '' : null,
                                            labelStyle:
                                                TextStyle(color: PrimaryColor),
                                            contentPadding: EdgeInsets.only(
                                              top: 12,
                                              bottom: 12,
                                              left: 10,
                                              right: 10,
                                            ),
                                          ),
                                        )

                                            ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            child: TextFormField(
                                          onChanged: (String val) {},
                                          controller: ifscCodeController,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                            labelText: getTranslated(
                                                context, 'IFSC Code'),
                                            isCollapsed: true,
                                            errorText: _validate ? '' : null,
                                            labelStyle:
                                                TextStyle(color: PrimaryColor),
                                            contentPadding: EdgeInsets.only(
                                              top: 12,
                                              bottom: 12,
                                              left: 10,
                                              right: 10,
                                            ),
                                          ),
                                        )
                                            ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                            color: PrimaryColor.withOpacity(0.1),
                            width: 1,
                          ))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            child: TextFormField(
                                          onChanged: (String val) {},
                                          controller: accHoldername,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                            labelText: getTranslated(
                                                context, 'Account Holder Name'),
                                            isCollapsed: true,
                                            errorText: _validate ? '' : null,
                                            labelStyle:
                                                TextStyle(color: PrimaryColor),
                                            contentPadding: EdgeInsets.only(
                                              top: 12,
                                              bottom: 12,
                                              left: 10,
                                              right: 10,
                                            ),
                                          ),
                                        )
                                            ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: TextFormField(
                                            onChanged: (String val) {},
                                            controller: accNumberController,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                            decoration: InputDecoration(
                                              labelText: getTranslated(
                                                  context, 'Account No'),
                                              isCollapsed: true,
                                              errorText: _validate ? '' : null,
                                              labelStyle: TextStyle(
                                                  color: PrimaryColor),
                                              contentPadding: EdgeInsets.only(
                                                top: 12,
                                                bottom: 12,
                                                left: 10,
                                                right: 10,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: TextFormField(
                                            onChanged: (String val) {},
                                            controller: branchController,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                            decoration: InputDecoration(
                                              labelText: getTranslated(
                                                  context, 'Branch'),
                                              isCollapsed: true,
                                              errorText: _validate ? '' : null,
                                              labelStyle: TextStyle(
                                                  color: PrimaryColor),
                                              contentPadding: EdgeInsets.only(
                                                top: 12,
                                                bottom: 12,
                                                left: 10,
                                                right: 10,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: TextFormField(
                                            onChanged: (String val) {},
                                            controller: acctypeController,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                            decoration: InputDecoration(
                                              labelText: getTranslated(
                                                  context, 'Account Type'),
                                              isCollapsed: true,
                                              errorText: _validate ? '' : null,
                                              labelStyle: TextStyle(
                                                  color: PrimaryColor),
                                              contentPadding: EdgeInsets.only(
                                                top: 12,
                                                bottom: 12,
                                                left: 10,
                                                right: 10,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: TextFormField(
                                            onChanged: (String val) {},
                                            controller: cityController,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                            decoration: InputDecoration(
                                              labelText: getTranslated(
                                                  context, 'City'),
                                              isCollapsed: true,
                                              errorText: _validate ? '' : null,
                                              labelStyle: TextStyle(
                                                  color: PrimaryColor),
                                              contentPadding: EdgeInsets.only(
                                                top: 12,
                                                bottom: 12,
                                                left: 10,
                                                right: 10,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Visibility(
              visible: editbtn2,
              child: Container(
                margin:
                    EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: PrimaryColor.withOpacity(0.08),
                      blurRadius: 0,
                      spreadRadius: 1,
                      offset: Offset(.0, .0), // shadow direction: bottom right
                    )
                  ],
                ),
                child: Container(
                  margin: EdgeInsets.only(
                      left: 0.5, right: 0.5, top: 0.5, bottom: 0.5),
                  child: Container(
                    color: TextColor.withOpacity(0.5),
                    padding:
                        EdgeInsets.only(top: 5, bottom: 0, left: 5, right: 5),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 0, bottom: 5),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                            color: PrimaryColor.withOpacity(0.5),
                            width: 3,
                          ))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getTranslated(context, 'Wallet Information'),
                                    style: TextStyle(
                                        fontSize: 20, color: SecondaryColor),
                                    textAlign: TextAlign.left,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 26,
                                    width: 60,
                                    margin: EdgeInsets.only(top: 2),
                                    child: FlatButton(
                                      color: SecondaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(0.3),
                                      ),
                                      padding: EdgeInsets.all(0),
                                      onPressed: () {
                                        setState(() {
                                          editbtn2 = false;
                                          savebtn2 = true;
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_outlined,
                                            size: 14,
                                            color: TextColor,
                                          ),
                                          Container(
                                            child: Text(
                                              getTranslated(context, 'Add'),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: TextColor),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        FutureBuilder(
                          builder: (context, projectSnap) {
                            if (projectSnap.connectionState ==
                                ConnectionState.none &&
                                projectSnap.hasData == null) {
                              //print('project snapshot data is: ${projectSnap.data}');
                              return Container();
                            }
                            return ListView.builder(
                              controller: listSlide,
                              shrinkWrap: true,
                              itemCount: dealerWalletList.length,
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                return Stack(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                      decoration: BoxDecoration(
                                          color: TextColor,
                                          border: Border.all(
                                            color: PrimaryColor.withOpacity(0.1),
                                            width: 1,
                                          )),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding:
                                            EdgeInsets.only(top: 5, bottom: 5),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                      color: PrimaryColor.withOpacity(0.1),
                                                      width: 1,
                                                    ))),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      getTranslated(context, 'Wallet Name') + " :",
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Expanded(
                                                      child: dealerWalletList[index]["walletname"] == null
                                                          ? DoteLoader()
                                                          : Container(
                                                        alignment: Alignment.centerRight,
                                                        child: Text(dealerWalletList[index]["walletname"],
                                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                                          textAlign:TextAlign.left,
                                                          overflow: TextOverflow.clip,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding:
                                            EdgeInsets.only(top: 5, bottom: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      getTranslated(context, 'Wallet No'),
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Text(
                                                      getTranslated(context, 'Wallet Holder'),
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                      ),
                                                      textAlign: TextAlign.right,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: dealerWalletList[index]["walletno"].toString() ==
                                                          null
                                                          ? DoteLoader()
                                                          : Text(
                                                        dealerWalletList[index]["walletno"]
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold),
                                                        textAlign:
                                                        TextAlign.left,
                                                        overflow:
                                                        TextOverflow.clip,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: dealerWalletList[index]["walletholdername"].toString() == null
                                                          ? DoteLoader()
                                                          : Text(
                                                        dealerWalletList[
                                                        index][
                                                        "walletholdername"]
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold),
                                                        textAlign:
                                                        TextAlign.right,
                                                        overflow:
                                                        TextOverflow.clip,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: -0,
                                      right: -1,
                                      child: GestureDetector(
                                        child: Icon(
                                          Icons.cancel,
                                          size: 16,
                                          color: Colors.red,
                                        ),
                                        onTap: () {
                                          accountId = dealerWalletList[index]
                                          ["walletid"]
                                              .toString();

                                          masterDeleatWalletAcc(accountId);
                                        },
                                      ),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                          future: masterAccountWalletInfo(),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: savebtn2,
              child: Container(
                margin:
                    EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: PrimaryColor.withOpacity(0.08),
                      blurRadius: 0,
                      spreadRadius: 1,
                      offset: Offset(.0, .0), // shadow direction: bottom right
                    )
                  ],
                ),
                child: Container(
                  margin: EdgeInsets.only(
                      left: 0.5, right: 0.5, top: 0.5, bottom: 0.5),
                  child: Container(
                    color: TextColor.withOpacity(0.5),
                    padding:
                        EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 0, bottom: 5),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                            color: PrimaryColor.withOpacity(0.5),
                            width: 3,
                          ))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getTranslated(context, 'Add Wallet'),
                                    style: TextStyle(
                                        fontSize: 20, color: SecondaryColor),
                                    textAlign: TextAlign.left,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        height: 26,
                                        width: 45,
                                        margin: EdgeInsets.only(top: 2),
                                        child: FlatButton(
                                          color: SecondaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(0.3),
                                          ),
                                          padding: EdgeInsets.all(0),
                                          onPressed: () {
                                            setState(() {
                                              editbtn2 = true;
                                              savebtn2 = false;
                                            });
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              /*Icon(
                                                Icons.save_rounded,
                                                size: 14,
                                                color: TextColor,
                                              ),*/
                                              Text(
                                                getTranslated(context, 'Close'),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: TextColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        height: 26,
                                        width: 45,
                                        margin: EdgeInsets.only(top: 2),
                                        child: FlatButton(
                                          color: SecondaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(0.3),
                                          ),
                                          padding: EdgeInsets.all(0),
                                          onPressed: () {
                                            setState(() {
                                              editbtn2 = true;
                                              savebtn2 = false;

                                              masterAddBankWallet(
                                                  walletNameController.text,
                                                  walletNumberController.text,
                                                  walletHolderController.text);
                                            });
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              /*Icon(
                                                Icons.save_rounded,
                                                size: 14,
                                                color: TextColor,
                                              ),*/
                                              Text(
                                                getTranslated(context, 'Save'),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: TextColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                            color: PrimaryColor.withOpacity(0.1),
                            width: 1,
                          ))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: TextFormField(
                                            onChanged: (String val) {},
                                            controller: walletHolderController,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                            decoration: InputDecoration(
                                              labelText: getTranslated(
                                                  context, 'wallet Holder Name'),
                                              isCollapsed: true,
                                              errorText: _validate ? '' : null,
                                              labelStyle:
                                              TextStyle(color: PrimaryColor),
                                              contentPadding: EdgeInsets.only(
                                                top: 12,
                                                bottom: 12,
                                                left: 10,
                                                right: 10,
                                              ),
                                            ),
                                          )
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        /*Text(
                                          "Wallet No",
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),*/
                                        Container(
                                          child:TextFormField(
                                            onChanged: (String val) {},
                                            controller: walletNumberController,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                            decoration: InputDecoration(
                                              labelText: getTranslated(
                                                  context, 'Wallet No'),
                                              isCollapsed: true,
                                              errorText: _validate ? '' : null,
                                              labelStyle:
                                              TextStyle(color: PrimaryColor),
                                              contentPadding: EdgeInsets.only(
                                                top: 12,
                                                bottom: 12,
                                                left: 10,
                                                right: 10,
                                              ),
                                            ),
                                          )
                                          /*TextField(
                                            controller: walletNumberController,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                top: 0,
                                                bottom: 0,
                                                left: 10,
                                                right: 10,
                                              ),
                                            ),
                                          )*/,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        /*Text(
                                          "Wallet Name",
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),*/
                                        Container(
                                          child:TextFormField(
                                            onChanged: (String val) {},
                                            controller: walletNameController,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                            decoration: InputDecoration(
                                              labelText: getTranslated(
                                                  context, 'Wallet Name'),
                                              isCollapsed: true,
                                              errorText: _validate ? '' : null,
                                              labelStyle:
                                              TextStyle(color: PrimaryColor),
                                              contentPadding: EdgeInsets.only(
                                                top: 12,
                                                bottom: 12,
                                                left: 10,
                                                right: 10,
                                              ),
                                            ),
                                          )
                                          /*TextField(
                                            controller: walletNameController,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                top: 0,
                                                bottom: 0,
                                                left: 10,
                                                right: 10,
                                              ),
                                            ),
                                          )*/,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
