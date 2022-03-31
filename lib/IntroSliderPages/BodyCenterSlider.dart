import 'package:flutter/material.dart';
import 'package:myapp/ThemeColor/Color.dart';

import 'SlidePage.dart';
import 'SlideTabs.dart';
import 'SliderImageText.dart';

class BodyCenterSlider extends StatefulWidget {
  @override
  _BodyCenterSliderState createState() => _BodyCenterSliderState();
}

class _BodyCenterSliderState extends State<BodyCenterSlider> {


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(0),
      child: SizedBox(
        height: 330,
        child: Center(
          child: Container(
            color: PrimaryColor,
            child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  PageView.builder(
                    controller: controller,
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                    itemCount: numberOfPages,
                    physics: ScrollPhysics(),
                    allowImplicitScrolling: false,
                    itemBuilder: (BuildContext context, index) {
                      return SlidePage();
                    },
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
