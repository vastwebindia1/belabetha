import 'package:flutter/material.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/delerpages/delerHomeTopPages/dealerRecentTr.dart';
import 'package:myapp/ui/pages/dashboard/delerpages/delerHomeTopPages/retailerList.dart';


class DealerTab extends StatefulWidget {
  const DealerTab({Key key}) : super(key: key);

  @override
  _DealerTabState createState() => _DealerTabState();
}

class _DealerTabState extends State<DealerTab> {

  int selectedIndex = 0;
  static List<StatefulWidget> _widgetOptions = [
    DealerRecentTra(),
  ];

  bool firstTap = false;
  bool secondTap = true;
  bool viewVisible = true;
  bool viewVisible1 = true;

  void changelay(int number) {
    if (number == 1) {
      setState(() {
        firstTap = true;
        secondTap = true;
         viewVisible = true;
         viewVisible1 = true;
        selectedIndex = 0;
      });
    } else if (number == 2) {
      setState(() {
        secondTap = true;
        firstTap = true;
         viewVisible = true;
         viewVisible1 = true;
        selectedIndex = 1;
      });
    }
  }
/*  void showWidget() {
    setState(() {
      firstTap = true;
      secondTap = false;
    });
  }

  void hideWidget() {
    setState(() {
      secondTap = true;
      firstTap = false;
    });
  }*/


  @override
    Widget build(BuildContext context) {
      return Container(
        padding: EdgeInsets.only(bottom: 10,top: 0),
        child: Column(
          children: [
            Container(
              color: PrimaryColor.withOpacity(0.8),
              padding: EdgeInsets.only(left: 10, right: 10,top: 5,bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    // decoration: BoxDecoration(
                    //     color: PrimaryColor,
                    //     border: Border.all(
                    //       color: PrimaryColor,
                    //     ),
                    //     borderRadius:
                    //     BorderRadius.all(Radius.circular(50))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Container(
                          child: Text(
                            getTranslated(context, 'Recent Transaction'),
                            style: TextStyle(
                              color: TextColor,
                                fontSize: 18,
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
                ],
              ),
            ),



            Expanded(child: _widgetOptions.elementAt(selectedIndex))
          ],
        ),
      );
    }
  }



