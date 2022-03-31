import 'dart:typed_data';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ThemeColor/themes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';




class SlidePage extends StatefulWidget {

  @override
  _SlidePageState createState() => _SlidePageState();
}
class _SlidePageState extends State<SlidePage> {

  var status;
  var data;
  List imagelist = [];
  String header1 = "Quality and Safety is our Main Motto";
  String header2 = "With Digital Wallet Multiple Services";
  String header3 = "BBPS Platform for Recharge & Utility";
  String header4 = "Micro ATM is Important in Business";
  String desc1 = "Dear Partner, We are dedicated to the development of your business, our main objective is to do a clean business in the market and we are completely serious about security.";
  String desc2 = "The user has a single digital wallet on this platform. User can use their digital wallet to pay for many services, digital wallet is very easy to use.";
  String desc3 = "We are using the BBPS platform for recharge and utility services and provide the best commission to users. Our financial and travel services are easy to use.";
  String desc4 = "Our government provides some platform for digitization, we are using the platform for better future of users. mPOS and micro ATM are very important for your business.";
  Uint8List image1,image2,image3,image4;
  String imgee;

  Future<void> imageslider() async {


    String token = "";
    var url = new Uri.http("api.vastwebindia.com", "/Common/api/data/appdataslider");
    final http.Response response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print(response);

    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      data   = dataa['data'];

      if(data.length == 0){

        setState(() {
          imgee = "null";
        });

      }else{

        var img1 = data[0]["Imagesss"];
        var img2 = data[1]["Imagesss"];
        var img3 = data[2]["Imagesss"];
        var img4 = data[3]["Imagesss"];

        image1 = base64.decode(img1);
        image2 = base64.decode(img2);
        image3 = base64.decode(img3);
        image4 = base64.decode(img4);


        header1 = data[0]["Header"].toString();
        header2 = data[1]["Header"].toString();
        header3 = data[2]["Header"].toString();
        header4 = data[3]["Header"].toString();

        desc1 = data[0]["Discription"].toString();
        desc2 = data[1]["Discription"].toString();
        desc3 = data[2]["Discription"].toString();
        desc4 = data[3]["Discription"].toString();

        setState(() {
          image1;
        });

      }

    } else {
      throw Exception('Failed');
    }


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imageslider();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(
              width: 0,
              color: Colors.transparent
          ),

        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              SizedBox(
                height: 330,
                width: double.infinity,
                child: Carousel(
                  dotSize: 6.0,
                  dotSpacing: 15.0,
                  dotColor: SecondaryColor,
                  indicatorBgPadding: 5.0,
                  dotBgColor: Colors.transparent,
                  dotPosition: DotPosition.bottomCenter,
                  autoplay: true,
                  showIndicator: true,
                  images: [

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        image1 != null ? Image.memory(image1) : Image.asset('assets/Sl10.png'),
                        //Image.asset('assets/Sl10.png'),
                        SizedBox(height: 10,),
                        Text(header1,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: TextColor
                          ),
                          textAlign: TextAlign.center
                          ,),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10,right: 10),
                          child: Text(desc1,
                            style: TextStyle(
                                fontSize: 12,
                                color: TextColor
                            ),
                            textAlign: TextAlign.justify
                            ,),
                        )

                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        image2 != null ? Image.memory(image2) :Image.asset('assets/Sl4.png'),
                        //Image.asset('assets/Sl4.png'),
                        SizedBox(height: 10,),
                        Text(header2,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: TextColor
                          ),
                          textAlign: TextAlign.center
                          ,),
                        SizedBox(
                          height: 3,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10,right: 10),
                          child: Text(desc2,
                            style: TextStyle(
                                fontSize: 12,
                                color: TextColor
                            ),
                            textAlign: TextAlign.justify
                            ,),
                        )

                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        image3 != null ? Image.memory(image3,) : Image.asset('assets/SL02.png'),
                        //Image.asset('assets/SL02.png'),
                        SizedBox(height: 10,),
                        Text(header3,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: TextColor
                          ),
                          textAlign: TextAlign.center
                          ,),
                        SizedBox(
                          height: 3,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10,right: 10),
                          child: Text(desc3,
                            style: TextStyle(
                                fontSize: 12,
                                color: TextColor
                            ),
                            textAlign: TextAlign.justify
                            ,),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        image4 != null ? Image.memory(image4) :Image.asset('assets/SL3.png'),
                        //Image.asset('assets/SL3.png'),

                        SizedBox(height: 10,),
                        Text(header4,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: TextColor
                          ),
                          textAlign: TextAlign.center
                          ,),
                        SizedBox(
                          height: 3,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10,right: 10),
                          child: Text(desc4,
                            style: TextStyle(
                                fontSize: 12,
                                color: TextColor
                            ),
                            textAlign: TextAlign.justify
                            ,),
                        )
                      ],
                    ),

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