import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/homeTopPages/addMoney.dart';
import 'package:safexpay/constants/strings.dart';
import 'package:safexpay/constants/utility.dart';
import 'package:safexpay/safexpay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(creditgatway());
}

class creditgatway extends StatefulWidget {
  final String amount,creditamnt,creditnet,mercentid,merchkey,succurl,failurl,uniqid;
  const creditgatway({Key key, this.amount, this.creditamnt, this.creditnet, this.mercentid, this.merchkey, this.succurl, this.failurl, this.uniqid}) : super(key: key);
  @override
  _creditgatwayState createState() => _creditgatwayState();
}

class _creditgatwayState extends State<creditgatway> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
    MerchantConstants.setDetails(
        mId: widget.mercentid,
        mKey:
        widget.merchkey,
        aggId: 'paygate',
        environment: Environment.PRODUCTION);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await Safexpay.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, home: UserInputPage(amount: widget.amount,creditamnt: widget.creditamnt,creditnet: widget.creditnet,succurl: widget.succurl,failurl: widget.failurl,uniqid: widget.uniqid,));
  }
}

class UserInputPage extends StatefulWidget {
  final String amount,creditamnt,creditnet,succurl,failurl,uniqid;
  const UserInputPage({Key key, this.amount, this.creditamnt, this.creditnet, this.succurl, this.failurl, this.uniqid}) : super(key: key);
  @override
  _UserInputPageState createState() => _UserInputPageState();
}

