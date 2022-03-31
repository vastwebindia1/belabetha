import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';

class MainButton extends StatelessWidget {
  final String btnText;
  final VoidCallback onPressed;
  final TextStyle style;
  final Color color;

  const MainButton({
    Key key,
    this.btnText,
    this.onPressed,
    this.style,
    this.color,


  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 52,
        margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            const Radius.circular(5.0),
          ),
        ),
        child:
        Row(children: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.all(15),
                backgroundColor:color ,
                shadowColor:Colors.transparent,
              ),
              onPressed:onPressed,
              child: Text(
                  btnText,
                  style: TextStyle(
                    color: TextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ]));
  }
}

class BackButtons extends StatelessWidget {
  final String btnText;

  const BackButtons({
    Key key, this.btnText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: Row(
        children: [
          Icon(
            Icons.arrow_back,
            size: 20,
            color: SecondaryColor,
          ),
          Text(getTranslated(context, 'back'),style: TextStyle(color: SecondaryColor),)
        ],
      ),
    );
  }
}

class BackButtons1 extends StatelessWidget {
  final String btnText;
  final VoidCallback onPressed;

  const BackButtons1({
    Key key, this.btnText, this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed:onPressed ,
      child: Row(
        children: [
          Icon(
            Icons.arrow_back,
            size: 20,
            color: SecondaryColor,
          ),
          Text(getTranslated(context, 'back'),style: TextStyle(color: SecondaryColor),)
        ],
      ),
    );
  }
}

class BackButtonsApBar extends StatelessWidget {
  final String btnText;
  final VoidCallback onPressed;

  const BackButtonsApBar({
    Key key, this.btnText, this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          /*Text("Back",style: TextStyle(color: SecondaryColor,fontSize: 8),),*/
          SvgIconBack(
          svgImage: 'assets/pngImages/backArrow.png',
            color: TextColor,
            width: 36,

        )

        ],
      ),
    );
  }
}
class BackButtonsApBar1 extends StatelessWidget {
  final String btnText;
  final VoidCallback onPressed;

  const BackButtonsApBar1({
    Key key, this.btnText, this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed:(){
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => Dashboard(),
            transitionDuration: Duration(seconds: 0),
          ),);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          /*Text("Back",style: TextStyle(color: SecondaryColor,fontSize: 8),),*/
          SvgIconBack(
            svgImage: 'assets/pngImages/backArrow.png',
            color: TextColor,
            width: 36,

          )

        ],
      ),
    );
  }
}

class SvgIconBack extends StatelessWidget {
  final svgImage;
  final double width ;
  final Color color;
  const SvgIconBack({
    Key key, this.svgImage, this.color, this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      svgImage,
      width: width,
      color: color,);
  }
}


class MainButtonSecodn extends StatelessWidget {
  final Widget btnText;
  final VoidCallback onPressed;
  final TextStyle style;
  final Color color;

  const MainButtonSecodn({
    Key key,
    this.btnText,
    this.onPressed,
    this.style,
    this.color,


  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            const Radius.circular(5.0),
          ),
        ),
        child:
        Row(children: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.all(15),
                backgroundColor:color ,
                shadowColor:Colors.transparent,

              ),
              onPressed:onPressed,
              child: btnText,
            ),
          ),
        ]));
  }
}

class MainButtonTh extends StatelessWidget {
  final Widget btnText;
  final VoidCallback onPressed;
  final TextStyle style;
  final Color color;

  const MainButtonTh({
    Key key,
    this.btnText,
    this.onPressed,
    this.style,
    this.color,


  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            const Radius.circular(5.0),
          ),
        ),
        child:
        Row(children: [
          Expanded(
            child: OutlinedButton(
              style:ButtonStyle(
                backgroundColor:MaterialStateProperty.all(color),
                padding: MaterialStateProperty.all(EdgeInsets.all(15),),
                shadowColor: MaterialStateProperty.all(Colors.transparent),
              ),
              onPressed:onPressed,
              child:btnText,
            ),
          ),
        ]));
  }
}