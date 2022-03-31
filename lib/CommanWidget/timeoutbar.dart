import 'package:flutter/material.dart';
import 'package:myapp/ThemeColor/Color.dart';

class TimeOutBar extends StatefulWidget {
  const TimeOutBar({Key key}) : super(key: key);

  @override
  _TimeOutBarState createState() => _TimeOutBarState();
}

class _TimeOutBarState extends State<TimeOutBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SnackBar(
        backgroundColor: Colors.red[900],
            content: Text("Data Not Found",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: TextColor),)),

    );
  }
}
