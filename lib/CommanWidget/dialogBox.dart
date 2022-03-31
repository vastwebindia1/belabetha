import 'dart:convert';
import 'dart:ui';
import 'package:cool_alert/cool_alert.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/locations/IpHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';


class CustomDialog extends StatefulWidget {
  final String title, description, buttonText;
  final IconData icon;
  final Function onpress;
  final Color color;

  CustomDialog({
    this.title,
    this.description,
    this.buttonText,
    this.icon,
    this.onpress,
    this.color,
  });

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
            top: 120,
            bottom: 16,
            left: 16,
            right: 16,
          ),
          margin: EdgeInsets.only(top: 0),
          decoration: new BoxDecoration(
            color: TextColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: TextColor,
                blurRadius: 1.0,
                offset: const Offset(0.0, 0.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children:[
              Text(
                widget.title,
                style: TextStyle(
                  color: widget.color,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                widget.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 10.0),
              Align(
                alignment: Alignment.center,
                // ignore: deprecated_member_use
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ignore: deprecated_member_use
                    FlatButton(
                      color: widget.color,
                      onPressed: widget.onpress,
                      child: Text(widget.buttonText,style: TextStyle(color: TextColor,fontSize: 18),),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          top: 30,
          child: CircleAvatar(
              backgroundColor: Colors.black12,
              radius: 40,
              child: Icon(widget.icon,size: 50,color: widget.color,)
          ),
        ),
      ],
    );
  }
}

/* =========== ========= CoolAlertDialog  ===========     ===========                */

class CoolAlertSuccessDialog extends StatefulWidget {

  final String title, description, buttonText;
  final IconData icon;
  final Function onpress;
  final Color color;

  CoolAlertSuccessDialog({
    this.title,
    this.description,
    this.buttonText,
    this.icon,
    this.onpress,
    this.color,

  });


  @override

  _CoolAlertSuccessDialogState createState() => _CoolAlertSuccessDialogState();
}

class _CoolAlertSuccessDialogState extends State<CoolAlertSuccessDialog> {

  @override

  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
    ),
    elevation: 0.0,
    backgroundColor: Colors.transparent,
    child: dialogContent(context),
    );
  }
  dialogContent(BuildContext context) {
    return CoolAlert.show(
      title: "status",
    );
  }
}

class CoolAlertFailedDialog extends StatefulWidget {

  final String title, description;
  final Function onpress;


  CoolAlertFailedDialog({
    this.title,
    this.description,
    this.onpress,

  });


  @override

  _CoolAlertFailedDialogState createState() => _CoolAlertFailedDialogState();
}

class _CoolAlertFailedDialogState extends State<CoolAlertFailedDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
  dialogContent(BuildContext context) {
    return CoolAlert.show(
      title: "status",
    );
  }
}

/*==================SECOND D==========================================================*/


class CustomDialogWidget extends StatefulWidget {
  final String title, description, description0, buttonText,buttonText1, description1, description01, description2, description02;
  final IconData icon;
  final buttonColor1,buttonColor;
  final VoidCallback onpress,onpress2;
  final TextStyle textStyle;

  const CustomDialogWidget({Key key,
    this.title,
    this.description,
    this.buttonText,
    this.icon,
    this.description1,
    this.description2,
    this.description0,
    this.description01,
    this.description02,
    this.textStyle,
    this.buttonText1,
    this.buttonColor1, this.buttonColor, this.onpress, this.onpress2,}) : super(key: key);

  @override
  _CustomDialogWidgetState createState() => _CustomDialogWidgetState();
}

