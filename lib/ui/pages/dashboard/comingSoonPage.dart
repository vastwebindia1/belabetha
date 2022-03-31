import 'package:flutter/material.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';

class ComingSoon extends StatefulWidget {
  const ComingSoon({Key key}) : super(key: key);

  @override
  _ComingSoonState createState() => _ComingSoonState();
}

class _ComingSoonState extends State<ComingSoon> {
  @override
  Widget build(BuildContext context) {
    return SimpleAppBarWidget(
      title: Align(
          alignment:  Alignment(-.4, 0),
          child: Text(getTranslated(context, 'Coming Soon'),style: TextStyle(color: TextColor),textAlign: TextAlign.center,)),
      body: Container(
        color: TextColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                alignment: Alignment.center,
                child: Text(getTranslated(context, 'Coming Soon'),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),))

          ],
        ),
      ),
    );
  }
}
