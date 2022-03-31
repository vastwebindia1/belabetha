import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myapp/ThemeColor/Color.dart';

class alertdialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
              child: Column(
                children: [
                  Text(
                    "Warning!!!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Invalid user id or pass",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    color: Colors.deepOrangeAccent,
                    textColor: Colors.black,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "ok",
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            child: CircleAvatar(
              backgroundColor: Colors.redAccent,
              radius: 30,
              child: Icon(
                Icons.assistant_photo,
                size: 20,
                color: TextColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
