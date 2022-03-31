import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/HomePage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/accountPages/addMoney.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/accountPages/manageAccount.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/accountPages/retailerDayBook.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/accountPages/retailerDisputList.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/accountPages/retailerFundReceive.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/accountPages/retailerIncomeReport.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/accountPages/retailerLedgerReport.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/accountPages/retailerOperatorCommision.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/accountPages/retailerPurchOrderReport.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/accountPages/rtorFundReport.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/accountPages/rtorFundTransfer.dart';

import '../comingSoonPage.dart';
import 'homeTopPages/paymentOptions.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
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

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    void onTap() {
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
        check = false;
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

    void onTap2() async {
      setState(() {
        check1 = false;
        check = false;
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

    void onTap3() async {
      setState(() {
        check1 = false;
        check = false;
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

    void onTap4() async {
      setState(() {
        check4 = true;
        check = false;
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

    void onTap5() async {
      setState(() {
        check5 = true;
        check = false;
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

    void onTap6() async {
      setState(() {
        check6 = true;
        check = false;
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

    void onTap7() async {
      setState(() {
        check7 = true;
        check = false;
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

    void onTap8() async {
      setState(() {
        check8 = true;
        check = false;
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

    TextStyle style = TextStyle(fontSize: 12, color: PrimaryColor);
    return Material(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 30, left: 10, right: 10),
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
                                onPressed: () {
                                  onTap2();
                                },
                                color1:
                                    check2 ? TextColor : Colors.transparent,
                                color2: check2 ? Colors.green : Colors.black38,
                                color3:
                                    check2 ? Colors.green : Colors.transparent,
                                widget:Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.orange,
                                    ),

                                    child: Center(child: Text("\u{20B9}",style: TextStyle(fontSize: 28,color: TextColor ),)))
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              getTranslated(context, 'Day Earning'),
                              style: style,
                            ),
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
                                  onPressed: () {
                                    onTap1();
                                  },
                                  color1: check1
                                      ? TextColor
                                      : Colors.transparent,
                                  color2:
                                      check1 ? Colors.green : Colors.black38,
                                  color3: check1
                                      ? Colors.green
                                      : Colors.transparent,
                                  widget: Stack(children: [
                                    Positioned(
                                      left: -2,
                                      right: 0,
                                      top: -2,
                                      bottom: 0,
                                      child: Icon(
                                        Icons.flaky,
                                        color: Colors.blueAccent,
                                        size: 32,
                                      ),
                                    )],
                                  )),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              getTranslated(context, 'Day Ledger'),
                              style: style,
                            ),
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
                                onPressed: () {
                                  onTap();
                                },
                                color1:
                                    check ? TextColor : Colors.transparent,
                                color2: check ? Colors.green : Colors.black38,
                                color3:
                                    check ? Colors.green : Colors.transparent,
                                widget: Image.asset(
                                  'assets/pngImages/book.png',
                                  height: 35,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              getTranslated(context, 'Day Book'),
                              style: style,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
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
                                onPressed: () {
                                  onTap3();
                                },
                                color1:
                                    check3 ? TextColor : Colors.transparent,
                                color2: check3 ? Colors.green : Colors.black38,
                                color3:
                                    check3 ? Colors.green : Colors.transparent,
                                widget: Image.asset(
                                  'assets/pngImages/wallets.png',
                                  height: 35,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              getTranslated(context, 'Added Money'),
                              style: style,
                              textAlign: TextAlign.center,
                            ),
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
                                onPressed: () {
                                  onTap6();
                                },
                                color1:
                                    check6 ? TextColor : Colors.transparent,
                                color2: check6 ? Colors.green : Colors.black38,
                                color3:
                                    check6 ? Colors.green : Colors.transparent,
                                widget: IconTheme(
                                  data: IconThemeData(color: PrimaryColor),
                                  child: Stack(children: [
                                    Positioned(
                                      left: 0,
                                      right: -2,
                                      top: -2,
                                      bottom: 0,
                                      child: Transform.rotate(angle: 3.1,child: Icon(
                                        Icons.downloading_sharp,size: 32,color: Colors.green,),),
                                    ),
                                  ]),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              getTranslated(context, 'R To R'),
                              textAlign: TextAlign.center,
                              style: style,
                            ),
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
                                  onPressed: () {
                                    onTap5();
                                  },
                                  color1: check5
                                      ? TextColor
                                      : Colors.transparent,
                                  color2:
                                      check5 ? Colors.green : Colors.black38,
                                  color3: check5
                                      ? Colors.green
                                      : Colors.transparent,
                                  widget: Stack(children: [
                                    Positioned(
                                        left: -2,
                                        right: 0,
                                        top: -2,
                                        bottom: 0,
                                        child: Icon(
                                          Icons.description,
                                          color: Colors.orangeAccent,
                                          size: 32,
                                        )),
                                  ])),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              getTranslated(context, 'R To R Report'),
                              style: style,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
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
                                  onPressed: () {
                                    onTap4();
                                  },
                                  color1: check4
                                      ? TextColor
                                      : Colors.transparent,
                                  color2:
                                      check4 ? Colors.green : Colors.black38,
                                  color3: check4
                                      ? Colors.green
                                      : Colors.transparent,
                                  widget: IconTheme(
                                    data: IconThemeData(
                                        color: Theme.of(context).accentColor),
                                    child: Stack(children: [
                                      Positioned(
                                          left: -2,
                                          right: 0,
                                          top: -0,
                                          bottom: 0,
                                          child: Icon(
                                            Icons.supervised_user_circle_outlined,
                                            color: Colors.orange,
                                            size: 32,
                                          )),
                                    ]),
                                  )),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              getTranslated(context, 'Fund Receive Report'),
                              style: style,
                              textAlign: TextAlign.center,
                            ),
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
                                  onPressed: () {
                                    onTap7();
                                  },
                                  color1: check7
                                      ? TextColor
                                      : Colors.transparent,
                                  color2:
                                      check7 ? Colors.green : Colors.black38,
                                  color3: check7
                                      ? Colors.green
                                      : Colors.transparent,
                                  widget: Stack(
                                    overflow: Overflow.visible,
                                    children: [
                                      Positioned(
                                          left: -3,
                                          right: 0,
                                          top: -2,
                                          bottom: 0,
                                          child: Icon(
                                            Icons.add_task ,
                                            color: Colors.red,
                                            size: 32,
                                          ))
                                    ],
                                  )),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              getTranslated(context, 'Operator Commission'),
                              style: style,
                              textAlign: TextAlign.center,
                            ),
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
                                onPressed: () {
                                  onTap8();
                                },
                                color1:
                                    check8 ? TextColor : Colors.transparent,
                                color2: check8 ? Colors.green : Colors.black38,
                                color3:
                                    check8 ? Colors.green : Colors.transparent,
                                widget: Stack(
                                  children: [
                                    Positioned(
                                        left: -2,
                                        right: 0,
                                        top: -2,
                                        bottom: 0,
                                        child: Icon(
                                          Icons.account_balance_sharp,
                                          color: Colors.brown,
                                          size: 32,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              getTranslated(context, 'Manage AC'),
                              style: style,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
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
                                  onPressed: () {
                                    onTap9();
                                  },
                                  color1: check9
                                      ? TextColor
                                      : Colors.transparent,
                                  color2:
                                      check9 ? Colors.green : Colors.black38,
                                  color3: check9
                                      ? Colors.green
                                      : Colors.transparent,
                                  widget: Stack(
                                    children: [
                                      Positioned(left: -2, right: 0, top: -2,bottom: 0, child: Icon(Icons.data_saver_on, size: 32, color: Colors.green,))
                                    ],
                                  )),
                            ),
                            SizedBox(height: 5,),
                            Text(getTranslated(context, 'Purchase order Report'), style: style,textAlign: TextAlign.center,maxLines: 2,),
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
                                onPressed: () {
                                  onTap10();
                                },
                                color1:
                                check10 ? TextColor : Colors.transparent,
                                color2:   check10 ? Colors.green : Colors.black38,
                                color3:
                                check10 ? Colors.green : Colors.transparent,
                                widget: Stack(children: [
                                  Positioned(left: -2, right: 0, top: -0, bottom: 0, child: Icon(
                                        Icons.add_shopping_cart_sharp,
                                        color: Colors.teal,
                                        size: 32,
                                      ))
                                ]),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              getTranslated(context, 'Dispute Report'),
                              style: style,
                              textAlign: TextAlign.center,
                            ),
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
                                onPressed: () {
                                  onTap11();
                                },
                                color1:
                                    check11 ? TextColor : Colors.transparent,
                                color2: check11 ? Colors.green : Colors.black38,
                                color3:
                                    check11 ? Colors.green : Colors.transparent,
                                widget: Stack(children: [
                                  Positioned(
                                      left: -2,
                                      right: 0,
                                      top: -2,
                                      bottom: 0,
                                      child: Icon(
                                        Icons.verified_rounded,
                                        color: Colors.orange,
                                        size: 32,
                                      ))
                                ]),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              getTranslated(context, 'Rewards'),
                              style: style,
                              textAlign: TextAlign.center,
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
              margin: EdgeInsets.only(top: 15, bottom: 15),
              child: MainButton(
                onPressed: () {
                  check1? Navigator.push(context, MaterialPageRoute(builder: (_) => RetailerLedgerReport())):
                  check2? Navigator.push(context, MaterialPageRoute(builder: (_) => RetailerIncomeReport())):
                  check3? Navigator.push(context, MaterialPageRoute(builder: (_) => RetailerAddMoney())):
                  check4? Navigator.push(context, MaterialPageRoute(builder: (_) => RetailerFundReceive())):
                  check5? Navigator.push(context, MaterialPageRoute(builder: (_) => RToRFundReport())):
                  check6? Navigator.push(context, MaterialPageRoute(builder: (_) => RToRFund())):
                  check7? Navigator.push(context, MaterialPageRoute(builder: (_) => RetailerOperatorCommision())):
                  check8? Navigator.push(context, MaterialPageRoute(builder: (_) => ManageAccounts())):
                  check9? Navigator.push(context, MaterialPageRoute(builder: (_) => RetailerPurchaseOrderReport())):
                  check10? Navigator.push(context, MaterialPageRoute(builder: (_) => RetailerDisputList())):
                  check11? Navigator.push(context, MaterialPageRoute(builder: (_) => ComingSoon())):
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RetailerDayBook())
                  );
                },
                btnText: check11 ? getTranslated(context, 'Rewards') : check1 ? getTranslated(context, 'Day Ledger') : check2 ? getTranslated(context, 'Day Earning') : check3 ? getTranslated(context, 'Added Money') : check4 ? getTranslated(context, 'Fund Receive Report') : check5 ? getTranslated(context, 'R To R Report') : check6 ? getTranslated(context, 'R to R Fund transfer') : check7 ? getTranslated(context, 'Operator Commission') : check8 ? getTranslated(context, 'Manage Bank Account')  : check9 ? getTranslated(context, 'Purchase order Report') : check10 ? getTranslated(context, 'Dispute Report')  :getTranslated(context, 'Day Book'),
                color: SecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
