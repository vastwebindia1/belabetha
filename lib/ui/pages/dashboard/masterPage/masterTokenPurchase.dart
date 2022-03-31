import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:http/http.dart'as http;
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';

class MasterPurchaseToken extends StatefulWidget {
  const MasterPurchaseToken({Key key}) : super(key: key);


  @override
  _MasterPurchaseTokenState createState() => _MasterPurchaseTokenState();
}

class _MasterPurchaseTokenState extends State<MasterPurchaseToken> {



  List tokenList = [];


  Future<void> tokenReport() async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;

    var url = new Uri.http("api.vastwebindia.com", "/api/master/Remain_dealer_token_report");
    final http.Response response = await http.get(url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 15), onTimeout: (){
      setState(() {

        final snackBar2 = SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(getTranslated(context, 'Data Not Found'),style: TextStyle(color: Colors.yellowAccent),textAlign: TextAlign.center),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar2);

      });
    });

    print(response);

    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);


      setState(() {

        tokenList = dataa;

      });

    } else {
      throw Exception('Failed to load themes');
    }

  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tokenReport();
  }



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(
                height: double.maxFinite,
                width: double.infinity,
                alignment: Alignment.center,
                color: TextColor,
                child: tokenList.length == 0?
                    Column(
                      children: [
                        Container(
                          child: Text(getTranslated(context, 'No Data') ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                        )
                      ],
                    ) :Column(
                  children: [
                    ListView.builder(
                        itemCount: 1,
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
                                    padding: EdgeInsets.all(4),

                                    child: Column(
                                      children: [

                                        Container(
                                          transform: Matrix4.translationValues(0.0, -2.0, 0.0),
                                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),


                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 0.0),

                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(bottom: 5),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          height: 37,
                                                          width: 37,
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                color: SecondaryColor,
                                                              ),
                                                              borderRadius: BorderRadius.all(Radius.circular(50)),
                                                              color: TextColor
                                                          ),
                                                          child: Text(tokenList[index]["RemainTokenPost"].toString(),
                                                            style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),

                                                        ),
                                                        SizedBox(
                                                          width: 8,
                                                        ),
                                                        Flexible(
                                                          flex: 1,
                                                          child: Container(
                                                            margin: EdgeInsets.only(top: 4),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  getTranslated(context, 'TOKEN'),
                                                                  softWrap: true,
                                                                  style: TextStyle(fontSize: 12),
                                                                  textAlign: TextAlign.left,
                                                                ),
                                                                SizedBox(height: 1,),
                                                                Text(
                                                                  getTranslated(context, 'QTY'),
                                                                  overflow: TextOverflow.ellipsis,
                                                                  maxLines: 1,
                                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                                  textAlign: TextAlign.left,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 2,
                                                  height: 28,
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
                                                        Text(getTranslated(context, 'Dealer Name'),style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,softWrap: true,),
                                                        SizedBox(height: 1,),
                                                        Text(tokenList[index]["DealerName"].toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
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
                                                        Text(getTranslated(context, 'Firm'),style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,),
                                                        SizedBox(height: 1,),
                                                        Text(tokenList[index]["FarmName"].toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
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
                  ],
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
