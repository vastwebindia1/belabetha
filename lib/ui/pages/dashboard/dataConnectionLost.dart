import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/CommanWidget/buttons.dart';
import 'package:myapp/ThemeColor/Color.dart';

class DataConnectionLost extends StatefulWidget {
  const DataConnectionLost({Key key}) : super(key: key);

  @override
  _DataConnectionLostState createState() => _DataConnectionLostState();
}

class _DataConnectionLostState extends  State<DataConnectionLost> with SingleTickerProviderStateMixin {






  Future<String> dataconnection() async{

    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

       /* Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => Dashboard()));*/
        Navigator.pop(context,true);
      }
    } on SocketException catch (_) {

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => DataConnectionLost()));


    }
  }


  @override
  Widget build(BuildContext context) {

    return Material(
      child: SafeArea(
        child: Container(
          color:PrimaryColor,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Row(
                    children: [
                      Expanded(
                          child:Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 10,),
                                  Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: TextColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Transform.translate(
                                        offset: Offset(0,-5),
                                        child: Center(
                                          child:Image(
                                            width: 70,
                                            image: AssetImage('assets/complain.png'),
                                          ) ,
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 10,),
                                  Column(
                                    children: [
                                      Text("Connection Lost !",style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: TextColor),),
                                      SizedBox(height: 10,),
                                      Text("Please Re-Check Your Internet Connection",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: SecondaryColor),),
                                    ],
                                  )
                                ],
                              ))

                      )
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10,right: 10),
                            width: MediaQuery.of(context).size.width,
                            child: Image(
                              fit: BoxFit.cover,
                              image: AssetImage("assets/network.png"),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: MainButton(
                                    onPressed: (){

                                      dataconnection();

                                    },
                                    color: SecondaryColor,
                                    btnText: "Retry",
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                )
              ],

            ),
          ),

        ),
      ),
    );
  }

}