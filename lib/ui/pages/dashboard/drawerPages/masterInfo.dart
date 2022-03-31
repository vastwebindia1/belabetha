import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:http/http.dart'as http;
import 'package:url_launcher/url_launcher.dart';


class MasterInfo extends StatefulWidget {
  const MasterInfo({Key key}) : super(key: key);

  @override
  _MasterInfoState createState() => _MasterInfoState();
}

class _MasterInfoState extends State<MasterInfo> {

  String name = "";
  String firmname = "";
  String mobile = "";
  String pinCode = "";
  String email = "";
  String address = "";
  String district= "";
  String state = "";
  String gst = "";
  String cityName = "";


  Future<void> masterInform() async {

    final storage = new FlutterSecureStorage();
    var a = await storage.read(key: "accessToken");

    String token = a;
    var url = new Uri.http("api.vastwebindia.com", "/api/Data/DealerMasterInfo");
    final http.Response response = await http.get(
      url,
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
      var result = dataa["Response"];
      var msz = dataa["Message"];
      name = msz["Name"];
      firmname = msz["firmName"];
      mobile = msz["Mobile"];
      pinCode = msz["PINCode"];
      email = msz["Email"];
      address = msz["Address"];
      district = msz["District"];
      state = msz["State"];
      gst = msz["GST"];



      setState(() {
        name;
        firmname;
        mobile;
        pinCode;
        email;
        address;
        district;
        state;
        gst;
      });





    } else {
      throw Exception('Failed to load themes');
    }


  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    masterInform();

  }
  bool notLaunchUrl = false;
  Future<void> _launched;

  Future<void> _openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      notLaunchUrl = true;
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: SingleChildScrollView(
          child:Column(
            children: [
              Container(
                padding: EdgeInsets.all(10,),
                decoration: BoxDecoration(
                  color:PrimaryColor.withOpacity(0.8),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 0,left: 0,bottom: 10,right: 0,),
                          decoration: BoxDecoration(
                          ),
                          child:Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 0),
                                child: IconButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: Icon(Icons.arrow_back,color: SecondaryColor,),

                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 85),
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: TextColor,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(50.0),
                                    ),
                                    color: TextColor
                                ),
                                child: Icon(Icons.account_box
                                  ,color: SecondaryColor,size: 60,),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text(getTranslated(context, 'Master Information'),style: TextStyle(color: TextColor,fontSize: 18,),),
                        Container(
                          child: Container(
                            padding: const EdgeInsets.only(top: 10,left: 10,bottom: 10,right: 10,),
                            margin: const EdgeInsets.only(top: 10,left: 10,bottom: 0,right: 10,),
                            decoration: BoxDecoration(
                              color: SecondaryColor,
                              border: Border.all(
                                width: 2,
                                color: PrimaryColor,
                              ),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(50.0),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                firmname.length <1 ? DoteLoaderWhiteColor():Text(firmname.toUpperCase(),
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(color: TextColor,fontSize: 18,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                              ],
                            ),

                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.only(
                  left: 10,right: 10,),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: PrimaryColor.withOpacity(0.08),
                      blurRadius: 0,
                      spreadRadius: 1,
                      offset: Offset(.0, .0), // shadow direction: bottom right
                    )
                  ],
                ),
                child:address.length <1 ? DoteLoader(): TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        EdgeInsets.all(0)),
                  ),
                  onPressed: () {
                    setState(() {
                      _launched =
                          _openUrl('google.navigation:q=$address&mode=d');
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 0.5,right: 0.5,top: 0.5,bottom: 0.5),
                    child: Container(
                      color: TextColor.withOpacity(0.5),
                      padding: EdgeInsets.only(
                          top: 0, bottom: 0, left: 5, right: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(padding: EdgeInsets.only(top:5,),child: Icon(Icons.location_on_outlined,size: 25,color: SecondaryColor,)),
                          Container(
                            padding: EdgeInsets.only(top:5,),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(getTranslated(context, 'Corporate Office Address'),style: TextStyle(fontSize: 18,color: SecondaryColor),),
                                Container(
                                  padding: EdgeInsets.only(top:0,bottom: 10),
                                  child: Text(address,style: TextStyle(fontSize: 15,color: PrimaryColor),),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                margin: EdgeInsets.only(
                    left: 10,right: 10,bottom: 10),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: PrimaryColor.withOpacity(0.08),
                      blurRadius: 0,
                      spreadRadius: 1,
                      offset: Offset(.0, .0), // shadow direction: bottom right
                    )
                  ],
                ),
                child: Container(
                  margin: EdgeInsets.only(
                      left: 0.5,right: 0.5,top: 0.5,bottom: 0.5),
                  child: Container(
                    color: TextColor.withOpacity(0.5),
                    padding: EdgeInsets.only(
                        top: 5, bottom: 0, left: 5, right: 5),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top:5,bottom: 10),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: PrimaryColor.withOpacity(0.1),width: 1,))
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(getTranslated(context, 'Registration No'),style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                              Text("......",style: TextStyle(fontSize: 17),textAlign: TextAlign.right,)
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top:10,bottom: 10),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: PrimaryColor.withOpacity(0.1),width: 1,))
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(getTranslated(context, 'GST IN'),style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                              gst == null ? DoteLoader():Text(gst,style: TextStyle(fontSize: 17),textAlign: TextAlign.right,)
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top:10,bottom: 10),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: PrimaryColor.withOpacity(0.1),width: 1,))
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(getTranslated(context, 'State'),style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                              state == null ? DoteLoader():Text(state,style: TextStyle(fontSize: 17),textAlign: TextAlign.right,)
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top:10,bottom: 10),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: PrimaryColor.withOpacity(0.1),width: 1,))
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(getTranslated(context, 'City'),style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                              Text(district,style: TextStyle(fontSize: 17),textAlign: TextAlign.right,)
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top:10,bottom: 10),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: PrimaryColor.withOpacity(0.1),width: 1,))
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(getTranslated(context, 'Pin'),style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                              pinCode == null ? DoteLoader():Text(pinCode,style: TextStyle(fontSize: 17),textAlign: TextAlign.right,)
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: PrimaryColor.withOpacity(0.1),width: 1,))
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(getTranslated(context, 'Contact No'),style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                              TextButton(
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.all(0)),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _launched = _openUrl('tel:$mobile}');
                                    });
                                  },
                                  child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding:
                                        EdgeInsets.only(left: 5, right: 5,top: 2,bottom: 2),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(20),
                                            color: SecondaryColor),
                                        child: Text(
                                          "Click To call",
                                          textScaleFactor: 1,
                                          style: TextStyle(
                                            color: TextColor,
                                            fontSize: 8,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 2,),
                                      Text(mobile,style: TextStyle(fontSize: 14,color: PrimaryColor),textAlign: TextAlign.right,),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(getTranslated(context, 'Email Id'),style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                              TextButton(
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _launched = _openUrl('mailto:$email}');
                                    });
                                  },
                                  child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding:
                                        EdgeInsets.only(left: 5, right: 5,top: 2,bottom: 2),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(20),
                                            color: SecondaryColor),
                                        child: Text(
                                          "Click To Send Email",
                                          textScaleFactor: 1,
                                          style: TextStyle(
                                            color: TextColor,
                                            fontSize: 8,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 2,),
                                      Text(email,style: TextStyle(fontSize: 14,color: PrimaryColor),textAlign: TextAlign.right,),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),


            ],
          ),


        ),
      ),
    );
  }
}
