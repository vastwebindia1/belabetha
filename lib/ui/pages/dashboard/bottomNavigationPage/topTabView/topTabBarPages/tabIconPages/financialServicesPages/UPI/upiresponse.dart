import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/financialServices.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/BroadbandPage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/Towallet/WalletSenderlist.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/UPI/upisenderlist.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/dmtPages/moneyTransfer.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/dmtPages/numberRegister.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/financialServicesPages/dmtPages/registerSender.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;

import 'package:share/share.dart';


class Upiresponse extends StatefulWidget {
  final String bankname,accnum,ifsc,date,status,bankrrn,mode,amount,sservicefee,name;
  const Upiresponse({Key key, this.bankname, this.accnum, this.ifsc, this.date, this.status, this.bankrrn, this.mode, this.amount, this.sservicefee, this.name}) : super(key: key);

  @override
  _UpiresponseState createState() => _UpiresponseState();
}

class _UpiresponseState extends State<Upiresponse> {
  List<String> imagePaths = [];
  var scr= new GlobalKey();
  static GlobalKey previewContainer = new GlobalKey();
  final _boundaryKey = GlobalKey();

  _onShareData(BuildContext context) async {

    final RenderBox box = context.findRenderObject();

    if (imagePaths.isNotEmpty) {
      await Share.shareFiles(imagePaths,
          text: "",
          subject: "",
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    } else {
      await Share.share("",
          subject: "",
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }

  @override
  Widget build(BuildContext context) {
    String pickedFile = imagePaths ==null?"":imagePaths.toString();
    String trimmedFileName = pickedFile.split("/").last;
    return RepaintBoundary(
      key: previewContainer,
      child: Container(
        color: PrimaryColor,
        child: Container(
          color: TextColor.withOpacity(0.5),
          child: SafeArea(
            child: Material(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                                padding: EdgeInsets.only(top: 0,bottom: 0,right: 10,left: 10),
                                child: SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: widget.status == getTranslated(context, 'Failed') ? Colors.red:Colors.transparent,
                                    ),
                                    child: widget.status == getTranslated(context, 'Success') ? Icon(Icons.check_circle,color: Colors.green,size: 50,):widget.status == getTranslated(context, 'Failed') ? Icon(Icons.close_rounded,color: TextColor,size: 50,):Icon(Icons.info,color: Colors.yellow,size: 50,),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                                padding: EdgeInsets.only(top: 0,bottom: 0,right: 10,left: 10),
                                child: Text("TRANSACTION " + widget.status.toUpperCase(),style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color:widget.status == getTranslated(context, 'Failed') ? Colors.red:widget.status == getTranslated(context, 'Success') ? Colors.green:Colors.yellow[800]),),
                              ),
                              Container(
                                height: 2,
                                margin: EdgeInsets.only(top: 10,left: 18,right: 18),
                                color: widget.status == getTranslated(context, 'Success') ? Colors.green : widget.status == getTranslated(context, 'Failed') ? SecondaryColor:Colors.yellow,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(left: 10,right: 10,top: 5),
                                padding: EdgeInsets.only(top: 8,bottom: 0,right: 10,left: 10),
                                child: Column(
                                  children: [
                                    /*  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("Status :".toUpperCase(),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 16,color: PrimaryColor,fontWeight: FontWeight.bold,),),
                                      Text(widget.status,textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1,
                                            color: PrimaryColor
                                        ),
                                      ),
                                    ],
                                  ),*/
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(widget.mode,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(fontSize: 16,color: PrimaryColor,fontWeight: FontWeight.bold,),),
                                        Expanded(
                                          child: Text(widget.accnum,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1,
                                                color: PrimaryColor
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8,),
                                    Container(color: PrimaryColor,height: 1,),
                                    SizedBox(height: 8,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(getTranslated(context, 'Name') ,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(fontSize: 16,color: PrimaryColor,fontWeight: FontWeight.bold,),),
                                        Expanded(
                                          child: Text(widget.name,textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1,
                                                color: PrimaryColor
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8,),
                                    Container(color: PrimaryColor,height: 1,),
                                    SizedBox(height: 8,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("Mode",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(fontSize: 16,color: PrimaryColor,fontWeight: FontWeight.bold,),),
                                        Expanded(
                                          child: Text(widget.ifsc,textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1,
                                                color: PrimaryColor
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8,),
                                    Container(color: PrimaryColor,height: 1,),
                                    SizedBox(height: 8,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(getTranslated(context, 'Amount'),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(fontSize: 16,color: PrimaryColor,fontWeight: FontWeight.bold,),),
                                        Expanded(
                                          child: Text(widget.amount,textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1,
                                                color: PrimaryColor
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8,),
                                    Container(color: PrimaryColor,height: 1,),
                                    SizedBox(height: 8,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(getTranslated(context, 'Enter Service Fee'),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(fontSize: 16,color: PrimaryColor,fontWeight: FontWeight.bold,),),
                                        Expanded(
                                          child: Text(widget.sservicefee,textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1,
                                                color: PrimaryColor
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8,),
                                    Container(color: PrimaryColor,height: 1,),
                                    SizedBox(height: 8,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(getTranslated(context, 'Date & Time'),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(fontSize: 16,color: PrimaryColor,fontWeight: FontWeight.bold,),),
                                        Expanded(
                                          child: Text(widget.date,textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1,
                                                color: PrimaryColor
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8,),
                                    Container(color: PrimaryColor,height: 1,),
                                    SizedBox(height: 8,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(getTranslated(context, 'Bank RRN'),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(fontSize: 16,color: widget.status == "Failed" ? Colors.red :PrimaryColor,fontWeight: FontWeight.bold,),),
                                        Expanded(
                                          child: Text(widget.bankrrn == null ? "" :widget.bankrrn,textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1,
                                                color: widget.status == "Failed" ? Colors.red :PrimaryColor
                                            ),
                                            overflow: TextOverflow.clip,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8,),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 60,
                              child: FlatButton(
                                color: SecondaryColor,
                                onPressed: (){

                                  Navigator.pushReplacement(
                                    context, MaterialPageRoute(builder: (context) => Dashboard()),);

                                },
                                child: Icon(Icons.home,color: TextColor,),
                                /*Text(
                                  "Home",style: TextStyle(color: TextColor,fontSize: 18),)*/
                              ),
                            ),
                            SizedBox(width: 5,),
                            SizedBox(
                              width: 110,
                              child: FlatButton(
                                color: SecondaryColor,
                                onPressed: (){

                                  if(widget.mode == "Wallet ID"){

                                    Navigator.pushReplacement(
                                      context, MaterialPageRoute(builder: (context) => walletsenderlist()),);

                                  }else{

                                    Navigator.pushReplacement(
                                      context, MaterialPageRoute(builder: (context) => Upisenderlist()),);

                                  }
                                },
                                child: Text(getTranslated(context, 'Pay Again'),style: TextStyle(color: TextColor,fontSize: 14),),
                              ),
                            ),
                            SizedBox(width: 5,),
                            Expanded(
                                child: OutlinedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(SecondaryColor),
                                  ),
                                  onPressed: ()async {

                                    RenderRepaintBoundary boundary = previewContainer.currentContext.findRenderObject();
                                    ui.Image image = await boundary.toImage();
                                    final directory = (await getApplicationDocumentsDirectory()).path;
                                    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
                                    Uint8List pngBytes = byteData.buffer.asUint8List();
                                    print(pngBytes);
                                    File imgFile =new File('$directory/ddd.png');
                                    imgFile.writeAsBytes(pngBytes);

                                    final result = await ImageGallerySaver.saveImage(pngBytes);

                                    final imagePicker = ImagePicker();
                                    final pickedFile = await imagePicker.getImage(
                                      source: ImageSource.gallery,
                                    );
                                    if (pickedFile != null) {
                                      setState(() {
                                        imagePaths.add(pickedFile.path);
                                      });
                                    }

                                    _onShareData(context);
                                  },
                                  child: Text("Share",style: TextStyle(color: TextColor),),
                                )
                            ),
                            /* Expanded(
                            child: FlatButton(
                              color: SecondaryColor,
                              onPressed: (){

                              },
                              child: Text("E-mail",style: TextStyle(color: TextColor,fontSize: 18),),
                            ),
                          ),
                          SizedBox(width: 5,),
                          Expanded(
                            child: FlatButton(
                              color: SecondaryColor,
                              onPressed: (){

                              },
                              child: Text("ok",style: TextStyle(color: TextColor,fontSize: 18),),
                            ),
                          ),
                          SizedBox(width: 5,),
                          Expanded(
                            child: FlatButton(
                              color: SecondaryColor,
                              onPressed: (){


                              },
                              child: Text("ok",style: TextStyle(color: TextColor,fontSize: 18),),
                            ),
                          ),*/

                          ],
                        ),
                      ),
                    ],
                  ),
                )
            ),
          ),
        ),
      ),
    );
  }
}
