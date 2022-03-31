import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/travelsHotel.dart';

import '../../../../../ThemeColor/Color.dart';
import 'topTabBarPages/RechargeAndBill.dart';
import 'topTabBarPages/financialServices.dart';

class TopTabBar extends StatefulWidget {
  const TopTabBar({
    Key key,
  }) : super(key: key);

  @override
  _TopTabBarState createState() => _TopTabBarState();
}

class _TopTabBarState extends State<TopTabBar> {
  int selectedIndex = 0;
  static List<StatefulWidget> _widgetOptions = [
    RechargeAndBill(),
    FinancialServices(),
    TravelsHotel()
  ];

  bool firstTap = false;
  bool secondTap = false;
  bool lastTap = false;

  void changelay(int number) {
    if (number == 1) {
      setState(() {
        firstTap = true;
        secondTap = false;
        lastTap = false;
        selectedIndex = 0;
      });
    } else if (number == 2) {
      setState(() {
        secondTap = true;
        firstTap = false;
        lastTap = false;
        selectedIndex = 1;
      });
    } else if (number == 3) {
      setState(() {
        lastTap = true;
        secondTap = false;
        firstTap = false;
        selectedIndex = 2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),

      child: Column(
        children: [
          Container(
            color: PrimaryColor,
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8.0),
                          topLeft: Radius.circular(8.0),
                        ),
                        color: secondTap
                            ? Colors.transparent
                            : lastTap
                            ? Colors.transparent
                            : Colors.white.withOpacity(0.3),
                      ),
                      child: FlatButton(
                        onPressed: () {
                          changelay(1);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/pngImages/RechargeBill.png",
                              width: 22,
                              color: TextColor,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Recharge \n& Utilities",
                              style: TextStyle(fontSize: 12, color: DashboardCardTextColor),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8.0),
                        topLeft: Radius.circular(8.0),
                      ),
                      color: secondTap
                          ? Colors.white.withOpacity(0.3)
                          : Colors.transparent,
                    ),
                    child: FlatButton(
                      onPressed: () {
                        changelay(2);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/pngImages/buldings.png",
                            width: 23,
                            color: TextColor,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Financial \nServices",
                              style: TextStyle(fontSize: 12,color: TextColor))
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8.0),
                      topLeft: Radius.circular(8.0),
                    ),
                      color: lastTap
                          ? Colors.white.withOpacity(0.3)
                          : Colors.transparent,
                    ),
                    child: FlatButton(
                      onPressed: () {
                        changelay(3);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/pngImages/bus.svg",
                            width: 23,
                            color: TextColor,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Travels\n& Other",
                              style: TextStyle(fontSize: 12,color: TextColor))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _widgetOptions.elementAt(selectedIndex)
        ],
      ),
    );
  }
}
