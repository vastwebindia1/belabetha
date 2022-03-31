import 'package:flutter/material.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/masterPage/masterRecentTra.dart';


class MasterHomTab extends StatefulWidget {
  const MasterHomTab({Key key}) : super(key: key);

  @override
  _MasterHomTabState createState() => _MasterHomTabState();
}

class _MasterHomTabState extends State<MasterHomTab> {
  int selectedIndex = 0;
  static List<StatefulWidget> _widgetOptions = [

    MasterRecentTra(),
  ];

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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Container(
                        child: Text(
                          getTranslated(context, 'Recent Transaction'),
                          style: TextStyle(
                              color: TextColor,
                              fontSize: 18,
                              fontWeight:FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),


          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _widgetOptions.elementAt(selectedIndex),
              ],
            ),
          )
        ],
      ),
    );
  }
}