class _UserInputPageState extends State<UserInputPage>
    implements SafeXPayPaymentCallback {
  TextEditingController controller = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SafeXPayPaymentCallbackObservable _safeXPayPaymentCallbackObservable;
  bool _isloading = false;


  @override
  void initState() {
    super.initState();
    _safeXPayPaymentCallbackObservable = SafeXPayPaymentCallbackObservable();
    _safeXPayPaymentCallbackObservable.register(this);

  }

  @override
  void dispose() {
    _safeXPayPaymentCallbackObservable.unRegister(this);
    super.dispose();
  }
  String paymentid = "";
  String statuss = "";
  String transactionid = "";
  String errormsz = "";
  bool responsesucc =false;
  bool responsefild =false;
  void paymode()async{

    final prefs = await SharedPreferences.getInstance();


    String name = prefs.getString("name");
    String email = prefs.getString("email");
    String mobile = prefs.getString("mobi");

    /*SafeXPayGateway safeXPayGateway = SafeXPayGateway(
        orderNo: '${Random().nextInt(1000)}',
        amount: double.parse(widget.amount),
        currency: 'INR',
        transactionType: 'SALE',
        channel: 'MOBILE',
        successUrl: widget.succurl,
        failureUrl: widget.failurl,
        countryCode: 'IND');

    safeXPayGateway.setUserDetails(
        name: name,
        emailId: email,
        mobile: mobile);

    safeXPayGateway.allowedPaymentMethods(
        allowCardPayment: true,
        allowNetBankingPayment: false,
        allowWalletPayment: false,
        allowUPIPayment: false);*/

    MHSafeXPayGateway safeXPayGateway = MHSafeXPayGateway(
                      orderNo: widget.uniqid,
                      amount: double.parse(widget.amount),
                      currency: 'INR',
                      transactionType: 'SALE',
                      channel: 'MOBILE',
                      successUrl: widget.succurl,
                      failureUrl: widget.failurl,
                      countryCode: 'IND',
                      pgDetails:'|CC||',
                      customerDetails:'$name|$email|$mobile| |Y',
                      cardDetails:'||||',
                      billDetails:'||||',
                      shipDetails:'||||||',
                      itemDetails:'||',
                      upiDetails:'',
                      otherDetails:'||||');

    MaterialPageRoute route = MaterialPageRoute(builder: (context) => safeXPayGateway);
    Navigator.push(context, route);

  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
          child: Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 15,bottom: 15,),
                  decoration: BoxDecoration(
                    color:PrimaryColor.withOpacity(0.9),),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Container(
                              height: 120,
                              width: 120,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: TextColor,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(100),
                                  ),
                                  color: TextColor
                              ),
                              child: Image.asset('assets/pngImages/creditCard.png'),
                            ),
                            SizedBox(height: 5,),
                            Text(getTranslated(context, 'Credit Card'),style: TextStyle(color: TextColor,fontSize: 18,),)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Amount: " + widget.amount,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                Visibility(
                  visible: responsesucc,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              margin: EdgeInsets.only(top: 30),
                              width:50,
                              height:50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:Colors.green
                              ),
                              child: Icon(Icons.check,color:Colors.white,size: 30,))
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Transcation Response",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(getTranslated(context, 'Status'),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                          Text(statuss,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Transaction Id",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                          Text(transactionid,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Payment Id",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                          Text(paymentid,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                        ],
                      ),
                      SizedBox(height: 10,),
                    ],
                  ),

                ),
                Visibility(
                  visible: responsefild,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              margin: EdgeInsets.only(top: 30),
                              width:50,
                              height:50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: Icon( Icons.cancel,color:Colors.white,size: 30,))
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Transcation Response",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Text(errormsz,style: TextStyle(fontSize: 20,color: Colors.red),),
                      ),
                      SizedBox(height: 10,),
                    ],
                  ),

                ),
                Row(
                  children: [
                    Expanded(
                        child: MainButton(
                          color: SecondaryColor,
                          onPressed: () {
                            paymode();
                          },
                          btnText: "Pay",
                        )
                    )
                  ],
                )
              ],
            ),
          )
      ),
    );
  }

  @override
  void onInitiatePaymentFailure(
      String orderID,
      String transactionID,
      String paymentID,
      String paymentStatus,
      String date,
      String time,
      String paymode,
      String amount,
      String udf1,
      String udf2,
      String udf3,
      String udf4,
      String udf5
      ) {
    // TODO: implement onInitiatePaymentFailure
    setState(() {
      errormsz = paymentStatus;
      responsesucc = false;
      responsefild = true;
    });
  }

  @override
  void onPaymentCancelled() {
    // TODO: implement onPaymentCancelled
  }

  @override
  void onPaymentComplete(
      String orderID,
      String transactionID,
      String paymentID,
      String paymentStatus,
      String date,
      String time,
      String paymode,
      String amount,
      String udf1,
      String udf2,
      String udf3,
      String udf4,
      String udf5) {
    // TODO: implement onPaymentComplete
    setState(() {
      transactionid = transactionID;
      paymentid = paymentID;
      statuss = paymentStatus;
      responsesucc = true;
      responsefild = false;
    });
  }

 /* @override
  void onInitiatePaymentFailure(
      String orderID,
      String transactionID,
      String paymentID,
      String paymentStatus,
      String date,
      String time,
      String paymode,
      String amount ,
      String udf1 ,
      String udf2 ,
      String udf3 ,
      String udf4 ,
      String udf5 ) {
    Utility.showSnackBarMessage(
        state: _scaffoldKey.currentState,
        message:
        '$orderID -- $transactionID -- $paymentID -- $paymentStatus -- $date -- $time -- $paymode-- $amount -- $udf1 -- $udf2 -- $udf3 -- $udf4 -- $udf5');
  }


  @override
  void onPaymentCancelled() {
    Utility.showSnackBarMessage(
        state: _scaffoldKey.currentState, message: 'Transaction Cancelled');
  }

  @override
  void onPaymentComplete(String orderID, String transactionID, String paymentID,
      String paymentStatus, String date, String time, String paymode ,String amount , String udf1 , String udf2 , String udf3 , String udf4 , String udf5 ) {
    Utility.showSnackBarMessage(
        state: _scaffoldKey.currentState,
        message:
        '$orderID -- $transactionID -- $paymentID -- $paymentStatus -- $date -- $time -- $paymode -- $amount -- $udf1 -- $udf2 -- $udf3 -- $udf4 -- $udf5');
  }*/
}

class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // AppHeader(),
        Expanded(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            // home: LoginScreen(),
          ),
        ),
      ],
    );
  }
}