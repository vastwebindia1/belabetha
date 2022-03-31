import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'RegisteruserForm.dart';


class Registerpancard extends StatefulWidget {
  const Registerpancard({Key key, this.status}) : super(key: key);
  final String status;

  @override
  _RegisterpancardState createState() => _RegisterpancardState();
}

class _RegisterpancardState extends State<Registerpancard> {

  _launchURL() async {
    const url = 'https://www.psaonline.utiitsl.com/psaonline/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  Future<void> checkpanlivestatus() async {

    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/PAN/api/PAN/PSALiveCheckStatus");
    final http.Response response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 10), onTimeout: () {});

    print(response);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      var status = data["Response"].toString();
      var msz = data["Message"].toString();

      final snackBar = SnackBar(
        content: Text(msz,style: TextStyle(color: Colors.yellowAccent),),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);


    } else {
      throw Exception('Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey,
          body: Visibility(
            visible: widget.status == "NOTRegistered" ? true : false,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 5),
                  color: PrimaryColor.withOpacity(0.8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(top: 10, left: 5, right: 5,bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                          height: 50,
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.only(left: 5,right: 0,top: 0),
                                          padding: EdgeInsets.only(top: 4,bottom: 4,right: 10,left: 10),
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 1,color: PrimaryColor),
                                            borderRadius: BorderRadius.circular(0),
                                            color: TextColor.withOpacity(0.8),
                                          ),
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Text(getTranslated(context, 'PSA ID'),overflow: TextOverflow.ellipsis,),
                                                Flexible(
                                                  child: Text(": Unregistered User",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                                                    overflow: TextOverflow.clip,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 120,
                                decoration: BoxDecoration(
                                    color: SecondaryColor,
                                    border: Border.all(
                                        width: 1,
                                        color: PrimaryColor
                                    )
                                ),
                                child: FlatButton(
                                  onPressed: (){
                                    _launchURL();
                                  },
                                  child: Text(getTranslated(context, 'Login UTR'),style: TextStyle(color: TextColor),overflow: TextOverflow.ellipsis,),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Image.asset('assets/pngImages/registerimgpa.png'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("You are Not Registered with Pancard Service.",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                      Container(
                          margin: EdgeInsets.all(10),
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: SecondaryColor
                            ),
                            onPressed: (){

                              Navigator.push( context, MaterialPageRoute( builder: (context) => Registerform()));

                            },
                            child: Text("Click TO Register At UTI"),
                          )
                      )
                    ],
                  ),
                )
              ],
            ),
            replacement: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 5),
                  color: PrimaryColor.withOpacity(0.8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(top: 10, left: 5, right: 5,bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                          height: 50,
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.only(left: 5,right: 0,top: 0),
                                          padding: EdgeInsets.only(top: 4,bottom: 4,right: 10,left: 10),
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 1,color: PrimaryColor),
                                            borderRadius: BorderRadius.circular(0),
                                            color: TextColor.withOpacity(0.8),
                                          ),
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Text(getTranslated(context, 'PSA ID'),overflow: TextOverflow.ellipsis,),
                                                Flexible(
                                                  child: Text(": User Registration Pending",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                                                    overflow: TextOverflow.clip,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 120,
                                decoration: BoxDecoration(
                                    color: SecondaryColor,
                                    border: Border.all(
                                        width: 1,
                                        color: PrimaryColor
                                    )
                                ),
                                child: FlatButton(
                                  onPressed: (){
                                    _launchURL();
                                  },
                                  child: Text(getTranslated(context, 'Login UTR'),style: TextStyle(color: TextColor),overflow: TextOverflow.ellipsis,),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Icon(Icons.pending,color: Colors.yellow,size: 150,),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("PENDING",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.yellow),),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 10,right: 0),
                        child: Text("Your PAN Card Service Registration Pending For Approval.",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                              margin: EdgeInsets.all(10),
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: SecondaryColor
                                ),
                                onPressed: (){
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Dashboard()));
                                },
                                child: Text("Back"),
                              )
                          ),
                        ),
                        Expanded(
                            child: Container(
                            margin: EdgeInsets.all(10),
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: SecondaryColor
                              ),
                              onPressed: (){

                                checkpanlivestatus();
                              },
                              child: Text("Check Live Status"),
                            )
                        ))
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}
