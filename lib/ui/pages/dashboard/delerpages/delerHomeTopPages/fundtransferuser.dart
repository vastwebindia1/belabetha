import 'package:flutter/material.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/homeTopPages/toSelf.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/BroadbandPage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/dthRechargePage.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:myapp/ui/pages/dashboard/delerpages/delerHomeTopPages/fundTrasferTab.dart';
import 'package:myapp/ui/pages/dashboard/delerpages/delerHomeTopPages/userTabs.dart';


class FundTransferUser extends StatefulWidget {
  const FundTransferUser({Key key}) : super(key: key);

  @override
  _FundTransferUserState createState() => _FundTransferUserState();
}

class _FundTransferUserState extends State<FundTransferUser> {
  @override
  Widget build(BuildContext context) {
    return SimpleAppBarWidget(
      title: Align(
          alignment:  Alignment(-.4, 0),
          child: Text(getTranslated(context, 'Fund Transfer'),style: TextStyle(color: TextColor),textAlign: TextAlign.center,)),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            color: PrimaryColor,
            child: Column(
              children: [

                Container(
                  child: FundTrasnferTab(),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }
}
