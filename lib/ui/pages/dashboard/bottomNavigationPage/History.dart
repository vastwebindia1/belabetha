import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/HistoryPage/AepsHistory.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/HistoryPage/BusBookinghistory.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/HistoryPage/CashDepositeHistory.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/HistoryPage/DigitalGifCardhistory.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/HistoryPage/E-commercehistory.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/HistoryPage/FlightHistory.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/HistoryPage/HotelBookinghistory.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/HistoryPage/Impshistory.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/HistoryPage/MircroATMhistory.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/HistoryPage/MposHistory.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/HistoryPage/PancardHistory.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/HistoryPage/Possreport.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/HistoryPage/Rechargehistorypage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/HistoryPage/walletUnloadHistory.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/accountPages/manageAccount.dart';

import 'homeTopPages/paymentOptions.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
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

class _HistoryState extends State<History> {
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
                                  widget:Image.asset(
                                    'assets/pngImages/mobile-phone.png',
                                    height: 35,
                                  ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              getTranslated(context, 'Utility'),
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
                                      child: Image.asset(
                                        'assets/pngImages/money-transfer.png',
                                        height: 35,
                                      ),
                                    )],
                                  )),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "IMPS/NEFT" ,
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
                                  'assets/pngImages/Aeps.png',
                                  height: 35,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text("AEPS/AadharPay",
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
                                  'assets/pngImages/Pos.png',
                                  height: 35,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              getTranslated(context, 'M-poss'),
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
                                      left: -2,
                                      right: 0,
                                      top: -2,
                                      bottom: 0,
                                      child: Image.asset(
                                        'assets/pngImages/atm-machine.png',
                                        height: 35,
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              getTranslated(context, 'mATM'),
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
                                        child: Image.asset(
                                          'assets/pngImages/pancard.png',
                                          height: 35,
                                        ),),
                                  ])),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              getTranslated(context, 'pancard'),
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
                                          child: Image.asset(
                                            'assets/pngImages/cashDeposit.png',
                                            height: 35,
                                          ),),
                                    ]),
                                  )),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              getTranslated(context, 'Cash Deposit'),
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
                                    clipBehavior: Clip.none, children: [
                                    Positioned(
                                        left: -3,
                                        right: 0,
                                        top: -2,
                                        bottom: 0,
                                        child:  Image.asset(
                                          'assets/pngImages/Flight.png',
                                          height: 35,
                                        ))
                                  ],
                                  )),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              getTranslated(context, 'Flight Booking'),
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
                                        child:  Image.asset(
                                          'assets/pngImages/bus.png',
                                          height: 35,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              getTranslated(context, 'Bus Booking'),
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
                                      Positioned(
                                          left: -2,
                                          right: 0,
                                          top: -2,
                                          bottom: 0,
                                          child:  Image.asset(
                                            'assets/pngImages/hotel.png',
                                            height: 35,
                                          ))
                                    ],
                                  )),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              getTranslated(context, 'Hotel Booking'),
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
                                  onTap10();
                                },
                                color1:
                                check10 ? TextColor : Colors.transparent,
                                color2: check10 ? Colors.green : Colors.black38,
                                color3:
                                check10 ? Colors.green : Colors.transparent,
                                widget: Stack(children: [
                                  Positioned(
                                      left: -2,
                                      right: 0,
                                      top: -0,
                                      bottom: 0,
                                      child: Icon(
                                        Icons.post_add_sharp,
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
                              "Pos Wallet",
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
                                        Icons.account_balance_wallet,
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
                              "Wallet Unload \n Report",
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


                  check2? Navigator.push(context, MaterialPageRoute(builder: (_) => Rechargehistory())):
                  check1? Navigator.push(context, MaterialPageRoute(builder: (_) => Impshistorypage())):
                  check?  Navigator.push(context, MaterialPageRoute(builder: (_) => Aepshistorypage())):
                  check3? Navigator.push(context, MaterialPageRoute(builder: (_) => Mposhistorypage())):
                  check7? Navigator.push(context, MaterialPageRoute(builder: (_) => FlighthistoryPage())):
                  check6? Navigator.push(context, MaterialPageRoute(builder: (_) => MATMhistorypage())):
                  check5? Navigator.push(context, MaterialPageRoute(builder: (_) => PancardHistory())):
                  check8? Navigator.push(context, MaterialPageRoute(builder: (_) => BusbookingHistoryPage())):
                  check4? Navigator.push(context, MaterialPageRoute(builder: (_) => CashDepositeHistoryPage())):
                  check9? Navigator.push(context, MaterialPageRoute(builder: (_) => HotelbookHistoryPage())):
                  check10? Navigator.push(context, MaterialPageRoute(builder: (_) => Possreport())):
                  check11? Navigator.push(context, MaterialPageRoute(builder: (_) => WalletUnloadReport())):
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ManageAccounts())
                  );

                },
                btnText: check11 ? "Wallet Unload \n Report" : check1 ? "IMPS/NEFT Report"  : check2 ? "Recharge History"  : check3 ? "M-Pos Report" : check4 ? "Cash Deposite Report" : check5 ? "Pancard Report" : check6 ? "mATM Report" : check7 ? "Flight Booking Report" : check8 ? "Bus Booking Report" : check9 ? "Hotel Booking Report" : check10 ? "Poss Report" : check ? "AEPS Report" : getTranslated(context, 'Day Book') ,
                color: SecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
