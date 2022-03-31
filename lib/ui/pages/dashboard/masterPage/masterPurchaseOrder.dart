import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/Doatedborder.dart';
import 'package:myapp/ui/pages/dashboard/masterPage/masterPaymentOption.dart';

import '../dashboard.dart';

class MasterPurchaseOrder extends StatefulWidget {
  const MasterPurchaseOrder({Key key}) : super(key: key);

  @override
  _MasterPurchaseOrderState createState() => _MasterPurchaseOrderState();
}

class _MasterPurchaseOrderState extends State<MasterPurchaseOrder> {
  var balance = "";
  bool errorText = false;

  Future<void> masteruserdetails() async {
    List<dynamic> list;

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var url = new Uri.http("api.vastwebindia.com", "/Common/api/inform/Get_User_Information");
    final http.Response response = await http.get(url,
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
      var data = dataa["data"];
      var keyy = data["kkkk"];
      var vii = data["vvvv"];
      var firmnamee = data["frmanems"];
      var remainbal = data["remainbal"];
      var photoo = data["photoss"];
      var adminfirmnam = data["adminfarmname"];
      var passcode = data["passcodests"]["Status"];

      var keee = base64.decode(keyy);
      var viii = base64.decode(vii);

      String keySTR = utf8.decode(keee);
      String ivSTR = utf8.decode(viii);

      final key = encrypt.Key.fromUtf8(keySTR);
      final iv = encrypt.IV.fromUtf8(ivSTR);
      final encrypter = encrypt.Encrypter(
          encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));


      final decrypted2 =
      encrypter.decrypt(encrypt.Encrypted.fromBase64(remainbal), iv: iv);


      balance = decrypted2.toString();

    } else {
      throw Exception('Failed to load themes');
    }

