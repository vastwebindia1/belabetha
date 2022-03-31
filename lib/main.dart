
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:myapp/IntroSliderPages/IntroSlider.dart';
import 'package:myapp/ui/pages/Languages/localization/demo_localization.dart';
import 'package:myapp/ui/pages/Languages/localization/language_constants.dart';
import 'package:myapp/ui/pages/dashboard/DealerMainPage.dart';
import 'package:myapp/ui/pages/dashboard/dashboard.dart';
import 'package:myapp/ui/pages/dashboard/masterPage/masterMainPage.dart';
import 'package:myapp/ui/pages/login/login.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'CommanWidget/buttons.dart';
import 'CommanWidget/dialogBox.dart';
import 'ThemeColor/Color.dart';
import 'ThemeColor/themes.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Locale _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  String titile,dis;
  List<String> notificationlist = List<String>();
  List<String> notificationlist2 = List<String>();

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
        setState(() async{
          titile = notification.title.toString();
          dis = notification.body.toString();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          notificationlist.add(titile);
          notificationlist2.add(dis);
          prefs.setStringList('Categories', notificationlist);
          prefs.setStringList('Categories2', notificationlist2);
        });

      }
    });
    _locale;
    print(_locale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      themeMode: ThemeMode.system,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.lightTheme,
      locale: _locale,
      supportedLocales: [
        Locale("en", "US"),
        Locale("ar", "SA"),
        Locale("hi", "IN"),
        Locale("mr", "IN"),
        Locale("gu", "IN"),
        Locale("ta", "IN"),
      ],
      localizationsDelegates: [
        DemoLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,

      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },

      home: permissions(),

    );
  }
}

class permissions extends StatefulWidget {
  const permissions({Key key}) : super(key: key);

  @override
  _permissionsState createState() => _permissionsState();
}

class _permissionsState extends State<permissions> {

