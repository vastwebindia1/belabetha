import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/dthRechargePage.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NotificationPage extends StatefulWidget {
  const NotificationPage({Key key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  String titile = "dd";
  String des = "dhd";
  List<String> notificationlist = List<String>();
  List<String> notificationlist2 = List<String>();

  @override
  void initState() {
    super.initState();
    _update();
  }

  void _update() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    notificationlist = prefs.getStringList('Categories');
    notificationlist2 = prefs.getStringList('Categories2');

    print(notificationlist);

    setState(() {
      notificationlist;
      notificationlist2 ;
    });

  }

  @override
  Widget build(BuildContext context) {
    return AppBarWidget(
        title: CenterAppbarTitleWithIcon(
          icon: Icon(Icons.notification_important_outlined,color: Colors.white,),
          topText: "Selected Information",
          selectedItemName: "Notification",
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: notificationlist == null ? Text("") : ListView.builder(
                        itemCount: notificationlist.length ,
                        shrinkWrap: true,
                        itemBuilder:  (BuildContext context, int index){
                          return Container(
                            color: PrimaryColor.withOpacity(0.9),
                            child: Column(
                              children: [
                                Text(notificationlist[index],style: TextStyle(color: Colors.white),),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10,right: 10),
                                  child:  Text(notificationlist2[index],style: TextStyle(color: Colors.white),textAlign: TextAlign.justify,),
                                ),
                                Container(
                                  height: 5,
                                  color:Colors.white,
                                ),
                              ],
                            ),
                          );

                        }),
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}