    setState(() {
      balance;
    });
  }


  TextEditingController amountController = TextEditingController();


  double debitupto;
  double debitabove;
  double prepaidupto;
  double prepaidabove;
  double rupaydebit;
  double creditcard;
  double netbanking;
  double amex;
  double internationalcard;
  double wallet;
  var upi;
  double upi2;
  double getwayupi;

  double debitcharge1 ,debitnet1;
  double prepaidcharge1 ,prepaidnet1;
  double rupaycharge1 , rupaynet1;
  double creditcharge1 ,creditnet1;
  double netbankingcharge1 ,netbankingnet1;
  double amexcharge1, amexnet1;
  double internationalcharge1 , internationalnet1;
  double walletcharge1 ,walletnet1;
  double gatewaycharge1 ,gatewaynet1;
  var upislabstatus1;
  double upicharge1, upinet1;
  var upi1;
  double upinet2;


  bool ccsts = true;
  bool dcsts = true;
  bool netsts = true;
  bool wlttsts = true;
  bool upistatus = true;

  double netbanksxis,netbankingother;


  Future<void> showcharges() async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");
    String token = a;
    var url = new Uri.http("api.vastwebindia.com", "/Common/api/data/Wallet_ALL_Charges_Show");
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
          content: Text(getTranslated(context, 'Data Not Found') + " !!!",style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar2);
      });
    });

    print(response);

    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      var data = dataa["WalletCharges"];
      var keyy = dataa["kkkk"];
      var vii = dataa["vvvv"];

      var keee = base64.decode(keyy);
      var viii = base64.decode(vii);

      String keySTR = utf8.decode(keee);
      String ivSTR = utf8.decode(viii);

      final key = encrypt.Key.fromUtf8(keySTR);
      final iv = encrypt.IV.fromUtf8(ivSTR);
      final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));

      final decrypted1 = encrypter.decrypt(encrypt.Encrypted.fromBase64(data), iv: iv);


      var dataa1 = json.decode(decrypted1);

      var data1 = dataa1["data"];

      setState(() {
        debitupto = data1["debitupto2000"];
        debitabove = data1["debitabove2000"];

        prepaidupto = data1["prepaidcard"];
        rupaydebit = data1["rupaydebit"];
        creditcard = data1["creditcard"];
        netbanking = data1["netbanking"];
        netbanksxis = data1["axis"];

        netbankingother = data1["others"];
        amex = data1["amex"];
        internationalcard = data1["internationalcard"];
        wallet = data1["wallet"];
        getwayupi = data1["UPI"];

        ccsts = data1["CreditCardsts"];
        dcsts = data1["DebitCardsts"];
        netsts = data1["netbankingsts"];
        wlttsts = data1["walletsts"];
        upistatus = data1["upists"];
      });

      /*getwayupi = data1["GetwayUPI"];
      upi2 = data1["Slabupi"];
      upistatus = data1["Slabupi"]["upislabstatus"];


      if(upistatus == "Y"){

        upi = upi2;

      }else{

        upi = getwayupi;

      }
*/

    } else {
      throw Exception('Failed to load themes');
    }

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showcharges();
    masteruserdetails();
  }

  @override
  Widget build(BuildContext context) {
    return SecondAppBarWidget(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Center(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: SecondaryColor,
                        ),
                        child: Icon(
                          Icons.account_balance_wallet,
                          size: 80,
                          color: TextColor,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Center(
                      child: Text(
                        getTranslated(context, 'Add Main Wallet'),
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          getTranslated(context, 'Available Main Wallet Balance'),
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(width: 5,),
                        Text("\u{20B9} " + balance,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,

                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: InputTextField(
                    controller: amountController,
                    keyBordType: TextInputType.number,
                    label: getTranslated(context, 'Enter Amount'),
                    hint: "Enter Amount",
                    onChange: (String val) {
                      if (val.length > 0) {
                        setState(() {
                          errorText = false;
                        });
                      }
                    },
                    obscureText: false,
                    labelStyle: TextStyle(color: PrimaryColor),
                  ),
                ),
                Visibility(
                  maintainSize: false,
                  visible: errorText,
                  child: Container(
                    margin: EdgeInsets.only(left: 10,top: 10),
                    alignment: Alignment.centerLeft,
                    child: Text("Enter Amount",style: TextStyle(fontSize: 18,color: Colors.red),),
                  ),
                ),
                Container(
                    child: MainButton(
                      btnText: getTranslated(context, 'Add Money'),
                      onPressed: (){

                        var g = amountController.text;

                        double dd = double.parse(g);

                        setState(() {

                          if(dd == null){

                            errorText = true;

                          } else if (dd != null) {

                            errorText = false;

                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MasterPaymentOption(amount: amountController.text,)));


                          }


                        });


                      },
                      color: SecondaryColor,
                      style: TextStyle(color: TextColor),
                    )
                ),
                Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: PrimaryColor,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 2,right: 2),
                          child: Text(getTranslated(context, 'Charges Information')),),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: PrimaryColor,
                          ),
                        ),
                      ],
                    )
                ),
                Container(
                  margin: EdgeInsets.only(top: 10,left: 5,right: 5),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,),
                      ChargeInfoText(
                        text:upistatus == true ? "UPI (VPA)" : "UPI (Self)",
                        text3:getwayupi == null ? DoteLoader():Text("% "+getwayupi.toString()),
                      ),
                      SizedBox(
                        height: 3,),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        child: DashedRect(color:SecondaryColor.withOpacity(0.1), strokeWidth: 2.0, gap: 3.0,),
                      ),
                      /* SizedBox(
                        height: 3,),
                      ChargeInfoText(
                        text:"UPI (QR Code)",
                        text3:upi == null ? DoteLoader():Text("% "+upi.toString()),
                      ),
                      SizedBox(
                        height: 3,),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        child: DashedRect(color:SecondaryColor.withOpacity(0.1), strokeWidth: 2.0, gap: 3.0,),
                      ),*/
                      Visibility(
                          visible: ccsts,
                          child: Column(
                            children: [
                              SizedBox(height: 3,),
                              ChargeInfoText(
                                text:getTranslated(context, 'Credit Card'),
                                text3:creditcard == null ? DoteLoader():Text("% "+creditcard.toString()) ,
                              ),
                              SizedBox(height: 3,),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 1,
                                child: DashedRect(color:SecondaryColor.withOpacity(0.1), strokeWidth: 2.0, gap: 3.0,),
                              ),
                            ],
                          )),
                      Visibility(
                          visible: dcsts,
                          child:Column(
                            children: [
                              SizedBox(height: 3,),
                              ChargeInfoText(
                                text:"Debit Card upto 2000",
                                text3:debitupto == null ? DoteLoader():Text("% "+debitupto.toString()),
                              ),
                              SizedBox(height: 3,),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 1,
                                child: DashedRect(color:SecondaryColor.withOpacity(0.1), strokeWidth: 2.0, gap: 3.0,),
                              ),
                            ],
                          )),
                      Visibility(
                          visible: dcsts,
                          child: Column(
                            children: [
                              SizedBox(height: 3,),
                              ChargeInfoText(
                                text: "Debit Card above 2000",
                                text3:debitabove == null ? DoteLoader():Text("% "+debitabove.toString()),
                              ),
                              SizedBox(height: 3,),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 1,
                                child: DashedRect(color:SecondaryColor.withOpacity(0.1), strokeWidth: 2.0, gap: 3.0,),
                              ),
                            ],
                          )),
                      Visibility(
                          child: Column(
                            children: [
                              SizedBox(height: 3,),
                              ChargeInfoText(
                                text:"Rupay Debit Card",
                                text3: Text(getTranslated(context, 'Free'),overflow: TextOverflow.ellipsis,),
                              ),
                              SizedBox(height: 3,),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 1,
                                child: DashedRect(color:SecondaryColor.withOpacity(0.1), strokeWidth: 2.0, gap: 3.0,),
                              ),
                            ],
                          )),
                      Visibility(
                          visible: amex == null ? false :true,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 3,),
                              ChargeInfoText(
                                text:getTranslated(context, 'Amax Card'),
                                text3: amex == null ? DoteLoader(): Text("% "+amex.toString()),
                              ),
                              SizedBox(
                                height: 3,),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 1,
                                child: DashedRect(color:SecondaryColor.withOpacity(0.1), strokeWidth: 2.0, gap: 3.0,),
                              ),
                            ],
                          )),
                      Visibility(
                          visible: netsts,
                          child: Column(
                            children: [
                              SizedBox(height: 3,),
                              ChargeInfoText(
                                text: "Net Banking (HDFC/ICICI)",
                                text3: netbanking == null ? DoteLoader():Text("% "+netbanking.toString()),
                              ),
                              SizedBox(height: 3,),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 1,
                                child: DashedRect(color:SecondaryColor.withOpacity(0.1), strokeWidth: 2.0, gap: 3.0,),
                              ),
                            ],
                          )),
                      Visibility(
                          visible: netsts,
                          child: Column(
                            children: [
                              SizedBox(height: 3,),
                              ChargeInfoText(
                                text: "Net Banking (AXIS/SBI/KOTAK)",
                                text3: netbanksxis == null ? DoteLoader():Text("% "+netbanksxis.toString()),
                              ),
                              SizedBox(height: 3,),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 1,
                                child: DashedRect(color:SecondaryColor.withOpacity(0.1), strokeWidth: 2.0, gap: 3.0,),
                              ),
                            ],
                          )),
                      Visibility(
                          visible: netsts,
                          child: Column(
                            children: [
                              SizedBox(height: 3,),
                              ChargeInfoText(
                                text: "Net Banking (Others Bank)",
                                text3: netbankingother == null ? DoteLoader():Text("% "+netbankingother.toString()),
                              ),
                              SizedBox(height: 3,),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 1,
                                child: DashedRect(color:SecondaryColor.withOpacity(0.1), strokeWidth: 2.0, gap: 3.0,),
                              ),
                            ],
                          )),
                      Visibility(
                          visible: wlttsts,
                          child: Column(
                            children: [
                              SizedBox(height: 3,),
                              ChargeInfoText(
                                text:getTranslated(context, 'Wallets'),
                                text3: wallet == null ? DoteLoader(): Text("% "+wallet.toString()),
                              ),
                              SizedBox(height: 3,),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 1,
                                child: DashedRect(color:SecondaryColor.withOpacity(0.1), strokeWidth: 2.0, gap: 3.0,),
                              ),
                              SizedBox(height: 3,),
                            ],
                          ))
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
}


