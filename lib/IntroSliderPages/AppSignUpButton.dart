import 'package:flutter/material.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/login/join.dart';


class TextButtons extends StatelessWidget {
  final String textButtonText;
  final String buttonText;
  final VoidCallback onPressed;
  final TextStyle textButtonStyle;
  const TextButtons({
    Key key, this.textButtonText, this.buttonText, this.textButtonStyle, this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          textButtonText,
          style: textButtonStyle,
          overflow: TextOverflow.ellipsis,
        ),
        TextButton(
          clipBehavior: Clip.none,
          autofocus: true,
          onPressed:onPressed,
          child: Text(
          buttonText,
          style: TextStyle(
            color: SecondaryColor,
            fontSize: 16,
          ),
              overflow: TextOverflow.ellipsis

        ),
          style:TextButton.styleFrom(
            padding: EdgeInsets.all(0),
            primary: Colors.white,
            backgroundColor: Colors.transparent,
        ),
    )
      ],
    );
  }
}