import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:http/http.dart'as http;
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';

class DealerUsedToken extends StatefulWidget {
  const DealerUsedToken({Key key}) : super(key: key);

  @override
  _DealerUsedTokenState createState() => _DealerUsedTokenState();
}

class _DealerUsedTokenState extends State<DealerUsedToken> {


  List usetoken = [];

  String RemainTokenPre = "";
  String RemainTokenPost = "";
  String JoinDate = "";
  String Email = "";
  String JoiningTokenId = "";
  String usedtoken = "";


  Future<void> purchasetokenn() async {
    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url =
    new Uri.http("api.vastwebindia.com", "/api/Dealer/UsedTokens",{
    });
    final http.Response response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
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
      var data = json.decode(response.body);
      var report = data["Report"];

      setState(() {

        usetoken = report;


      });

    } else {
      throw Exception('Failed to load themes');
    }
  }

  ScrollController listScroll = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    purchasetokenn();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        color: TextColor,
        child: usetoken.length == 0 ? Container(
            height: 50,
            child: DoteLoader()) :ListView.builder(
            controller: listScroll,
            shrinkWrap: true,
            itemCount: usetoken.length,
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
                                            Text(usetoken[index]["RemainTokenPre"].toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.left,)
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
                                            Text(getTranslated(context, 'Use Token'),style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,softWrap: true,),
                                            SizedBox(height: 1,),
                                            Text(usetoken[index]["usedtoken"].toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
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
                                            Text(usetoken[index]["RemainTokenPost"].toString(),style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.right,)
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
                                    usetoken[index]["JoiningTokenId"].toString(),
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
                                    getTranslated(context, 'Retailer Info'),
                                    style: TextStyle(fontSize: 16),
                                  ),

                                  Text(
                                    usetoken[index]["Email"].toString().toLowerCase(),
                                    style: TextStyle(fontSize: 14),
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
                                    usetoken[index]["JoinDate"].toString(),
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
    );
  }
}
