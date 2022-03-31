import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/comingSoonPage.dart';
import 'package:myapp/ui/pages/dashboard/delerpages/dealerHistorypages/dealerAepsHistory.dart';
import 'package:myapp/ui/pages/dashboard/delerpages/dealerHistorypages/dealerMicroAtmRentalReport.dart';
import 'package:myapp/ui/pages/dashboard/delerpages/dealerHistorypages/dealerMpossHistory.dart';
import 'dealerHistorypages/dealerMoneyTransferHistory.dart';
import 'dealerHistorypages/dealerPanHistory.dart';
import 'dealerHistorypages/dealerRechargeHistory.dart';



class DealerHistory extends StatefulWidget {
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


  const DealerHistory({Key key, this.amount, this.debitcharge2, this.debitnet2, this.prepaidcharge2, this.prepaidnet2, this.rupaycharge2, this.rupaynet2, this.creditcharge2, this.creditnet2, this.netbankingcharge2, this.netbankingnet2, this.amexcharge2, this.amexnet2, this.internationalcharge2, this.internationalnet2, this.walletcharge2, this.walletnet2, this.gatewaycharge2, this.gatewaynet2, this.upicharge2, this.upinet3, }) : super(key: key);
  static const String _title = 'Flutter Code Sample';

  @override
  _DealerHistoryState createState() => _DealerHistoryState();
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
String text = "";

class _DealerHistoryState extends State<DealerHistory> {



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
      });
    }
    TextStyle style= TextStyle(fontSize: 12,color: PrimaryColor);

    return Material(
      child: SafeArea(
        child: Container(
          color: TextColor,
          child: Container(
            color: TextColor,
                child: Column(
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
                                                  widget: Image.asset('assets/pngImages/mobile-phone.png',height: 35,),
                                                ),
                                              ),
                                              SizedBox(height: 5,),
                                              Text(getTranslated(context, 'Recharge Utility'),style: style,),
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
                                                  widget: Image.asset('assets/pngImages/Aeps.png',height: 35,),
                                                ),
                                              ),
                                              SizedBox(height: 5,),
                                              Text(getTranslated(context, 'Aeps & Aadhar'),style: style,),
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
                                                  widget: Image.asset('assets/pngImages/money-transfer.png',height: 38,),
                                                ),
                                              ),
                                              SizedBox(height: 5,),
                                              Text(getTranslated(context, 'Money Transfer'),style: style,),
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
                                                  widget: Image.asset('assets/pngImages/qr-code.png',),
                                                ),
                                              ),
                                              SizedBox(height: 5,),
                                              Text(getTranslated(context, 'Add Money') ,style: style,),
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
                                                    onTap6();
                                                  },
                                                  color1: check6 ? Colors.white: Colors.transparent,
                                                  color2:check6 ? Colors.green: Colors.black38,
                                                  color3: check6 ? Colors.green:Colors.transparent,
                                                  widget: Image.asset('assets/pngImages/atm-machine.png',height: 35,),
                                                ),
                                              ),
                                              SizedBox(height: 5,),
                                              Text(getTranslated(context, 'Pos ATM'),textAlign: TextAlign.center,style: style,),
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
                                                  widget: Image.asset('assets/pngImages/creditCard.png',height: 35,),
                                                ),
                                              ),
                                              SizedBox(height: 5,),
                                              Text(getTranslated(context, 'pancard'),style: style,),
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
                                                    onTap4();
                                                  },
                                                  color1: check4 ? Colors.white: Colors.transparent,
                                                  color2:check4 ? Colors.green: Colors.black38,
                                                  color3: check4 ? Colors.green:Colors.transparent,
                                                  widget: Image.asset('assets/pngImages/bus.png',height: 35,),
                                                ),
                                              ),
                                              SizedBox(height: 5,),
                                              Text(getTranslated(context, 'Travel'),style: style,),
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
                                              Text(getTranslated(context, 'Security'),style: style,textAlign: TextAlign.center,),
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
                                              Text(getTranslated(context, 'MicroATM Rental Report'),style: style,textAlign: TextAlign.center,),
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
                                check? Navigator.push(context, MaterialPageRoute(builder: (_) => DealerRechargeHistory())):
                                check1? Navigator.push(context, MaterialPageRoute(builder: (_) => DealerAepsReport())):
                                check2? Navigator.push(context, MaterialPageRoute(builder: (_) => DealerMoneyTransferReport())):
                                check6? Navigator.push(context, MaterialPageRoute(builder: (_) => DealerMpossReport())):
                                check5? Navigator.push(context, MaterialPageRoute(builder: (_) => DealerPanReport())):
                                check8? Navigator.push(context, MaterialPageRoute(builder: (_) => DealerMicroAtmRentalReport())):
                                Navigator.push(context, MaterialPageRoute(builder: (_) => ComingSoon(

                                )));

                              },
                              btnText: check ? getTranslated(context, 'Recharge Utility History'):
                              check1 ? getTranslated(context, 'Aeps Aadhar History'):
                              check2 ? getTranslated(context, 'Money Transfer History'):
                              check3 ? getTranslated(context, 'Add Money History'):
                              check4 ? getTranslated(context, 'Travel History'):
                              check5 ? getTranslated(context, 'Pan Card History'):
                              check6 ? getTranslated(context, 'Pos ATM History'):
                              check7 ? getTranslated(context, 'Security History'):
                              check8 ? getTranslated(context, 'MicroATM Rental Report'): getTranslated(context, 'Recharge History'),
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