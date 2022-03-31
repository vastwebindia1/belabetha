import 'package:flutter/material.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/comingSoonPage.dart';
import 'package:myapp/ui/pages/dashboard/delerpages/delerAccountPages/Dealer_AddWallet&AddAccount.dart';
import 'package:myapp/ui/pages/dashboard/delerpages/delerAccountPages/dealerCreditReport.dart';
import 'package:myapp/ui/pages/dashboard/delerpages/delerAccountPages/dealerDayBook.dart';
import 'package:myapp/ui/pages/dashboard/delerpages/delerAccountPages/dealerEarn.dart';
import 'package:myapp/ui/pages/dashboard/delerpages/delerAccountPages/dealerFundReciveReport.dart';
import 'package:myapp/ui/pages/dashboard/delerpages/delerAccountPages/dealerFundTransferHistory.dart';
import 'package:myapp/ui/pages/dashboard/delerpages/delerAccountPages/dealerLedger.dart';
import 'package:myapp/ui/pages/dashboard/delerpages/delerAccountPages/dealerOperatorCommision.dart';
import 'package:myapp/ui/pages/dashboard/delerpages/delerAccountPages/dealerPurchOrderReport.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'dealerHistorypages/dealerRechargeHistory.dart';

class DealerAccount extends StatefulWidget {
  final String amount;
  final String debitcharge2;
  final String debitnet2;
  final String prepaidcharge2;
  final String prepaidnet2;
  final String rupaycharge2;
  final String rupaynet2;
  final String creditcharge2;
  final String creditnet2;
  final String netbankingcharge2;
  final String netbankingnet2;
  final String amexcharge2;
  final String amexnet2;
  final String internationalcharge2;
  final String internationalnet2;
  final String walletcharge2;
  final String walletnet2;
  final String gatewaycharge2;
  final String gatewaynet2;
  final String upicharge2;
  final String upinet3;


  const DealerAccount({Key key, this.amount, this.debitcharge2, this.debitnet2, this.prepaidcharge2, this.prepaidnet2, this.rupaycharge2, this.rupaynet2, this.creditcharge2, this.creditnet2, this.netbankingcharge2, this.netbankingnet2, this.amexcharge2, this.amexnet2, this.internationalcharge2, this.internationalnet2, this.walletcharge2, this.walletnet2, this.gatewaycharge2, this.gatewaynet2, this.upicharge2, this.upinet3, }) : super(key: key);

  @override
  _DealerAccountState createState() => _DealerAccountState();
}
bool check = true;
bool check1 = false;
bool check2 = false;
bool check3 = false;
bool check4 = false;
bool check5 = false;
bool check6 = false;
bool check7 = false;
bool check8 = false;
bool check9 = false;
bool check10 = false;
bool check11 = false;
String text = "";

class _DealerAccountState extends State<DealerAccount> {

