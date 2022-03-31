import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';

class Rechargedialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 180,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
                children: [
                  Text(
                    getTranslated(context, 'Please Confirm'),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Column(
                    children: [
                      Text(
                        getTranslated(context, 'Amount : 20'),
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5,),
                      Text(
                        getTranslated(context, 'Mobile No : 7414088555'),
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RaisedButton(
                        color: Colors.deepOrangeAccent,
                        textColor: Colors.black,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(getTranslated(context, 'Cancle')
                        ),
                      ),
                      RaisedButton(
                        color: Colors.deepOrangeAccent,
                        textColor: Colors.black,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(getTranslated(context, 'ok')
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
