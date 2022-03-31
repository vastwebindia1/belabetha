import 'package:flutter/material.dart';


class Customsnakbar extends StatelessWidget {
  final String text;

  const Customsnakbar({
    Key key, this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Text('Hey! This is a SnackBar message.'),
      duration: Duration(seconds: 5),
      action: SnackBarAction(
        label: 'Retry',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );


  }
}