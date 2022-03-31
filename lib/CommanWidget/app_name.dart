import 'package:flutter/material.dart';

class AppName extends StatelessWidget {
  final Color color;
  final String adminfn;
  const AppName({
    Key key, this.color, this.adminfn,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text(adminfn,
          style: TextStyle(fontSize: 14,color: color,
            fontWeight: FontWeight.normal,),)
    );
  }
}
