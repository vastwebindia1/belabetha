import 'package:flutter/material.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';


class MasterRemainToken extends StatefulWidget {
  const MasterRemainToken({Key key}) : super(key: key);

  @override
  _MasterRemainTokenState createState() => _MasterRemainTokenState();
}

class _MasterRemainTokenState extends State<MasterRemainToken> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          child: Column(
            children: [

              Container(height: double.maxFinite,
                width: double.infinity,
                alignment: Alignment.center,
                color: TextColor,
                child: ListView.builder(
                    itemCount: 50,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          ListTile(
                            title:Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: PrimaryColor.withOpacity(0.08),
                                    blurRadius: .5,
                                    spreadRadius: 1,
                                    offset:
                                    Offset(.0, .0), // shadow direction: bottom right
                                  )
                                ],
                              ),
                              margin:
                              EdgeInsets.only(left: 0, right: 0, top: 6, bottom: 0),
                              padding: EdgeInsets.all(1.0),

                              child: Container(
                                color:Colors.white.withOpacity(0.5),
                                padding: EdgeInsets.all(6),

                                child: Column(
                                  children: [

                                    Container(
                                      transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                      padding: EdgeInsets.only(top: 0),

                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 0.0),

                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [

                                            Expanded(
                                              child: Container(
                                                alignment: Alignment.centerLeft,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(getTranslated(context, 'Pre Stock'),style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,),
                                                    SizedBox(height: 1,),
                                                    Text('100',style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.left,)
                                                  ],
                                                ),
                                              ),
                                            ),

                                            SizedBox(
                                              width: 2,
                                              height: 25,
                                              child: Container(
                                                width: 2,
                                                color: Colors.black12,
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: Column(
                                                  children: [
                                                    Text(getTranslated(context, 'Sale Token'),style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                    SizedBox(height: 1,),
                                                    Text('1',style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
                                                  ],
                                                ),
                                              ),
                                            ),

                                            SizedBox(
                                              width: 2,
                                              height: 25,
                                              child: Container(
                                                width: 2,
                                                color: Colors.black12,
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                alignment: Alignment.centerRight,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Text(getTranslated(context, 'Post Stock'),style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,),
                                                    SizedBox(height: 1,),
                                                    Text('100',style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
                                                  ],
                                                ),
                                              ),
                                            )

                                          ],
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [

                                          Text(
                                            'Tokens No',
                                            style: TextStyle(fontSize: 16),
                                          ),


                                          Text(
                                            'hhh@hhh.vbb',
                                            style: TextStyle(fontSize: 16),
                                            textAlign: TextAlign.end,
                                          ),


                                        ],
                                      ),
                                    ),

                                    Container(
                                      margin: EdgeInsets.only(top:4),
                                      height: 1,
                                      color: PrimaryColor.withOpacity(0.1),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [

                                          Text(
                                            'Distributor Info',
                                            style: TextStyle(fontSize: 16),
                                          ),


                                          Text(
                                            'hhh@hhh.vbb',
                                            style: TextStyle(fontSize: 16),
                                            textAlign: TextAlign.end,
                                          ),


                                        ],
                                      ),
                                    ),

                                    Container(
                                      margin: EdgeInsets.only(top:4),
                                      height: 1,
                                      color: PrimaryColor.withOpacity(0.1),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [

                                          Text(
                                            getTranslated(context, 'Transaction Date'),
                                            style: TextStyle(fontSize: 16),
                                          ),


                                          Text(
                                            '6/14/2021',
                                            style: TextStyle(fontSize: 16),
                                            textAlign: TextAlign.end,
                                          ),


                                        ],
                                      ),
                                    ),


                                  ],
                                ),
                              ),

                            ),
                            onTap: (){
                              /*Navigator.push(context, MaterialPageRoute(builder: (context) =>RetailerDetail()));*/
                            },
                          ),

                        ],

                      );

                    }),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
