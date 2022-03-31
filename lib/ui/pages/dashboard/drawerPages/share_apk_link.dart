import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;

class ShareApkLink extends StatefulWidget {
  @override
  _ShareApkLinkState createState() => _ShareApkLinkState();
}

class _ShareApkLinkState extends State<ShareApkLink> {
  String text = 'https://play.google.com/store/apps/details?id=com.aasha.newaashaflutter';
  String text2 = 'https://www.test.vastwebindia.com/Home/Index1';
  String text3 = 'https://www.test.vastwebindia.com/Home/Index1';
  String text4 = 'https://www.test.vastwebindia.com/Home/Index1';
  String subject = 'App Link';
  List<String> imagePaths = [];

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: TextColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color:PrimaryColor.withOpacity(0.8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 0,left: 0,bottom: 2,right: 0,),
                    child:Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 50,
                          margin: EdgeInsets.only(top: 5),
                          child: IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Icon(Icons.arrow_back,color: SecondaryColor,),

                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: PrimaryColor,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: PrimaryColor,
                              width: 1,
                            )
                          ),
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(left:70),
                          child: Icon(Icons.share,color: TextColor,size: 70,),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 15,right: 15,),
                    child:Column(
                      children: [
                        Text(getTranslated(context, 'apkShare'),style: TextStyle(fontSize: 18,color: TextColor,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                        SizedBox(height: 5,),
                        Text(getTranslated(context, 'apkMsg'),
                        style: TextStyle(fontSize: 12,color: TextColor,fontWeight: FontWeight.bold),textAlign: TextAlign.justify,),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 15,),

            Container(
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: PrimaryColor.withOpacity(0.08),
                    blurRadius: 0,
                    spreadRadius: 1,
                    offset: Offset(.0, .0), // shadow direction: bottom right
                  )
                ],
                border: Border.all(
                  width: 1,
                  color: PrimaryColor.withOpacity(0.1),
                )
              ),
              child: Container(
                color: TextColor.withOpacity(0.5),
                padding: EdgeInsets.only(top: 1, bottom: 0, left: 1, right: 1),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 0, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(bottom: 3),
                            decoration: BoxDecoration(
                              color: SecondaryColor,
                                ),
                            child: Row(

                              children: [
                                Image.asset("assets/pngImages/android.png",width: 30,height: 30,),
                                SizedBox(width: 5,),
                                Expanded(child: Text(getTranslated(context, 'androidApk'),style: TextStyle(fontSize: 13,color: TextColor), overflow: TextOverflow.clip,textAlign: TextAlign.justify,)),

                              ]
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 0,top: 7),
                            margin: EdgeInsets.only(top: 0, bottom: 5, left: 5, right: 5),


                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [


                                SizedBox(height: 0,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(right: 4),
                                        alignment: Alignment.center,
                                        child: FlatButton(
                                          color: TextColor,
                                          shape:RoundedRectangleBorder(side: BorderSide(
                                              color: PrimaryColor.withOpacity(0.2),
                                              width: 1,
                                              style: BorderStyle.solid
                                          ),borderRadius: new BorderRadius.circular(5),),
                                          padding: EdgeInsets.all(5),
                                          onPressed: (){

                                            _onShare(context);
                                          },
                                          child:Row(
                                            children: [
                                              SizedBox(width: 5,),
                                              Image.asset("assets/pngImages/google-play.png",width: 20,height: 22,),
                                              SizedBox(width: 10,),
                                              Column(
                                                children: [
                                                  Container(
                                                    width:80,
                                                    child: Text(
                                                      getTranslated(context, 'Play Store'),
                                                      style: TextStyle(fontSize: 12),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 80,
                                                    child: Text(
                                                        getTranslated(context, 'Link'),
                                                        style: TextStyle(fontSize: 14),
                                                        overflow: TextOverflow.ellipsis
                                                    ),
                                                  ),
                                                ],
                                              ),


                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: 50,),

                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(right: 4),
                                        alignment: Alignment.centerRight,
                                        child: FlatButton(
                                          color: TextColor,
                                          shape:RoundedRectangleBorder(side: BorderSide(
                                              color: PrimaryColor.withOpacity(0.2),
                                              width: 1,
                                              style: BorderStyle.solid
                                          ),borderRadius: new BorderRadius.circular(5),),
                                          padding: EdgeInsets.all(5),
                                          onPressed: (){

                                            _onShare2(context);
                                          },
                                          child:Row(
                                            children: [
                                              SizedBox(width: 5,),
                                              Icon(CupertinoIcons.globe, size: 23,color: Colors.red,),
                                              SizedBox(width: 10,),
                                              Column(
                                                children: [
                                                  Container(
                                                    width:80,
                                                    child: Text(
                                                      getTranslated(context, 'Web Site'),
                                                      style: TextStyle(fontSize: 12),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 80,
                                                    child: Text(
                                                        getTranslated(context, 'Link'),
                                                        style: TextStyle(fontSize: 14),
                                                        overflow: TextOverflow.ellipsis
                                                    ),
                                                  ),
                                                ],
                                              ),


                                            ],
                                          ),
                                        ),
                                      ),
                                    ),



                                  ],
                                ),
                              ],
                            ),
                          ),


                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20,),

            Container(
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: PrimaryColor.withOpacity(0.08),
                      blurRadius: 0,
                      spreadRadius: 1,
                      offset: Offset(.0, .0), // shadow direction: bottom right
                    )
                  ],
                  border: Border.all(
                    width: 1,
                    color: PrimaryColor.withOpacity(0.1),
                  )
              ),
              child: Container(
                color: TextColor.withOpacity(0.5),
                padding: EdgeInsets.only(top: 1, bottom: 0, left: 1, right: 1),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 0, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(bottom: 3),
                            decoration: BoxDecoration(
                              color: SecondaryColor,
                            ),
                            child: Row(

                                children: [
                                  Image.asset("assets/pngImages/apple.png",width: 30,height: 30,),
                                  SizedBox(width: 5,),
                                  Expanded(child: Text(getTranslated(context, 'iosMsg'),style: TextStyle(fontSize: 13,color: TextColor), overflow: TextOverflow.clip,textAlign: TextAlign.justify,)),

                                ]
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 0,top: 7),
                            margin: EdgeInsets.only(top: 0, bottom: 5, left: 5, right: 5),


                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [


                                SizedBox(height: 0,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(right: 4),
                                        alignment: Alignment.center,
                                        child: FlatButton(
                                          color: TextColor,
                                          shape:RoundedRectangleBorder(side: BorderSide(
                                              color: PrimaryColor.withOpacity(0.2),
                                              width: 1,
                                              style: BorderStyle.solid
                                          ),borderRadius: new BorderRadius.circular(5),),
                                          padding: EdgeInsets.all(5),
                                          onPressed: (){

                                            _onShare3(context);
                                          },
                                          child:Row(
                                            children: [
                                              SizedBox(width: 5,),
                                              Image.asset("assets/pngImages/app-store.png",width: 20,height: 22,),
                                              SizedBox(width: 10,),

                                              Column(
                                                children: [
                                                  Container(
                                                    width:80,
                                                    child: Text(
                                                      getTranslated(context, 'App Store'),
                                                      style: TextStyle(fontSize: 12),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 80,
                                                    child: Text(
                                                        getTranslated(context, 'Link'),
                                                        style: TextStyle(fontSize: 14),
                                                        overflow: TextOverflow.ellipsis
                                                    ),
                                                  ),
                                                ],
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 50,),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(right: 4),
                                        alignment: Alignment.centerRight,
                                        child: FlatButton(
                                          color: TextColor,
                                          shape:RoundedRectangleBorder(side: BorderSide(
                                              color: PrimaryColor.withOpacity(0.2),
                                              width: 1,
                                              style: BorderStyle.solid
                                          ),borderRadius: new BorderRadius.circular(5),),
                                          padding: EdgeInsets.all(5),
                                          onPressed: (){

                                            _onShare4(context);
                                          },
                                          child:Row(
                                            children: [
                                              SizedBox(width: 5,),
                                              Icon(CupertinoIcons.globe, size: 22,color: Colors.red,),
                                              SizedBox(width: 10,),
                                             Column(
                                                children: [
                                                  Container(
                                                    width:80,
                                                    child: Text(
                                                      getTranslated(context, 'Web Site'),
                                                      style: TextStyle(fontSize: 12),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 80,
                                                    child: Text(
                                                      getTranslated(context, 'Link'),
                                                      style: TextStyle(fontSize: 14),
                                                        overflow: TextOverflow.ellipsis
                                                    ),
                                                  ),
                                                ],
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                    ),



                                  ],
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  _onShare(BuildContext context) async {

    final RenderBox box = context.findRenderObject() as RenderBox;


    await Share.share(text,
        subject: subject,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);

  }

  _onShare2(BuildContext context) async {

    final RenderBox box = context.findRenderObject() as RenderBox;


    await Share.share(text2,
        subject: subject,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);

  }

  _onShare3(BuildContext context) async {

    final RenderBox box = context.findRenderObject() as RenderBox;


    await Share.share(text3,
        subject: subject,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);

  }

  _onShare4(BuildContext context) async {

    final RenderBox box = context.findRenderObject() as RenderBox;


    await Share.share(text4,
        subject: subject,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);

  }


}