class ChargeInfoText extends StatefulWidget {
  final String text , text2;
  final Widget text3;
  const ChargeInfoText({
    key, this.text, this.text2, this.text3,
  }) : super(key: key);

  @override
  _ChargeInfoTextState createState() => _ChargeInfoTextState();
}

class _ChargeInfoTextState extends State<ChargeInfoText> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(widget.text)),
        Container(
          alignment: Alignment.centerRight,
          width: 60,
          child: widget.text3,),
      ],
    );
  }
}

class SecondAppBarWidget extends StatefulWidget {
  final body;
  final Widget title;

  const SecondAppBarWidget({key, this.body, this.title}) : super(key: key);

  @override
  _SecondAppBarWidgetState createState() => _SecondAppBarWidgetState();
}

class _SecondAppBarWidgetState extends State<SecondAppBarWidget> {
  String balance = "";

  Future<void> masteruserdetails() async {
    List<dynamic> list;

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var url = new Uri.http("api.vastwebindia.com", "/Common/api/inform/Get_User_Information");
    final http.Response response = await http.get(url,
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
      var data = json.decode(response.body);
      var keyy = data["kkkk"];
      var vii = data["vvvv"];
      var remainbal = data["remainbal"];

      var keee = base64.decode(keyy);
      var viii = base64.decode(vii);

      String keySTR = utf8.decode(keee);
      String ivSTR = utf8.decode(viii);

      final key = encrypt.Key.fromUtf8(keySTR);
      final iv = encrypt.IV.fromUtf8(ivSTR);
      final encrypter = encrypt.Encrypter(
          encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));


      final decrypted2 =
      encrypter.decrypt(encrypt.Encrypted.fromBase64(remainbal), iv: iv);

      balance = decrypted2.toString();
    } else {
      throw Exception('Failed to load themes');
    }

