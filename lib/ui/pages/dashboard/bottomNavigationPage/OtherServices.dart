import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';

class OtherServices extends StatefulWidget {
  const OtherServices({Key key}) : super(key: key);

  @override
  _OtherServicesState createState() => _OtherServicesState();
}

class _OtherServicesState extends State<OtherServices> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: TextColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.upcoming_rounded,size: 150,),
            SizedBox(
              height: 10,
            ),
            AnimatedTextKit(
              isRepeatingAnimation: true,
              repeatForever: true,
              animatedTexts: [
                TypewriterAnimatedText(
                  'COMING SOON',
                  textStyle: const TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                  speed: const Duration(milliseconds: 500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
