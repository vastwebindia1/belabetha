import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/travelsHotelPages/Busbooking/busBookingPage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/travelsHotelPages/IRCTC/irctcrailway.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/travelsHotelPages/antiVirusSecurity/antiVirusPage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/travelsHotelPages/flightbooking/flightbookingpage.dart';
import 'package:http/http.dart' as http;
import '../../HomePage.dart';
import 'RechargeAndBill.dart';

class TravelsHotel extends StatefulWidget {
  @override
  _TravelsHotelState createState() => _TravelsHotelState();
}
Image image1;
Image image2;
Image image3;
Image image4;
Image image5;
Image image6;
Image image7;
Image image8;
Image image9;
Image image10;
Image image11;
Image image12;
Image image13;


class _TravelsHotelState extends State<TravelsHotel> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    servicestacheck();

    image1 = Image.asset('assets/pngImages/bus.png', width: 10,);
    image2 = Image.asset('assets/pngImages/Flight.png', width: 32,);
    image3 = Image.asset('assets/pngImages/train.png', width: 64,);
    image4 = Image.asset('assets/pngImages/hotel.png', width: 32,);
    image6 = Image.asset('assets/pngImages/healthcare.png', width: 32,);
    image7 = Image.asset('assets/pngImages/Entertainment.png', width: 32,);
    image5 = Image.asset('assets/pngImages/allgift.png', width: 32,);
    image8 = Image.asset('assets/pngImages/ecommerce.png', width: 32,);
    image9 = Image.asset('assets/pngImages/Jewellery.png', width: 32,);
    image10 = Image.asset('assets/pngImages/fashion.png', width: 32,);
    image11 = Image.asset('assets/pngImages/sports.png', width: 32,);
    image12 = Image.asset('assets/pngImages/security.png', width: 32,);
    image13 = Image.asset('assets/pngImages/package.png', width: 32,);
  }

  bool othervisis = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(image1.image, context);
    precacheImage(image2.image, context);
    precacheImage(image3.image, context);
    precacheImage(image4.image, context);
    precacheImage(image5.image, context);
    precacheImage(image6.image, context);
    precacheImage(image7.image, context);
    precacheImage(image8.image, context);
    precacheImage(image9.image, context);
    precacheImage(image10.image, context);
    precacheImage(image11.image, context);
    precacheImage(image12.image, context);
    precacheImage(image13.image, context);

  }

  Future<void> servicestacheck() async {

    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/Retailer/api/data/Rempermissionshow");
    final http.Response response = await http.post(url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 15), onTimeout: (){

    });

    print(response);

    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);

      for(int i =0;i<dataa.length;i++){

        var optname = dataa[i]["servicename"];
        if(optname == "Other"){

          var status = dataa[i]["status"];

          setState(() {
            othervisis = status;
          });

        }

      }


    } else {
      throw Exception('Failed to load themes');
    }

  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: PrimaryColor
      ),
      padding: EdgeInsets.only(left: 8,right: 8,top: 0),
      child: Column(
        children: [
          /*Travels ================*/
          Container(
            margin: EdgeInsets.only(left: 8, right: 8, top: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: TextColor,
            ),
            child: Container(
              padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 5),
              color: DashboardCardPrimaryColor.withOpacity(0.9),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                              margin: EdgeInsets.only(
                                  left: 5,top: 6,bottom: 6),
                              child: Text(
                                getTranslated(context, 'Travels & Hotels'),
                                style: TextStyle(fontSize: 12,color: DashboardCardTextColor),)))
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: IconButtonInk1(
                          onPressed: (){

                            Navigator.push(context, MaterialPageRoute(builder: (_) => BusBooking()));
                          },
                          icon:image1,
                          colors: Colors.white,
                          text:getTranslated(context, 'Bus'),
                          textStyle: TextStyle(fontSize: 10, color: DashboardCardTextColor),
                        ),
                      ),
                      Expanded(
                        child: IconButtonInk1(
                          onPressed: (){

                            Navigator.push(context, MaterialPageRoute(builder: (_) => FlightBooking()));

                          },
                          icon:image2,
                          colors: Colors.white,
                          text:getTranslated(context, 'Flight'),
                          textStyle: TextStyle(fontSize: 10, color: DashboardCardTextColor),
                        ),
                      ),
                      Expanded(
                        child: IconButtonInk1(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => IrctcRailway()));
                          },
                          icon:image3,
                          colors: Colors.white,
                          text:getTranslated(context, 'Train'),
                          textStyle: TextStyle(fontSize: 10, color: DashboardCardTextColor),
                        ),
                      ),
                      Expanded(
                        child: IconButtonInk1(
                          onPressed: (){

                          },
                          icon:image4,
                          colors: Colors.white,
                          text: getTranslated(context, 'Hotels'),
                          textStyle: TextStyle(fontSize: 10, color: DashboardCardTextColor),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3,),
                ],
              ),
            ),
          ),
          /*Pos & Aadhaar Services================*/
          Visibility(
            visible: othervisis,
            child: Container(
            margin: EdgeInsets.only(left: 8, right: 8, top: 12),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: TextColor,
            ),
            child: Container(
              padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 10),
              color: DashboardCardPrimaryColor.withOpacity(0.9),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                              margin: EdgeInsets.only(
                                  left: 5,top: 6,bottom: 6),
                              child: Text(
                                getTranslated(context, 'Digital & Physical Gift Card'),
                                style: TextStyle(fontSize: 12,color: DashboardCardTextColor),)))
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: IconButtonInk1(
                          onPressed: (){

                          },
                          icon:image5,
                          colors: DashboardCardPrimaryColor,
                          text:getTranslated(context, 'All'),
                          textStyle: TextStyle(fontSize: 10, color: DashboardCardTextColor),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(5),
                          child: Column(
                            children: [
                              ClipOval(
                                child: Material(
                                  color: IconBackgroundPrimaryColor, // button color
                                  child: InkWell(
                                    splashColor: DashboardCardPrimaryColor, // inkwell color
                                    child: SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: image6)
                                    ),
                                    onTap: (){

                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                getTranslated(context, 'health'),
                                style: TextStyle(fontSize: 10, color: DashboardCardTextColor),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(5),
                          child: Column(
                            children: [
                              ClipOval(
                                child: Material(
                                  color: IconBackgroundPrimaryColor, // button color
                                  child: InkWell(
                                    splashColor: IconBackgroundPrimaryColor, // inkwell color
                                    child: SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: Container(
                                            padding: EdgeInsets.all(8),
                                            child: image7)
                                    ),
                                    onTap: (){

                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                getTranslated(context, 'Entertainment'),
                                style: TextStyle(fontSize: 10, color: DashboardCardTextColor),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: IconButtonInk1(
                          onPressed: (){

                          },
                          icon:image9,
                          colors: Colors.white,
                          text:getTranslated(context, 'Jewellery'),
                          textStyle: TextStyle(fontSize: 10, color: DashboardCardTextColor),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3,),
                  Row(
                    children: [
                      Expanded(
                        child: IconButtonInk1(
                          onPressed: (){

                          },
                          icon:image8,
                          colors: Colors.white,
                          text:getTranslated(context, 'EcoOnline'),
                          textStyle: TextStyle(fontSize: 10, color: DashboardCardTextColor),
                        ),
                      ),
                      Expanded(
                        child: IconButtonInk1(
                          onPressed: (){

                          },
                          icon:image13,
                          colors: Colors.white,
                          text:getTranslated(context, 'Package'),
                          textStyle: TextStyle(fontSize: 10, color: DashboardCardTextColor),
                        ),
                      ),
                      Expanded(
                        child: IconButtonInk1(
                          onPressed: (){

                          },
                          icon:image10,
                          colors: Colors.white,
                          text:getTranslated(context, 'FashionLife'),
                          textStyle: TextStyle(fontSize: 10, color: DashboardCardTextColor),
                        ),
                      ),
                      Expanded(
                        child: IconButtonInk1(
                          onPressed: (){

                          },
                          icon:image11,
                          colors: Colors.white,
                          text:getTranslated(context, 'SportFoot'),
                          textStyle: TextStyle(fontSize: 10, color: DashboardCardTextColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),),

          Visibility(
            visible: othervisis,
            child: Container(
            margin: EdgeInsets.only(left: 8, right: 8, top: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: TextColor,
            ),
            child: Container(

              padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 5),
              color: DashboardCardPrimaryColor.withOpacity(0.9),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                              margin: EdgeInsets.only(left: 5,top: 6,bottom: 6),
                              child: Text(getTranslated(context, 'Device Security'),
                                style: TextStyle(fontSize: 12,color: DashboardCardTextColor),)))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButtonInk1(
                        onPressed: (){
                          Navigator.push(
                            context, MaterialPageRoute(
                            builder: (_) => AntiVirusSecurity(),),);

                        },
                        icon:image12,
                        colors: Colors.white,
                        text: getTranslated(context, 'Security'),
                        textStyle: TextStyle(fontSize: 10, color: DashboardCardTextColor),
                      ),


                    ],
                  ),
                  SizedBox(height: 3,),
                ],
              ),
            ),
          ),)
        ],
      ),
    );
  }
}
