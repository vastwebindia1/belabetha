import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myapp/CommanWidget/Servicepurchasepage.dart';
import 'package:myapp/CommanWidget/otpPage.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/BroadbandPage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/Club&AssPage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/CreditCardPage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/EducationFee.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/HousingSocietyPage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/MuncipalPage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/SubscriptionPage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/cabletvPage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/dthRechargePage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/fastTag.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/hospitalPage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/insurancePage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/landLinePage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/loanpage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/paipegaspage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/RechargesPages/waterbillpage.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/tabIconPages/travelsHotelPages/IRCTC/irctcrailway.dart';
import '../../../../../../ThemeColor/Color.dart';
import '../../../Aadharorpanverfication.dart';
import '../../HomePage.dart';
import 'tabIconPages/RechargesPages/electricityPage.dart';
import 'tabIconPages/RechargesPages/gasCylinderPage.dart';
import 'tabIconPages/RechargesPages/mobileRecharge.dart';
import 'package:http/http.dart' as http;

class RechargeAndBill extends StatefulWidget {
  const RechargeAndBill({Key key}) : super(key: key);

  @override
  _RechargeAndBillState createState() => _RechargeAndBillState();
}

bool onIconTap = false;

class _RechargeAndBillState extends State<RechargeAndBill> {

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
  Image image14;
  Image image15;
  Image image16;
  Image image17;
  Image image18;
  Image image19;
  Image image20;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    image1 =  Image.asset('assets/pngImages/mobile-phone.png', width: 10,);
    image2 =  Image.asset('assets/pngImages/DTH.png', width: 32,);
    image3 =  Image.asset('assets/pngImages/Landline.png', width: 32,);
    image4 =  Image.asset('assets/pngImages/gas-tank.png', width: 32,);
    image5 =  Image.asset('assets/pngImages/Electricity.png', width: 32,);
    image6 =  Image.asset('assets/pngImages/toll-road.png', width: 32,);
    image7 =  Image.asset('assets/pngImages/water.png', width: 32,);
    image8 =  Image.asset('assets/pngImages/Loan.png', width: 32,);
    image9 =  Image.asset('assets/pngImages/Piped-gas.png', width: 32,);
    image10 = Image.asset('assets/pngImages/book.png', width: 32,);
    image11 = Image.asset('assets/pngImages/hospital.png', width: 32,);
    image12 = Image.asset('assets/pngImages/google-play.png', width: 32,);
    image13 = Image.asset('assets/pngImages/tv.png', width: 32,);
    image14 = Image.asset('assets/pngImages/insurance.png', width: 32,);
    image15 = Image.asset('assets/pngImages/Broadband.png', width: 32,);
    image16 = Image.asset('assets/pngImages/Municipal.png', width: 32,);
    image17 = Image.asset('assets/pngImages/Society.png', width: 32,);
    image18 = Image.asset('assets/pngImages/creditCard.png', width: 32,);
    image19 = Image.asset('assets/pngImages/subscribe.png', width: 32,);
    image20 = Image.asset('assets/pngImages/clubsCocieties.png', width: 32,);
  }

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
    precacheImage(image14.image, context);
    precacheImage(image15.image, context);
    precacheImage(image16.image, context);
    precacheImage(image17.image, context);
    precacheImage(image18.image, context);
    precacheImage(image19.image, context);
    precacheImage(image20.image, context);

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PrimaryColor,
      padding: EdgeInsets.only(left: 8,right: 8),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 8, right: 8, top: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: TextColor,
            ),
            child: Container(
              padding: EdgeInsets.all(5),
              color:DashboardCardPrimaryColor.withOpacity(0.9),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                              margin: EdgeInsets.only(left: 5, top: 6, bottom: 6),
                              child: Text(
                                getTranslated(context, 'Recharges & Bills'),
                                style:
                                TextStyle(fontSize: 12, color: DashboardCardTextColor),
                              ))
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: IconButtonInk1(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MobileRecharge()));
                          },
                          icon:image1,
                          colors: Colors.white,
                          text: getTranslated(context, 'Mobile'),
                          textStyle:
                          TextStyle(fontSize: 10, color: DashboardCardTextColor),
                        ),
                      ),
                      Expanded(
                        child: IconButtonInk1(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => DthRechargePage()));
                          },
                          icon:image2,
                          colors:Colors.white,
                          text:getTranslated(context, 'DTH'),
                          textStyle:TextStyle(fontSize: 10, color: DashboardCardTextColor),
                        ),
                      ),
                      Expanded(
                        child: IconButtonInk1(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => LandLinePage()));
                          },
                          icon:image3,
                          colors: Colors.white,
                          text: getTranslated(context, 'Landline'),
                          textStyle:
                          TextStyle(fontSize: 10, color: DashboardCardTextColor),
                        ),
                      ),
                      Expanded(
                        child: IconButtonInk1(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => GasCylinderPage()));
                          },
                          icon:image4,
                          colors: Colors.white,
                          text: getTranslated(context, 'Gas Cylinder') ,
                          textStyle:
                          TextStyle(fontSize: 10, color: DashboardCardTextColor),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: IconButtonInk1(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => ElectricityPage()));
                          },
                          icon:image5,
                          colors: Colors.white,
                          text:getTranslated(context, 'Electricity') ,
                          textStyle:
                          TextStyle(fontSize: 10, color: DashboardCardTextColor),
                        ),
                      ),
                      Expanded(
                        child: IconButtonInk1(
                          onPressed: () {

                            Navigator.push(context, MaterialPageRoute(builder: (context) => FASTag()));
                          },
                          icon:image6,
                          colors: Colors.white,
                          text:getTranslated(context, 'FASTag') ,
                          textStyle:
                          TextStyle(fontSize: 10, color: DashboardCardTextColor),
                        ),
                      ),
                      Expanded(
                        child: IconButtonInk1(
                          onPressed: () {

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Waterbillpage()));
                          },
                          icon:image7,
                          colors: Colors.white,
                          text:getTranslated(context, 'Water Bill'),
                          textStyle:
                          TextStyle(fontSize: 10, color: DashboardCardTextColor),
                        ),
                      ),
                      Expanded(
                        child: IconButtonInk1(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Loanpage()));
                          },
                          icon:image8,
                          colors: Colors.white,
                          text:getTranslated(context, 'Loan'),
                          textStyle:
                          TextStyle(fontSize: 10, color: DashboardCardTextColor),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 8, right: 8,top: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: TextColor,
            ),
            child: Container(
              padding: EdgeInsets.all(5),
              color: DashboardCardPrimaryColor.withOpacity(0.9),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                              margin: EdgeInsets.only(left: 5, top: 6, bottom: 6),
                              child: Text(
                                getTranslated(context, 'Other Utility Services'),
                                style:
                                TextStyle(fontSize: 12, color: DashboardCardTextColor),
                              )))
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: IconButtonInk1(
                          onPressed: () {

                          },
                          icon:image9,
                          colors: Colors.white,
                          text:getTranslated(context, 'Piped Gas'),
                          textStyle:
                          TextStyle(fontSize: 10, color: DashboardCardTextColor),
                        ),
                      ),
                      Expanded(
                        child: IconButtonInk1(
                          onPressed: () {
                          },
                          icon:image10,
                          colors: Colors.white,
                          text:getTranslated(context, 'Education Fee'),
                          textStyle:
                          TextStyle(fontSize: 10, color: DashboardCardTextColor),
                        ),
                      ),
                      Expanded(
                        child: IconButtonInk1(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HospitalPage()));
                          },
                          icon:image11,
                          colors: Colors.white,
                          text:getTranslated(context, 'Hospital') ,
                          textStyle:
                          TextStyle(fontSize: 10, color: DashboardCardTextColor),
                        ),
                      ),
                      Expanded(
                        child: IconButtonInk1(
                          onPressed: () {

                            //Navigator.push(context, MaterialPageRoute(builder: (context) => aadhrpanverify(aadharcard: "ggg",pancard: "fff",)));

                          },
                          icon:image10,
                          colors: Colors.white,
                          text:getTranslated(context, 'Education Fee'),
                          textStyle: TextStyle(fontSize: 10, color: DashboardCardTextColor),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: IconButtonInk1(
                          onPressed: () {

                          },
                          icon:image13,
                          colors: Colors.white,
                          text:getTranslated(context, 'Cable TV'),
                          textStyle:
                          TextStyle(fontSize: 10, color: DashboardCardTextColor),
                        ),
                      ),
                      Expanded(
                        child: IconButtonInk1(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => insurancePage()));
                          },
                          icon:image14,
                          colors: Colors.white,
                          text:getTranslated(context, 'Insurance') ,
                          textStyle:
                          TextStyle(fontSize: 10, color: DashboardCardTextColor),
                        ),
                      ),
                      Expanded(
                        child: IconButtonInk1(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Broadbandpage()));
                          },
                          icon:image15,
                          colors: Colors.white,
                          text:getTranslated(context, 'Broadband'),
                          textStyle:
                          TextStyle(fontSize: 10, color: DashboardCardTextColor),
                        ),
                      ),
                      Expanded(
                        child: IconButtonInk1(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MuncipalPage()));
                          },
                          icon:image16,
                          colors: Colors.white,
                          text: getTranslated(context, 'Municipal Tax'),
                          textStyle:
                          TextStyle(fontSize: 10, color: DashboardCardTextColor),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: IconButtonInk1(
                          onPressed: () {
                            Navigator.push(context,MaterialPageRoute(builder: (context) => HousingPage()));
                          },
                          icon:image17,
                          colors: Colors.white,
                          text:getTranslated(context, 'Housing So'),
                          textStyle: TextStyle(fontSize: 10, color: DashboardCardTextColor),
                        ),
                      ),
                      Expanded(
                        child: IconButtonInk1(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CreditcardPage()));
                          },
                          icon:image18,
                          colors: Colors.white,
                          text:getTranslated(context, 'Credit Card'),
                          textStyle: TextStyle(fontSize: 10, color: DashboardCardTextColor),
                        ),
                      ),
                      Expanded(
                        child: IconButtonInk1(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SubscriptionPage()));
                          },
                          icon:image19,
                          colors: Colors.white,
                          text:getTranslated(context, 'Subscription'),
                          textStyle: TextStyle(fontSize: 10, color: DashboardCardTextColor),
                        ),
                      ),
                      Expanded(
                        child: IconButtonInk1(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ClubPage()));
                          },
                          icon:image20,
                          colors: Colors.white,
                          text:getTranslated(context, 'Clubs & Ass'),
                          textStyle: TextStyle(fontSize: 10, color: DashboardCardTextColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SvgIconWithCard extends StatelessWidget {
  final String text;
  final Widget svgImages;
  final Color iconColor;
  final VoidCallback onPressed;

  const SvgIconWithCard({
    Key key,
    this.text,
    this.svgImages,
    this.onPressed,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: TextColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: FlatButton(
        splashColor: PrimaryColor,
        hoverColor: PrimaryColor,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            5,
          ),
        ),
        padding: EdgeInsets.only(top: 8, bottom: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            svgImages,
            SizedBox(
              height: 5,
            ),
            Text(
              text,
              style: TextStyle(fontSize: 10, color: PrimaryColor),
            )
          ],
        ),
      ),
    );
  }
}

class SvgIcon extends StatelessWidget {
  final svgImage;
  final Color color;

  const SvgIcon({
    Key key,
    this.svgImage,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      svgImage,
      width: 33,
      color: color,
    );
  }
}
