import 'package:flutter/material.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/HomePage.dart';
import 'package:myapp/ui/pages/dashboard/delerpages/dealerhometab.dart';
import 'package:myapp/ui/pages/dashboard/delerpages/delerHomeTopPages/dealerPurchaseOrder.dart';
import 'package:myapp/ui/pages/dashboard/delerpages/dealerUsers.dart';
import 'package:myapp/ui/pages/dashboard/delerpages/delerHomeTopPages/fundtransferuser.dart';
import 'delerHomeTopPages/dealerToken.dart';

class DealerDashboard extends StatefulWidget {
  const DealerDashboard({Key key}) : super(key: key);

  @override
  _DealerDashboardState createState() => _DealerDashboardState();
}

List users = [];
List newslist = ["null"];

class _DealerDashboardState extends State<DealerDashboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Column(
          children: [
            Container(
                alignment: Alignment.center,
                height: 35,
                color: TextColor,
                child: Marquee(
                  child: Row(
                    children: users
                        .map(
                          (item) => new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              item == "null"
                                  ? Image.asset(
                                      'assets/pngImages/live.png',
                                      height: 22,
                                    )
                                  : Image.network(
                                            item["images"],
                                            height: 22,
                                          ) ==
                                          null
                                      ? Image.asset(
                                          'assets/pngImages/live.png',
                                          height: 22,
                                        )
                                      : Image.network(
                                          item["images"],
                                          height: 22,
                                        ),
                              /*Image.asset('assets/pngImages/decrease.png',height: 25,),*/
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                item == "null"
                                    ? "Congratulations on being part of the team, The whole company welcomes you, and we look forward to a successful journey with you."
                                    : item["messahes"],
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                  textDirection: TextDirection.ltr,
                  directionMarguee: DirectionMarguee.TwoDirection,
                  autoRepeat: true,
                  direction: Axis.horizontal,
                )),
            Container(
                height: 78,
                color: TextColor.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: IconButtonInk(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => DealerToken()));
                                },
                                icon: Icons.add,
                                colors: Colors.white,
                                text: getTranslated(context, 'Add Token'),
                                textStyle: TextStyle(
                                    color: TextColor, fontSize: 11),
                                iconSize: 20.0,
                              ),
                            ),
                            Expanded(
                              child: IconButtonInk(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => DealerUser()));
                                },
                                icon: Icons.person,
                                colors: Colors.white,
                                text: getTranslated(context, 'Users'),
                                textStyle: TextStyle(
                                    color: TextColor, fontSize: 11),
                                iconSize: 20.0,
                              ),
                            ),
                            Expanded(
                              child: IconButtonInk(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => FundTransferUser()));
                                },
                                icon: Icons.monetization_on_outlined,
                                colors: Colors.white,
                                text: getTranslated(context, 'Fund Transfer'),
                                textStyle: TextStyle(
                                    color: TextColor, fontSize: 11),
                                iconSize: 20.0,
                              ),
                            ),
                            Expanded(
                              child: IconButtonInk(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              DealerPurchaseOrder()));
                                },
                                icon: Icons.account_balance_wallet_rounded,
                                colors: Colors.white,
                                text: getTranslated(context, 'Purchase Order'),
                                textStyle: TextStyle(
                                    color: TextColor, fontSize: 11),
                                iconSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                      ]),
                )),
            SizedBox(
              height: 0,
            ),
            Expanded(
              child: Container(
                color: TextColor,
                margin: EdgeInsets.only(left: 4, right: 4),
                child: DealerTab(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
