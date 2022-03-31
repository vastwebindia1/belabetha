import 'package:flutter/material.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';

class Utility extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Expanded(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: GridView.count(
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  crossAxisCount: 4,
                  primary: false,
                  children: <Widget>[

                    Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(
                                Icons.home,
                              ),
                            onPressed: (){

                            },

                          ),
                          Text("data")
                        ],

                      ),
                    ),

                    Card(
                      child: Expanded(
                        // ignore: deprecated_member_use
                        child: FlatButton(
                          onPressed: (){

                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(Icons.home,
                                size: 30,),
                                Text("data")
                              ],

                            ),
                          ),
                        ),
                      ),
                    ),

                    Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                              Icons.home
                          ),
                          Text("Fastag")
                        ],
                      ),
                    ),

                    Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                              Icons.home
                          ),
                          Text("Gas")
                        ],
                      ),
                    ),

                    Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                              Icons.home
                          ),
                          Text(getTranslated(context, 'Landline'),overflow: TextOverflow.ellipsis,maxLines: 1,)
                        ],
                      ),
                    ),

                    Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                              Icons.home
                          ),
                          Text("Insurance")
                        ],
                      ),
                    ),

                    Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                              Icons.home
                          ),
                          Text("Water")
                        ],
                      ),
                    ),

                    Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                              Icons.home
                          ),
                          Text("Electricity")
                        ],
                      ),
                    ),

                    Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                              Icons.home
                          ),
                          Text("Loan")
                        ],
                      ),
                    ),

                    Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                              Icons.home
                          ),
                          Text("Brodband")
                        ],
                      ),
                    ),


                  ],

                ),
              )
          ),
        ],
      ),
    );
  }
}
