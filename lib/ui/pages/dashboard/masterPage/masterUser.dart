import 'package:flutter/material.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/DealerMainPage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/homeTopPages/toSelf.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/BroadbandPage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/dthRechargePage.dart';
import 'package:myapp/ui/pages/dashboard/masterPage/masterUserTab.dart';

class MasterUser extends StatefulWidget {
  const MasterUser({Key key}) : super(key: key);

  @override
  _MasterUserState createState() => _MasterUserState();
}

class _MasterUserState extends State<MasterUser> {
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
                  child: MasterUserTabs(),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }
}
