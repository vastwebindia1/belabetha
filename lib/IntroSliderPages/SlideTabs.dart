import 'package:flutter/material.dart';

import 'TabIndicator.dart';

class BottomArea extends StatelessWidget {
  const BottomArea({
    Key key,
    @required this.controller,
    @required this.currentPage,
    @required this.numberOfPages,
  }) : super(key: key);

  final PageController controller;
  final int currentPage;
  final int numberOfPages;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.only(top: 15),
        height: 15,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            TabIndicator(
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }
}