    setState(() {
      balance;
    });
  }


  double posBalance ;
  double mainBalance;
  double creditBalance;
  double holdBalance;
  double adminCreditBalance;
  double dealerBalance;


  Future<void> allBalanceShow() async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var url = new Uri.http("api.vastwebindia.com", "/common/api/data/Show_ALL_balanceremRem");
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
      var dataa1 = dataa["data"];
      mainBalance = dataa1[0]["remainbal"];
      posBalance =  dataa1[0]["posremain"];
      creditBalance = dataa1[0]["totalCurrentcr"];
      holdBalance = dataa1[0]["tholdamount"];
      adminCreditBalance = dataa1[0]["admincr"];
      dealerBalance = dataa1[0]["dealer"];


      setState(() {
        posBalance;
        mainBalance;
        creditBalance;
        holdBalance;
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
    masteruserdetails();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PrimaryColor,
      child: Container(
        color: TextColor.withOpacity(0.5),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: TextColor,
            appBar: AppBar(
              title: widget.title,
              backgroundColor: PrimaryColor,
              toolbarHeight: 39,
              leading: BackButtonsApBar(),
              leadingWidth: 60,
              actions: [
                Transform.translate(
                  offset: Offset(5.0, 0.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 2),
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                       Expanded(child:  Text(
                         getTranslated(context, 'Hold Amount'),
                         style: TextStyle(
                             color: TextColor,
                             fontSize: 8,
                             fontWeight: FontWeight.bold),
                       ),),
                        SizedBox(
                          height: 1,
                        ),
                        Text(
                          holdBalance.toString(),
                          style: TextStyle(
                              color: TextColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  color: TextColor,
                  margin: EdgeInsets.only(top: 8, bottom: 8, left: 4, right: 2),
                ),
                Container(
                  margin: EdgeInsets.only(top: 2),
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          "Credit Amount",
                          style: TextStyle(
                              color: TextColor,
                              fontSize: 8,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Text(
                        creditBalance.toString(),
                        style: TextStyle(
                            color: TextColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  color: TextColor,
                  margin: EdgeInsets.only(top: 8, bottom: 8, left: 0, right: 2),
                ),
                Container(
                  margin: EdgeInsets.only(top: 2),
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          getTranslated(context, 'Pos Wallet'),
                          style: TextStyle(
                              color: TextColor,
                              fontSize: 8,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Text(
                        posBalance.toString(),
                        style: TextStyle(
                            color: TextColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            body: widget.body,
          ),
        ),
      ),
    );
  }


}