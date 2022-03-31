import 'dart:convert';
import 'dart:typed_data';
import 'package:any_widget_marquee/any_widget_marquee.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:myapp/IntroSliderPages/SlidePage.dart';
import 'package:myapp/ThemeColor/Color.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/homeTopPages/recentHistory.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/homeTopPages/toSelf.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/Fullnews.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/RechargeAndBill.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/financialServices.dart';
import 'package:myapp/ui/pages/dashboard/bottomNavigationPage/topTabView/topTabBarPages/travelsHotel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homeTopPages/addMoney.dart';
import 'homeTopPages/holdAndCreditPage.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  TabController _tabController;
  String Message = "";
  var msz;
  var data;
  List imagelist = [];
  Uint8List imag1,imag2,imag3,imag4;
  String imgee;

  String firmname = "";
  String balance = "";
  String photo = "";
  String header = "";
  List users = [];
  List newslist = ["null"];

  Future<void> userdetails() async {

    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");

    var url = new Uri.http("api.vastwebindia.com", "/Common/api/inform/Get_User_Information");
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
      var data = dataa["data"];
      var keyy = data["kkkk"];
      var vii = data["vvvv"];
      var firmnamee = data["frmanems"];
      var remainbal = data["remainbal"];
      var photoo = data["photoss"];
      users = dataa["newservices"];


      if(users.length == 0){

        setState(() {
          shownew = false;
        });
      }else{

        setState(() {
          users;
          shownew = true;
        });
      }

      var keee = base64.decode(keyy);
      var viii = base64.decode(vii);

      String keySTR = utf8.decode(keee);
      String ivSTR = utf8.decode(viii);

      final key = encrypt.Key.fromUtf8(keySTR);
      final iv = encrypt.IV.fromUtf8(ivSTR);

      final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));
      final decrypted1 = encrypter.decrypt(encrypt.Encrypted.fromBase64(firmnamee), iv: iv);
      final decrypted2 = encrypter.decrypt(encrypt.Encrypted.fromBase64(remainbal), iv: iv);

      if(photoo == null){
        photoo = "";
      }else{
        final decrypted3 = encrypter.decrypt(encrypt.Encrypted.fromBase64(photoo), iv: iv);
        photo = decrypted3.toString();
      }

      firmname = decrypted1.toString();
      balance = decrypted2.toString();

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('dpPhoto', photo);

    } else {
      throw Exception('Failed to load themes');
    }

    setState(() {
      users;
      firmname;
    });
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

        if(optname == "Finiance"){

         var status = dataa[i]["status"];
         setState(() {
           financilaser = status;
         });

       }else if(optname == "Travel"){

         var status = dataa[i]["status"];
         setState(() {
           travelserser = status;
         });

       }

    }


    } else {
      throw Exception('Failed to load themes');
    }

    setState(() {
      users;
      firmname;
    });
  }

  @override
  void initState() {
    super.initState();
    userdetails();
    servicestacheck();
    _tabController = new TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }


  int selectedIndex = 0;
  static List<StatefulWidget> _widgetOptions = [
    RechargeAndBill(),
    FinancialServices(),
    TravelsHotel()
  ];

  bool firstTap = false;
  bool secondTap = false;
  bool lastTap = false;

  bool shownew = false;

  bool financilaser = true;
  bool travelserser = true;

  void changelay(int number) {
    if (number == 1) {
      setState(() {
        firstTap = true;
        secondTap = false;
        lastTap = false;
        selectedIndex = 0;
      });
    } else if (number == 2) {
      setState(() {
        secondTap = true;
        firstTap = false;
        lastTap = false;
        selectedIndex = 1;
      });
    } else if (number == 3) {
      setState(() {
        lastTap = true;
        secondTap = false;
        firstTap = false;
        selectedIndex = 2;
      });
    }
  }

  bool blTest = false;
  @override
  Widget build(BuildContext context) {


    setState(() {
      if(balance == null){
        blTest = true;
      }
      else{
        blTest = false;
      }
    });

    return Material(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: PrimaryColor,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                      height: 78,
                      color:PrimaryColor,
                      child: Container(
                        color:  TextColor.withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: IconButtonInk(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => AddMoneyPage()));
                                        },
                                        icon: Icons.account_balance_wallet,
                                        colors: IconPrimaryWhite,
                                        text: getTranslated(context, 'Add Money'),
                                        textStyle:
                                        TextStyle(color: TextColor, fontSize: 11),
                                        iconSize: 20.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: IconButtonInk(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => ToSelf()));
                                        },
                                        icon: Icons.replay_circle_filled,
                                        colors: IconPrimaryWhite,
                                        text: getTranslated(context, 'To Self'),
                                        textStyle:
                                        TextStyle(color: TextColor, fontSize: 11),
                                        iconSize: 20.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: IconButtonInk(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => HoldAndCreditPage()));
                                        },
                                        icon: Icons.motion_photos_pause_sharp ,
                                        colors: IconPrimaryWhite,
                                        text: getTranslated(context, 'Hold & Credit'),
                                        textStyle:
                                        TextStyle(color: TextColor, fontSize: 11),
                                        iconSize: 20.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: IconButtonInk(
                                        onPressed: () {
                                           Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => RecentHistory()));
                                        },
                                        icon: Icons.update,
                                        colors: IconPrimaryWhite,
                                        text: getTranslated(context, 'Recent hi'),
                                        textStyle:
                                        TextStyle(color: TextColor, fontSize: 11),
                                        iconSize: 20.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                      )),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 0,right: 0,top: 5,bottom: 5,),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Visibility(
                            visible: shownew,
                            child: SizedBox(
                              height: 80,
                              width: MediaQuery.of(context).size.width,
                              child:Carousel(
                                dotSize: 6.0,
                                dotSpacing: 15.0,
                                dotColor: SecondaryColor,
                                indicatorBgPadding: 5.0,
                                dotBgColor: Colors.transparent,
                                dotPosition: DotPosition.bottomCenter,
                                autoplay: true,
                                showIndicator: false,
                                images:users.map((i) =>
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => fullfromnews()));
                                      },
                                      child: Container(
                                          width: MediaQuery.of(context).size.width,
                                          margin: new EdgeInsets.symmetric(horizontal: 5.0),
                                          decoration: new BoxDecoration(
                                              color: SecondaryColor,
                                              borderRadius: BorderRadius.circular(3)
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(left: 8,right: 3),
                                                  child:Text(i["messahes"],overflow: TextOverflow.clip,textAlign: TextAlign.justify,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                                ),),
                                              Container(
                                                margin: EdgeInsets.all(5),
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(3)
                                                ),
                                                child:Image.network(i["images"],height: 64,width: 64,),
                                              )
                                            ],
                                          )
                                      ),
                                    )
                                ).toList(),
                              ),
                            ),),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Column(
                      children: [
                        Container(
                          color: TextColor,
                          child: Container(
                            padding: EdgeInsets.only(top: 6,left: 0,right: 0),
                            color: PrimaryColor.withOpacity(0.9),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(8.0),
                                          topLeft: Radius.circular(8.0),
                                        ),
                                        color: secondTap ? Colors.transparent : lastTap ? Colors.transparent : PrimaryColor,
                                      ),
                                      child: FlatButton(
                                        onPressed: () {
                                          changelay(1);
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/pngImages/RechargeBill.png",
                                              width: 26,
                                              color: TextColor,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Flexible(
                                              child: Text(
                                                getTranslated(context, 'Recharge & Utilities'),
                                                style: TextStyle(fontSize: 12, color: Colors.white),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: financilaser,
                                  child: Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(8.0),
                                        topLeft: Radius.circular(8.0),
                                      ),
                                      color: secondTap
                                          ? PrimaryColor
                                          : Colors.transparent,
                                    ),
                                    child: FlatButton(
                                      onPressed: () {
                                        changelay(2);
                                      },

                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/pngImages/buldings.png",
                                            width: 23,
                                            color: TextColor,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Flexible(
                                            child: Text(getTranslated(context, 'Financial Services'),
                                              style: TextStyle(fontSize: 12,color: TextColor),
                                              overflow: TextOverflow.clip,
                                              maxLines: 2,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),),
                                Visibility(
                                  visible: travelserser,
                                    child: Expanded(
                                    child: Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(8.0),
                                      topLeft: Radius.circular(8.0),
                                    ),
                                      color: lastTap ? PrimaryColor : Colors.transparent,
                                    ),
                                    child: FlatButton(
                                      onPressed: () {
                                        changelay(3);
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/pngImages/bus.svg",
                                            width: 23,
                                            color: TextColor,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Flexible(
                                            child: Text(getTranslated(context, 'Travels & others'),
                                              style: TextStyle(fontSize: 12,color: TextColor),
                                              overflow: TextOverflow.clip,
                                              maxLines: 2,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ))
                              ],
                            ),
                          ),
                        ),
                        _widgetOptions.elementAt(selectedIndex)
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}


class IconButtonInk extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final Color colors;
  final iconSize;
  final TextStyle textStyle;

  const IconButtonInk({
    Key key,
    this.onPressed,
    this.text,
    this.icon,
    this.colors,
    this.iconSize,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            ClipOval(
              child: Material(
                color: IconBackgroundSecondaryColor, // button color
                child: InkWell(
                  splashColor: PrimaryColor, // inkwell color
                  child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(
                        icon,
                        color: colors,
                        size: iconSize,
                      )),
                  onTap: onPressed,
                ),
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              text,
              style: textStyle,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ));
  }
}

class IconButtonInk1 extends StatelessWidget {
  final Widget icon;
  final String text;
  final VoidCallback onPressed;
  final Color colors;
  final iconSize;
  final TextStyle textStyle;

  const IconButtonInk1({
    Key key,
    this.onPressed,
    this.text,
    this.icon,
    this.colors,
    this.iconSize,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          ClipOval(
            child: Material(
              color: IconBackgroundPrimaryColor, // button color
              child: InkWell(
                splashColor: PrimaryColor, // inkwell color
                child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Container(
                        padding: EdgeInsets.all(10),
                        child: icon)
                ),
                onTap: onPressed,
              ),
            ),
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            text,
            style: textStyle,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          )
        ],
      ),
    );
  }
}
