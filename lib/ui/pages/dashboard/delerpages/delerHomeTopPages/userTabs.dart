import 'package:flutter/material.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/delerpages/delerHomeTopPages/createUser.dart';
import 'package:myapp/ui/pages/dashboard/delerpages/delerHomeTopPages/dealerRecentTr.dart';
import 'package:myapp/ui/pages/dashboard/delerpages/delerHomeTopPages/retailerList.dart';

class UserTab extends StatefulWidget {
  const UserTab({Key key}) : super(key: key);

  @override
  _UserTabState createState() => _UserTabState();
}

class _UserTabState extends State<UserTab> {

  int selectedIndex = 0;
  static List<StatefulWidget> _widgetOptions1 = [
    RetailerList(),
    CreateUser(),
  ];

  bool firstTap = false;
  bool secondTap = false;
  bool viewVisible = true;
  bool viewVisible1 = false;

  void changelay(int number) {
    if (number == 1) {
      setState(() {
        firstTap = true;
        secondTap = false;
        viewVisible = true;
        viewVisible1 = false;
        selectedIndex = 0;
      });
    } else if (number == 2) {
      setState(() {
        secondTap = true;
        firstTap = false;
        viewVisible = false;
        viewVisible1 = true;
        selectedIndex = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            color: TextColor.withOpacity(0.2),
            padding: EdgeInsets.only(bottom: 10,top: 10,right: 10,left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      changelay(1);
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                        top: viewVisible1 ? 7 : 6,
                        bottom: viewVisible1 ? 8 : 6,
                        right: viewVisible1 ? 20 : 8,
                        left: viewVisible1 ? 20 : 8,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: PrimaryColor,
                          border: Border.all(
                            color: PrimaryColor,
                          ),
                          borderRadius:
                          BorderRadius.all(Radius.circular(50))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            viewVisible
                                ? Icons.check_circle
                                : Icons.check_circle,
                            size: viewVisible ? 19 : 0,
                            color: SecondaryColor,
                          ),
                          SizedBox(
                            width: viewVisible ? 5 : 0,
                          ),
                          Container(
                            child: Text(
                              getTranslated(context, 'Users List'),
                              style: TextStyle(
                                color: SecondaryColor,
                                  fontWeight: viewVisible
                                      ? FontWeight.bold
                                      : viewVisible1
                                      ? FontWeight.normal
                                      : FontWeight.normal),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      changelay(2);
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                        top: viewVisible ? 7 : 6,
                        bottom: viewVisible ? 7 : 6,
                        right: viewVisible ? 18 : 5,
                        left: viewVisible ? 18 : 5,
                      ),
                      alignment: Alignment.center,

                      decoration: BoxDecoration(
                        color: PrimaryColor,
                          border: Border.all(
                            color: PrimaryColor,
                          ),
                          borderRadius:
                          BorderRadius.all(Radius.circular(50))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            viewVisible1
                                ? Icons.check_circle
                                : Icons.check_circle,color:SecondaryColor,
                            size: viewVisible1 ? 19 : 0,
                          ),
                          SizedBox(
                            width: viewVisible1 ? 5 : 0,
                          ),
                          Container(
                            child: Text(
                              getTranslated(context, 'Create User'),
                              style: TextStyle(
                                color: SecondaryColor,
                                  fontWeight: viewVisible1
                                      ? FontWeight.bold
                                      : viewVisible
                                      ? FontWeight.normal
                                      : FontWeight.normal),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(child: _widgetOptions1.elementAt(selectedIndex))
        ],
      ),
    );
  }
}

