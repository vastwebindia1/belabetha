import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/CommanWidget/inputTextField.dart';
import 'package:myapp/IntroSliderPages/SliderImageText.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/language.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/Doatedborder.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/homeTopPages/paymentOptions.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/dthRechargePage.dart';
import 'package:uuid/uuid.dart';

import '../../dashboard.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert' as convert;
import 'paymentOptions.dart';

class AddMoneyPage extends StatefulWidget {


  @override
  _AddMoneyPageState createState() => _AddMoneyPageState();
}

class _AddMoneyPageState extends State<AddMoneyPage> {

  var balance = "";
  bool errorText = false;

  Future<void> userdetails() async {
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
      var remainbal = data["remainbal"];


      var keee = base64.decode(keyy);
      var viii = base64.decode(vii);

      String keySTR = utf8.decode(keee);
      String ivSTR = utf8.decode(viii);

      final key = encrypt.Key.fromUtf8(keySTR);
      final iv = encrypt.IV.fromUtf8(ivSTR);
      final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));


      final decrypted2 = encrypter.decrypt(encrypt.Encrypted.fromBase64(remainbal), iv: iv);



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
  double netbanking,netbanksxis,netbankingother;
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
    userdetails();
    showcharges();
  }

  Future<void> paymentgatewaycharge(String ammount2) async {
    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var uri =
    new Uri.http("api.vastwebindia.com", "/Common/api/data/GetFinalChargeAmountWallet_ALL_Charges_Show", {
      "amount": ammount2,
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
      var dataa4 = dataa["WalletChargesenc"];
      debitcharge1 = dataa4["debitCardcharges"]["total"];
      debitnet1 = dataa4["debitCardcharges"]["netrecived"];
      prepaidcharge1 = dataa4["PrepaidCardcharges"]["total"];
      prepaidnet1 = dataa4["PrepaidCardcharges"]["netrecived"];
      rupaycharge1 = dataa4["Rupay"]["total"];
      rupaynet1 = dataa4["Rupay"]["netrecived"];
      creditcharge1 = dataa4["Creditcard"]["total"];
      creditnet1 =dataa4["Creditcard"]["netrecived"];
      netbankingcharge1 = dataa4["Netbanking"]["total"];
      netbankingnet1 = dataa4["Netbanking"]["netrecived"];
      amexcharge1 = dataa4["amex"]["total"];
      amexnet1 = dataa4["amex"]["netrecived"];
      internationalcharge1 = dataa4["International"]["total"];
      internationalnet1 = dataa4["International"]["netrecived"];
      walletcharge1 = dataa4["Wallet"]["total"];
      walletnet1 = dataa4["Wallet"]["netrecived"];
      gatewaycharge1 = dataa4["GetwayUPI"]["total"];
      gatewaynet1 = dataa4["GetwayUPI"]["netrecived"];

     /* upislabstatus1 = dataa4["Slabupi"]["upislabstatus"];
      upicharge1 = dataa4["Slabupi"]["total"];
      upinet1 = dataa4["Slabupi"]["netrecived"];



      if(upislabstatus1 == "Y"){

        upi1 = upicharge1;
        upinet2 = upinet1;


      }else{

        upi1 = gatewaycharge1;
        upinet2 = gatewaynet1;

      }
*/

      Navigator.push(
          context, MaterialPageRoute(
          builder: (_) => PaymentOptions(amount:amountController.text,debitcharge2: debitcharge1.toString(),debitnet2: debitnet1.toString(),
            prepaidcharge2: prepaidcharge1.toString(),prepaidnet2: prepaidnet1.toString(),rupaycharge2: rupaycharge1.toString(),rupaynet2: rupaynet1.toString(),
            creditcharge2: creditcharge1.toString(),creditnet2: creditnet1.toString(),netbankingcharge2: netbankingcharge1.toString(),netbankingnet2: netbankingnet1.toString(),
            amexcharge2: amexcharge1.toString(),amexnet2: amexnet1.toString(),internationalcharge2: internationalcharge1.toString(),internationalnet2: internationalnet1.toString(),
            walletcharge2: walletcharge1.toString(),walletnet2: walletnet1.toString(),upicharge2: gatewaycharge1.toString(),upinet3: gatewaynet1.toString(),)));


    } else {
      throw Exception('Failed to load themes');
    }
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
                  margin: EdgeInsets.only(top: 10,left: 10,right: 10),
                  alignment: Alignment.center,
                  child: Text(
                    getTranslated(context, 'Add Main Wallet'),
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width:200,
                          child: Text(
                            getTranslated(context, 'Available Main Wallet Balance'),
                            style: TextStyle(
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
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
                    hint:getTranslated(context, 'Enter Amount'),
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
                    child: Text(getTranslated(context, 'Enter Amount'),style: TextStyle(fontSize: 18,color: Colors.red),),
                  ),
                ),
                Container(
                    child: MainButton(
                      btnText:getTranslated(context, 'Add Money'),
                      onPressed: (){

                        var g = amountController.text;

                        double dd = double.parse(g);

                        setState(() {

                          if(dd == null){

                            errorText = true;

                          } else if (dd != null) {

                            errorText = false;

                            paymentgatewaycharge(amountController.text);


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
        Expanded(child: Text(widget.text,overflow: TextOverflow.ellipsis,maxLines: 1,),),
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

  Future<void> userdetails() async {
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

    var url = new Uri.http("api.vastwebindia.com", "/Retailer/api/data/Show_ALL_balanceremRem");
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
    userdetails();
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
                        Text(
                          getTranslated(context, 'Hold Amount'),
                          style: TextStyle(
                              color: TextColor,
                              fontSize: 8,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: holdBalance == null ? 6:1,
                        ),
                        holdBalance == null ? DoteLoaderWhiteColor():Expanded(
                          child: Text(
                            holdBalance.toString(),
                            style: TextStyle(
                                color: TextColor,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
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
                      Text(
                        getTranslated(context, 'Credit Amount'),
                        style: TextStyle(
                            color: TextColor,
                            fontSize: 8,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height:creditBalance == null ? 6: 1,
                      ),
                      creditBalance == null ? DoteLoaderWhiteColor(): Expanded(child: Text(
                        creditBalance.toString(),
                        style: TextStyle(
                            color: TextColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      )),
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
                      Text(
                        getTranslated(context, 'Pos Wallet'),
                        style: TextStyle(
                            color: TextColor,
                            fontSize: 8,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height:posBalance == null ? 6: 1,
                      ),
                      posBalance == null ? DoteLoaderWhiteColor():Expanded(child: Text(
                        posBalance.toString(),
                        style: TextStyle(
                            color: TextColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      )),
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








/*
class PaymentOptions extends StatefulWidget {
  const PaymentOptions({ key}) : super(key: key);

  @override
  _PaymentOptionsState createState() => _PaymentOptionsState();
}

class _PaymentOptionsState extends State<PaymentOptions> {
  @override
  Widget build(BuildContext context) {
    return AppBarWidget(
      body: SingleChildScrollView(
        child: Container(
          child: Text("test"),
        ),
      ),
    );
  }
}*/
