import 'package:flutter/material.dart';
import 'package:myapp/ThemeColor/Color.dart';

class TabIndicator extends AnimatedWidget {

  final PageController controller;
  const TabIndicator({this.controller}) : super(listenable: controller);

  @override
  Widget build(BuildContext context) {

    return Container(
          child: Center(
            child: Container(
              height: 10,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[ListView.builder(
                    shrinkWrap: true,
                    itemCount: 4,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context,index){
                      return _createTabIndicator(index);
                    })],
              ),
            ),
          ),
        );

  }
  Widget _createTabIndicator(index) {
    bool changeColor = false;
    MaterialColor color=Colors.grey;

    if(controller.page==index)
    {
      changeColor=true;
      color=Colors.blueGrey;
    }

    return  Container(
        height: 10,
        width: 10,
        margin: EdgeInsets.symmetric(horizontal: 2,vertical: 0),
        decoration: BoxDecoration(
          color: changeColor? Colors.white: SecondaryColor,
          borderRadius: BorderRadius.circular(30),

        ),
        child: Center(
          child: AnimatedContainer(
            color: color,
            margin: EdgeInsets.all(5),
            duration: Duration(milliseconds: 1),
          ),
        ),
      );
  
  }
}