  @override
  Widget build(BuildContext context) {

    void onTap(){

      setState(() {
        check = true;
        check1 = false;
        check2 = false;
        check3 = false;
        check4 = false;
        check5 = false;
        check6 = false;
        check7 = false;
        check8 = false;
        check9 = false;
        check10 = false;
        check11 = false;
      });

    }
    void onTap1() {
      setState(() {
        check1 = true;
        check  = false;
        check2 = false;
        check3 = false;
        check4 = false;
        check5 = false;
        check6 = false;
        check7 = false;
        check8 = false;
        check9 = false;
        check10 = false;
        check11 = false;
      });


    }
    void onTap2() async{
      setState(() {
        check1 = false;
        check  = false;
        check2 = true;
        check3 = false;
        check4 = false;
        check5 = false;
        check6 = false;
        check7 = false;
        check8 = false;
        check9 = false;
        check10 = false;
        check11 = false;
      });
    }
    void onTap3() async{
      setState(() {
        check1 = false;
        check  = false;
        check2 = false;
        check3 = true;
        check4 = false;
        check5 = false;
        check6 = false;
        check7 = false;
        check8 = false;
        check9 = false;
        check10 = false;
        check11 = false;
      });
    }
    void onTap4() async{
      setState(() {
        check4 = true;
        check  = false;
        check2 = false;
        check3 = false;
        check1 = false;
        check5 = false;
        check6 = false;
        check7 = false;
        check8 = false;
        check9 = false;
        check10 = false;
        check11 = false;
      });
    }
    void onTap5() async{
      setState(() {
        check5 = true;
        check  = false;
        check2 = false;
        check3 = false;
        check4 = false;
        check1 = false;
        check6 = false;
        check7 = false;
        check8 = false;
        check9 = false;
        check10 = false;
        check11 = false;
      });
    }
    void onTap6() async{
      setState(() {
        check6 = true;
        check  = false;
        check2 = false;
        check3 = false;
        check4 = false;
        check5 = false;
        check1 = false;
        check7 = false;
        check8 = false;
        check9 = false;
        check10 = false;
        check11 = false;
      });
    }
    void onTap7() async{
      setState(() {
        check7 = true;
        check  = false;
        check2 = false;
        check3 = false;
        check4 = false;
        check5 = false;
        check6 = false;
        check1 = false;
        check8 = false;
        check9 = false;
        check10 = false;
        check11 = false;
      });
    }
    void onTap8() async{
      setState(() {
        check8 = true;
        check  = false;
        check2 = false;
        check3 = false;
        check4 = false;
        check5 = false;
        check6 = false;
        check7 = false;
        check1 = false;
        check9 = false;
        check10 = false;
        check11 = false;
      });
    }
    void onTap9() async {
      setState(() {
        check9 = true;
        check10 = false;
        check11 = false;
        check8 = false;
        check = false;
        check2 = false;
        check3 = false;
        check4 = false;
        check5 = false;
        check6 = false;
        check7 = false;
        check1 = false;
      });
    }
    void onTap10() async {
      setState(() {
        check9 = false;
        check10 = true;
        check11 = false;
        check8 = false;
        check = false;
        check2 = false;
        check3 = false;
        check4 = false;
        check5 = false;
        check6 = false;
        check7 = false;
        check1 = false;
      });
    }
    void onTap11() async {
      setState(() {
        check9 = false;
        check10 = false;
        check11 = true;
        check8 = false;
        check = false;
        check2 = false;
        check3 = false;
        check4 = false;
        check5 = false;
        check6 = false;
        check7 = false;
        check1 = false;
      });
    }


    TextStyle style= TextStyle(fontSize: 12,color: PrimaryColor);

    return Material(
      color: TextColor,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Container(
              color: TextColor,
              padding: EdgeInsets.only(bottom: 38),
              child: StickyHeader(
                  header: Container(
                    color: TextColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          color: PrimaryColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                color: TextColor.withOpacity(0.1),
                                padding: EdgeInsets.only(top: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 45,
                                      alignment: Alignment.center,
                                      margin:  EdgeInsets.only(top: 10, left: 10, right: 10,bottom: 15),
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: PrimaryColor,
                                      ),
                                      child: Text(getTranslated(context, 'accMsg'),
                                      style: TextStyle(color: TextColor,),),
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
                    children: [
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 20,left: 10,right: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 60,
                                                  width: 60,
                                                  child: PaymentsButtons(
                                                    onPressed: (){
                                                      onTap();
                                                    },
                                                    color1: check ? Colors.white: Colors.transparent,
                                                    color2:check ? Colors.green: Colors.black38,
                                                    color3: check ? Colors.green:Colors.transparent,
                                                    widget: Image.asset('assets/pngImages/book.png',height: 35,),
                                                  ),
                                                ),
                                                SizedBox(height: 5,),
                                                Text(getTranslated(context, 'Day & Month Book'),style: style,textAlign: TextAlign.center),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 60,
                                                  width: 60,
                                                  child: PaymentsButtons(
                                                    onPressed: (){
                                                      onTap1();
                                                    },
                                                    color1: check1 ? Colors.white: Colors.transparent,
                                                    color2:check1 ? Colors.green: Colors.black38,
                                                    color3: check1 ? Colors.green:Colors.transparent,
                                                    widget: Image.asset('assets/pngImages/Mini-ststment.png',height: 35,),
                                                  ),
                                                ),
                                                SizedBox(height: 5,),
                                                Text(getTranslated(context, 'Ledger'),style: style,),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 60,
                                                  width: 60,
                                                  child: PaymentsButtons(
                                                    onPressed: (){
                                                      onTap2();
                                                    },
                                                    color1: check2 ? Colors.white: Colors.transparent,
                                                    color2:check2 ? Colors.green: Colors.black38,
                                                    color3: check2 ? Colors.green:Colors.transparent,
                                                    widget: Image.asset('assets/pngImages/Loan.png',height: 38,),
                                                  ),
                                                ),
                                                SizedBox(height: 5,),
                                                Text(getTranslated(context, 'Day Earn'),style: style,textAlign: TextAlign.center),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20,),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 60,
                                                  width: 60,
                                                  child: PaymentsButtons(
                                                    onPressed: (){
                                                      onTap3();
                                                    },
                                                    color1: check3 ? Colors.white: Colors.transparent,
                                                    color2:check3 ? Colors.green: Colors.black38,
                                                    color3: check3 ? Colors.green:Colors.transparent,
                                                    widget: Image.asset('assets/pngImages/cashDeposit.png',),
                                                  ),
                                                ),
                                                SizedBox(height: 5,),
                                                Text(getTranslated(context, 'Purchase order Report'),style: style,textAlign: TextAlign.center),
                                              ],
                                            ),
                                          ),

                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 60,
                                                  width: 60,
                                                  child: PaymentsButtons(
                                                    onPressed: (){
                                                      onTap4();
                                                    },
                                                    color1: check4 ? Colors.white: Colors.transparent,
                                                    color2:check4 ? Colors.green: Colors.black38,
                                                    color3: check4 ? Colors.green:Colors.transparent,
                                                    widget: Image.asset('assets/pngImages/money-transfer.png',height: 35,),
                                                  ),
                                                ),
                                                SizedBox(height: 5,),
                                                Text(getTranslated(context, 'Fund Transfer History'),style: style,textAlign: TextAlign.center),
                                              ],
                                            ),
                                          ),

                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 60,
                                                  width: 60,
                                                  child: PaymentsButtons(
                                                    onPressed: (){
                                                      onTap5();
                                                    },
                                                    color1: check5 ? Colors.white: Colors.transparent,
                                                    color2:check5 ? Colors.green: Colors.black38,
                                                    color3: check5 ? Colors.green:Colors.transparent,
                                                    widget: Image.asset('assets/pngImages/Society.png',height: 35,),
                                                  ),
                                                ),
                                                SizedBox(height: 5,),
                                                Text(getTranslated(context, 'Add & Manage Account'),style: style,textAlign: TextAlign.center),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20,),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 60,
                                                  width: 60,
                                                  child: PaymentsButtons(
                                                    onPressed: (){
                                                      onTap6();
                                                    },
                                                    color1: check6 ? Colors.white: Colors.transparent,
                                                    color2:check6 ? Colors.green: Colors.black38,
                                                    color3: check6 ? Colors.green:Colors.transparent,
                                                    widget: Image.asset('assets/pngImages/Mini-ststment.png',height: 35,),
                                                  ),
                                                ),
                                                SizedBox(height: 5,),
                                                Text(getTranslated(context, 'Tax Invoice'),textAlign: TextAlign.center,style: style,),
                                              ],
                                            ),
                                          ),

                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 60,
                                                  width: 60,
                                                  child: PaymentsButtons(
                                                    onPressed: (){
                                                      onTap7();
                                                    },
                                                    color1: check7 ? Colors.white: Colors.transparent,
                                                    color2:check7 ? Colors.green: Colors.black38,
                                                    color3: check7 ? Colors.green:Colors.transparent,
                                                    widget: Image.asset('assets/pngImages/Distributor.png',height: 35,),
                                                  ),
                                                ),
                                                SizedBox(height: 5,),
                                                Text(getTranslated(context, 'TDS Report'),style: style,textAlign: TextAlign.center,),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 60,
                                                  width: 60,
                                                  child: PaymentsButtons(
                                                    onPressed: (){
                                                      onTap8();
                                                    },
                                                    color1: check8 ? Colors.white: Colors.transparent,
                                                    color2:check8 ? Colors.green: Colors.black38,
                                                    color3: check8 ? Colors.green:Colors.transparent,
                                                    widget: Image.asset('assets/pngImages/wallets.png',height: 35,),
                                                  ),
                                                ),
                                                SizedBox(height: 5,),
                                                Text(getTranslated(context, 'Rewards'),style: style,textAlign: TextAlign.center,),
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                      SizedBox(height: 20,),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 60,
                                                  width: 60,
                                                  child: PaymentsButtons(
                                                    onPressed: (){
                                                      onTap9();
                                                    },
                                                    color1: check9 ? Colors.white: Colors.transparent,
                                                    color2:check9 ? Colors.green: Colors.black38,
                                                    color3: check9 ? Colors.green:Colors.transparent,
                                                    widget: Image.asset('assets/pngImages/operatorcommision.png',height: 35,),
                                                  ),
                                                ),
                                                SizedBox(height: 5,),
                                                Text(getTranslated(context, 'Operator Commision'),style: style,textAlign: TextAlign.center,),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 60,
                                                  width: 60,
                                                  child: PaymentsButtons(
                                                    onPressed: (){
                                                      onTap10();
                                                    },
                                                    color1: check10 ? Colors.white: Colors.transparent,
                                                    color2:check10 ? Colors.green: Colors.black38,
                                                    color3: check10 ? Colors.green:Colors.transparent,
                                                    widget: Image.asset('assets/pngImages/fundcredit.png',height: 35,),
                                                  ),
                                                ),
                                                SizedBox(height: 5,),
                                                Text(getTranslated(context, 'Credit Report'),style: style,textAlign: TextAlign.center,),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 60,
                                                  width: 60,
                                                  child: PaymentsButtons(
                                                    onPressed: (){
                                                      onTap11();
                                                    },
                                                    color1: check11 ? Colors.white: Colors.transparent,
                                                    color2:check11 ? Colors.green: Colors.black38,
                                                    color3: check11 ? Colors.green:Colors.transparent,
                                                    widget: Image.asset('assets/pngImages/fundreceive.png',height: 35,),
                                                  ),
                                                ),
                                                SizedBox(height: 5,),
                                                Text(getTranslated(context, 'Fund Receive Report'),style: style,textAlign: TextAlign.center,),
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
                            Container(
                              margin: EdgeInsets.only(top: 15),
                              child: MainButton(
                                onPressed: (){
                                  check11? Navigator.push(context, MaterialPageRoute(builder: (_) => DealerFundReceive())):
                                  check10? Navigator.push(context, MaterialPageRoute(builder: (_) => DealerCreditReport())):
                                  check9? Navigator.push(context, MaterialPageRoute(builder: (_) => DealerOperatorCommision())):
                                  check1? Navigator.push(context, MaterialPageRoute(builder: (_) => DealerLedger())):
                                  check2? Navigator.push(context, MaterialPageRoute(builder: (_) => DealerEarn())):
                                  check3? Navigator.push(context, MaterialPageRoute(builder: (_) => DealerPurchaseOrderReport())):
                                  check4? Navigator.push(context, MaterialPageRoute(builder: (_) => DealerFundTransferHistory())):
                                  check5? Navigator.push(context, MaterialPageRoute(builder: (_) => AddAccountAndWallet())):
                                  check6? Navigator.push(context, MaterialPageRoute(builder: (_) => ComingSoon())):
                                  check7? Navigator.push(context, MaterialPageRoute(builder: (_) => ComingSoon())):
                                  check8? Navigator.push(context, MaterialPageRoute(builder: (_) => ComingSoon())):
                                  check? Navigator.push(context,  MaterialPageRoute(builder: (_) => DealerDayBook())):
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => DealerRechargeHistory()));

                                },
                                btnText: check ? getTranslated(context, 'Day & Month Book'):
                                check1 ? getTranslated(context, 'Ledger'):
                                check2 ? getTranslated(context, 'Day Earn'):
                                check3 ? getTranslated(context, 'Purchase order Report'):
                                check4 ? getTranslated(context, 'Fund Transfer History'):
                                check5 ? getTranslated(context, 'Add & Manage Account'):
                                check6 ? getTranslated(context, 'Tax Invoice'):
                                check7 ? getTranslated(context, 'TDS Report'):
                                check8 ? getTranslated(context, 'Rewards'):
                                check9 ? getTranslated(context, 'Operator Commision'):
                                check10 ? getTranslated(context, 'Credit Report'):
                                check11 ? getTranslated(context, 'Fund Receive Report'):getTranslated(context, 'Day & Month Book'),
                                color: SecondaryColor,
                              ),
                            ),
                            Container(
                              height: 20,
                              child: Row(
                                children: [

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class PaymentsButtons extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget widget;
  final Color color1, color2,color3;
  const PaymentsButtons({
    Key key, this.onPressed, this.widget, this.color1, this.color2, this.color3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                        width:1,color: color2)),
                color: Colors.transparent,
                onPressed: onPressed,
                child:widget,
              )
          ),
          Positioned(
            top: -1,
            right: -2,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100),
                  ),
                  color: color1,
                ),
                child: Icon(Icons.check_circle,color: color3,)
            ),
          ),
        ],
      ),
    );
  }
}