  _launchURL() async {
    const url = 'https://play.google.com/store/apps/details?id=com.aasha.newaashaflutter';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Position _currentPosition;
  String _currentAddress = "";

  String currentVersion = "";

  Future getstorage() async {

    if (await Permission.storage.request().isGranted) {

      getcamera();

    } else if (await Permission.storage.request().isPermanentlyDenied) {

      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text('Storage Permission'),
            content: Text(
                'This app needs access the storage permission'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('Deny'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              CupertinoDialogAction(
                  child: Text('Allow'),
                  onPressed: ()async {
                    openAppSettings();
                    Navigator.of(context).pop();

                  }
              ),
            ],
          ));

    } else if (await Permission.storage.request().isDenied) {
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text('Storage Permission'),
            content: Text(
                'This app needs access the storage permission'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('Deny'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              CupertinoDialogAction(
                  child: Text('Allow'),
                  onPressed: ()async {
                    openAppSettings();
                    Navigator.of(context).pop();

                  }
              ),
            ],
          ));
    }
  }

  Future getlocation() async {

    if (await Permission.location.request().isGranted) {

      getstorage();

    } else if (await Permission.location.request().isPermanentlyDenied) {

      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text('location Permission'),
            content: Text(
                'This app needs access the location'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('Deny'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              CupertinoDialogAction(
                  child: Text('Allow'),
                  onPressed: ()async {
                    openAppSettings();
                    Navigator.of(context).pop();

                  }
              ),
            ],
          ));

    } else if (await Permission.location.request().isDenied) {
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text('location Permission'),
            content: Text(
                'This app needs access the location'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('Deny'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              CupertinoDialogAction(
                  child: Text('Allow'),
                  onPressed: ()async {
                    openAppSettings();
                    Navigator.of(context).pop();

                  }
              ),
            ],
          ));
    }
  }

  Future getcamera() async {

    if (await Permission.camera.request().isGranted) {

      final storage = new FlutterSecureStorage();
      final prefs = await SharedPreferences.getInstance();
      var token = await storage.read(key: "accessToken");
      var role = await storage.read(key: "role");
      var kycvideosts = prefs.getString("kyvvideostatus");

      if(token == null){

        Navigator.push(context, MaterialPageRoute(builder: (context) => IntroSlider()));

      } else{

        if(role == "Retailer") {

          Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));

        }else if (role == "Dealer"){

          Navigator.push(context, MaterialPageRoute(builder: (context) => DealermaninDashboard()));
        }
        else if (role == "master"){

          Navigator.push(context, MaterialPageRoute(builder: (context) => MasterManinDashboard()));

        }
      }

    } else if (await Permission.camera.request().isPermanentlyDenied) {

      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text('Camera Permission'),
            content: Text(
                'This app needs camera access to take pictures for upload user profile photo'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('Deny'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              CupertinoDialogAction(
                  child: Text('Allow'),
                  onPressed: ()async {
                    openAppSettings();
                    Navigator.of(context).pop();

                  }
              ),
            ],
          ));

    } else if (await Permission.camera.request().isDenied) {
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text('Camera Permission'),
            content: Text(
                'This app needs camera access to take pictures for upload user profile photo'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('Deny'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              CupertinoDialogAction(
                  child: Text('Allow'),
                  onPressed: ()async {
                    openAppSettings();
                    Navigator.of(context).pop();

                  }
              ),
            ],
          ));
    }
  }

  Future<void> checkversion() async {

    final storage = new FlutterSecureStorage();
    var token = await storage.read(key: "accessToken");
    var url = new Uri.http("api.vastwebindia.com", "/Common/api/data/Check_Android_Current_Version",
        {
          "vs_no":"1.0.0"
        });
    final http.Response response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 30), onTimeout: () {

    });

    print(response);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var status = data["status"];
      var msz = data["msg"];
      currentVersion = data["currentversion"].toString();

      if(status == "Success"){

        getlocation();

      }else{

        if(currentVersion == "1.0.0"){

          getlocation();

        }else{

          showDialog(
              context: context,
              builder: (BuildContext context) {
                return updatedialog(
                  buttonText: "Update",
                  color: Colors.yellow[800],
                  description: "Sorry for the inconvenience, Updated application is available with some improvements, you can update it by clicking the button below, if any inconvenience please uninstall the application and reinstall it",
                  title: " Update Notification",
                  icon: Icons.notification_important,
                  newversion: "NEW APP VERSION IS : 1.0.1",
                  oldversion: "CURRENT APP VERSION IS : 1.0.0",
                  /*onpress: () => Navigator.of(context).pop(),*/
                  onpress: () {
                    _launchURL();
                  },
                );
              });
        }


      }


    } else {

      getlocation();

    }
  }

  Future<String> dataconnection() async{

    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DataConnectionLost()));

    }
  }

  var  aadad;
  String frmDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataconnection();
    checkversion();
  }
  @override

  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Image.asset('assets/aashalogo.png'),
      ),
    );
  }

}


class DataConnectionLost extends StatefulWidget {
  const DataConnectionLost({Key key}) : super(key: key);

  @override
  _DataConnectionLostState createState() => _DataConnectionLostState();
}

class _DataConnectionLostState extends  State<DataConnectionLost> with SingleTickerProviderStateMixin {


  Future<String> dataconnection() async{

    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

        /* Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Dashboard()));*/

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => permissions()));

      }
    } on SocketException catch (_) {

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => DataConnectionLost()));


    }
  }

  @override
  Widget build(BuildContext context) {

    return Material(
      child: SafeArea(
        child: Container(
          color:PrimaryColor,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Row(
                    children: [
                      Expanded(
                          child:Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 10,),
                                  Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: TextColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Transform.translate(
                                        offset: Offset(0,-5),
                                        child: Center(
                                          child:Image(
                                            width: 70,
                                            image: AssetImage('assets/complain.png'),
                                          ) ,
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 10,),
                                  Column(
                                    children: [
                                      Text("Connection Lost !",style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: TextColor),),
                                      SizedBox(height: 10,),
                                      Text("Please Re-Check Your Internet Connection",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: SecondaryColor),),
                                    ],
                                  )
                                ],
                              ))

                      )
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10,right: 10),
                            width: MediaQuery.of(context).size.width,
                            child: Image(
                              fit: BoxFit.cover,
                              image: AssetImage("assets/network.png"),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: MainButton(
                                    onPressed: (){

                                      dataconnection();

                                    },
                                    color: SecondaryColor,
                                    btnText: "Retry",
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                )
              ],

            ),
          ),

        ),
      ),
    );
  }

}