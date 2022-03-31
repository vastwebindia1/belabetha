import 'package:flutter/material.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/homeTopPages/toSelf.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/BroadbandPage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/dthRechargePage.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:myapp/ui/pages/dashboard/delerpages/delerHomeTopPages/userTabs.dart';


class DealerUser extends StatefulWidget {
  const DealerUser({Key key}) : super(key: key);

  @override
  _DealerUserState createState() => _DealerUserState();
}

class _DealerUserState extends State<DealerUser> {
  @override
  Widget build(BuildContext context) {
    return AppBarWidget(
      title: CenterAppbarTitle(
        svgImage: 'assets/pngImages/BBPS.png',
        topText: getTranslated(context, 'All'),
        selectedItemName: viewVisible1 ? "To Main Wallet":getTranslated(context, 'Users'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            color: PrimaryColor,
            child: Column(
              children: [

                Container(
                  child: UserTab(),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }
}