class _CustomDialogWidgetState extends State<CustomDialogWidget> {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding:  EdgeInsets.only(left:18.0,right: 18,top: 15,bottom: 15),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 1.0,
      backgroundColor: Colors.transparent,
      child: Stack(
        fit:StackFit.loose ,
        children: [
          Container(
            margin: EdgeInsets.only(top: 0),
            decoration: new BoxDecoration(
              color: TextColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: TextColor,
                  blurRadius: 1.0,
                  offset: const Offset(0.0, 0.0),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children:[
                Container(
                  padding: EdgeInsets.only(top: 10,bottom: 10),
                  color: PrimaryColor,
                  child: Column(
                    children: [
                      CircleAvatar(
                          backgroundColor: PrimaryColor,
                          radius: 40,
                          child: Icon(widget.icon,size: 90,color: TextColor,)
                      ),
                      SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              widget.title,
                              style: TextStyle(
                                color: TextColor,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8,)
                    ],
                  ),
                ),
                Container(
                  color: PrimaryColor.withOpacity(0.1),
                  padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),
                      Text(
                        widget.description,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                              widget.description0,
                              textAlign: TextAlign.right,
                              style:widget.textStyle
                          ),
                        ],
                      ),
                      Container(height: 2,color: TextColor,margin: EdgeInsets.only(bottom: 5,top: 2),),
                      Text(
                        widget.description1,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                          widget.description01,
                          textAlign: TextAlign.left,
                          style: widget.textStyle
                      ),
                      Container(height: 2,color: TextColor,margin: EdgeInsets.only(bottom: 5,top: 2),),
                      Text(
                        widget.description2,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                          widget.description02,
                          textAlign: TextAlign.right,
                          style: widget.textStyle
                      ),
                      Container(height: 2,color: TextColor,margin: EdgeInsets.only(bottom: 5,top: 2),),
                      SizedBox(height: 5.0),
                      Align(
                        alignment: Alignment.center,
                        // ignore: deprecated_member_use
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // ignore: deprecated_member_use
                            FlatButton(
                              color: widget.buttonColor1,
                              onPressed: widget.onpress,
                              child: Text(widget.buttonText1,style: TextStyle(color: TextColor,fontSize: 18),),
                            ),
                            SizedBox(width: 10,),
                            // ignore: deprecated_member_use
                            Flexible(
                              child: FlatButton(
                                color: widget.buttonColor,
                                onPressed:widget.onpress2,
                                child: Text(widget.buttonText,
                                  style: TextStyle(color: TextColor,fontSize: 18),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

}


/*======================================Third D====================================================*/


class CustomDialog2 extends StatefulWidget {
  final String title, description, buttonText,buttonText2;
  final IconData icon;
  final Function onpress,onpress2;
  final Color color;

  CustomDialog2({
    this.title,
    this.description,
    this.buttonText,
    this.icon,
    this.onpress,
    this.color, this.onpress2, this.buttonText2,
  });

  @override
  _CustomDialogState2 createState() => _CustomDialogState2();
}

class _CustomDialogState2 extends State<CustomDialog2> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: [
        Container(
            color: TextColor,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 20),
                  color: PrimaryColor.withOpacity(0.8),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 10,right: 10,top: 15),
                    padding: EdgeInsets.only(top: 8,bottom: 0,right: 10,left: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1,color: PrimaryColor),
                      borderRadius: BorderRadius.circular(5),
                      color: TextColor.withOpacity(0.8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Status :".toUpperCase(),
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 16,color: PrimaryColor,fontWeight: FontWeight.bold,),),
                            Text("",textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                  color: PrimaryColor
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Bank Name :".toUpperCase(),
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 16,color: PrimaryColor,fontWeight: FontWeight.bold,),),
                            Text("widget.bankname",textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                  color: PrimaryColor
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Acc No :".toUpperCase(),
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 16,color: PrimaryColor,fontWeight: FontWeight.bold,),),
                            Text("widget.accnum",textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                  color: PrimaryColor
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text("IFSC :".toUpperCase(),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 16,color: PrimaryColor,fontWeight: FontWeight.bold,),),
                                Text("widget.ifscc",textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                      color: PrimaryColor
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Mode:".toUpperCase(),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 16,color: PrimaryColor,fontWeight: FontWeight.bold,),),
                                Text(getTranslated(context, 'IMPS') ,textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                      color: PrimaryColor
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(getTranslated(context, 'Bank RRN'),
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 16,color: PrimaryColor,fontWeight: FontWeight.bold,),),
                            Text("",textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                  color: PrimaryColor
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Date & Time :".toUpperCase(),
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 16,color: PrimaryColor,fontWeight: FontWeight.bold,),),
                            Text("",textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                  color: PrimaryColor
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Align(
                          alignment: Alignment.center,
                          // ignore: deprecated_member_use
                          child: FlatButton(
                            color: SecondaryColor,
                            onPressed: (){},
                            child: Text("ok",style: TextStyle(color: TextColor,fontSize: 18),),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),


              ],
            )
        ),

      ],
    );
  }
}


/*======================================Playstore dialog====================================================*/

class updatedialog extends StatefulWidget {
  final String title, description, buttonText, oldversion, newversion;
  final IconData icon;
  final Function onpress;
  final Color color;

  updatedialog({
    this.title,
    this.description,
    this.oldversion,
    this.newversion,
    this.buttonText,
    this.icon,
    this.onpress,
    this.color,
  });

  @override
  _updatedialogState createState() => _updatedialogState();
}

class _updatedialogState extends State<updatedialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
            top: 100,
            bottom: 16,
            left: 16,
            right: 16,
          ),
          margin: EdgeInsets.only(top: 0),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                blurRadius: 1.0,
                offset: const Offset(0.0, 0.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children:[
              Text(
                widget.title,
                style: TextStyle(
                  color: widget.color,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                widget.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 10.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ignore: deprecated_member_use
                  Text(
                    widget.oldversion,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    widget.newversion,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),

                ],
              ),
              SizedBox(height: 10.0),
              Align(
                alignment: Alignment.center,
                // ignore: deprecated_member_use
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ignore: deprecated_member_use
                    FlatButton(
                      color: widget.color,
                      onPressed: widget.onpress,
                      child: Text(widget.buttonText,style: TextStyle(color: Colors.white,fontSize: 18),),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          top: 20,
          child: Container(
            height: 65,
            width: 65,
            child: CircleAvatar(
                backgroundColor: Colors.black12,
                radius: 40,
                child: Icon(widget.icon,size: 50,color: widget.color,)
            ),
          ),
        ),
      ],
    );
  }
}
