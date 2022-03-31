import 'package:flutter/material.dart';
import 'package:myapp/CommanWidget/utility.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';

class TabHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(

        child: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 50,
                backgroundColor: TextColor,
                elevation: 0,
                bottom: TabBar(
                    unselectedLabelColor: Colors.purple,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: Colors.redAccent,
                    /*indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.redAccent),*/

                    tabs: [
                      Tab(
                        child: Container(
                          height: 20.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.redAccent, width: 1)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("Recharge & Bills", style: TextStyle(color: Colors.redAccent),),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          height: 20.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.redAccent, width: 1)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("Financial", style: TextStyle(color: Colors.redAccent),),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          height: 20.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.redAccent, width: 1)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(getTranslated(context, 'Travel'), style: TextStyle(color: Colors.redAccent),),
                          ),
                        ),
                      ),
                    ]),
              ),
              body: TabBarView(children: [
                Utility(),
                Utility(),
                Utility(),

              ]),
            ))
    );
  }
}
